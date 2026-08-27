import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_roles.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../../core/widgets/app_reveal.dart';
import '../../../../core/widgets/async_states.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../medicines/data/repositories/medicines_repository.dart';
import '../../data/models/supply_chain_models.dart';
import '../../data/repositories/supply_chain_repository.dart';
import '../controllers/supply_chain_providers.dart';

class SupplyChainWorkspacePage extends ConsumerWidget {
  const SupplyChainWorkspacePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref
        .watch(authControllerProvider)
        .valueOrNull
        ?.user
        .primaryRole;
    return switch (role) {
      AppRole.warehouse => const _WarehouseWorkspace(),
      AppRole.representative => const _RepresentativeWorkspace(),
      _ => const _PharmacySupplyWorkspace(),
    };
  }
}

class _WarehouseWorkspace extends ConsumerStatefulWidget {
  const _WarehouseWorkspace();

  @override
  ConsumerState<_WarehouseWorkspace> createState() =>
      _WarehouseWorkspaceState();
}

class _WarehouseWorkspaceState extends ConsumerState<_WarehouseWorkspace> {
  int section = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pending = ref
        .watch(supplyDashboardProvider)
        .valueOrNull
        ?.pendingOrders;
    final pages = <Widget>[
      const _WarehouseDashboard(),
      const _BatchesTab(),
      const _OrdersTab(warehouse: true),
      const _RepresentativesTab(),
      const _FinanceTab(),
    ];
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.supplyWarehouseTitle),
            Text(
              l10n.supplyWarehouseSubtitle,
              style: TextStyle(
                color: context.appColors.textMuted,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: l10n.refreshDataTooltip,
            onPressed: _refresh,
            icon: const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          _WarehouseNavigation(
            selected: section,
            pendingOrders: pending ?? 0,
            onSelected: (value) => setState(() => section = value),
          ),
          const Divider(height: 1),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 320),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: KeyedSubtree(
                key: ValueKey(section),
                child: pages[section],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _refresh() {
    switch (section) {
      case 0:
        ref.invalidate(supplyDashboardProvider);
        return;
      case 1:
        ref.invalidate(supplyBatchesProvider);
        return;
      case 2:
        ref.invalidate(supplyOrdersProvider);
        return;
      case 3:
        ref.invalidate(supplyRepresentativesProvider);
        return;
      case 4:
        ref
          ..invalidate(supplyInvoicesProvider)
          ..invalidate(supplyReturnsProvider)
          ..invalidate(supplyRecallsProvider);
        return;
    }
  }
}

class _WarehouseNavigation extends StatelessWidget {
  const _WarehouseNavigation({
    required this.selected,
    required this.pendingOrders,
    required this.onSelected,
  });

  final int selected;
  final int pendingOrders;
  final ValueChanged<int> onSelected;

  static List<({String label, IconData icon, int? count})> sections(
    AppLocalizations l10n,
  ) =>
      [
        (label: l10n.supplySummaryLabel, icon: Icons.dashboard_rounded, count: null),
        (label: l10n.supplyBatchesLabel, icon: Icons.inventory_2_outlined, count: null),
        (label: l10n.supplyOrdersLabel, icon: Icons.receipt_long_outlined, count: null),
        (label: l10n.supplyRepresentativesLabel, icon: Icons.delivery_dining_outlined, count: null),
        (
          label: l10n.supplyFinanceLabel,
          icon: Icons.account_balance_wallet_outlined,
          count: null,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final itemsWithCounts = sections(l10n).map((item) {
      if (item.label == l10n.supplyOrdersLabel) {
        return (label: item.label, icon: item.icon, count: pendingOrders);
      }
      return item;
    }).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: itemsWithCounts
            .asMap()
            .entries
            .map((entry) {
              final selected = this.selected == entry.key;
              final item = entry.value;
              return Padding(
                padding: const EdgeInsetsDirectional.only(end: 8),
                child: Material(
                  color: selected
                      ? context.appColors.primary
                      : context.appColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                    side: BorderSide(
                      color: selected
                          ? context.appColors.primary
                          : context.appColors.border,
                    ),
                  ),
                  child: InkWell(
                    onTap: () => onSelected(entry.key),
                    borderRadius: BorderRadius.circular(17),
                    child: AnimatedPadding(
                      duration: const Duration(milliseconds: 220),
                      padding: EdgeInsets.symmetric(
                        horizontal: selected ? 17 : 14,
                        vertical: 11,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            item.icon,
                            size: 19,
                            color: selected
                                ? Colors.white
                                : context.appColors.primary,
                          ),
                          const SizedBox(width: 7),
                          Text(
                            item.label,
                            style: TextStyle(
                              color: selected
                                  ? Colors.white
                                  : context.appColors.text,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          if ((item.count ?? 0) > 0) ...[
                            const SizedBox(width: 7),
                            Container(
                              constraints: const BoxConstraints(minWidth: 20),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: selected
                                    ? context.appColors.secondary.withValues(
                                        alpha: .3,
                                      )
                                    : context.appColors.primary.withValues(
                                        alpha: .1,
                                      ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${item.count}',
                                style: TextStyle(
                                  color: selected
                                      ? Colors.white
                                      : context.appColors.primary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            })
            .toList(growable: false),
      ),
    );
  }
}

class _WarehouseDashboard extends ConsumerWidget {
  const _WarehouseDashboard();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return ref
        .watch(supplyDashboardProvider)
        .when(
          loading: () => AppLoadingState(label: l10n.supplyLoadingWarehouse),
          error: (e, _) => AppErrorState(
            error: e,
            onRetry: () => ref.invalidate(supplyDashboardProvider),
          ),
          data: (data) => RefreshIndicator(
            onRefresh: () => ref.refresh(supplyDashboardProvider.future),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                AppReveal(
                  child: _Hero(
                    icon: Icons.warehouse_rounded,
                    title: l10n.supplyWarehouseOpsTitle,
                    subtitle: l10n.supplyInventoryValue(_money(data.inventoryValue)),
                    badge: l10n.supplyNewOrdersCount(data.pendingOrders),
                  ),
                ),
                const SizedBox(height: 20),
                _SectionTitle(
                  l10n.supplyTodayIndicators,
                  Icons.insights_rounded,
                  subtitle: l10n.supplyTodayIndicatorsSubtitle,
                ),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 1.7,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    AppReveal(
                      delay: Duration(milliseconds: 70),
                      child: _Metric(
                        l10n.supplyActiveBatches,
                        data.activeBatches,
                        Icons.inventory_2_outlined,
                        context.appColors.primary,
                      ),
                    ),
                    AppReveal(
                      delay: Duration(milliseconds: 110),
                      child: _Metric(
                        l10n.supplyLowStock,
                        data.lowStockBatches,
                        Icons.trending_down_rounded,
                        context.appColors.primary,
                      ),
                    ),
                    AppReveal(
                      delay: Duration(milliseconds: 150),
                      child: _Metric(
                        l10n.supplyExpiringSoon,
                        data.expiringBatches,
                        Icons.event_busy_outlined,
                        context.appColors.primary,
                      ),
                    ),
                    AppReveal(
                      delay: Duration(milliseconds: 190),
                      child: _Metric(
                        l10n.supplyActiveDeliveries,
                        data.activeDeliveries,
                        Icons.local_shipping_outlined,
                        context.appColors.primary,
                      ),
                    ),
                  ],
                ),
                if (data.alerts.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  _SectionTitle(
                    l10n.supplyNeedsAttention,
                    Icons.notifications_active_outlined,
                    subtitle: l10n.supplyNeedsAttentionSubtitle,
                  ),
                  ...data.alerts.map((b) => _BatchCard(batch: b)),
                ],
              ],
            ),
          ),
        );
  }
}

class _BatchesTab extends ConsumerWidget {
  const _BatchesTab();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(supplyBatchesProvider);
    return Scaffold(
      body: state.when(
        loading: () => const AppLoadingState(),
        error: (e, _) => AppErrorState(
          error: e,
          onRetry: () => ref.invalidate(supplyBatchesProvider),
        ),
        data: (items) => RefreshIndicator(
          onRefresh: () => ref.refresh(supplyBatchesProvider.future),
          child: items.isEmpty
              ? _Empty(
                  icon: Icons.inventory_2_outlined,
                  text: l10n.supplyNoBatches,
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 90),
                  itemCount: items.length + 1,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => i == 0
                      ? _CollectionHeader(
                          icon: Icons.inventory_2_outlined,
                          title: l10n.supplyBatchesStockTitle,
                          subtitle: l10n.supplyBatchesStockSubtitle,
                          count: items.length,
                        )
                      : AppReveal(
                          delay: Duration(
                            milliseconds: ((i - 1).clamp(0, 5)) * 45,
                          ),
                          child: _BatchCard(batch: items[i - 1]),
                        ),
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addBatch(context, ref),
        backgroundColor: context.appColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text(l10n.supplyBatchLabel),
      ),
    );
  }
}

Future<void> _addBatch(BuildContext context, WidgetRef ref) async {
  final medicines = await ref
      .read(medicinesRepositoryProvider)
      .getMedicines(pageSize: 100);
  if (!context.mounted) return;
  final l10n = AppLocalizations.of(context);
  String? medicineId = medicines.items.isEmpty
      ? null
      : medicines.items.first.id;
  final batch = TextEditingController(),
      quantity = TextEditingController(),
      purchase = TextEditingController(),
      price = TextEditingController(),
      location = TextEditingController();
  DateTime expiry = DateTime.now().add(const Duration(days: 365));
  final save = await showDialog<bool>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text(l10n.supplyAddBatch),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: medicineId,
                isExpanded: true,
                decoration: InputDecoration(labelText: l10n.medicineLabel),
                items: medicines.items
                    .map(
                      (m) => DropdownMenuItem(
                        value: m.id,
                        child: Text(m.name, overflow: TextOverflow.ellipsis),
                      ),
                    )
                    .toList(),
                onChanged: (v) => medicineId = v,
              ),
              const SizedBox(height: 10),
              _Field(batch, l10n.supplyBatchNumber),
              _Field(quantity, l10n.quantityLabel, number: true),
              _Field(purchase, l10n.supplyPurchasePrice, number: true),
              _Field(price, l10n.supplyWholesalePrice, number: true),
              _Field(location, l10n.supplyStorageLocation),
              ListTile(
                title: Text(l10n.expiryDateLabel),
                subtitle: Text(_date(expiry)),
                trailing: const Icon(Icons.calendar_month),
                onTap: () async {
                  final d = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 3650)),
                  );
                  if (d != null) setState(() => expiry = d);
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.save),
          ),
        ],
      ),
    ),
  );
  if (save == true && medicineId != null && batch.text.trim().isNotEmpty) {
    try {
      await ref
          .read(supplyChainRepositoryProvider)
          .saveBatch(
            medicineId: medicineId!,
            batchNumber: batch.text.trim(),
            quantity: int.tryParse(quantity.text) ?? 0,
            purchasePrice: double.tryParse(purchase.text) ?? 0,
            wholesalePrice: double.tryParse(price.text) ?? 0,
            expiryDate: expiry,
            storageLocation: location.text.trim(),
          );
      ref
        ..invalidate(supplyBatchesProvider)
        ..invalidate(supplyDashboardProvider);
      if (context.mounted) _snack(context, l10n.supplyBatchAdded);
    } catch (e) {
      if (context.mounted) _snack(context, _error(l10n, e), true);
    }
  }
  for (final c in [batch, quantity, purchase, price, location]) {
    c.dispose();
  }
}

