import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
            Text('إدارة المستودع'),
            Text(
              'مركز الإمداد والتوزيع',
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
            tooltip: 'تحديث البيانات',
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

  static const sections = <(String, IconData)>[
    ('الملخص', Icons.dashboard_rounded),
    ('التشغيلات', Icons.inventory_2_outlined),
    ('الطلبات', Icons.receipt_long_outlined),
    ('المندوبون', Icons.delivery_dining_outlined),
    ('المالية', Icons.account_balance_wallet_outlined),
  ];

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 78,
    child: ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      scrollDirection: Axis.horizontal,
      itemCount: sections.length,
      separatorBuilder: (_, _) => const SizedBox(width: 8),
      itemBuilder: (_, index) {
        final active = selected == index;
        final item = sections[index];
        return InkWell(
          borderRadius: BorderRadius.circular(17),
          onTap: () => onSelected(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: active ? context.appColors.primaryDeep : context.appColors.surfaceSoft,
              borderRadius: BorderRadius.circular(17),
              border: Border.all(
                color: active ? context.appColors.primaryDeep : context.appColors.border,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  item.$2,
                  size: 19,
                  color: active ? context.appColors.secondary : context.appColors.primary,
                ),
                const SizedBox(width: 7),
                Text(
                  item.$1,
                  style: TextStyle(
                    color: active ? Colors.white : context.appColors.text,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (index == 2 && pendingOrders > 0) ...[
                  const SizedBox(width: 7),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: active ? context.appColors.secondary : context.appColors.danger,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$pendingOrders',
                      style: TextStyle(
                        color: active ? context.appColors.primaryDeep : Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    ),
  );
}

class _WarehouseDashboard extends ConsumerWidget {
  const _WarehouseDashboard();
  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
      .watch(supplyDashboardProvider)
      .when(
        loading: () => const AppLoadingState(label: 'جاري تحميل المستودع...'),
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
                  title: 'مركز تشغيل المستودع',
                  subtitle: 'قيمة المخزون ${_money(data.inventoryValue)} ل.س',
                  badge: '${data.pendingOrders} طلب جديد',
                ),
              ),
              const SizedBox(height: 20),
              const _SectionTitle(
                'مؤشرات اليوم',
                Icons.insights_rounded,
                subtitle: 'قراءة سريعة لحالة التشغيل والمخزون',
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
                      'تشغيلات نشطة',
                      data.activeBatches,
                      Icons.inventory_2_outlined,
                      context.appColors.primary,
                    ),
                  ),
                  AppReveal(
                    delay: Duration(milliseconds: 110),
                    child: _Metric(
                      'مخزون منخفض',
                      data.lowStockBatches,
                      Icons.trending_down_rounded,
                      context.appColors.warning,
                    ),
                  ),
                  AppReveal(
                    delay: Duration(milliseconds: 150),
                    child: _Metric(
                      'قرب الانتهاء',
                      data.expiringBatches,
                      Icons.event_busy_outlined,
                      context.appColors.danger,
                    ),
                  ),
                  AppReveal(
                    delay: Duration(milliseconds: 190),
                    child: _Metric(
                      'شحنات نشطة',
                      data.activeDeliveries,
                      Icons.local_shipping_outlined,
                      context.appColors.success,
                    ),
                  ),
                ],
              ),
              if (data.alerts.isNotEmpty) ...[
                const SizedBox(height: 20),
                const _SectionTitle(
                  'تحتاج إلى انتباه',
                  Icons.notifications_active_outlined,
                  subtitle: 'تشغيلات منخفضة أو قريبة من الانتهاء',
                ),
                ...data.alerts.map((b) => _BatchCard(batch: b)),
              ],
            ],
          ),
        ),
      );
}

