import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/async_states.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../dashboard/presentation/widgets/role_dashboard_widgets.dart';
import '../../data/models/supply_chain_models.dart';
import '../controllers/supply_chain_providers.dart';

class RepresentativeHomePage extends ConsumerWidget {
  const RepresentativeHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(supplyOrdersProvider);
    return state.when(
      loading: () => AppLoadingState(label: l10n.representativeLoadingSchedule),
      error: (error, _) => AppErrorState(
        error: error,
        onRetry: () => ref.invalidate(supplyOrdersProvider),
      ),
      data: (orders) {
        final deliveries =
            orders.where((order) => order.shipment != null).toList()
              ..sort((a, b) => b.createdAtUtc.compareTo(a.createdAtUtc));
        final active = deliveries
            .where((order) => !_closed(order.shipment!.status))
            .toList();
        final completed = deliveries
            .where((order) => order.shipment!.status == 'Delivered')
            .length;
        final current = active.isEmpty ? null : active.first;
        return RefreshIndicator(
          onRefresh: () => ref.refresh(supplyOrdersProvider.future),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 112),
            children: [
              RoleDashboardHero(
                title: current == null
                    ? l10n.representativeReadyForNextTask
                    : l10n.representativeCurrentTaskTo(current.pharmacyName),
                subtitle: current == null
                    ? l10n.representativeNoTaskSubtitle
                    : l10n.representativeTaskLocation(
                        current.pharmacyArea,
                        current.pharmacyCity,
                        _shipmentStatus(l10n, current.shipment!.status),
                      ),
                icon: Icons.delivery_dining_rounded,
                accent: const Color(0xFF176F65),
                badge: active.isEmpty
                    ? l10n.representativeNoActiveTask
                    : l10n.representativeActiveTasksCount(active.length),
              ),
              const SizedBox(height: 22),
              RoleSectionHeader(
                title: l10n.representativeTripsSummary,
                subtitle: l10n.representativeTripsSummarySubtitle,
              ),
              const SizedBox(height: 11),
              RoleMetricsGrid(
                items: [
                  RoleMetricData(
                    label: l10n.representativeTotalTasks,
                    value: '${deliveries.length}',
                    icon: Icons.route_rounded,
                    color: context.appColors.primary,
                  ),
                  RoleMetricData(
                    label: l10n.representativeActiveTasks,
                    value: '${active.length}',
                    icon: Icons.local_shipping_outlined,
                    color: context.appColors.primaryLight,
                  ),
                  RoleMetricData(
                    label: l10n.supplyCompletedShort,
                    value: '$completed',
                    icon: Icons.task_alt_rounded,
                    color: context.appColors.success,
                  ),
                  RoleMetricData(
                    label: l10n.representativeFailedTasks,
                    value:
                        '${deliveries.where((x) => {'Failed', 'Returned'}.contains(x.shipment!.status)).length}',
                    icon: Icons.report_problem_outlined,
                    color: context.appColors.danger,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              RoleSectionHeader(
                title: l10n.representativeQuickAccess,
                subtitle: l10n.representativeQuickAccessSubtitle,
              ),
              const SizedBox(height: 11),
              RoleActionsGrid(
                items: [
                  RoleActionData(
                    title: l10n.supplyDeliveryTasks,
                    subtitle: l10n.representativeDeliveryTasksSubtitle,
                    badge: active.isNotEmpty ? '${active.length}' : null,
                    icon: Icons.delivery_dining_rounded,
                    color: context.appColors.primary,
                    onTap: () => context.go('/supply-chain'),
                  ),
                  RoleActionData(
                    title: l10n.notifications,
                    subtitle: l10n.representativeNotificationsSubtitle,
                    icon: Icons.notifications_active_outlined,
                    color: context.appColors.primaryLight,
                    onTap: () => context.push('/notifications'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              RoleSectionHeader(
                title: l10n.representativeActiveTasksTitle,
                subtitle: active.isEmpty
                    ? l10n.representativeNoActionRequired
                    : l10n.representativeStartOldest,
                action: active.isEmpty
                    ? null
                    : TextButton(
                        onPressed: () => context.go('/supply-chain'),
                        child: Text(l10n.viewAll),
                      ),
              ),
              const SizedBox(height: 10),
              if (active.isEmpty)
                RoleNoticeCard(
                  title: l10n.representativeAvailableForNewTask,
                  message: l10n.representativeAvailableForNewTaskSubtitle,
                  icon: Icons.check_circle_outline_rounded,
                  color: context.appColors.success,
                  onTap: () => context.push('/notifications'),
                )
              else
                ...active
                    .take(3)
                    .map(
                      (order) => Padding(
                        padding: const EdgeInsets.only(bottom: 9),
                        child: _DeliverySummaryCard(
                          order: order,
                          onTap: () => context.go('/supply-chain'),
                        ),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }
}

class _DeliverySummaryCard extends StatelessWidget {
  const _DeliverySummaryCard({required this.order, required this.onTap});

  final SupplyOrder order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final shipment = order.shipment!;
    return RoleNoticeCard(
      title: order.pharmacyName,
      message: l10n.representativeDeliveryCardSummary(
        shipment.shipmentCode,
        order.pharmacyArea,
        order.pharmacyCity,
        _shipmentStatus(l10n, shipment.status),
      ),
      icon: _shipmentIcon(shipment.status),
      color: _shipmentColor(context.appColors, shipment.status),
      onTap: onTap,
    );
  }
}

bool _closed(String status) =>
    {'Delivered', 'Failed', 'Returned'}.contains(status);

String _shipmentStatus(AppLocalizations l10n, String status) => switch (status) {
  'Assigned' => l10n.supplyStatusAssigned,
  'Loading' => l10n.supplyStatusLoading,
  'OutForDelivery' => l10n.supplyStatusOutForDelivery,
  'Arrived' => l10n.supplyStatusArrived,
  'Delivered' => l10n.supplyStatusDelivered,
  'Failed' => l10n.representativeStatusFailed,
  'Returned' => l10n.representativeStatusReturned,
  _ => status,
};

IconData _shipmentIcon(String status) => switch (status) {
  'Loading' => Icons.inventory_2_outlined,
  'OutForDelivery' => Icons.route_rounded,
  'Arrived' => Icons.location_on_outlined,
  'Delivered' => Icons.task_alt_rounded,
  'Failed' || 'Returned' => Icons.report_problem_outlined,
  _ => Icons.local_shipping_outlined,
};

Color _shipmentColor(AppColors colors, String status) => switch (status) {
  'Delivered' => colors.success,
  'Failed' || 'Returned' => colors.danger,
  'OutForDelivery' || 'Arrived' => colors.primaryLight,
  _ => colors.primary,
};