class _OrdersTab extends ConsumerStatefulWidget {
  const _OrdersTab({required this.warehouse});

  final bool warehouse;

  @override
  ConsumerState<_OrdersTab> createState() => _OrdersTabState();
}

class _OrdersTabState extends ConsumerState<_OrdersTab> {
  String filter = 'all';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ref
        .watch(supplyOrdersProvider)
        .when(
          loading: () => AppLoadingState(label: l10n.supplyLoadingOrders),
          error: (error, _) => AppErrorState(
            error: error,
            onRetry: () => ref.invalidate(supplyOrdersProvider),
          ),
          data: (items) {
            final visible = items.where(_matchesFilter).toList();
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                  child: _CollectionHeader(
                    icon: Icons.receipt_long_outlined,
                    title: widget.warehouse
                        ? l10n.supplyPharmacyOrdersTitle
                        : l10n.supplyMyOrders,
                    subtitle: widget.warehouse
                        ? l10n.supplyPharmacyOrdersSubtitle
                        : l10n.supplyMyOrdersSubtitle,
                    count: items.length,
                  ),
                ),
                SizedBox(
                  height: 54,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    children: [
                      _filterChip('all', l10n.allLabel, items.length),
                      _filterChip(
                        'new',
                        l10n.supplyNewOrdersFilter,
                        items.where((x) => x.status == 'Submitted').length,
                      ),
                      _filterChip(
                        'active',
                        l10n.supplyActiveOrdersFilter,
                        items.where(_isActive).length,
                      ),
                      _filterChip(
                        'done',
                        l10n.completedLabel,
                        items.where(_isDone).length,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => ref.refresh(supplyOrdersProvider.future),
                    child: visible.isEmpty
                        ? _Empty(
                            icon: Icons.receipt_long_outlined,
                            text: l10n.supplyNoOrdersInCategory,
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                            itemCount: visible.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) => AppReveal(
                              delay: Duration(
                                milliseconds: index.clamp(0, 5) * 45,
                              ),
                              child: _OrderCard(
                                order: visible[index],
                                actions: widget.warehouse,
                                onChanged: () =>
                                    ref.invalidate(supplyOrdersProvider),
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            );
          },
        );
  }

  bool _matchesFilter(SupplyOrder order) => switch (filter) {
    'new' => order.status == 'Submitted',
    'active' => _isActive(order),
    'done' => _isDone(order),
    _ => true,
  };

  bool _isActive(SupplyOrder order) => const {
    'Accepted',
    'Preparing',
    'ReadyForDispatch',
    'Shipped',
  }.contains(order.status);

  bool _isDone(SupplyOrder order) =>
      const {'Delivered', 'Rejected', 'Cancelled'}.contains(order.status);

  Widget _filterChip(String value, String label, int count) {
    final colors = context.appColors;
    final selected = filter == value;
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 8),
      child: InkWell(
        onTap: () => setState(() => filter = value),
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? colors.primary : colors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? colors.primary : colors.border,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : colors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: selected
                      ? colors.secondary.withValues(alpha: .3)
                      : colors.primary.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    color: selected ? Colors.white : colors.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
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

class _OrderCard extends ConsumerWidget {
  const _OrderCard({
    required this.order,
    required this.actions,
    required this.onChanged,
  });
  final SupplyOrder order;
  final bool actions;
  final VoidCallback onChanged;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Card(
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: context.appColors.surfaceSoft,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  Icons.local_shipping_outlined,
                  color: context.appColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '#${order.orderCode}',
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    Text(actions ? order.pharmacyName : order.warehouseName),
                  ],
                ),
              ),
              _Badge(
                _status(l10n, order.status),
                _statusColor(context.appColors, order.status),
              ),
            ],
          ),
          const Divider(height: 24),
          Text(
            l10n.supplyOrderItemsTotal(
              order.items.length,
              _money(order.totalAmount),
            ),
          ),
          if (order.shipment != null)
            Text(
              l10n.supplyShipmentInfo(
                order.shipment!.shipmentCode,
                _status(l10n, order.shipment!.status),
              ),
              style: TextStyle(color: context.appColors.textMuted),
            ),
          if (actions &&
              ![
                'Delivered',
                'Rejected',
                'Cancelled',
              ].contains(order.status)) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 7,
              children: [
                if (order.status == 'Submitted')
                  FilledButton(
                    onPressed: () => _statusUpdate(context, ref, 'Accepted'),
                    child: Text(l10n.supplyAccept),
                  ),
                if (order.status == 'Accepted')
                  FilledButton(
                    onPressed: () => _statusUpdate(context, ref, 'Preparing'),
                    child: Text(l10n.supplyStartPreparing),
                  ),
                if (order.status == 'Preparing')
                  FilledButton(
                    onPressed: () =>
                        _statusUpdate(context, ref, 'ReadyForDispatch'),
                    child: Text(l10n.supplyReadyForDispatch),
                  ),
                if (order.status == 'ReadyForDispatch' &&
                    order.shipment == null)
                  FilledButton.icon(
                    onPressed: () => _assignShipment(context, ref),
                    icon: const Icon(Icons.delivery_dining_outlined),
                    label: Text(l10n.supplyAssignRepresentative),
                  ),
                TextButton(
                  onPressed: () => _statusUpdate(context, ref, 'Rejected'),
                  child: Text(l10n.reject),
                ),
              ],
            ),
          ],
          if (!actions &&
              order.shipment?.status == 'Arrived' &&
              order.status != 'Delivered') ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => _confirmDelivery(context, ref),
                icon: const Icon(Icons.qr_code_scanner_rounded),
                label: Text(l10n.supplyConfirmReceipt),
              ),
            ),
          ],
          if (!actions && order.status == 'Delivered') ...[
            const SizedBox(height: 8),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton.icon(
                onPressed: () => _createReturn(context, ref),
                icon: const Icon(Icons.keyboard_return_rounded),
                label: Text(l10n.supplyReturnItem),
              ),
            ),
          ],
        ],
      ),
    ),
  );
  }
  Future<void> _statusUpdate(
    BuildContext context,
    WidgetRef ref,
    String status,
  ) async {
    final l10n = AppLocalizations.of(context);
    try {
      await ref
          .read(supplyChainRepositoryProvider)
          .updateOrderStatus(order.id, status);
      onChanged();
      if (context.mounted) _snack(context, l10n.supplyOrderUpdated);
    } catch (e) {
      if (context.mounted) _snack(context, _error(l10n, e), true);
    }
  }

  Future<void> _assignShipment(BuildContext context, WidgetRef ref) async {
    try {
      final representatives = await ref.read(
        supplyRepresentativesProvider.future,
      );
      if (!context.mounted) return;
      final l10n = AppLocalizations.of(context);
      String? selectedId = representatives
          .where((item) => item.isEnabled && item.isAvailable)
          .firstOrNull
          ?.id;
      final packages = TextEditingController(text: '1');
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: Text(l10n.supplyAssignShipment),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: selectedId,
                  decoration: InputDecoration(labelText: l10n.supplyRepresentativeLabel),
                  items: representatives
                      .where((item) => item.isEnabled)
                      .map(
                        (item) => DropdownMenuItem(
                          value: item.id,
                          child: Text(item.fullName),
                        ),
                      )
                      .toList(growable: false),
                  onChanged: (value) =>
                      setDialogState(() => selectedId = value),
                ),
                const SizedBox(height: 10),
                _Field(packages, l10n.supplyPackagesCount, number: true),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: Text(l10n.cancel),
              ),
              FilledButton(
                onPressed: selectedId == null
                    ? null
                    : () => Navigator.pop(dialogContext, true),
                child: Text(l10n.supplyAssign),
              ),
            ],
          ),
        ),
      );
      final packageCount = int.tryParse(packages.text) ?? 1;
      packages.dispose();
      if (confirmed != true || selectedId == null) return;
      await ref
          .read(supplyChainRepositoryProvider)
          .assignShipment(order.id, selectedId!, packageCount: packageCount);
      onChanged();
      if (context.mounted) _snack(context, l10n.supplyShipmentAssigned);
    } catch (error) {
      if (context.mounted) _snack(context, _error(AppLocalizations.of(context), error), true);
    }
  }

  Future<void> _confirmDelivery(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final token = TextEditingController();
    final note = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.supplyConfirmReceipt),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Field(token, l10n.supplyReceiptCode),
            _Field(note, l10n.supplyReceiptNote),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
    final qrToken = token.text.trim();
    final proofNote = note.text.trim();
    token.dispose();
    note.dispose();
    if (confirmed != true || qrToken.isEmpty) return;
    try {
      await ref
          .read(supplyChainRepositoryProvider)
          .confirmDelivery(order.shipment!.id, qrToken, note: proofNote);
      onChanged();
      if (context.mounted) _snack(context, l10n.supplyReceiptConfirmed);
    } catch (error) {
      if (context.mounted) _snack(context, _error(l10n, error), true);
    }
  }

  Future<void> _createReturn(BuildContext context, WidgetRef ref) async {
    if (order.items.isEmpty) return;
    final l10n = AppLocalizations.of(context);
    var itemId = order.items.first.id;
    final quantity = TextEditingController(text: '1');
    final reason = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(l10n.supplyReturnItem),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: itemId,
                decoration: InputDecoration(labelText: l10n.supplyItemLabel),
                items: order.items
                    .map(
                      (item) => DropdownMenuItem(
                        value: item.id,
                        child: Text(item.medicineName),
                      ),
                    )
                    .toList(growable: false),
                onChanged: (value) {
                  if (value != null) setDialogState(() => itemId = value);
                },
              ),
              const SizedBox(height: 8),
              _Field(quantity, l10n.quantityLabel, number: true),
              _Field(reason, l10n.supplyReturnReason),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(l10n.sendRequest),
            ),
          ],
        ),
      ),
    );
    final count = int.tryParse(quantity.text) ?? 0;
    final returnReason = reason.text.trim();
    quantity.dispose();
    reason.dispose();
    if (confirmed != true || count < 1 || returnReason.isEmpty) return;
    try {
      await ref
          .read(supplyChainRepositoryProvider)
          .createReturn(order.id, itemId, count, returnReason);
      ref.invalidate(supplyReturnsProvider);
      if (context.mounted) _snack(context, l10n.supplyReturnSent);
    } catch (error) {
      if (context.mounted) _snack(context, _error(l10n, error), true);
    }
  }
}