class _BatchesTab extends ConsumerWidget {
  const _BatchesTab();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              ? const _Empty(
                  icon: Icons.inventory_2_outlined,
                  text: 'لا توجد تشغيلات دوائية بعد.',
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 90),
                  itemCount: items.length + 1,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => i == 0
                      ? _CollectionHeader(
                          icon: Icons.inventory_2_outlined,
                          title: 'مخزون التشغيلات',
                          subtitle: 'تتبّع الكميات والأسعار وتواريخ الانتهاء',
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
        icon: const Icon(Icons.add),
        label: const Text('تشغيلة'),
      ),
    );
  }
}

Future<void> _addBatch(BuildContext context, WidgetRef ref) async {
  final medicines = await ref
      .read(medicinesRepositoryProvider)
      .getMedicines(pageSize: 100);
  if (!context.mounted) return;
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
        title: const Text('إضافة تشغيلة'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: medicineId,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'الدواء'),
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
              _Field(batch, 'رقم التشغيلة'),
              _Field(quantity, 'الكمية', number: true),
              _Field(purchase, 'سعر الشراء', number: true),
              _Field(price, 'سعر الجملة', number: true),
              _Field(location, 'موضع التخزين'),
              ListTile(
                title: const Text('تاريخ الانتهاء'),
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
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('حفظ'),
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
      if (context.mounted) _snack(context, 'تمت إضافة التشغيلة.');
    } catch (e) {
      if (context.mounted) _snack(context, _error(e), true);
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
    return ref
        .watch(supplyOrdersProvider)
        .when(
          loading: () => const AppLoadingState(label: 'جاري تحميل الطلبات...'),
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
                    title: widget.warehouse ? 'طلبات الصيدليات' : 'طلباتي',
                    subtitle: widget.warehouse
                        ? 'معالجة الطلب من الاستلام حتى التسليم'
                        : 'متابعة حالة طلبات التوريد والشحن',
                    count: items.length,
                  ),
                ),
                SizedBox(
                  height: 54,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    children: [
                      _filterChip('all', 'الكل', items.length),
                      _filterChip(
                        'new',
                        'جديدة',
                        items.where((x) => x.status == 'Submitted').length,
                      ),
                      _filterChip(
                        'active',
                        'قيد التنفيذ',
                        items.where(_isActive).length,
                      ),
                      _filterChip(
                        'done',
                        'مكتملة',
                        items.where(_isDone).length,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => ref.refresh(supplyOrdersProvider.future),
                    child: visible.isEmpty
                        ? const _Empty(
                            icon: Icons.receipt_long_outlined,
                            text: 'لا توجد طلبات ضمن هذا التصنيف.',
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

  Widget _filterChip(String value, String label, int count) => Padding(
    padding: const EdgeInsetsDirectional.only(end: 8),
    child: ChoiceChip(
      selected: filter == value,
      onSelected: (_) => setState(() => filter = value),
      label: Text('$label  $count'),
    ),
  );
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
  Widget build(BuildContext context, WidgetRef ref) => Card(
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
                _status(order.status),
                _statusColor(context.appColors, order.status),
              ),
            ],
          ),
          const Divider(height: 24),
          Text(
            '${order.items.length} أصناف · ${_money(order.totalAmount)} ل.س',
          ),
          if (order.shipment != null)
            Text(
              'الشحنة: ${order.shipment!.shipmentCode} · ${_status(order.shipment!.status)}',
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
                    child: const Text('قبول'),
                  ),
                if (order.status == 'Accepted')
                  FilledButton(
                    onPressed: () => _statusUpdate(context, ref, 'Preparing'),
                    child: const Text('بدء التجهيز'),
                  ),
                if (order.status == 'Preparing')
                  FilledButton(
                    onPressed: () =>
                        _statusUpdate(context, ref, 'ReadyForDispatch'),
                    child: const Text('جاهز للشحن'),
                  ),
                if (order.status == 'ReadyForDispatch' &&
                    order.shipment == null)
                  FilledButton.icon(
                    onPressed: () => _assignShipment(context, ref),
                    icon: const Icon(Icons.delivery_dining_outlined),
                    label: const Text('إسناد لمندوب'),
                  ),
                TextButton(
                  onPressed: () => _statusUpdate(context, ref, 'Rejected'),
                  child: const Text('رفض'),
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
                label: const Text('تأكيد استلام الشحنة'),
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
                label: const Text('طلب إرجاع صنف'),
              ),
            ),
          ],
        ],
      ),
    ),
  );
  Future<void> _statusUpdate(
    BuildContext context,
    WidgetRef ref,
    String status,
  ) async {
    try {
      await ref
          .read(supplyChainRepositoryProvider)
          .updateOrderStatus(order.id, status);
      onChanged();
      if (context.mounted) _snack(context, 'تم تحديث الطلب.');
    } catch (e) {
      if (context.mounted) _snack(context, _error(e), true);
    }
  }

  Future<void> _assignShipment(BuildContext context, WidgetRef ref) async {
    try {
      final representatives = await ref.read(
        supplyRepresentativesProvider.future,
      );
      if (!context.mounted) return;
      String? selectedId = representatives
          .where((item) => item.isEnabled && item.isAvailable)
          .firstOrNull
          ?.id;
      final packages = TextEditingController(text: '1');
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: const Text('إسناد الشحنة'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: selectedId,
                  decoration: const InputDecoration(labelText: 'المندوب'),
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
                _Field(packages, 'عدد الطرود', number: true),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('إلغاء'),
              ),
              FilledButton(
                onPressed: selectedId == null
                    ? null
                    : () => Navigator.pop(dialogContext, true),
                child: const Text('إسناد'),
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
      if (context.mounted) _snack(context, 'تم إسناد الشحنة للمندوب.');
    } catch (error) {
      if (context.mounted) _snack(context, _error(error), true);
    }
  }

  Future<void> _confirmDelivery(BuildContext context, WidgetRef ref) async {
    final token = TextEditingController();
    final note = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تأكيد استلام الشحنة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Field(token, 'رمز الاستلام'),
            _Field(note, 'ملاحظة الاستلام'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('تأكيد'),
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
      if (context.mounted) _snack(context, 'تم تأكيد استلام الشحنة.');
    } catch (error) {
      if (context.mounted) _snack(context, _error(error), true);
    }
  }

  Future<void> _createReturn(BuildContext context, WidgetRef ref) async {
    if (order.items.isEmpty) return;
    var itemId = order.items.first.id;
    final quantity = TextEditingController(text: '1');
    final reason = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('طلب إرجاع صنف'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: itemId,
                decoration: const InputDecoration(labelText: 'الصنف'),
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
              _Field(quantity, 'الكمية', number: true),
              _Field(reason, 'سبب الإرجاع'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('إلغاء'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('إرسال الطلب'),
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
      if (context.mounted) _snack(context, 'تم إرسال طلب الإرجاع.');
    } catch (error) {
      if (context.mounted) _snack(context, _error(error), true);
    }
  }
}

class _RepresentativesTab extends ConsumerWidget {
  const _RepresentativesTab();
  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    body: ref
        .watch(supplyRepresentativesProvider)
        .when(
          loading: () => const AppLoadingState(),
          error: (e, _) => AppErrorState(
            error: e,
            onRetry: () => ref.invalidate(supplyRepresentativesProvider),
          ),
          data: (items) => items.isEmpty
              ? const _Empty(
                  icon: Icons.badge_outlined,
                  text: 'لا يوجد مندوبون.',
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 90),
                  itemCount: items.length + 1,
                  separatorBuilder: (_, _) => const SizedBox(height: 9),
                  itemBuilder: (context, i) => i == 0
                      ? _CollectionHeader(
                          icon: Icons.delivery_dining_outlined,
                          title: 'فريق التوصيل',
                          subtitle:
                              '${items.where((x) => x.isAvailable).length} متاح الآن · '
                              '${items.fold<int>(0, (sum, x) => sum + x.activeDeliveries)} مهمة نشطة',
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
      icon: const Icon(Icons.person_add_alt),
      label: const Text('مندوب'),
    ),
  );
}

class _RepresentativeCard extends ConsumerWidget {
  const _RepresentativeCard({required this.representative});

  final Representative representative;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                        ? context.appColors.success.withValues(alpha: .1)
                        : context.appColors.surfaceSoft,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.delivery_dining_rounded,
                    color: r.isAvailable
                        ? context.appColors.success
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
                        '${r.employeeCode} · ${r.vehiclePlateNumber ?? 'دون مركبة'}',
                        style: TextStyle(
                          color: context.appColors.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                _Badge(
                  r.isOnShift ? 'ضمن الوردية' : 'خارج الوردية',
                  r.isOnShift ? context.appColors.success : context.appColors.textMuted,
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: _CompactStat(
                    label: 'نشطة',
                    value: '${r.activeDeliveries}',
                    icon: Icons.route_outlined,
                  ),
                ),
                Expanded(
                  child: _CompactStat(
                    label: 'مكتملة',
                    value: '${r.completedDeliveries}',
                    icon: Icons.task_alt_rounded,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      'متاح',
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
    try {
      await ref
          .read(supplyChainRepositoryProvider)
          .updateRepresentative(representative, isAvailable: value);
      ref.invalidate(supplyRepresentativesProvider);
    } catch (error) {
      if (context.mounted) _snack(context, _error(error), true);
    }
  }
}

Future<void> _addRepresentative(BuildContext context, WidgetRef ref) async {
  final name = TextEditingController(),
      email = TextEditingController(),
      password = TextEditingController(),
      code = TextEditingController(),
      plate = TextEditingController();
  final save = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      title: const Text('إضافة مندوب'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Field(name, 'الاسم'),
            _Field(email, 'البريد'),
            _Field(password, 'كلمة المرور'),
            _Field(code, 'رمز الموظف'),
            _Field(plate, 'لوحة المركبة'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(c, false),
          child: const Text('إلغاء'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(c, true),
          child: const Text('إنشاء'),
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
      if (context.mounted) _snack(context, 'تم إنشاء حساب المندوب.');
    } catch (e) {
      if (context.mounted) _snack(context, _error(e), true);
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
    const items = <(String, IconData)>[
      ('الفواتير', Icons.receipt_long_outlined),
      ('المرتجعات', Icons.keyboard_return_rounded),
      ('السحب', Icons.warning_amber_rounded),
    ];
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 16, 20, 6),
          child: _CollectionHeader(
            icon: Icons.account_balance_wallet_outlined,
            title: 'المالية والرقابة',
            subtitle: 'الفواتير والتحصيل والمرتجعات وسحب التشغيلات',
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
                            ? context.appColors.primaryDeep
                            : context.appColors.surfaceSoft,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            items[index].$2,
                            size: 19,
                            color: active
                                ? context.appColors.secondary
                                : context.appColors.primary,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            items[index].$1,
                            style: TextStyle(
                              color: active ? Colors.white : context.appColors.text,
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

class _PharmacySupplyWorkspace extends StatelessWidget {
  const _PharmacySupplyWorkspace();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('توريد الصيدلية'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'المستودعات'),
              Tab(text: 'طلباتي'),
              Tab(text: 'احتياج المخزون'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _MarketplaceTab(),
            _OrdersTab(warehouse: false),
            _SuggestionsTab(),
          ],
        ),
      ),
    );
  }
}

class _MarketplaceTab extends ConsumerWidget {
  const _MarketplaceTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(supplyMarketplaceProvider)
        .when(
          loading: () => const AppLoadingState(),
          error: (error, _) => AppErrorState(
            error: error,
            onRetry: () => ref.invalidate(supplyMarketplaceProvider),
          ),
          data: (items) => items.isEmpty
              ? const _Empty(
                  icon: Icons.store_mall_directory_outlined,
                  text: 'لا توجد مستودعات متاحة.',
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final warehouse = items[index];
                    return Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(14),
                        leading: Icon(
                          Icons.warehouse_outlined,
                          color: context.appColors.primary,
                        ),
                        title: Text(warehouse.name),
                        subtitle: Text(
                          '${warehouse.city} · ${warehouse.area}\n'
                          '${warehouse.availableMedicines} دواء · توصيل '
                          '${_money(warehouse.deliveryFee)} ل.س',
                        ),
                        isThreeLine: true,
                        trailing: const Icon(Icons.chevron_left),
                        onTap: () => showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          useSafeArea: true,
                          builder: (_) =>
                              _CatalogOrderSheet(warehouse: warehouse),
                        ),
                      ),
                    );
                  },
                ),
        );
  }
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
                const Text('حدد الكميات المطلوبة ثم أرسل الطلب.'),
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
                        '${_money(item.bestPrice)} ل.س · '
                        'متاح ${item.availableQuantity}',
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
                label: Text(sending ? 'جاري الإرسال...' : 'إرسال الطلب'),
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
        _snack(context, 'تم إرسال طلب التوريد.');
      }
    } catch (e) {
      if (mounted) _snack(context, _error(e), true);
    } finally {
      if (mounted) setState(() => sending = false);
    }
  }
}

