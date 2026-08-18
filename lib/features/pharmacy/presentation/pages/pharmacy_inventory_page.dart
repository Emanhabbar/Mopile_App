import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/layout.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/async_states.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/models/pharmacy_models.dart';
import '../../data/repositories/pharmacy_repository.dart';
import '../controllers/pharmacy_providers.dart';
import '../widgets/batch_inventory_editor.dart';
import 'pharmacy_barcode_scanner_page.dart';

/// المساحة المحجوزة لشريط التنقل السفلي المخصص (76px ارتفاع + ~12px SafeArea).
/// تُستخدم كـ padding سفلي للـ Bottom Sheets حتى تظهر أزرارها فوق الشريط.
const double kPharmacyBottomNavReserved = kBottomNavReserved;

class PharmacyInventoryPage extends ConsumerStatefulWidget {
  const PharmacyInventoryPage({super.key});
  @override
  ConsumerState<PharmacyInventoryPage> createState() =>
      _PharmacyInventoryPageState();
}

class _PharmacyInventoryPageState extends ConsumerState<PharmacyInventoryPage> {
  final _search = TextEditingController();
  String? _stockStatus;
  String _query = '';
  bool _showArabicNames = false;

  PharmacyInventoryFilter get _filter =>
      (search: _query, stockStatus: _stockStatus);

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(pharmacyInventoryProvider(_filter));
    final snapshot = state.valueOrNull ?? const <PharmacyInventoryItem>[];
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.inventoryTitle),
        actions: [
          IconButton(
            onPressed: _searchByBarcode,
            tooltip: l10n.scanBarcode,
            icon: const Icon(Icons.qr_code_scanner_rounded),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 9),
            child: FilterChip(
              selected: _showArabicNames,
              showCheckmark: false,
              avatar: const Icon(Icons.translate_rounded, size: 17),
              label: Text(l10n.arabicLabel),
              tooltip: l10n.showArabicNamesTooltip,
              onSelected: (value) => setState(() => _showArabicNames = value),
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            onPressed: () => ref.invalidate(pharmacyInventoryProvider(_filter)),
            tooltip: l10n.refreshInventoryTooltip,
            icon: const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
            child: Column(
              children: [
                _InventoryOverview(items: snapshot, onAdd: _openAddOptions),
                const SizedBox(height: 13),
                AppTextField(
                  label: l10n.searchByMedicineOrScientificName,
                  controller: _search,
                  icon: Icons.search_rounded,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) =>
                      setState(() => _query = _search.text.trim()),
                  suffixIcon: IconButton(
                    onPressed: () =>
                        setState(() => _query = _search.text.trim()),
                    icon: const Icon(Icons.arrow_forward_rounded),
                    tooltip: l10n.searchLabel,
                  ),
                ),
                const SizedBox(height: 10),
                _StockStatusSelector(
                  selectedStatus: _stockStatus,
                  onStatusSelected: (status) => setState(() {
                    _stockStatus = status == 'All' ? null : status;
                  }),
                ),
              ],
            ),
          ),
          Expanded(
            child: state.when(
              loading: () => AppLoadingState(label: l10n.inventoryLoading),
              error: (error, _) => AppErrorState(
                error: error,
                onRetry: () =>
                    ref.invalidate(pharmacyInventoryProvider(_filter)),
              ),
              data: (items) => RefreshIndicator(
                onRefresh: () =>
                    ref.refresh(pharmacyInventoryProvider(_filter).future),
                child: items.isEmpty
                    ? _InventoryEmpty(onAdd: _openAddOptions)
                    : ListView.separated(
                        padding: EdgeInsets.fromLTRB(
                          20,
                          10,
                          20,
                          kPharmacyBottomNavReserved + 12,
                        ),
                        itemCount: items.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, index) => _InventoryCard(
                          item: items[index],
                          showArabicName: _showArabicNames,
                          onEdit: () => _editItem(items[index]),
                          onDelete: () => _delete(items[index]),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openAddOptions() async {
    final action = await showModalBottomSheet<_AddMedicineAction>(
      context: context,
      isScrollControlled: true,
      useSafeArea: false,
      builder: (context) => const _AddMedicineOptions(),
      // نستخدم rootNavigator عشان الـ BottomSheet يطلع فوق الـ
      // BottomNavigationBar المخصص (76px + SafeArea).
      routeSettings: const RouteSettings(name: '/add-medicine-options'),
    );
    if (!mounted || action == null) return;
    if (action == _AddMedicineAction.manual) {
      await _openManualEditor();
    } else if (action == _AddMedicineAction.barcode) {
      final barcode = await _scanBarcode(context);
      if (barcode != null && mounted) await _openCatalog(initialQuery: barcode);
    } else {
      await _openCatalog();
    }
  }

  Future<void> _searchByBarcode() async {
    final barcode = await _scanBarcode(context);
    if (barcode == null || !mounted) return;
    _search.text = barcode;
    setState(() => _query = barcode);
  }

  Future<void> _openCatalog({String? initialQuery}) async {
    final l10n = AppLocalizations.of(context);
    final selected = await showModalBottomSheet<List<PharmacyCatalogMedicine>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _CatalogSheet(initialQuery: initialQuery),
    );
    if (selected == null || selected.isEmpty) return;
    if (selected.length == 1) {
      await _editItem(null, medicine: selected.first);
      return;
    }
    if (!mounted) return;

    final items =
        await showModalBottomSheet<List<PharmacyInventoryBatchItemInput>>(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (_) => BatchInventoryEditor(medicines: selected),
        );
    if (items == null || items.isEmpty) return;
    try {
      await ref
          .read(pharmacyRepositoryProvider)
          .remote
          .addInventoryBatch(items: items);
      _refresh();
      _message(l10n.inventoryBatchAdded(items.length));
    } catch (error) {
      _message(_error(error), true);
    }
  }

  Future<void> _openManualEditor() async {
    final l10n = AppLocalizations.of(context);
    final info = await showModalBottomSheet<_ManualMedicineInfo>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const _ManualMedicineEditor(),
    );
    if (info == null || !mounted) return;
    final inventory = await showModalBottomSheet<_InventoryDraft>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _InventoryEditor(
        medicine: PharmacyCatalogMedicine(
          id: 'manual',
          name: info.name,
          arabicName: info.arabicName,
          scientificName: info.scientificName,
          arabicScientificName: info.arabicScientificName,
          manufacturer: info.manufacturer,
          dosageForm: info.dosageForm,
          capacity: info.capacity,
          requiresPrescription: info.requiresPrescription,
        ),
      ),
    );
    if (inventory == null) return;
    try {
      await ref
          .read(pharmacyRepositoryProvider)
          .remote
          .addManualInventory(
            name: info.name,
            barcode: info.barcode,
            arabicName: info.arabicName,
            scientificName: info.scientificName,
            arabicScientificName: info.arabicScientificName,
            manufacturer: info.manufacturer,
            dosageForm: info.dosageForm,
            packageSize: info.packageSize,
            capacity: info.capacity,
            composition: info.composition,
            description: info.description,
            requiresPrescription: info.requiresPrescription,
            quantity: inventory.quantity,
            unitPrice: inventory.price,
            isPriceVisibleToUsers: inventory.priceVisible,
            isAvailable: inventory.available,
            lowStockThreshold: inventory.threshold,
            expiryDate: inventory.expiryDate,
          );
      ref.read(pharmacyRepositoryProvider).clearCatalogCache();
      _refresh();
      _message(l10n.manualMedicineCreated);
    } catch (error) {
      _message(_error(error), true);
    }
  }

  Future<void> _editItem(
    PharmacyInventoryItem? item, {
    PharmacyCatalogMedicine? medicine,
  }) async {
    final l10n = AppLocalizations.of(context);
    final draft = await showModalBottomSheet<_InventoryDraft>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _InventoryEditor(item: item, medicine: medicine),
    );
    if (draft == null) return;
    try {
      final remote = ref.read(pharmacyRepositoryProvider).remote;
      if (item == null) {
        await remote.addInventory(
          medicineId: draft.medicineId,
          quantity: draft.quantity,
          unitPrice: draft.price,
          isPriceVisibleToUsers: draft.priceVisible,
          isAvailable: draft.available,
          lowStockThreshold: draft.threshold,
          expiryDate: draft.expiryDate,
        );
      } else {
        await remote.updateInventory(
          item.inventoryItemId,
          quantity: draft.quantity,
          unitPrice: draft.price,
          isPriceVisibleToUsers: draft.priceVisible,
          isAvailable: draft.available,
          lowStockThreshold: draft.threshold,
          expiryDate: draft.expiryDate,
        );
      }
      _refresh();
      _message(item == null ? l10n.inventoryItemAdded : l10n.inventoryItemUpdated);
    } catch (error) {
      _message(_error(error), true);
    }
  }

  Future<void> _delete(PharmacyInventoryItem item) async {
    final l10n = AppLocalizations.of(context);
    final yes = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteItemTitle),
        content: Text(l10n.deleteItemConfirm(item.medicineName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: context.appColors.danger),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (yes != true) return;
    try {
      await ref
          .read(pharmacyRepositoryProvider)
          .remote
          .deleteInventory(item.inventoryItemId);
      _refresh();
      _message(l10n.inventoryItemDeleted);
    } catch (error) {
      _message(_error(error), true);
    }
  }

  void _refresh() {
    ref
      ..invalidate(pharmacyInventoryProvider)
      ..invalidate(pharmacyDashboardProvider);
  }

  void _message(String text, [bool error = false]) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: error ? context.appColors.danger : null,
      ),
    );
  }

  String _error(Object error) => error is ApiException
      ? error.localize(AppLocalizations.of(context))
      : AppLocalizations.of(context).operationFailed;
}