class _RepresentativesTab extends ConsumerWidget {
  const _RepresentativesTab();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
    body: ref
        .watch(supplyRepresentativesProvider)
        .when(
          loading: () => const AppLoadingState(),
          error: (e, _) => AppErrorState(
            error: e,
            onRetry: () => ref.invalidate(supplyRepresentativesProvider),
          ),
          data: (items) => items.isEmpty
              ? _Empty(
                  icon: Icons.badge_outlined,
                  text: l10n.supplyNoRepresentatives,
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 90),
                  itemCount: items.length + 1,
                  separatorBuilder: (_, _) => const SizedBox(height: 9),
                  itemBuilder: (context, i) => i == 0
                      ? _CollectionHeader(
                          icon: Icons.delivery_dining_outlined,
                          title: l10n.supplyDeliveryTeam,
                          subtitle: l10n.supplyTeamSummary(
                            items.where((x) => x.isAvailable).length,
                            items.fold<int>(0, (sum, x) => sum + x.activeDeliveries),
                          ),
                          count: items.length,
                        )
                      : AppReveal(
                          delay: Duration(
                            milliseconds: ((i - 1).clamp(0, 5)) * 45,
                          ),
                          child: _RepresentativeCard(
                            representative: items[i - 1],
                          ),
                        ),
                ),
        ),
    floatingActionButton: FloatingActionButton.extended(
      onPressed: () => _addRepresentative(context, ref),
      backgroundColor: context.appColors.primary,
      foregroundColor: Colors.white,
      icon: const Icon(Icons.person_add_alt),
      label: Text(l10n.supplyRepresentativeLabel),
    ),
  );
  }
}