class _SuggestionsTab extends ConsumerWidget {
  const _SuggestionsTab();
  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
      .watch(supplySuggestionsProvider)
      .when(
        loading: () => const AppLoadingState(),
        error: (e, _) => AppErrorState(
          error: e,
          onRetry: () => ref.invalidate(supplySuggestionsProvider),
        ),
        data: (items) => items.isEmpty
            ? const _Empty(
                icon: Icons.task_alt,
                text: 'المخزون ضمن الحدود المناسبة.',
              )
            : ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(height: 9),
                itemBuilder: (_, i) {
                  final x = items[i];
                  return Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.auto_graph,
                        color: context.appColors.warning,
                      ),
                      title: Text(x.medicineName),
                      subtitle: Text(
                        'الحالي ${x.currentQuantity} · المقترح ${x.suggestedQuantity}\n${x.recommendedWarehouseName ?? 'لا يوجد مستودع مقترح'}',
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              ),
      );
}

class _RepresentativeWorkspace extends ConsumerWidget {
  const _RepresentativeWorkspace();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(supplyOrdersProvider);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('مهام التوصيل'),
            Text(
              'جدولك الميداني اليوم',
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
            tooltip: 'تحديث المهام',
            onPressed: () => ref.invalidate(supplyOrdersProvider),
            icon: const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: state.when(
        loading: () => const AppLoadingState(label: 'جاري تجهيز مهامك...'),
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
                    title: 'الشحنات المسندة',
                    subtitle: deliveries.isEmpty
                        ? 'لا توجد مهمة جديدة في الوقت الحالي'
                        : 'حدّث حالة المهمة عند كل مرحلة',
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
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: AlignmentDirectional.topStart,
        end: AlignmentDirectional.bottomEnd,
        colors: [context.appColors.primaryDeep, context.appColors.primary],
      ),
      borderRadius: BorderRadius.circular(28),
      boxShadow: [
        BoxShadow(
          color: context.appColors.primaryDeep.withValues(alpha: .16),
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
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'رحلة آمنة ومنظمة',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'راجع العنوان وحدّث حالة الشحنة أثناء التوصيل',
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            _HeroStat(label: 'المهام', value: total),
            const SizedBox(width: 8),
            _HeroStat(label: 'نشطة', value: active),
            const SizedBox(width: 8),
            _HeroStat(label: 'مكتملة', value: completed),
          ],
        ),
      ],
    ),
  );
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
                        '${shipment.shipmentCode} · ${order.items.length} أصناف',
                        style: TextStyle(
                          color: context.appColors.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                _Badge(
                  _status(shipment.status),
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
                      if (context.mounted) _snack(context, _error(e), true);
                    }
                  },
                  icon: Icon(_nextIcon(next)),
                  label: Text(_nextLabel(next)),
                ),
              ),
            ] else ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.task_alt_rounded, color: context.appColors.success),
                  SizedBox(width: 7),
                  Text(
                    'تم تسليم الشحنة بنجاح',
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

  static const labels = ['استلام', 'تحميل', 'بالطريق', 'وصول', 'تسليم'];

  @override
  Widget build(BuildContext context) => Row(
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
                      color: reached ? context.appColors.primary : context.appColors.border,
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
                      color: reached ? context.appColors.primary : context.appColors.border,
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
                color: reached ? context.appColors.primary : context.appColors.textMuted,
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
    return state.when(
      loading: () => const AppLoadingState(),
      error: (error, _) => AppErrorState(error: error, onRetry: onRetry),
      data: (items) => items.isEmpty
          ? const _Empty(icon: Icons.inbox_outlined, text: 'لا توجد بيانات.')
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
  Widget build(BuildContext context, WidgetRef ref) => Card(
    child: ListTile(
      leading: Icon(Icons.receipt_long, color: context.appColors.primary),
      title: Text(x.invoiceNumber),
      subtitle: Text(
        '${x.pharmacyName} · متبقي ${_money(x.remainingAmount)} ل.س',
      ),
      trailing: _Badge(
        _status(x.paymentStatus),
        _statusColor(context.appColors, x.paymentStatus),
      ),
      onTap: () => _manageInvoice(context, ref),
    ),
  );

  Future<void> _manageInvoice(BuildContext context, WidgetRef ref) async {
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
                'الإجمالي ${_money(x.totalAmount)} ل.س · المدفوع ${_money(x.paidAmount)} ل.س',
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () => Navigator.pop(sheetContext, 'edit'),
                icon: const Icon(Icons.edit_calendar_outlined),
                label: const Text('تعديل شروط الفاتورة'),
              ),
              FilledButton.icon(
                onPressed: x.remainingAmount <= 0
                    ? null
                    : () => Navigator.pop(sheetContext, 'payment'),
                icon: const Icon(Icons.payments_outlined),
                label: const Text('تسجيل دفعة'),
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
    final amount = TextEditingController(text: _money(x.remainingAmount));
    final reference = TextEditingController();
    var method = x.paymentMethod.isEmpty ? 'CashOnDelivery' : x.paymentMethod;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('تسجيل دفعة'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Field(amount, 'المبلغ', number: true),
              DropdownButtonFormField<String>(
                initialValue: method,
                decoration: const InputDecoration(labelText: 'طريقة الدفع'),
                items: const [
                  DropdownMenuItem(
                    value: 'CashOnDelivery',
                    child: Text('نقدي عند التسليم'),
                  ),
                  DropdownMenuItem(
                    value: 'BankTransfer',
                    child: Text('تحويل بنكي'),
                  ),
                  DropdownMenuItem(value: 'Credit', child: Text('آجل')),
                ],
                onChanged: (value) {
                  if (value != null) setDialogState(() => method = value);
                },
              ),
              const SizedBox(height: 8),
              _Field(reference, 'رقم المرجع (اختياري)'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('إلغاء'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('حفظ'),
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
      if (context.mounted) _snack(context, 'تم تسجيل الدفعة.');
    } catch (error) {
      if (context.mounted) _snack(context, _error(error), true);
    }
  }

  Future<void> _editInvoice(BuildContext context, WidgetRef ref) async {
    final discount = TextEditingController(text: _money(x.discountAmount));
    final tax = TextEditingController(text: _money(x.taxAmount));
    final note = TextEditingController(text: x.warehouseNote);
    var method = x.paymentMethod.isEmpty ? 'CashOnDelivery' : x.paymentMethod;
    var due = x.dueAtUtc;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('تعديل الفاتورة'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: method,
                  decoration: const InputDecoration(labelText: 'طريقة الدفع'),
                  items: const [
                    DropdownMenuItem(
                      value: 'CashOnDelivery',
                      child: Text('نقدي عند التسليم'),
                    ),
                    DropdownMenuItem(
                      value: 'BankTransfer',
                      child: Text('تحويل بنكي'),
                    ),
                    DropdownMenuItem(value: 'Credit', child: Text('آجل')),
                  ],
                  onChanged: (value) {
                    if (value != null) setDialogState(() => method = value);
                  },
                ),
                const SizedBox(height: 8),
                _Field(discount, 'الحسم', number: true),
                _Field(tax, 'الضريبة', number: true),
                _Field(note, 'ملاحظة المستودع'),
                ListTile(
                  title: const Text('تاريخ الاستحقاق'),
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
              child: const Text('إلغاء'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('حفظ'),
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
      if (context.mounted) _snack(context, 'تم تحديث الفاتورة.');
    } catch (error) {
      if (context.mounted) _snack(context, _error(error), true);
    }
  }
}

class _ReturnCard extends ConsumerWidget {
  const _ReturnCard(this.x);
  final SupplyReturn x;
  @override
  Widget build(BuildContext context, WidgetRef ref) => Card(
    child: ListTile(
      leading: Icon(Icons.keyboard_return, color: context.appColors.warning),
      title: Text(x.medicineName),
      subtitle: Text('${x.quantity} عبوات · ${x.reason}'),
      trailing:
          x.status == 'Requested' ||
              x.status == 'Approved' ||
              x.status == 'Collected'
          ? PopupMenuButton<String>(
              onSelected: (status) => _review(context, ref, status),
              itemBuilder: (_) => [
                if (x.status == 'Requested') ...const [
                  PopupMenuItem(value: 'Approved', child: Text('قبول المرتجع')),
                  PopupMenuItem(value: 'Rejected', child: Text('رفض المرتجع')),
                ],
                if (x.status == 'Approved')
                  const PopupMenuItem(
                    value: 'Collected',
                    child: Text('تم الاستلام من الصيدلية'),
                  ),
                if (x.status == 'Collected')
                  const PopupMenuItem(
                    value: 'Completed',
                    child: Text('إكمال المرتجع'),
                  ),
              ],
            )
          : _Badge(
              _status(x.status),
              _statusColor(context.appColors, x.status),
            ),
    ),
  );

  Future<void> _review(
    BuildContext context,
    WidgetRef ref,
    String status,
  ) async {
    try {
      await ref.read(supplyChainRepositoryProvider).reviewReturn(x.id, status);
      ref.invalidate(supplyReturnsProvider);
      if (context.mounted) _snack(context, 'تم تحديث المرتجع.');
    } catch (error) {
      if (context.mounted) _snack(context, _error(error), true);
    }
  }
}

class _RecallsPanel extends ConsumerWidget {
  const _RecallsPanel();
  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
        child: SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => _createRecall(context, ref),
            icon: const Icon(Icons.add_alert_outlined),
            label: const Text('إنشاء تنبيه سحب'),
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

  Future<void> _createRecall(BuildContext context, WidgetRef ref) async {
    try {
      final batches = await ref.read(supplyBatchesProvider.future);
      if (!context.mounted || batches.isEmpty) return;
      var batchId = batches.first.id;
      var severity = 'Medium';
      final reason = TextEditingController();
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: const Text('سحب تشغيلة دوائية'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: batchId,
                  decoration: const InputDecoration(labelText: 'التشغيلة'),
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
                  decoration: const InputDecoration(labelText: 'درجة الخطورة'),
                  items: const [
                    DropdownMenuItem(value: 'Low', child: Text('منخفضة')),
                    DropdownMenuItem(value: 'Medium', child: Text('متوسطة')),
                    DropdownMenuItem(value: 'High', child: Text('عالية')),
                    DropdownMenuItem(value: 'Critical', child: Text('حرجة')),
                  ],
                  onChanged: (value) {
                    if (value != null) setDialogState(() => severity = value);
                  },
                ),
                const SizedBox(height: 8),
                _Field(reason, 'سبب السحب'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('إلغاء'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text('إنشاء التنبيه'),
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
      if (context.mounted) _snack(context, 'تم إنشاء تنبيه السحب.');
    } catch (error) {
      if (context.mounted) _snack(context, _error(error), true);
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
  Widget build(BuildContext context) => Card(
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
                  color: context.appColors.surfaceSoft,
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
                      'رقم التشغيلة ${batch.batchNumber}',
                      style: TextStyle(
                        color: context.appColors.textMuted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              _Badge(_health(batch.health), _healthColor(context.appColors, batch.health)),
            ],
          ),
          const Divider(height: 22),
          Row(
            children: [
              Expanded(
                child: _CompactStat(
                  label: 'المتاح',
                  value: '${batch.sellableQuantity}',
                  icon: Icons.inventory_2_outlined,
                ),
              ),
              Expanded(
                child: _CompactStat(
                  label: 'سعر الجملة',
                  value: _money(batch.wholesalePrice),
                  icon: Icons.payments_outlined,
                ),
              ),
              Expanded(
                child: _CompactStat(
                  label: 'الانتهاء',
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
      gradient: LinearGradient(
        begin: AlignmentDirectional.topStart,
        end: AlignmentDirectional.bottomEnd,
        colors: [context.appColors.primaryDeep, context.appColors.primary],
      ),
      borderRadius: BorderRadius.circular(28),
      boxShadow: [
        BoxShadow(
          color: context.appColors.primaryDeep.withValues(alpha: .16),
          blurRadius: 24,
          offset: const Offset(0, 12),
        ),
      ],
    ),
    child: Stack(
      children: [
        PositionedDirectional(
          end: -35,
          top: -42,
          child: Container(
            width: 145,
            height: 145,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: .06),
            ),
          ),
        ),
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
                        color: context.appColors.primaryDeep,
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
              style: TextStyle(fontSize: 10, color: context.appColors.textMuted),
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
          color: context.appColors.surfaceSoft,
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
              style: TextStyle(color: context.appColors.textMuted, fontSize: 10),
            ),
          ],
        ),
      ),
      if (count != null)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: context.appColors.surfaceSoft,
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
String _error(Object e) =>
    e is ApiException ? e.message : 'تعذر إكمال العملية.';
void _snack(BuildContext c, String t, [bool error = false]) =>
    ScaffoldMessenger.of(c).showSnackBar(
      SnackBar(
        content: Text(t),
        backgroundColor: error ? c.appColors.danger : null,
      ),
    );
String _health(String s) => switch (s.toLowerCase()) {
  'healthy' => 'سليم',
  'lowstock' => 'منخفض',
  'expiring' => 'قرب الانتهاء',
  'expired' => 'منتهي',
  _ => s,
};
Color _healthColor(AppColors colors, String s) => switch (s.toLowerCase()) {
  'healthy' => colors.success,
  'expired' => colors.danger,
  _ => colors.warning,
};
String _status(String s) => switch (s.toLowerCase()) {
  'submitted' => 'مرسل',
  'accepted' => 'مقبول',
  'preparing' => 'قيد التجهيز',
  'readyfordispatch' => 'جاهز للشحن',
  'assigned' => 'مسند',
  'loading' => 'تحميل',
  'outfordelivery' => 'في الطريق',
  'arrived' => 'وصل',
  'delivered' => 'تم التسليم',
  'rejected' => 'مرفوض',
  'paid' => 'مدفوع',
  'partiallypaid' => 'مدفوع جزئيًا',
  'unpaid' => 'غير مدفوع',
  'requested' => 'مطلوب',
  'approved' => 'مقبول',
  'active' => 'نشط',
  _ => s,
};
Color _statusColor(AppColors colors, String s) => switch (s.toLowerCase()) {
  'delivered' || 'paid' || 'approved' => colors.success,
  'rejected' || 'failed' || 'overdue' => colors.danger,
  'submitted' || 'requested' || 'unpaid' => colors.warning,
  _ => colors.primary,
};
String _nextLabel(String s) => switch (s) {
  'Loading' => 'بدء التحميل',
  'OutForDelivery' => 'بدء التوصيل',
  'Arrived' => 'تأكيد الوصول',
  'Delivered' => 'تأكيد التسليم',
  _ => 'تحديث',
};
