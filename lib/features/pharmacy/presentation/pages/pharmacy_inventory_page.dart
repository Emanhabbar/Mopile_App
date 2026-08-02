import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../../core/widgets/async_states.dart';
import '../../data/models/pharmacy_models.dart';
import '../../data/repositories/pharmacy_repository.dart';
import '../controllers/pharmacy_providers.dart';
import '../widgets/batch_inventory_editor.dart';

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

  PharmacyInventoryFilter get _filter =>
      (search: _query, stockStatus: _stockStatus);

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pharmacyInventoryProvider(_filter));
    final snapshot = state.valueOrNull ?? const <PharmacyInventoryItem>[];
    return Scaffold(
      appBar: AppBar(
        title: const Text('مخزون الأدوية'),
        actions: [
          IconButton(
            onPressed: () => ref.invalidate(pharmacyInventoryProvider(_filter)),
            tooltip: 'تحديث المخزون',
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
                TextField(
                  controller: _search,
                  onSubmitted: (value) => setState(() => _query = value.trim()),
                  decoration: InputDecoration(
                    hintText: 'ابحث باسم الدواء أو الاسم العلمي',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: IconButton(
                      onPressed: () =>
                          setState(() => _query = _search.text.trim()),
                      icon: const Icon(Icons.arrow_forward_rounded),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'All', label: Text('الكل')),
                      ButtonSegment(value: 'InStock', label: Text('متوفر')),
                      ButtonSegment(value: 'LowStock', label: Text('منخفض')),
                      ButtonSegment(value: 'OutOfStock', label: Text('نافد')),
                    ],
                    selected: {_stockStatus ?? 'All'},
                    onSelectionChanged: (values) => setState(() {
                      _stockStatus = values.first == 'All'
                          ? null
                          : values.first;
                    }),
                    showSelectedIcon: false,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: state.when(
              loading: () =>
                  const AppLoadingState(label: 'جاري تحميل المخزون...'),
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
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                        itemCount: items.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, index) => _InventoryCard(
                          item: items[index],
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
      useSafeArea: true,
      builder: (context) => const _AddMedicineOptions(),
    );
    if (!mounted || action == null) return;
    if (action == _AddMedicineAction.manual) {
      await _openManualEditor();
    } else {
      await _openCatalog();
    }
  }

  Future<void> _openCatalog() async {
    final selected = await showModalBottomSheet<List<PharmacyCatalogMedicine>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const _CatalogSheet(),
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
      _message('تمت إضافة ${items.length} أدوية إلى المخزون.');
    } catch (error) {
      _message(_error(error), true);
    }
  }

  Future<void> _openManualEditor() async {
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
          scientificName: info.scientificName,
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
            scientificName: info.scientificName,
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
      _refresh();
      _message('تم إنشاء الدواء وإضافته إلى المخزون.');
    } catch (error) {
      _message(_error(error), true);
    }
  }

  Future<void> _editItem(
    PharmacyInventoryItem? item, {
    PharmacyCatalogMedicine? medicine,
  }) async {
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
      _message(item == null ? 'تمت إضافة الدواء.' : 'تم تحديث الصنف.');
    } catch (error) {
      _message(_error(error), true);
    }
  }

  Future<void> _delete(PharmacyInventoryItem item) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الصنف؟'),
        content: Text('سيتم حذف ${item.medicineName} من مخزون الصيدلية.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            child: const Text('حذف'),
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
      _message('تم حذف الصنف.');
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
        backgroundColor: error ? AppColors.danger : null,
      ),
    );
  }

  String _error(Object error) =>
      error is ApiException ? error.message : 'تعذر إكمال العملية.';
}

class _InventoryOverview extends StatelessWidget {
  const _InventoryOverview({required this.items, required this.onAdd});