class _RepresentativeCard extends ConsumerWidget {
  const _RepresentativeCard({required this.representative});

  final Representative representative;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final r = representative;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: r.isAvailable
                        ? context.appColors.primary.withValues(alpha: .1)
                        : context.appColors.surfaceSoft,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.delivery_dining_rounded,
                    color: r.isAvailable
                        ? context.appColors.primary
                        : context.appColors.textMuted,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        r.fullName,
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                      Text(
                        '${r.employeeCode} · ${r.vehiclePlateNumber ?? l10n.supplyNoVehicle}',
                        style: TextStyle(
                          color: context.appColors.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                _Badge(
                  r.isOnShift ? l10n.supplyOnShift : l10n.supplyOffShift,
                  r.isOnShift
                      ? context.appColors.primary
                      : context.appColors.textMuted,
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: _CompactStat(
                    label: l10n.supplyActiveShort,
                    value: '${r.activeDeliveries}',
                    icon: Icons.route_outlined,
                  ),
                ),
                Expanded(
                  child: _CompactStat(
                    label: l10n.supplyCompletedShort,
                    value: '${r.completedDeliveries}',
                    icon: Icons.task_alt_rounded,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      l10n.availableLabel,
                      style: TextStyle(
                        color: context.appColors.textMuted,
                        fontSize: 10,
                      ),
                    ),
                    Switch.adaptive(
                      value: r.isAvailable,
                      onChanged: r.isEnabled
                          ? (value) => _setAvailability(context, ref, value)
                          : null,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _setAvailability(
    BuildContext context,
    WidgetRef ref,
    bool value,
  ) async {
    final l10n = AppLocalizations.of(context);
    try {
      await ref
          .read(supplyChainRepositoryProvider)
          .updateRepresentative(representative, isAvailable: value);
      ref.invalidate(supplyRepresentativesProvider);
    } catch (error) {
      if (context.mounted) _snack(context, _error(l10n, error), true);
    }
  }
}

Future<void> _addRepresentative(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context);
  final name = TextEditingController(),
      email = TextEditingController(),
      password = TextEditingController(),
      code = TextEditingController(),
      plate = TextEditingController();
  final save = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      title: Text(l10n.supplyAddRepresentative),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Field(name, l10n.nameLabel),
            _Field(email, l10n.emailLabel),
            _Field(password, l10n.registerPasswordLabel),
            _Field(code, l10n.supplyEmployeeCode),
            _Field(plate, l10n.supplyVehiclePlate),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(c, false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(c, true),
          child: Text(l10n.supplyCreate),
        ),
      ],
    ),
  );
  if (save == true) {
    try {
      await ref
          .read(supplyChainRepositoryProvider)
          .createRepresentative(
            fullName: name.text,
            email: email.text,
            password: password.text,
            employeeCode: code.text,
            vehiclePlateNumber: plate.text,
          );
      ref.invalidate(supplyRepresentativesProvider);
      if (context.mounted) _snack(context, l10n.supplyRepresentativeCreated);
    } catch (e) {
      if (context.mounted) _snack(context, _error(l10n, e), true);
    }
  }
  for (final c in [name, email, password, code, plate]) {
    c.dispose();
  }
}

class _FinanceTab extends ConsumerStatefulWidget {
  const _FinanceTab();

  @override
  ConsumerState<_FinanceTab> createState() => _FinanceTabState();
}

class _FinanceTabState extends ConsumerState<_FinanceTab> {
  int section = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pages = <Widget>[
      _AsyncList<SupplyInvoice>(
        state: ref.watch(supplyInvoicesProvider),
        onRetry: () => ref.invalidate(supplyInvoicesProvider),
        item: (item) => _InvoiceCard(item),
      ),
      _AsyncList<SupplyReturn>(
        state: ref.watch(supplyReturnsProvider),
        onRetry: () => ref.invalidate(supplyReturnsProvider),
        item: (item) => _ReturnCard(item),
      ),
      const _RecallsPanel(),
    ];
    final items = <(String, IconData)>[
      (l10n.supplyInvoicesLabel, Icons.receipt_long_outlined),
      (l10n.supplyReturnsLabel, Icons.keyboard_return_rounded),
      (l10n.supplyRecallsLabel, Icons.warning_amber_rounded),
    ];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
          child: _CollectionHeader(
            icon: Icons.account_balance_wallet_outlined,
            title: l10n.supplyFinanceTitle,
            subtitle: l10n.supplyFinanceSubtitle,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            children: List.generate(items.length, (index) {
              final active = section == index;
              return Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.only(
                    end: index == items.length - 1 ? 0 : 7,
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () => setState(() => section = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      decoration: BoxDecoration(
                        color: active
                            ? context.appColors.primary
                            : context.appColors.surface,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: active
                              ? context.appColors.primary
                              : context.appColors.border,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            items[index].$2,
                            size: 19,
                            color: active
                                ? Colors.white
                                : context.appColors.primary,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            items[index].$1,
                            style: TextStyle(
                              color: active
                                  ? Colors.white
                                  : context.appColors.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 260),
            child: KeyedSubtree(key: ValueKey(section), child: pages[section]),
          ),
        ),
      ],
    );
  }
}

class _PharmacySupplyWorkspace extends ConsumerStatefulWidget {
  const _PharmacySupplyWorkspace();

