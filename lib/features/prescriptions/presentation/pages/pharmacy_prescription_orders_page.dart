import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../../core/widgets/async_states.dart';
import '../../data/models/prescription_models.dart';
import '../../data/repositories/prescriptions_repository.dart';
import '../controllers/prescriptions_providers.dart';
import 'prescriptions_page.dart';

class PharmacyPrescriptionOrdersPage extends ConsumerStatefulWidget {
  const PharmacyPrescriptionOrdersPage({super.key});

  @override
  ConsumerState<PharmacyPrescriptionOrdersPage> createState() =>
      _PharmacyPrescriptionOrdersPageState();
}

class _PharmacyPrescriptionOrdersPageState
    extends ConsumerState<PharmacyPrescriptionOrdersPage> {
  String? _workingOrderId;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pharmacyPrescriptionOrdersProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('طلبات الوصفات'),
        actions: [
          IconButton(
            onPressed: () => ref.invalidate(pharmacyPrescriptionOrdersProvider),
            tooltip: 'تحديث الطلبات',
            icon: const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: state.when(
        loading: () => const AppLoadingState(label: 'جاري تحميل الطلبات...'),
        error: (error, _) => AppErrorState(
          error: error,
          onRetry: () => ref.invalidate(pharmacyPrescriptionOrdersProvider),
        ),
        data: (orders) {
          final active = orders
              .where((order) => order.isReserved || order.isReadyForPickup)
              .length;
          final ready = orders.where((order) => order.isReadyForPickup).length;
          return RefreshIndicator(
            onRefresh: () =>
                ref.refresh(pharmacyPrescriptionOrdersProvider.future),
            child: orders.isEmpty
                ? const _EmptyOrders()
                : ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                    itemCount: orders.length + 1,
                    separatorBuilder: (_, index) =>
                        SizedBox(height: index == 0 ? 15 : 10),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _OrdersOverview(
                          total: orders.length,
                          active: active,
                          ready: ready,
                        );
                      }
                      final order = orders[index - 1];
                      return _PharmacyOrderCard(
                        order: order,
                        working: _workingOrderId == order.id,
                        onReady: () => _markReady(order),
                        onCollected: () => _markCollected(order),
                      );
                    },
                  ),
          );
        },
      ),
    );
  }

  Future<void> _markReady(PrescriptionOrder order) async {
    await _update(order, status: 'ReadyForPickup');
  }

  Future<void> _markCollected(PrescriptionOrder order) async {
    final controller = TextEditingController();
    final code = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد تسليم الوصفة'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          maxLength: 8,
          decoration: const InputDecoration(
            labelText: 'رمز الاستلام',
            prefixIcon: Icon(Icons.pin_outlined),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (code == null || code.length != 8) {
      if (code != null) _message('أدخل رمز الاستلام المكون من 8 أرقام.', true);
      return;
    }
    await _update(order, status: 'Collected', pickupCode: code);
  }

  Future<void> _update(
    PrescriptionOrder order, {
    required String status,
    String? pickupCode,
  }) async {
    setState(() => _workingOrderId = order.id);
    try {
      await ref
          .read(prescriptionsRepositoryProvider)
          .updatePharmacyStatus(
            order.id,
            status: status,
            pickupCode: pickupCode,
          );
      ref.invalidate(pharmacyPrescriptionOrdersProvider);
      _message(
        status == 'Collected'
            ? 'تم تأكيد استلام الوصفة.'
            : 'تم تحديث الطلب إلى جاهز للاستلام.',
        false,
      );
    } catch (error) {
      _message(
        error is ApiException ? error.message : 'تعذر تحديث حالة الوصفة.',
        true,
      );
    } finally {
      if (mounted) setState(() => _workingOrderId = null);
    }
  }

  void _message(String text, bool error) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(text),
          backgroundColor: error ? AppColors.danger : null,
        ),
      );
  }
}

class _PharmacyOrderCard extends StatelessWidget {
  const _PharmacyOrderCard({
    required this.order,
    required this.working,
    required this.onReady,
    required this.onCollected,
  });

  final PrescriptionOrder order;
  final bool working;
  final VoidCallback onReady;
  final VoidCallback onCollected;

  @override
  Widget build(BuildContext context) {
    final info = prescriptionStatusInfo(order.status);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: info.color.withValues(alpha: .09),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(info.icon, color: info.color),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Text(
                    order.originalFileName.isEmpty
                        ? 'وصفة طبية'
                        : order.originalFileName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: info.color.withValues(alpha: .09),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    info.label,
                    style: TextStyle(
                      color: info.color,
                      fontWeight: FontWeight.w800,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: AppColors.surfaceSoft,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.medication_outlined,
                    color: AppColors.primary,
                    size: 19,
                  ),
                  const SizedBox(width: 7),
                  Text('${order.items.length} أدوية'),
                  const Spacer(),
                  Text(
                    'تطابق ${order.matchPercentage.toStringAsFixed(0)}٪',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ...order.items
                .take(4)
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.circle,
                          size: 5,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(width: 7),
                        Expanded(child: Text(item.displayName)),
                        Text(
                          '× ${item.reservedQuantity > 0 ? item.reservedQuantity : item.requestedQuantity}',
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                ),
            if (order.isReserved || order.isReadyForPickup) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: working
                      ? null
                      : order.isReserved
                      ? onReady
                      : onCollected,
                  icon: working
                      ? const SizedBox.square(
                          dimension: 17,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Icon(
                          order.isReserved
                              ? Icons.inventory_2_rounded
                              : Icons.task_alt_rounded,
                        ),
                  label: Text(
                    order.isReserved
                        ? 'تحديد كجاهزة للاستلام'
                        : 'تأكيد التسليم بالرمز',
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _OrdersOverview extends StatelessWidget {
  const _OrdersOverview({
    required this.total,
    required this.active,
    required this.ready,
  });

  final int total;
  final int active;
  final int ready;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(19),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [AppColors.primaryDeep, AppColors.primary],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ),
      borderRadius: BorderRadius.circular(25),
    ),
    child: Row(
      children: [
        Container(
          width: 51,
          height: 51,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .12),
            borderRadius: BorderRadius.circular(17),
          ),
          child: const Icon(
            Icons.receipt_long_rounded,
            color: AppColors.secondary,
            size: 28,
          ),
        ),
        const SizedBox(width: 13),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'وصفات الصيدلية',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                'جهّز الوصفة ثم أكّد تسليمها بالرمز',
                style: TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ],
          ),
        ),
        _OrderFact(value: active, label: 'نشطة'),
        const SizedBox(width: 11),
        _OrderFact(value: ready, label: 'جاهزة'),
        const SizedBox(width: 11),
        _OrderFact(value: total, label: 'الكل'),
      ],
    ),
  );
}

class _OrderFact extends StatelessWidget {
  const _OrderFact({required this.value, required this.label});
  final int value;
  final String label;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        '$value',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w900,
        ),
      ),
      Text(label, style: const TextStyle(color: Colors.white60, fontSize: 9)),
    ],
  );
}

class _EmptyOrders extends StatelessWidget {
  const _EmptyOrders();

  @override
  Widget build(BuildContext context) => ListView(
    physics: const AlwaysScrollableScrollPhysics(),
    padding: const EdgeInsets.all(32),
    children: const [
      SizedBox(height: 80),
      Icon(Icons.receipt_long_outlined, color: AppColors.textMuted, size: 42),
      SizedBox(height: 12),
      Text('لا توجد طلبات وصفات للصيدلية', textAlign: TextAlign.center),
    ],
  );
}