  final List<PharmacyInventoryItem> items;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
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
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [AppColors.primaryDeep, Color(0xFF185866)],
        ),
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
                child: const Icon(
                  Icons.inventory_2_rounded,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'إدارة المخزون',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: Colors.white),
                    ),
                    Text(
                      '${items.length} صنف · $available متاح للطلب',
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
                tooltip: 'إضافة دواء',
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: AppColors.primaryDeep,
                ),
                icon: const Icon(Icons.add_rounded),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _OverviewFact(
                label: 'متوفر',
                value: available,
                color: AppColors.primaryLight,
              ),
              const SizedBox(width: 8),
              _OverviewFact(
                label: 'منخفض',
                value: low,
                color: AppColors.secondary,
              ),
              const SizedBox(width: 8),
              _OverviewFact(
                label: 'نافد',
                value: out,
                color: const Color(0xFFFFA0A0),
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
    required this.onEdit,
    required this.onDelete,
  });
  final PharmacyInventoryItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  @override
  Widget build(BuildContext context) {
    final statusColor = _stockColor(item.stockStatus);
    final details = [
      item.scientificName,
      item.dosageForm,
      item.capacity,
    ].whereType<String>().where((value) => value.isNotEmpty).join(' · ');
    final expiry = item.expiryDateUtc == null
        ? null
        : '${item.expiryDateUtc!.year}/${item.expiryDateUtc!.month.toString().padLeft(2, '0')}/${item.expiryDateUtc!.day.toString().padLeft(2, '0')}';
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onEdit,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 5, color: statusColor),
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
                            tooltip: 'خيارات الصنف',
                            onSelected: (value) =>
                                value == 'edit' ? onEdit() : onDelete(),
                            itemBuilder: (_) => const [
                              PopupMenuItem(
                                value: 'edit',
                                child: ListTile(
                                  leading: Icon(Icons.edit_outlined),
                                  title: Text('تعديل'),
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: ListTile(
                                  leading: Icon(
                                    Icons.delete_outline_rounded,
                                    color: AppColors.danger,
                                  ),
                                  title: Text('حذف'),
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
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            _InventoryFact(
                              label: 'الكمية',
                              value: '${item.quantity}',
                            ),
                            _InventoryFact(
                              label: 'السعر',
                              value: item.isPriceVisibleToUsers
                                  ? '${item.sellingPrice.toStringAsFixed(0)} ل.س'
                                  : 'مخفي',
                            ),
                            _InventoryFact(
                              label: 'الحالة',
                              value: _stock(item.stockStatus),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 7,
                        runSpacing: 7,
                        children: [
                          _Chip(
                            text: item.isAvailable ? 'متاح للطلب' : 'غير متاح',
                            color: item.isAvailable
                                ? AppColors.success
                                : AppColors.textMuted,
                          ),
                          if (item.requiresPrescription)
                            const _Chip(
                              text: 'يتطلب وصفة',
                              color: Color(0xFFB47618),
                            ),
                          if (expiry != null)
                            _Chip(
                              text: 'ينتهي $expiry',
                              color:
                                  item.daysUntilExpiry != null &&
                                      item.daysUntilExpiry! <= 30
                                  ? AppColors.danger
                                  : AppColors.textMuted,
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
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

enum _AddMedicineAction { catalog, manual }

class _AddMedicineOptions extends StatelessWidget {
  const _AddMedicineOptions();

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'إضافة إلى المخزون',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            'اختر الطريقة الأنسب لإدخال الدواء.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          _AddOptionTile(
            icon: Icons.library_add_outlined,
            title: 'اختيار من دليل الأدوية',
            subtitle: 'اختر دواءً واحدًا أو عدة أدوية دفعة واحدة',
            onTap: () => Navigator.pop(context, _AddMedicineAction.catalog),
          ),
          const SizedBox(height: 10),
          _AddOptionTile(
            icon: Icons.edit_note_rounded,
            title: 'إضافة دواء يدويًا',
            subtitle: 'استخدمها عندما لا تجد الدواء في الدليل',
            onTap: () => Navigator.pop(context, _AddMedicineAction.manual),
          ),
        ],
      ),
    ),
  );
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
    color: AppColors.surfaceSoft,
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
              child: Icon(icon, color: AppColors.primary),
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
            const Icon(Icons.chevron_left_rounded, color: AppColors.primary),
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
  final _scientificName = TextEditingController();
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
    _scientificName.dispose();
    _manufacturer.dispose();
    _dosageForm.dispose();
    _packageSize.dispose();
    _capacity.dispose();
    _composition.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(
      20,
      16,
      20,
      MediaQuery.viewInsetsOf(context).bottom + 24,
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
                color: AppColors.border,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'بيانات الدواء الجديد',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            'اكتب البيانات كما تظهر على عبوة الدواء لتسهيل العثور عليه.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          _TextField(
            label: 'اسم الدواء *',
            controller: _name,
            icon: Icons.medication_outlined,
          ),
          _TextField(
            label: 'الاسم العلمي',
            controller: _scientificName,
            icon: Icons.science_outlined,
          ),
          _TextField(
            label: 'الشركة المصنعة',
            controller: _manufacturer,
            icon: Icons.factory_outlined,
          ),
          Row(
            children: [
              Expanded(
                child: _TextField(
                  label: 'الشكل الدوائي',
                  controller: _dosageForm,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _TextField(
                  label: 'التركيز أو السعة',
                  controller: _capacity,
                ),
              ),
            ],
          ),
          _TextField(
            label: 'حجم العبوة',
            controller: _packageSize,
            icon: Icons.inventory_2_outlined,
          ),
          _TextField(
            label: 'التركيب الدوائي',
            controller: _composition,
            icon: Icons.biotech_outlined,
            lines: 2,
          ),
          _TextField(
            label: 'وصف إضافي',
            controller: _description,
            icon: Icons.notes_rounded,
            lines: 3,
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 13),
            decoration: BoxDecoration(
              color: AppColors.surfaceSoft,
              borderRadius: BorderRadius.circular(15),
            ),
            child: SwitchListTile(
              value: _requiresPrescription,
              onChanged: (value) =>
                  setState(() => _requiresPrescription = value),
              secondary: const Icon(
                Icons.description_outlined,
                color: AppColors.primary,
              ),
              title: const Text('يتطلب وصفة طبية'),
            ),
          ),
          if (_error != null) ...[
            Text(
              _error!,
              style: const TextStyle(
                color: AppColors.danger,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
          ],
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.arrow_back_rounded),
              label: const Text('متابعة إلى بيانات المخزون'),
            ),
          ),
        ],
      ),
    ),
  );

  void _submit() {
    if (_name.text.trim().isEmpty) {
      setState(() => _error = 'اسم الدواء مطلوب.');
      return;
    }
    Navigator.pop(
      context,
      _ManualMedicineInfo(
        name: _name.text.trim(),
        scientificName: _cleanText(_scientificName.text),
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

class _TextField extends StatelessWidget {
  const _TextField({
    required this.label,
    required this.controller,
    this.icon,
    this.lines = 1,
  });
  final String label;
  final TextEditingController controller;
  final IconData? icon;
  final int lines;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextField(
      controller: controller,
      minLines: lines,
      maxLines: lines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon == null ? null : Icon(icon),
        alignLabelWithHint: lines > 1,
      ),
    ),
  );
}

class _ManualMedicineInfo {
  const _ManualMedicineInfo({
    required this.name,
    required this.requiresPrescription,
    this.scientificName,
    this.manufacturer,
    this.dosageForm,
    this.packageSize,
    this.capacity,
    this.composition,
    this.description,
  });
  final String name;
  final String? scientificName;
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
  const _CatalogSheet();
  @override
  ConsumerState<_CatalogSheet> createState() => _CatalogSheetState();
}

class _CatalogSheetState extends ConsumerState<_CatalogSheet> {
  final _search = TextEditingController();
  final Map<String, PharmacyCatalogMedicine> _selected = {};
  String _query = '';
  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pharmacyCatalogProvider(_query));
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
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'اختيار أدوية من الدليل',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 3),
                Text(
                  'يمكنك اختيار دواء واحد أو عدة أدوية وإضافتها دفعة واحدة.',
                  style: Theme.of(context).textTheme.bodyMedium,
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
                      color: AppColors.surfaceWarm,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Text(
                      'تم اختيار ${_selected.length} دواء',
                      style: const TextStyle(
                        color: AppColors.warning,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                TextField(
                  controller: _search,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) => setState(() => _query = value.trim()),
                  decoration: InputDecoration(
                    hintText: 'اسم الدواء أو الاسم العلمي',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: IconButton(
                      onPressed: () =>
                          setState(() => _query = _search.text.trim()),
                      icon: const Icon(Icons.arrow_forward_rounded),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: state.when(
              loading: () => const AppLoadingState(),
              error: (error, _) => AppErrorState(
                error: error,
                onRetry: () => ref.invalidate(pharmacyCatalogProvider(_query)),
              ),
              data: (items) => ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(height: 9),
                itemBuilder: (_, index) {
                  final medicine = items[index];
                  final selected = _selected.containsKey(medicine.id);
                  return Card(
                    margin: EdgeInsets.zero,
                    clipBehavior: Clip.antiAlias,
                    color: selected
                        ? AppColors.primary.withValues(alpha: .06)
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
                          color: AppColors.surfaceSoft,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.medication_rounded,
                          color: AppColors.primary,
                        ),
                      ),
                      title: Text(medicine.name),
                      subtitle: Text(
                        [
                          medicine.scientificName,
                          medicine.dosageForm,
                          medicine.capacity,
                        ].whereType<String>().join(' · '),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 160),
                        child: Icon(
                          selected
                              ? Icons.check_circle_rounded
                              : Icons.add_circle_outline_rounded,
                          key: ValueKey(selected),
                          color: selected
                              ? AppColors.primary
                              : AppColors.textMuted,
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
            minimum: const EdgeInsets.fromLTRB(20, 8, 20, 14),
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
                      ? 'اختر دواءً واحدًا على الأقل'
                      : 'متابعة مع ${_selected.length} دواء',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(
      20,
      20,
      20,
      MediaQuery.viewInsetsOf(context).bottom + 24,
    ),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.item?.medicineName ?? widget.medicine?.name ?? '',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            widget.item == null
                ? 'أدخل بيانات توفر الدواء داخل صيدليتك.'
                : 'حدّث الكمية والسعر وحالة العرض للمستخدمين.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          _NumberField(label: 'الكمية', controller: _quantity),
          _NumberField(
            label: 'السعر بالليرة السورية',
            controller: _price,
            decimal: true,
          ),
          _NumberField(label: 'حد المخزون المنخفض', controller: _threshold),
          SwitchListTile(
            value: _available,
            onChanged: (v) => setState(() => _available = v),
            title: const Text('متاح للطلب'),
          ),
          SwitchListTile(
            value: _visible,
            onChanged: (v) => setState(() => _visible = v),
            title: const Text('إظهار السعر للمستخدم'),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('تاريخ الانتهاء'),
            subtitle: Text(
              _expiry == null
                  ? 'غير محدد'
                  : '${_expiry!.year}/${_expiry!.month}/${_expiry!.day}',
            ),
            trailing: const Icon(Icons.calendar_today_rounded),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 3650)),
              );
              if (picked != null) setState(() => _expiry = picked);
            },
          ),
          if (_validationError != null) ...[
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.danger.withValues(alpha: .07),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Text(
                _validationError!,
                style: const TextStyle(
                  color: AppColors.danger,
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
                    _validationError =
                        'أدخل أرقامًا صحيحة؛ لا يمكن أن تكون الكمية أو السعر أو حد المخزون أقل من صفر.';
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
              child: const Text('حفظ الصنف'),
            ),
          ),
        ],
      ),
    ),
  );
}