class _InventoryOverview extends StatelessWidget {
  const _InventoryOverview({required this.items, required this.onAdd});

  final List<PharmacyInventoryItem> items;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final available = items.where((item) => item.isAvailable).length;
    final low = items
        .where((item) => item.stockStatus.toLowerCase() == 'lowstock')
        .length;
    final out = items
        .where((item) => item.stockStatus.toLowerCase() == 'outofstock')
        .length;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appColors.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  Icons.inventory_2_rounded,
                  color: context.appColors.primaryLight,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.inventoryManagement,
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: Colors.white),
                    ),
                    Text(
                      l10n.inventoryOverviewSummary(items.length, available),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.64),
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton.filled(
                onPressed: onAdd,
                tooltip: l10n.addMedicine,
                style: IconButton.styleFrom(
                  backgroundColor: context.appColors.primaryLight,
                  foregroundColor: context.appColors.primaryDeep,
                ),
                icon: const Icon(Icons.add_rounded),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _OverviewFact(
                label: l10n.availableLabel,
                value: available,
                color: Colors.white.withValues(alpha: 0.95),
              ),
              const SizedBox(width: 8),
              _OverviewFact(
                label: l10n.lowLabel,
                value: low,
                color: Colors.white.withValues(alpha: 0.85),
              ),
              const SizedBox(width: 8),
              _OverviewFact(
                label: l10n.outOfStockLabel,
                value: out,
                color: Colors.white.withValues(alpha: 0.75),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OverviewFact extends StatelessWidget {
  const _OverviewFact({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.075),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(
              '$value',
              style: TextStyle(color: color, fontWeight: FontWeight.w900),
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.58),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InventoryCard extends StatelessWidget {
  const _InventoryCard({
    required this.item,
    required this.showArabicName,
    required this.onEdit,
    required this.onDelete,
  });
  final PharmacyInventoryItem item;
  final bool showArabicName;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final statusColor = _stockColor(context, item.stockStatus);
    final details = [
      if (showArabicName) item.arabicMedicineName,
      item.scientificName,
      if (showArabicName) item.arabicScientificName,
    ].whereType<String>().where((value) => value.isNotEmpty).join(' · ');
    final expiry = item.expiryDateUtc == null
        ? null
        : '${item.expiryDateUtc!.year}/${item.expiryDateUtc!.month.toString().padLeft(2, '0')}/${item.expiryDateUtc!.day.toString().padLeft(2, '0')}';
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onEdit,
        child: Row(
          children: [
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 43,
                            height: 43,
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.09),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              Icons.medication_rounded,
                              color: statusColor,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 11),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.medicineName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                if (details.isNotEmpty)
                                  Text(
                                    details,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                              ],
                            ),
                          ),
                          PopupMenuButton<String>(
                            tooltip: l10n.itemOptions,
                            onSelected: (value) =>
                                value == 'edit' ? onEdit() : onDelete(),
                            itemBuilder: (_) => [
                              PopupMenuItem(
                                value: 'edit',
                                child: ListTile(
                                  leading: const Icon(Icons.edit_outlined),
                                  title: Text(l10n.editLabel),
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: ListTile(
                                  leading: Icon(
                                    Icons.delete_outline_rounded,
                                    color: const Color(0xFFB33A3A),
                                  ),
                                  title: Text(l10n.delete),
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 13),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: context.appColors.background,
                          borderRadius: BorderRadius.circular(16),
                        ),
                          child: Row(
                            children: [
                              _InventoryFact(
                                label: l10n.quantityLabel,
                                value: '${item.quantity}',
                              ),
                              _InventoryFact(
                                label: l10n.priceLabel,
                                value: item.isPriceVisibleToUsers
                                    ? l10n.priceValue(item.sellingPrice.toStringAsFixed(0))
                                    : l10n.hiddenLabel,
                              ),
                              _InventoryFact(
                                label: l10n.statusLabel,
                                value: _stock(l10n, item.stockStatus),
                              ),
                            ],
                          ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 7,
                        runSpacing: 7,
                        children: [
                          if (item.capacity != null)
                            _Chip(
                              text: l10n.concentrationChip(item.capacity!),
                              color: context.appColors.primary,
                            ),
                          if (item.dosageForm != null)
                            _Chip(
                              text: l10n.dosageFormChip(item.dosageForm!),
                              color: context.appColors.primary,
                            ),
                          _Chip(
                            text: item.isAvailable
                                ? l10n.availableForOrder
                                : l10n.notAvailable,
                            color: item.isAvailable
                                ? context.appColors.primary
                                : context.appColors.textMuted,
                          ),
                          if (item.requiresPrescription)
                            _Chip(
                              text: l10n.requiresPrescription,
                              color: context.appColors.primary,
                            ),
                          if (expiry != null)
                            _Chip(
                              text: l10n.expiresOn(expiry),
                              color:
                                  item.daysUntilExpiry != null &&
                                      item.daysUntilExpiry! <= 30
                                  ? context.appColors.danger
                                  : context.appColors.textMuted,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _InventoryFact extends StatelessWidget {
  const _InventoryFact({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: context.appColors.text,
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

enum _AddMedicineAction { catalog, barcode, manual }

class _AddMedicineOptions extends StatelessWidget {
  const _AddMedicineOptions();

  @override
  Widget build(BuildContext context) {
    // الـ BottomNav المخصص بارتفاع 76px + SafeArea ~12px.
    // نضيف padding سفلية كافية عشان محتوى الـ Sheet يبان فوقه.
    final l10n = AppLocalizations.of(context);
    final bottomPadding = MediaQuery.of(context).padding.bottom + kPharmacyBottomNavReserved;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 12, 20, bottomPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: context.appColors.border,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            l10n.addToInventoryTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            l10n.addToInventorySubtitle,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          _AddOptionTile(
            icon: Icons.library_add_outlined,
            title: l10n.chooseFromCatalog,
            subtitle: l10n.chooseFromCatalogSubtitle,
            onTap: () => Navigator.pop(context, _AddMedicineAction.catalog),
          ),
          const SizedBox(height: 10),
          _AddOptionTile(
            icon: Icons.qr_code_scanner_rounded,
            title: l10n.scanPackageBarcode,
            subtitle: l10n.scanPackageBarcodeSubtitle,
            onTap: () => Navigator.pop(context, _AddMedicineAction.barcode),
          ),
          const SizedBox(height: 10),
          _AddOptionTile(
            icon: Icons.edit_note_rounded,
            title: l10n.addMedicineManually,
            subtitle: l10n.addMedicineManuallySubtitle,
            onTap: () => Navigator.pop(context, _AddMedicineAction.manual),
          ),
        ],
      ),
    );
  }
}

class _AddOptionTile extends StatelessWidget {
  const _AddOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: context.appColors.surfaceSoft,
    borderRadius: BorderRadius.circular(18),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: context.appColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            Icon(Icons.chevron_left_rounded, color: context.appColors.primary),
          ],
        ),
      ),
    ),
  );
}

class _ManualMedicineEditor extends StatefulWidget {
  const _ManualMedicineEditor();

  @override
  State<_ManualMedicineEditor> createState() => _ManualMedicineEditorState();
}

class _ManualMedicineEditorState extends State<_ManualMedicineEditor> {
  final _name = TextEditingController();
  final _arabicName = TextEditingController();
  final _barcode = TextEditingController();
  final _scientificName = TextEditingController();
  final _arabicScientificName = TextEditingController();
  final _manufacturer = TextEditingController();
  final _dosageForm = TextEditingController();
  final _packageSize = TextEditingController();
  final _capacity = TextEditingController();
  final _composition = TextEditingController();
  final _description = TextEditingController();
  bool _requiresPrescription = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _arabicName.dispose();
    _barcode.dispose();
    _scientificName.dispose();
    _arabicScientificName.dispose();
    _manufacturer.dispose();
    _dosageForm.dispose();
    _packageSize.dispose();
    _capacity.dispose();
    _composition.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
    padding: EdgeInsets.fromLTRB(
      20,
      16,
      20,
      (MediaQuery.viewInsetsOf(context).bottom > 0
          ? MediaQuery.viewInsetsOf(context).bottom
          : kPharmacyBottomNavReserved) +
          16,
    ),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: context.appColors.border,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            l10n.newMedicineDataTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            l10n.newMedicineDataSubtitle,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: l10n.medicineNameEnglishLabel,
            controller: _name,
            icon: Icons.medication_outlined,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: l10n.medicineNameArabicLabel,
            controller: _arabicName,
            icon: Icons.translate_rounded,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: l10n.barcodeLabel,
            controller: _barcode,
            icon: Icons.qr_code_rounded,
            keyboardType: TextInputType.number,
            suffixIcon: IconButton(
              onPressed: () async {
                final value = await _scanBarcode(context);
                if (value != null && mounted) _barcode.text = value;
              },
              tooltip: l10n.scanWithCamera,
              icon: const Icon(Icons.qr_code_scanner_rounded),
            ),
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: l10n.scientificNameEnglishLabel,
            controller: _scientificName,
            icon: Icons.science_outlined,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: l10n.scientificNameArabicLabel,
            controller: _arabicScientificName,
            icon: Icons.science_rounded,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: l10n.manufacturerLabel,
            controller: _manufacturer,
            icon: Icons.factory_outlined,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  label: l10n.dosageFormLabel,
                  controller: _dosageForm,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppTextField(
                  label: l10n.concentrationOrCapacityLabel,
                  controller: _capacity,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: l10n.packageSizeLabel,
            controller: _packageSize,
            icon: Icons.inventory_2_outlined,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: l10n.compositionLabel,
            controller: _composition,
            icon: Icons.biotech_outlined,
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: l10n.additionalDescriptionLabel,
            controller: _description,
            icon: Icons.notes_rounded,
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.only(bottom: 13),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: context.appColors.surfaceSoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.description_outlined,
                  color: context.appColors.primary,
                  size: 21,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.requiresPrescription,
                    style: TextStyle(
                      color: context.appColors.text,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Switch(
                  value: _requiresPrescription,
                  onChanged: (value) =>
                      setState(() => _requiresPrescription = value),
                ),
              ],
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.appColors.danger.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: context.appColors.danger.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    color: context.appColors.danger,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _error!,
                      style: TextStyle(
                        color: context.appColors.danger,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.arrow_back_rounded),
              label: Text(l10n.continueToInventoryData),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
  }

  void _submit() {
    if (_name.text.trim().isEmpty) {
      setState(() => _error = AppLocalizations.of(context).medicineNameRequired);
      return;
    }
    Navigator.pop(
      context,
      _ManualMedicineInfo(
        name: _name.text.trim(),
        barcode: _cleanText(_barcode.text),
        arabicName: _cleanText(_arabicName.text),
        scientificName: _cleanText(_scientificName.text),
        arabicScientificName: _cleanText(_arabicScientificName.text),
        manufacturer: _cleanText(_manufacturer.text),
        dosageForm: _cleanText(_dosageForm.text),
        packageSize: _cleanText(_packageSize.text),
        capacity: _cleanText(_capacity.text),
        composition: _cleanText(_composition.text),
        description: _cleanText(_description.text),
        requiresPrescription: _requiresPrescription,
      ),
    );
  }
}

class _ManualMedicineInfo {
  const _ManualMedicineInfo({
    required this.name,
    required this.requiresPrescription,
    this.barcode,
    this.arabicName,
    this.scientificName,
    this.arabicScientificName,
    this.manufacturer,
    this.dosageForm,
    this.packageSize,
    this.capacity,
    this.composition,
    this.description,
  });
  final String name;
  final String? barcode;
  final String? arabicName;
  final String? scientificName;
  final String? arabicScientificName;
  final String? manufacturer;
  final String? dosageForm;
  final String? packageSize;
  final String? capacity;
  final String? composition;
  final String? description;
  final bool requiresPrescription;
}

String? _cleanText(String value) {
  final text = value.trim();
  return text.isEmpty ? null : text;
}

class _CatalogSheet extends ConsumerStatefulWidget {
  const _CatalogSheet({this.initialQuery});
  final String? initialQuery;
  @override
  ConsumerState<_CatalogSheet> createState() => _CatalogSheetState();
}

class _CatalogSheetState extends ConsumerState<_CatalogSheet> {
  late final TextEditingController _search;
  final _scroll = ScrollController();
  final Map<String, PharmacyCatalogMedicine> _selected = {};
  final List<PharmacyCatalogMedicine> _items = [];
  late String _query;
  bool _showArabicNames = false;
  bool _initialLoading = true;
  bool _loadingMore = false;
  bool _hasNextPage = true;
  int _pageNumber = 0;
  int _totalCount = 0;
  Object? _catalogError;

  @override
  void initState() {
    super.initState();
    _query = widget.initialQuery?.trim() ?? '';
    _search = TextEditingController(text: _query);
    _scroll.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadPage(reset: true));
  }

  @override
  void dispose() {
    _search.dispose();
    _scroll
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * .82,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: context.appColors.border,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.catalogSelectionTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 3),
                Text(
                  l10n.catalogSelectionSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 9),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: FilterChip(
                    selected: _showArabicNames,
                    showCheckmark: false,
                    avatar: const Icon(Icons.translate_rounded, size: 17),
                    label: Text(l10n.showArabicName),
                    onSelected: (value) =>
                        setState(() => _showArabicNames = value),
                  ),
                ),
                if (_selected.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: context.appColors.surfaceWarm,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Text(
                      l10n.selectedMedicinesCount(_selected.length),
                      style: const TextStyle(
                        color: Color(0xFFB7791F),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                AppTextField(
                  label: l10n.searchByMedicineOrScientificName,
                  controller: _search,
                  icon: Icons.search_rounded,
                  textInputAction: TextInputAction.search,
                  onSubmitted: _startSearch,
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: _scanCatalogBarcode,
                        tooltip: l10n.scanBarcode,
                        icon: const Icon(Icons.qr_code_scanner_rounded),
                      ),
                      IconButton(
                        onPressed: () => _startSearch(_search.text),
                        icon: const Icon(Icons.arrow_forward_rounded),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _initialLoading
                ? AppLoadingState(label: l10n.catalogOpening)
                : _catalogError != null && _items.isEmpty
                ? AppErrorState(
                    error: _catalogError!,
                    onRetry: () => _loadPage(reset: true),
                  )
                : _items.isEmpty
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(l10n.noMatchingMedicines),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () => _loadPage(reset: true),
                    child: ListView.separated(
                      controller: _scroll,
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      itemCount: _items.length + 1,
                      separatorBuilder: (_, _) => const SizedBox(height: 9),
                      itemBuilder: (_, index) {
                        if (index == _items.length) {
                          return _CatalogPaginationFooter(
                            loading: _loadingMore,
                            hasNextPage: _hasNextPage,
                            loadedCount: _items.length,
                            totalCount: _totalCount,
                            error: _catalogError,
                            onRetry: () => _loadPage(),
                          );
                        }
                        final medicine = _items[index];
                        final selected = _selected.containsKey(medicine.id);
                        return Card(
                          margin: EdgeInsets.zero,
                          clipBehavior: Clip.antiAlias,
                          color: selected
                              ? context.appColors.primary.withValues(alpha: .06)
                              : null,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 7,
                            ),
                            leading: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: context.appColors.surfaceSoft,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.medication_rounded,
                                color: Color(0xFF216474),
                              ),
                            ),
                            title: Text(medicine.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  [
                                    if (_showArabicNames) medicine.arabicName,
                                    medicine.scientificName,
                                    if (_showArabicNames)
                                      medicine.arabicScientificName,
                                  ].whereType<String>().join(' · '),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 5),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 4,
                                  children: [
                                    if (medicine.capacity != null)
                                      _CatalogIdentityChip(
                                        icon: Icons.straighten_rounded,
                                        text: medicine.capacity!,
                                      ),
                                    if (medicine.dosageForm != null)
                                      _CatalogIdentityChip(
                                        icon: Icons.category_outlined,
                                        text: medicine.dosageForm!,
                                      ),
                                    if (medicine.packageSize != null)
                                      _CatalogIdentityChip(
                                        icon: Icons.inventory_2_outlined,
                                        text: medicine.packageSize!,
                                      ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 160),
                              child: Icon(
                                selected
                                    ? Icons.check_circle_rounded
                                    : Icons.add_circle_outline_rounded,
                                key: ValueKey(selected),
                                color: selected
                                    ? context.appColors.primary
                                    : context.appColors.textMuted,
                              ),
                            ),
                            onTap: () => setState(() {
                              if (selected) {
                                _selected.remove(medicine.id);
                              } else {
                                _selected[medicine.id] = medicine;
                              }
                            }),
                          ),
                        );
                      },
                    ),
                  ),
          ),
          SafeArea(
            top: false,
            minimum: EdgeInsets.fromLTRB(
              20,
              8,
              20,
              kPharmacyBottomNavReserved + 14,
            ),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _selected.isEmpty
                    ? null
                    : () => Navigator.pop(
                        context,
                        _selected.values.toList(growable: false),
                      ),
                icon: const Icon(Icons.playlist_add_check_rounded),
                label: Text(
                  _selected.isEmpty
                      ? l10n.selectAtLeastOneMedicine
                      : l10n.continueWithSelectedCount(_selected.length),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _scanCatalogBarcode() async {
    final value = await _scanBarcode(context);
    if (value == null || !mounted) return;
    _search.text = value;
    await _startSearch(value);
  }

  Future<void> _startSearch(String value) async {
    FocusManager.instance.primaryFocus?.unfocus();
    _query = value.trim();
    await _loadPage(reset: true);
  }

  void _onScroll() {
    if (!_scroll.hasClients ||
        _scroll.position.extentAfter > 420 ||
        _loadingMore ||
        !_hasNextPage) {
      return;
    }
    _loadPage();
  }

  Future<void> _loadPage({bool reset = false}) async {
    if (!mounted || (_loadingMore && !reset)) return;
    final nextPage = reset ? 1 : _pageNumber + 1;
    setState(() {
      if (reset) {
        _initialLoading = true;
        _catalogError = null;
      } else {
        _loadingMore = true;
        _catalogError = null;
      }
    });
    try {
      final page = await ref
          .read(pharmacyRepositoryProvider)
          .searchCatalog(_query, pageNumber: nextPage, pageSize: 30);
      if (!mounted) return;
      setState(() {
        if (reset) _items.clear();
        final known = _items.map((item) => item.id).toSet();
        _items.addAll(page.items.where((item) => known.add(item.id)));
        _pageNumber = page.pageNumber;
        _totalCount = page.totalCount;
        _hasNextPage = page.hasNextPage;
      });
    } catch (error) {
      if (mounted) setState(() => _catalogError = error);
    } finally {
      if (mounted) {
        setState(() {
          _initialLoading = false;
          _loadingMore = false;
        });
      }
    }
  }
}

class _CatalogPaginationFooter extends StatelessWidget {
  const _CatalogPaginationFooter({
    required this.loading,
    required this.hasNextPage,
    required this.loadedCount,
    required this.totalCount,
    required this.error,
    required this.onRetry,
  });
  final bool loading;
  final bool hasNextPage;
  final int loadedCount;
  final int totalCount;
  final Object? error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
    padding: const EdgeInsets.symmetric(vertical: 14),
    child: Center(
      child: loading
          ? const SizedBox.square(
              dimension: 24,
              child: CircularProgressIndicator(strokeWidth: 2.4),
            )
          : error != null
          ? TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(l10n.reloadMore),
            )
          : Text(
              hasNextPage
                  ? l10n.scrollForMore
                  : l10n.shownCountOfTotal(loadedCount, totalCount),
              style: Theme.of(context).textTheme.bodySmall,
            ),
    ),
  );
  }
}