  @override
  ConsumerState<_PharmacySupplyWorkspace> createState() =>
      _PharmacySupplyWorkspaceState();
}

class _PharmacySupplyWorkspaceState
    extends ConsumerState<_PharmacySupplyWorkspace> {
  int _selectedSection = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pages = <Widget>[
      const _MarketplaceTab(),
      const _OrdersTab(warehouse: false),
      const _SuggestionsTab(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.supplyPharmacySupplyTitle),
        actions: [
          IconButton(
            tooltip: l10n.refreshDataTooltip,
            onPressed: _refresh,
            icon: const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          _PharmacySupplyNavigation(
            selected: _selectedSection,
            onSelected: (value) => setState(() => _selectedSection = value),
          ),
          const Divider(height: 1),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: KeyedSubtree(
                key: ValueKey(_selectedSection),
                child: pages[_selectedSection],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _refresh() {
    switch (_selectedSection) {
      case 0:
        ref.invalidate(supplyMarketplaceProvider);
        return;
      case 1:
        ref.invalidate(supplyOrdersProvider);
        return;
      case 2:
        ref.invalidate(supplySuggestionsProvider);
        return;
    }
  }
}

class _PharmacySupplyNavigation extends StatelessWidget {
  const _PharmacySupplyNavigation({
    required this.selected,
    required this.onSelected,
  });

  final int selected;
  final ValueChanged<int> onSelected;

  static List<(String, IconData)> sections(AppLocalizations l10n) => [
    (l10n.supplyWarehousesLabel, Icons.store_mall_directory_outlined),
    (l10n.supplyMyOrders, Icons.receipt_long_outlined),
    (l10n.supplyStockNeeds, Icons.inventory_2_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SizedBox(
    height: 78,
    child: ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      scrollDirection: Axis.horizontal,
      itemCount: sections(l10n).length,
      separatorBuilder: (_, _) => const SizedBox(width: 8),
      itemBuilder: (_, index) {
        final active = selected == index;
        final item = sections(l10n)[index];
        return InkWell(
          borderRadius: BorderRadius.circular(17),
          onTap: () => onSelected(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: active
                  ? context.appColors.primary
                  : context.appColors.surfaceSoft,
              borderRadius: BorderRadius.circular(17),
              border: Border.all(
                color: active
                    ? context.appColors.primary
                    : context.appColors.border,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  item.$2,
                  size: 19,
                  color: active ? Colors.white : context.appColors.primary,
                ),
                const SizedBox(width: 7),
                Text(
                  item.$1,
                  style: TextStyle(
                    color: active ? Colors.white : context.appColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
  }
}

class _MarketplaceTab extends ConsumerWidget {
  const _MarketplaceTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return ref
        .watch(supplyMarketplaceProvider)
        .when(
          loading: () => const AppLoadingState(),
          error: (error, _) => AppErrorState(
            error: error,
            onRetry: () => ref.invalidate(supplyMarketplaceProvider),
          ),
          data: (items) => RefreshIndicator(
            onRefresh: () => ref.refresh(supplyMarketplaceProvider.future),
            child: items.isEmpty
                ? _Empty(
                    icon: Icons.store_mall_directory_outlined,
                    text: l10n.supplyNoWarehouses,
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                    itemCount: items.length + 1,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) => index == 0
                        ? _CollectionHeader(
                            icon: Icons.store_mall_directory_outlined,
                            title: l10n.supplyAvailableWarehouses,
                            subtitle: l10n.supplyAvailableWarehousesSubtitle,
                            count: items.length,
                          )
                        : _WarehouseCard(warehouse: items[index - 1]),
                  ),
          ),
        );
  }
}

class _WarehouseCard extends StatelessWidget {
  const _WarehouseCard({required this.warehouse});
  final WarehouseMarketplace warehouse;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (_) => _CatalogOrderSheet(warehouse: warehouse),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: context.appColors.primary.withValues(alpha: .08),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.warehouse_outlined,
                  color: context.appColors.primary,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      warehouse.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        color: context.appColors.text,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: context.appColors.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${warehouse.city} · ${warehouse.area}',
                          style: TextStyle(
                            fontSize: 12,
                            color: context.appColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _WarehouseStat(
                          icon: Icons.medication_outlined,
                          label: l10n.supplyAvailableMedicinesCount(
                            warehouse.availableMedicines,
                          ),
                        ),
                        const SizedBox(width: 12),
                        _WarehouseStat(
                          icon: Icons.local_shipping_outlined,
                          label: l10n.supplyDeliveryFee(
                            _money(warehouse.deliveryFee),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_back_rounded, color: context.appColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}

class _WarehouseStat extends StatelessWidget {
  const _WarehouseStat({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 13, color: context.appColors.textMuted),
      const SizedBox(width: 4),
      Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: context.appColors.textMuted,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}

class _CatalogOrderSheet extends ConsumerStatefulWidget {
  const _CatalogOrderSheet({required this.warehouse});
  final WarehouseMarketplace warehouse;
  @override
  ConsumerState<_CatalogOrderSheet> createState() => _CatalogOrderSheetState();
}

class _CatalogOrderSheetState extends ConsumerState<_CatalogOrderSheet> {
  final Map<String, int> quantities = {};
  bool sending = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(supplyCatalogProvider(widget.warehouse.id));
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * .86,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.warehouse.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(l10n.supplySelectQuantities),
              ],
            ),
          ),
          Expanded(
            child: state.when(
              loading: () => const AppLoadingState(),
              error: (error, _) => AppErrorState(
                error: error,
                onRetry: () =>
                    ref.invalidate(supplyCatalogProvider(widget.warehouse.id)),
              ),
              data: (items) => ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: items.length,
                itemBuilder: (_, index) {
                  final item = items[index];
                  final quantity = quantities[item.medicineId] ?? 0;
                  return Card(
                    child: ListTile(
                      title: Text(item.medicineName),
                      subtitle: Text(
                        l10n.supplyCatalogItem(
                          _money(item.bestPrice),
                          item.availableQuantity,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: quantity == 0
                                ? null
                                : () => setState(
                                    () => quantities[item.medicineId] =
                                        quantity - 1,
                                  ),
                            icon: const Icon(Icons.remove_circle_outline),
                          ),
                          Text('$quantity'),
                          IconButton(
                            onPressed: quantity >= item.availableQuantity
                                ? null
                                : () => setState(
                                    () => quantities[item.medicineId] =
                                        quantity + 1,
                                  ),
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SafeArea(
            top: false,
            minimum: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed:
                    quantities.values.every((quantity) => quantity == 0) ||
                        sending
                    ? null
                    : _send,
                icon: const Icon(Icons.send),
                label: Text(sending ? l10n.supplySending : l10n.sendRequest),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _send() async {
    setState(() => sending = true);
    try {
      await ref
          .read(supplyChainRepositoryProvider)
          .createOrder(
            widget.warehouse.id,
            Map.fromEntries(quantities.entries.where((e) => e.value > 0)),
          );
      ref.invalidate(supplyOrdersProvider);
      if (mounted) {
        Navigator.pop(context);
        _snack(context, AppLocalizations.of(context).supplySupplyOrderSent);
      }
    } catch (e) {
      if (mounted) {
        _snack(
          context,
          _error(AppLocalizations.of(context), e),
          true,
        );
      }
    } finally {
      if (mounted) setState(() => sending = false);
    }
  }
}

class _SuggestionsTab extends ConsumerWidget {
  const _SuggestionsTab();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return ref
        .watch(supplySuggestionsProvider)
        .when(
          loading: () => const AppLoadingState(),
          error: (e, _) => AppErrorState(
            error: e,
            onRetry: () => ref.invalidate(supplySuggestionsProvider),
          ),
          data: (items) => RefreshIndicator(
            onRefresh: () => ref.refresh(supplySuggestionsProvider.future),
            child: items.isEmpty
                ? _Empty(
                    icon: Icons.task_alt,
                    text: l10n.supplyStockAdequate,
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                    itemCount: items.length + 1,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (_, i) => i == 0
                        ? _CollectionHeader(
                            icon: Icons.inventory_2_outlined,
                            title: l10n.supplyStockNeeds,
                            subtitle: l10n.supplyStockNeedsSubtitle,
                            count: items.length,
                          )
                        : _SuggestionCard(suggestion: items[i - 1]),
                  ),
          ),
        );
  }
}

class _SuggestionCard extends StatelessWidget {
  const _SuggestionCard({required this.suggestion});
  final RestockSuggestion suggestion;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: context.appColors.primary.withValues(alpha: .08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(Icons.auto_graph, color: colors.primary, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    suggestion.medicineName,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: colors.text,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _SuggestionStat(
                        icon: Icons.inventory_2_outlined,
                        label: l10n.supplyCurrentQty(suggestion.currentQuantity),
                      ),
                      const SizedBox(width: 12),
                      _SuggestionStat(
                        icon: Icons.trending_up_rounded,
                        label: l10n.supplySuggestedQty(suggestion.suggestedQuantity),
                      ),
                    ],
                  ),
                  if (suggestion.recommendedWarehouseName != null) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.store_mall_directory_outlined,
                          size: 13,
                          color: colors.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          suggestion.recommendedWarehouseName!,
                          style: TextStyle(
                            fontSize: 11,
                            color: colors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuggestionStat extends StatelessWidget {
  const _SuggestionStat({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 13, color: context.appColors.textMuted),
      const SizedBox(width: 4),
      Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: context.appColors.textMuted,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}

class _RepresentativeWorkspace extends ConsumerWidget {
  const _RepresentativeWorkspace();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(supplyOrdersProvider);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.supplyDeliveryTasks),
            Text(
              l10n.supplyTodaySchedule,
              style: TextStyle(
                color: context.appColors.textMuted,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: l10n.supplyRefreshTasks,
            onPressed: () => ref.invalidate(supplyOrdersProvider),
            icon: const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: state.when(
        loading: () => AppLoadingState(label: l10n.supplyLoadingTasks),
        error: (e, _) => AppErrorState(
          error: e,
          onRetry: () => ref.invalidate(supplyOrdersProvider),
        ),
        data: (items) {
          final deliveries = items.where((x) => x.shipment != null).toList();
          final active = deliveries
              .where((x) => x.shipment?.status != 'Delivered')
              .length;
          final completed = deliveries.length - active;
          return RefreshIndicator(
            onRefresh: () => ref.refresh(supplyOrdersProvider.future),
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
              itemCount: deliveries.isEmpty ? 2 : deliveries.length + 2,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return AppReveal(
                    child: _DeliveryHero(
                      total: deliveries.length,
                      active: active,
                      completed: completed,
                    ),
                  );
                }
                if (index == 1) {
                  return _CollectionHeader(
                    icon: Icons.route_rounded,
                    title: l10n.supplyAssignedShipments,
                    subtitle: deliveries.isEmpty
                        ? l10n.supplyNoTasksNow
                        : l10n.supplyUpdateTaskStatus,
                    count: deliveries.length,
                  );
                }
                return AppReveal(
                  delay: Duration(milliseconds: ((index - 2).clamp(0, 5)) * 55),
                  child: _DeliveryCard(deliveries[index - 2]),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _DeliveryHero extends StatelessWidget {
  const _DeliveryHero({
    required this.total,
    required this.active,
    required this.completed,
  });

  final int total, active, completed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: context.appColors.primary,
      borderRadius: BorderRadius.circular(28),
      boxShadow: [
        BoxShadow(
          color: context.appColors.primary.withValues(alpha: .18),
          blurRadius: 24,
          offset: const Offset(0, 12),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(17),
              ),
              child: Icon(
                Icons.delivery_dining_rounded,
                color: context.appColors.secondary,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.supplySafeJourney,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    l10n.supplySafeJourneySubtitle,
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            _HeroStat(label: l10n.supplyTasksLabel, value: total),
            const SizedBox(width: 8),
            _HeroStat(label: l10n.supplyActiveShort, value: active),
            const SizedBox(width: 8),
            _HeroStat(label: l10n.supplyCompletedShort, value: completed),
          ],
        ),
      ],
    ),
  );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.label, required this.value});
  final String label;
  final int value;
  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .09),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: .08)),
      ),
      child: Column(
        children: [
          Text(
            '$value',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 10),
          ),
        ],
      ),
    ),
  );
}

class _DeliveryCard extends ConsumerWidget {
  const _DeliveryCard(this.order);
  final SupplyOrder order;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final shipment = order.shipment;
    if (shipment == null) return const SizedBox.shrink();
    final next = switch (shipment.status) {
      'Assigned' => 'Loading',
      'Loading' => 'OutForDelivery',
      'OutForDelivery' => 'Arrived',
      'Arrived' => 'Delivered',
      _ => null,
    };
    final progress = _deliveryProgress(shipment.status);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: context.appColors.surfaceSoft,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    Icons.local_pharmacy_outlined,
                    color: context.appColors.primary,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.pharmacyName,
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                      Text(
                        l10n.supplyDeliveryItems(
                          shipment.shipmentCode,
                          order.items.length,
                        ),
                        style: TextStyle(
                          color: context.appColors.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                _Badge(
                  _status(l10n, shipment.status),
                  _statusColor(context.appColors, shipment.status),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.appColors.surfaceSoft,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: context.appColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${order.pharmacyCity} · ${order.pharmacyArea}\n${order.pharmacyAddress}',
                      style: const TextStyle(fontSize: 12, height: 1.55),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _DeliveryProgress(progress: progress),
            if (next != null) ...[
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () async {
                    try {
                      await ref
                          .read(supplyChainRepositoryProvider)
                          .updateShipment(shipment.id, next);
                      ref.invalidate(supplyOrdersProvider);
                    } catch (e) {
                      if (context.mounted) _snack(context, _error(l10n, e), true);
                    }
                  },
                  icon: Icon(_nextIcon(next)),
                  label: Text(_nextLabel(l10n, next)),
                ),
              ),
            ] else ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.task_alt_rounded,
                    color: context.appColors.success,
                  ),
                  SizedBox(width: 7),
                  Text(
                    l10n.supplyDeliveredSuccess,
                    style: TextStyle(
                      color: context.appColors.success,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  int _deliveryProgress(String status) => switch (status) {
    'Assigned' => 0,
    'Loading' => 1,
    'OutForDelivery' => 2,
    'Arrived' => 3,
    'Delivered' => 4,
    _ => 0,
  };

  IconData _nextIcon(String status) => switch (status) {
    'Loading' => Icons.inventory_2_outlined,
    'OutForDelivery' => Icons.route_rounded,
    'Arrived' => Icons.location_on_outlined,
    'Delivered' => Icons.task_alt_rounded,
    _ => Icons.arrow_forward_rounded,
  };
}

class _DeliveryProgress extends StatelessWidget {
  const _DeliveryProgress({required this.progress});
  final int progress;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final labels = <String>[
      l10n.supplyStepPickup,
      l10n.supplyStepLoading,
      l10n.supplyStepOnWay,
      l10n.supplyStepArrival,
      l10n.supplyStepDelivered,
    ];
    return Row(
    children: List.generate(labels.length, (index) {
      final reached = index <= progress;
      return Expanded(
        child: Column(
          children: [
            Row(
              children: [
                if (index > 0)
                  Expanded(
                    child: Container(
                      height: 2,
                      color: reached
                          ? context.appColors.primary
                          : context.appColors.border,
                    ),
                  ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 260),
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: reached ? context.appColors.primary : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: reached
                          ? context.appColors.primary
                          : context.appColors.border,
                      width: 2,
                    ),
                  ),
                  child: reached
                      ? const Icon(Icons.check, color: Colors.white, size: 11)
                      : null,
                ),
                if (index < labels.length - 1)
                  Expanded(
                    child: Container(
                      height: 2,
                      color: index < progress
                          ? context.appColors.primary
                          : context.appColors.border,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              labels[index],
              style: TextStyle(
                color: reached
                    ? context.appColors.primary
                    : context.appColors.textMuted,
                fontSize: 8,
                fontWeight: reached ? FontWeight.w800 : FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }),
  );
  }
}

class _AsyncList<T> extends StatelessWidget {
  const _AsyncList({
    required this.state,
    required this.onRetry,
    required this.item,
  });

  final AsyncValue<List<T>> state;
  final VoidCallback onRetry;
  final Widget Function(T) item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return state.when(
      loading: () => const AppLoadingState(),
      error: (error, _) => AppErrorState(error: error, onRetry: onRetry),
      data: (items) => items.isEmpty
          ? _Empty(icon: Icons.inbox_outlined, text: l10n.supplyNoData)
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 9),
              itemBuilder: (_, index) => item(items[index]),
            ),
    );
  }
}

class _InvoiceCard extends ConsumerWidget {
  const _InvoiceCard(this.x);
  final SupplyInvoice x;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Card(
    child: ListTile(
      leading: Icon(Icons.receipt_long, color: context.appColors.primary),
      title: Text(x.invoiceNumber),
      subtitle: Text(
        l10n.supplyInvoiceRemaining(x.pharmacyName, _money(x.remainingAmount)),
      ),
      trailing: _Badge(
        _status(l10n, x.paymentStatus),
        _statusColor(context.appColors, x.paymentStatus),
      ),
      onTap: () => _manageInvoice(context, ref),
    ),
  );
  }

  Future<void> _manageInvoice(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                x.invoiceNumber,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 6),
              Text(
                l10n.supplyInvoiceSummary(
                  _money(x.totalAmount),
                  _money(x.paidAmount),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () => Navigator.pop(sheetContext, 'edit'),
                icon: const Icon(Icons.edit_calendar_outlined),
                label: Text(l10n.supplyEditInvoiceTerms),
              ),
              FilledButton.icon(
                onPressed: x.remainingAmount <= 0
                    ? null
                    : () => Navigator.pop(sheetContext, 'payment'),
                icon: const Icon(Icons.payments_outlined),
                label: Text(l10n.supplyRecordPayment),
              ),
            ],
          ),
        ),
      ),
    );
    if (!context.mounted) return;
    if (action == 'payment') {
      await _recordPayment(context, ref);
    } else if (action == 'edit') {
      await _editInvoice(context, ref);
    }
  }

  Future<void> _recordPayment(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final amount = TextEditingController(text: _money(x.remainingAmount));
    final reference = TextEditingController();
    var method = x.paymentMethod.isEmpty ? 'CashOnDelivery' : x.paymentMethod;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(l10n.supplyRecordPayment),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Field(amount, l10n.supplyAmountLabel, number: true),
              DropdownButtonFormField<String>(
                initialValue: method,
                decoration: InputDecoration(labelText: l10n.supplyPaymentMethod),
                items: [
                  DropdownMenuItem(
                    value: 'CashOnDelivery',
                    child: Text(l10n.supplyCashOnDelivery),
                  ),
                  DropdownMenuItem(
                    value: 'BankTransfer',
                    child: Text(l10n.supplyBankTransfer),
                  ),
                  DropdownMenuItem(value: 'Credit', child: Text(l10n.supplyCredit)),
                ],
                onChanged: (value) {
                  if (value != null) setDialogState(() => method = value);
                },
              ),
              const SizedBox(height: 8),
              _Field(reference, l10n.supplyReferenceOptional),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
    final paid = double.tryParse(amount.text) ?? 0;
    final referenceText = reference.text.trim();
    amount.dispose();
    reference.dispose();
    if (confirmed != true || paid <= 0) return;
    try {
      await ref
          .read(supplyChainRepositoryProvider)
          .recordPayment(
            x.id,
            amount: paid,
            method: method,
            reference: referenceText,
          );
      ref.invalidate(supplyInvoicesProvider);
      if (context.mounted) _snack(context, l10n.supplyPaymentRecorded);
    } catch (error) {
      if (context.mounted) _snack(context, _error(l10n, error), true);
    }
  }

  Future<void> _editInvoice(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final discount = TextEditingController(text: _money(x.discountAmount));
    final tax = TextEditingController(text: _money(x.taxAmount));
    final note = TextEditingController(text: x.warehouseNote);
    var method = x.paymentMethod.isEmpty ? 'CashOnDelivery' : x.paymentMethod;
    var due = x.dueAtUtc;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(l10n.supplyEditInvoice),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: method,
                  decoration: InputDecoration(labelText: l10n.supplyPaymentMethod),
                  items: [
                    DropdownMenuItem(
                      value: 'CashOnDelivery',
                      child: Text(l10n.supplyCashOnDelivery),
                    ),
                    DropdownMenuItem(
                      value: 'BankTransfer',
                      child: Text(l10n.supplyBankTransfer),
                    ),
                    DropdownMenuItem(value: 'Credit', child: Text(l10n.supplyCredit)),
                  ],
                  onChanged: (value) {
                    if (value != null) setDialogState(() => method = value);
                  },
                ),
                const SizedBox(height: 8),
                _Field(discount, l10n.supplyDiscountLabel, number: true),
                _Field(tax, l10n.supplyTaxLabel, number: true),
                _Field(note, l10n.supplyWarehouseNote),
                ListTile(
                  title: Text(l10n.supplyDueDate),
                  subtitle: Text(_date(due)),
                  trailing: const Icon(Icons.calendar_month_outlined),
                  onTap: () async {
                    final value = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 730)),
                      initialDate: due.isBefore(DateTime.now())
                          ? DateTime.now()
                          : due,
                    );
                    if (value != null) setDialogState(() => due = value);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
    final discountValue = double.tryParse(discount.text) ?? 0;
    final taxValue = double.tryParse(tax.text) ?? 0;
    final noteText = note.text.trim();
    discount.dispose();
    tax.dispose();
    note.dispose();
    if (confirmed != true) return;
    try {
      await ref
          .read(supplyChainRepositoryProvider)
          .updateInvoice(
            x.id,
            paymentMethod: method,
            dueAtUtc: due,
            discountAmount: discountValue,
            taxAmount: taxValue,
            note: noteText,
          );
      ref.invalidate(supplyInvoicesProvider);
      if (context.mounted) _snack(context, l10n.supplyInvoiceUpdated);
    } catch (error) {
      if (context.mounted) _snack(context, _error(l10n, error), true);
    }
  }
}

class _ReturnCard extends ConsumerWidget {
  const _ReturnCard(this.x);
  final SupplyReturn x;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Card(
    child: ListTile(
      leading: Icon(Icons.keyboard_return, color: context.appColors.warning),
      title: Text(x.medicineName),
      subtitle: Text(l10n.supplyReturnDetails(x.quantity, x.reason)),
      trailing:
          x.status == 'Requested' ||
              x.status == 'Approved' ||
              x.status == 'Collected'
          ? PopupMenuButton<String>(
              onSelected: (status) => _review(context, ref, status),
              itemBuilder: (_) => [
                if (x.status == 'Requested') ...[
                  PopupMenuItem(value: 'Approved', child: Text(l10n.supplyAcceptReturn)),
                  PopupMenuItem(value: 'Rejected', child: Text(l10n.supplyRejectReturn)),
                ],
                if (x.status == 'Approved')
                  PopupMenuItem(
                    value: 'Collected',
                    child: Text(l10n.supplyCollectedFromPharmacy),
                  ),
                if (x.status == 'Collected')
                  PopupMenuItem(
                    value: 'Completed',
                    child: Text(l10n.supplyCompleteReturn),
                  ),
              ],
            )
          : _Badge(
              _status(l10n, x.status),
              _statusColor(context.appColors, x.status),
            ),
    ),
  );
  }

  Future<void> _review(
    BuildContext context,
    WidgetRef ref,
    String status,
  ) async {
    final l10n = AppLocalizations.of(context);
    try {
      await ref.read(supplyChainRepositoryProvider).reviewReturn(x.id, status);
      ref.invalidate(supplyReturnsProvider);
      if (context.mounted) _snack(context, l10n.supplyReturnUpdated);
    } catch (error) {
      if (context.mounted) _snack(context, _error(l10n, error), true);
    }
  }
}

class _RecallsPanel extends ConsumerWidget {
  const _RecallsPanel();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Column(
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
        child: SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => _createRecall(context, ref),
            icon: const Icon(Icons.add_alert_outlined),
            label: Text(l10n.supplyCreateRecallAlert),
          ),
        ),
      ),
      Expanded(
        child: _AsyncList<MedicineRecall>(
          state: ref.watch(supplyRecallsProvider),
          onRetry: () => ref.invalidate(supplyRecallsProvider),
          item: (item) => _RecallCard(item),
        ),
      ),
    ],
  );
  }

  Future<void> _createRecall(BuildContext context, WidgetRef ref) async {
    try {
      final batches = await ref.read(supplyBatchesProvider.future);
      if (!context.mounted || batches.isEmpty) return;
      final l10n = AppLocalizations.of(context);
      var batchId = batches.first.id;
      var severity = 'Medium';
      final reason = TextEditingController();
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: Text(l10n.supplyRecallBatch),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: batchId,
                  decoration: InputDecoration(labelText: l10n.supplyBatchLabel),
                  items: batches
                      .map(
                        (item) => DropdownMenuItem(
                          value: item.id,
                          child: Text(
                            '${item.medicineName} · ${item.batchNumber}',
                          ),
                        ),
                      )
                      .toList(growable: false),
                  onChanged: (value) {
                    if (value != null) setDialogState(() => batchId = value);
                  },
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: severity,
                  decoration: InputDecoration(labelText: l10n.supplySeverityLabel),
                  items: [
                    DropdownMenuItem(value: 'Low', child: Text(l10n.supplySeverityLow)),
                    DropdownMenuItem(value: 'Medium', child: Text(l10n.supplySeverityMedium)),
                    DropdownMenuItem(value: 'High', child: Text(l10n.supplySeverityHigh)),
                    DropdownMenuItem(value: 'Critical', child: Text(l10n.supplySeverityCritical)),
                  ],
                  onChanged: (value) {
                    if (value != null) setDialogState(() => severity = value);
                  },
                ),
                const SizedBox(height: 8),
                _Field(reason, l10n.supplyRecallReason),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: Text(l10n.cancel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: Text(l10n.supplyCreateAlertButton),
              ),
            ],
          ),
        ),
      );
      final reasonText = reason.text.trim();
      reason.dispose();
      if (confirmed != true || reasonText.isEmpty) return;
      await ref
          .read(supplyChainRepositoryProvider)
          .createRecall(batchId, reasonText, severity);
      ref.invalidate(supplyRecallsProvider);
      if (context.mounted) _snack(context, l10n.supplyRecallAlertCreated);
    } catch (error) {
      if (context.mounted) _snack(context, _error(AppLocalizations.of(context), error), true);
    }
  }
}