class _NumberField extends StatelessWidget {
  const _NumberField({
    required this.label,
    required this.controller,
    this.decimal = false,
  });
  final String label;
  final TextEditingController controller;
  final bool decimal;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 11),
    child: TextField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: decimal),
      decoration: InputDecoration(labelText: label),
    ),
  );
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
  Widget build(BuildContext context) => ListView(
    physics: const AlwaysScrollableScrollPhysics(),
    padding: const EdgeInsets.symmetric(horizontal: 28),
    children: [
      const SizedBox(height: 80),
      const Icon(
        Icons.inventory_2_outlined,
        size: 48,
        color: AppColors.textMuted,
      ),
      const SizedBox(height: 12),
      Text(
        'لا توجد أصناف مطابقة',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      const SizedBox(height: 6),
      Text(
        'غيّر البحث أو أضف دواءً جديدًا من دليل الأدوية.',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      const SizedBox(height: 18),
      FilledButton.icon(
        onPressed: onAdd,
        icon: const Icon(Icons.add_rounded),
        label: const Text('إضافة دواء'),
      ),
    ],
  );
}

String _stock(String value) => switch (value.toLowerCase()) {
  'instock' => 'متوفر',
  'lowstock' => 'مخزون منخفض',
  'outofstock' => 'نافد',
  _ => value,
};
Color _stockColor(String value) => switch (value.toLowerCase()) {
  'instock' => AppColors.success,
  'lowstock' => const Color(0xFFB47618),
  _ => AppColors.danger,
};
