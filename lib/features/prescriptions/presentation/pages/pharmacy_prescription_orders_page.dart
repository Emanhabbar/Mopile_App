import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../../core/widgets/async_states.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../l10n/generated/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.prescriptionOrdersTitle),
        actions: [
          IconButton(
            onPressed: () => ref.invalidate(pharmacyPrescriptionOrdersProvider),
            tooltip: l10n.refreshOrders,
            icon: const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: state.when(
        loading: () => AppLoadingState(label: l10n.ordersLoading),
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
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController();
    final code = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDeliveryTitle),
        content: AppTextField(
          controller: controller,
          keyboardType: TextInputType.number,
          label: l10n.pickupCodeLabel,
          hint: l10n.pickupCodeHint,
          icon: Icons.pin_outlined,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
    controller.dispose();
    if (code == null || code.length != 8) {
      if (code != null) _message(l10n.invalidPickupCode, true);
      return;
    }
    await _update(order, status: 'Collected', pickupCode: code);
  }

  Future<void> _update(
    PrescriptionOrder order, {
    required String status,
    String? pickupCode,
  }) async {
    final l10n = AppLocalizations.of(context);
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
            ? l10n.prescriptionCollectedMsg
            : l10n.prescriptionReadyMsg,
        false,
      );
    } catch (error) {
      _message(
        error is ApiException ? error.localize(l10n) : l10n.prescriptionStatusUpdateFailed,
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
          backgroundColor: error ? context.appColors.danger : null,
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
    final l10n = AppLocalizations.of(context);
    final info = prescriptionStatusInfo(context.appColors, order.status, l10n);
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
                        ? l10n.prescriptionFallbackTitle
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
                color: context.appColors.surfaceSoft,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.medication_outlined,
                    color: context.appColors.primary,
                    size: 19,
                  ),
                  const SizedBox(width: 7),
                  Text(l10n.prescriptionItemsCount(order.items.length)),
                  const Spacer(),
                  Text(
                    l10n.matchPercentage(
                      order.matchPercentage.toStringAsFixed(0),
                    ),
                    style: TextStyle(
                      color: context.appColors.primary,
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
                        Icon(
                          Icons.circle,
                          size: 5,
                          color: context.appColors.textMuted,
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
                        ? l10n.markReadyAction
                        : l10n.confirmDeliveryWithCode,
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
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
    padding: const EdgeInsets.all(19),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [context.appColors.primaryDeep, context.appColors.primary],
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
          child: Icon(
            Icons.receipt_long_rounded,
            color: context.appColors.secondary,
            size: 28,
          ),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.pharmacyPrescriptionsTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                l10n.pharmacyPrescriptionsSubtitle,
                style: const TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ],
          ),
        ),
        _OrderFact(value: active, label: l10n.orderFactActive),
        const SizedBox(width: 11),
        _OrderFact(value: ready, label: l10n.orderFactReady),
        const SizedBox(width: 11),
        _OrderFact(value: total, label: l10n.statusAll),
      ],
    ),
    );
  }
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
    children: [
      const SizedBox(height: 80),
      Icon(Icons.receipt_long_outlined, color: context.appColors.textMuted, size: 42),
      const SizedBox(height: 12),
      Text(
        AppLocalizations.of(context).noPharmacyOrders,
        textAlign: TextAlign.center,
      ),
    ],
  );
}