class _CatalogIdentityChip extends StatelessWidget {
  const _CatalogIdentityChip({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
    decoration: BoxDecoration(
      color: context.appColors.primary.withValues(alpha: .07),
      borderRadius: BorderRadius.circular(9),
      border: Border.all(color: context.appColors.primary.withValues(alpha: .12)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: context.appColors.primary),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700),
        ),
      ],
    ),
  );
}

Future<String?> _scanBarcode(BuildContext context) =>
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute<String>(
        fullscreenDialog: true,
        builder: (_) => const PharmacyBarcodeScannerPage(),
      ),
    );

class _InventoryEditor extends StatefulWidget {
  const _InventoryEditor({this.item, this.medicine});
  final PharmacyInventoryItem? item;
  final PharmacyCatalogMedicine? medicine;
  @override
  State<_InventoryEditor> createState() => _InventoryEditorState();
}

class _InventoryEditorState extends State<_InventoryEditor> {
  late final TextEditingController _quantity;
  late final TextEditingController _price;
  late final TextEditingController _threshold;
  late bool _visible;
  late bool _available;
  DateTime? _expiry;
  String? _validationError;
  @override
  void initState() {
    super.initState();
    _quantity = TextEditingController(text: '${widget.item?.quantity ?? 0}');
    _price = TextEditingController(text: '${widget.item?.sellingPrice ?? 0}');
    _threshold = TextEditingController(
      text: '${widget.item?.lowStockThreshold ?? 5}',
    );
    _visible = widget.item?.isPriceVisibleToUsers ?? true;
    _available = widget.item?.isAvailable ?? true;
    _expiry = widget.item?.expiryDateUtc;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
    padding: EdgeInsets.fromLTRB(
      20,
      20,
      20,
      (MediaQuery.viewInsetsOf(context).bottom > 0
          ? MediaQuery.viewInsetsOf(context).bottom
          : kPharmacyBottomNavReserved) +
          16,
    ),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.item?.medicineName ?? widget.medicine?.name ?? '',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          if ((widget.item?.arabicMedicineName ?? widget.medicine?.arabicName)
              case final arabicName?) ...[
            const SizedBox(height: 2),
            Text(arabicName, style: Theme.of(context).textTheme.bodySmall),
          ],
          const SizedBox(height: 4),
          Text(
            widget.item == null
                ? l10n.enterInventoryAvailability
                : l10n.updateInventoryData,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: l10n.quantityLabel,
            controller: _quantity,
            icon: Icons.inventory_2_outlined,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: l10n.priceInSyrianPounds,
            controller: _price,
            icon: Icons.payments_outlined,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: l10n.lowStockThresholdLabel,
            controller: _threshold,
            icon: Icons.notification_important_outlined,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: context.appColors.surfaceSoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle_outline_rounded,
                  color: context.appColors.primary,
                  size: 21,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.availableForOrder,
                    style: TextStyle(
                      color: context.appColors.text,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Switch(
                  value: _available,
                  onChanged: (v) => setState(() => _available = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: context.appColors.surfaceSoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.visibility_outlined,
                  color: context.appColors.primary,
                  size: 21,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.showPriceToUser,
                    style: TextStyle(
                      color: context.appColors.text,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Switch(
                  value: _visible,
                  onChanged: (v) => setState(() => _visible = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 3650)),
              );
              if (picked != null) setState(() => _expiry = picked);
            },
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: context.appColors.surfaceSoft,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    color: context.appColors.primary,
                    size: 21,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.expiryDateLabel,
                          style: TextStyle(
                            color: context.appColors.text,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _expiry == null
                              ? l10n.notSpecified
                              : '${_expiry!.year}/${_expiry!.month}/${_expiry!.day}',
                          style: TextStyle(
                            color: context.appColors.textMuted,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: context.appColors.textMuted,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
          if (_validationError != null) ...[
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.appColors.danger.withValues(alpha: .07),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Text(
                _validationError!,
                style: const TextStyle(
                  color: Color(0xFFB33A3A),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                final q = int.tryParse(_quantity.text);
                final p = double.tryParse(_price.text);
                final t = int.tryParse(_threshold.text);
                if (q == null ||
                    q < 0 ||
                    p == null ||
                    p < 0 ||
                    t == null ||
                    t < 0) {
                  setState(() {
                    _validationError = l10n.invalidNumbersError;
                  });
                  return;
                }
                Navigator.pop(
                  context,
                  _InventoryDraft(
                    medicineId: widget.item?.medicineId ?? widget.medicine!.id,
                    quantity: q,
                    price: p,
                    threshold: t,
                    available: _available,
                    priceVisible: _visible,
                    expiryDate: _expiry,
                  ),
                );
              },
              child: Text(l10n.saveItem),
            ),
          ),
        ],
      ),
    ),
  );
  }
}

class _InventoryDraft {
  const _InventoryDraft({
    required this.medicineId,
    required this.quantity,
    required this.price,
    required this.threshold,
    required this.available,
    required this.priceVisible,
    this.expiryDate,
  });
  final String medicineId;
  final int quantity;
  final double price;
  final int threshold;
  final bool available;
  final bool priceVisible;
  final DateTime? expiryDate;
}

class _Chip extends StatelessWidget {
  const _Chip({required this.text, required this.color});
  final String text;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
    decoration: BoxDecoration(
      color: color.withValues(alpha: .08),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      text,
      style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700),
    ),
  );
}