class _RecallCard extends StatelessWidget {
  const _RecallCard(this.x);
  final MedicineRecall x;
  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: Icon(Icons.warning_amber, color: context.appColors.danger),
      title: Text(x.medicineName),
      subtitle: Text('${x.batchNumber} · ${x.reason}'),
      trailing: _Badge(x.severity, context.appColors.danger),
    ),
  );
}

class _BatchCard extends StatelessWidget {
  const _BatchCard({required this.batch});
  final MedicineBatch batch;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: context.appColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.medication, color: context.appColors.primary),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      batch.medicineName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    Text(
                      l10n.supplyBatchNumberLabel(batch.batchNumber),
                      style: TextStyle(
                        color: context.appColors.textMuted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              _Badge(
                _health(l10n, batch.health),
                _healthColor(context.appColors, batch.health),
              ),
            ],
          ),
          const Divider(height: 22),
          Row(
            children: [
              Expanded(
                child: _CompactStat(
                  label: l10n.supplyAvailableShort,
                  value: '${batch.sellableQuantity}',
                  icon: Icons.inventory_2_outlined,
                ),
              ),
              Expanded(
                child: _CompactStat(
                  label: l10n.supplyWholesalePrice,
                  value: _money(batch.wholesalePrice),
                  icon: Icons.payments_outlined,
                ),
              ),
              Expanded(
                child: _CompactStat(
                  label: l10n.supplyExpiryShort,
                  value: _date(batch.expiryDateUtc),
                  icon: Icons.event_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.badge,
  });
  final IconData icon;
  final String title, subtitle, badge;
  @override
  Widget build(BuildContext context) => Container(
    height: 178,
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: context.appColors.primary,
      borderRadius: BorderRadius.circular(28),
      boxShadow: [
        BoxShadow(
          color: context.appColors.primary.withValues(alpha: .18),
          blurRadius: 24,
          offset: const Offset(0, 12),
        ),
      ],
    ),
    child: Stack(
      children: [
        PositionedDirectional(
          end: 35,
          bottom: -50,
          child: Icon(
            Icons.inventory_2_rounded,
            size: 142,
            color: Colors.white.withValues(alpha: .045),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(icon, color: context.appColors.secondary),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: context.appColors.secondary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      badge,
                      style: TextStyle(
                        color: context.appColors.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _Metric extends StatelessWidget {
  const _Metric(this.label, this.value, this.icon, this.color);
  final String label;
  final int value;
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: context.appColors.surface,
      border: Border.all(color: context.appColors.border),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 9),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$value',
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: context.appColors.textMuted,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text, this.icon, {this.subtitle});
  final String text;
  final IconData icon;
  final String? subtitle;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 9),
    child: Row(
      children: [
        Icon(icon, color: context.appColors.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text, style: Theme.of(context).textTheme.titleMedium),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: TextStyle(
                    color: context.appColors.textMuted,
                    fontSize: 10,
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _CollectionHeader extends StatelessWidget {
  const _CollectionHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.count,
  });

  final IconData icon;
  final String title, subtitle;
  final int? count;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: context.appColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: context.appColors.primary, size: 21),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
            ),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: context.appColors.textMuted,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
      if (count != null)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: context.appColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Text(
            '$count',
            style: TextStyle(
              color: context.appColors.primary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
    ],
  );
}

class _CompactStat extends StatelessWidget {
  const _CompactStat({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label, value;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, color: context.appColors.primary, size: 17),
      const SizedBox(height: 4),
      Text(
        value,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900),
      ),
      Text(
        label,
        style: TextStyle(color: context.appColors.textMuted, fontSize: 9),
      ),
    ],
  );
}

class _Badge extends StatelessWidget {
  const _Badge(this.text, this.color);
  final String text;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    decoration: BoxDecoration(
      color: color.withValues(alpha: .09),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      text,
      style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w800),
    ),
  );
}