class _InventoryEmpty extends StatelessWidget {
  const _InventoryEmpty({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListView(
    physics: const AlwaysScrollableScrollPhysics(),
    padding: const EdgeInsets.symmetric(horizontal: 28),
    children: [
      const SizedBox(height: 80),
      const Icon(
        Icons.inventory_2_outlined,
        size: 48,
        color: Color(0xFF668087),
      ),
      const SizedBox(height: 12),
      Text(
        l10n.noMatchingItems,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      const SizedBox(height: 6),
      Text(
        l10n.noMatchingItemsSubtitle,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      const SizedBox(height: 18),
      FilledButton.icon(
        onPressed: onAdd,
        icon: const Icon(Icons.add_rounded),
        label: Text(l10n.addMedicine),
      ),
    ],
  );
  }
}

String _stock(AppLocalizations l10n, String value) => switch (value.toLowerCase()) {
  'instock' => l10n.availableLabel,
  'lowstock' => l10n.lowStockLabel,
  'outofstock' => l10n.outOfStockLabel,
  _ => value,
};
Color _stockColor(BuildContext context, String value) => switch (value.toLowerCase()) {
  'instock' => context.appColors.primary,
  'lowstock' => context.appColors.primary,
  _ => context.appColors.danger,
};

class _StockStatusSelector extends StatelessWidget {
  const _StockStatusSelector({
    required this.selectedStatus,
    required this.onStatusSelected,
  });

  final String? selectedStatus;
  final Function(String) onStatusSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    return Row(
      children: [
        Expanded(
          child: _StockButton(
            label: l10n.allLabel,
            icon: Icons.apps_rounded,
            color: colors.primary,
            isSelected: selectedStatus == null,
            onTap: () => onStatusSelected('All'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StockButton(
            label: l10n.availableLabel,
            icon: Icons.check_circle_rounded,
            color: colors.primary,
            isSelected: selectedStatus == 'InStock',
            onTap: () => onStatusSelected('InStock'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StockButton(
            label: l10n.lowLabel,
            icon: Icons.warning_amber_rounded,
            color: colors.primary,
            isSelected: selectedStatus == 'LowStock',
            onTap: () => onStatusSelected('LowStock'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StockButton(
            label: l10n.outOfStockLabel,
            icon: Icons.remove_circle_rounded,
            color: colors.primary,
            isSelected: selectedStatus == 'OutOfStock',
            onTap: () => onStatusSelected('OutOfStock'),
          ),
        ),
      ],
    );
  }
}

class _StockButton extends StatelessWidget {
  const _StockButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? color : colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : colors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : color,
              size: 22,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : color,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}