class _Empty extends StatelessWidget {
  const _Empty({required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) => ListView(
    physics: const AlwaysScrollableScrollPhysics(),
    children: [
      const SizedBox(height: 100),
      Icon(icon, size: 46, color: context.appColors.textMuted),
      const SizedBox(height: 10),
      Text(text, textAlign: TextAlign.center),
    ],
  );
}

class _Field extends StatelessWidget {
  const _Field(this.controller, this.label, {this.number = false});
  final TextEditingController controller;
  final String label;
  final bool number;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 9),
    child: TextField(
      controller: controller,
      keyboardType: number ? TextInputType.number : null,
      decoration: InputDecoration(labelText: label),
    ),
  );
}

String _money(double v) => v.toStringAsFixed(v % 1 == 0 ? 0 : 2);
String _date(DateTime d) => '${d.year}/${d.month}/${d.day}';
String _error(AppLocalizations l10n, Object e) =>
    e is ApiException ? e.localize(l10n) : l10n.operationFailed;
void _snack(BuildContext c, String t, [bool error = false]) =>
    ScaffoldMessenger.of(c).showSnackBar(
      SnackBar(
        content: Text(t),
        backgroundColor: error ? c.appColors.danger : null,
      ),
    );
String _health(AppLocalizations l10n, String s) =>
    switch (s.toLowerCase()) {
  'healthy' => l10n.supplyHealthHealthy,
  'lowstock' => l10n.supplyHealthLow,
  'expiring' => l10n.supplyHealthExpiring,
  'expired' => l10n.supplyHealthExpired,
  _ => s,
};
Color _healthColor(AppColors colors, String s) => switch (s.toLowerCase()) {
  'healthy' => colors.primary,
  'expired' => colors.primary,
  _ => colors.primary,
};
String _status(AppLocalizations l10n, String s) =>
    switch (s.toLowerCase()) {
  'submitted' => l10n.supplyStatusSubmitted,
  'accepted' => l10n.supplyStatusAccepted,
  'preparing' => l10n.supplyStatusPreparing,
  'readyfordispatch' => l10n.supplyStatusReadyForDispatch,
  'assigned' => l10n.supplyStatusAssigned,
  'loading' => l10n.supplyStatusLoading,
  'outfordelivery' => l10n.supplyStatusOutForDelivery,
  'arrived' => l10n.supplyStatusArrived,
  'delivered' => l10n.supplyStatusDelivered,
  'rejected' => l10n.supplyStatusRejected,
  'paid' => l10n.supplyStatusPaid,
  'partiallypaid' => l10n.supplyStatusPartiallyPaid,
  'unpaid' => l10n.supplyStatusUnpaid,
  'requested' => l10n.supplyStatusRequested,
  'approved' => l10n.supplyStatusApproved,
  'active' => l10n.supplyStatusActive,
  _ => s,
};
Color _statusColor(AppColors colors, String s) => switch (s.toLowerCase()) {
  'delivered' || 'paid' || 'approved' => colors.primary,
  'rejected' || 'failed' || 'overdue' => colors.primary,
  'submitted' || 'requested' || 'unpaid' => colors.primary,
  _ => colors.primary,
};
String _nextLabel(AppLocalizations l10n, String s) => switch (s) {
  'Loading' => l10n.supplyNextLoading,
  'OutForDelivery' => l10n.supplyNextOutForDelivery,
  'Arrived' => l10n.supplyNextArrived,
  'Delivered' => l10n.supplyNextDelivered,
  _ => l10n.supplyNextUpdate,
};
