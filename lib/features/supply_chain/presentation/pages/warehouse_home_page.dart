import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/layout.dart';
import '../../../../core/widgets/async_states.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../dashboard/presentation/widgets/role_dashboard_widgets.dart';
import '../controllers/supply_chain_providers.dart';

class WarehouseHomePage extends ConsumerWidget {
  const WarehouseHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(supplyDashboardProvider);
    return state.when(
      loading: () => AppLoadingState(label: l10n.supplyLoadingWarehouse),
      error: (error, _) => AppErrorState(
        error: error,
        onRetry: () => ref.invalidate(supplyDashboardProvider),
      ),
      data: (data) => RefreshIndicator(
        onRefresh: () => ref.refresh(supplyDashboardProvider.future),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(20, 14, 20, kBottomNavReserved),
          children: [
            RoleDashboardHero(
              title: l10n.warehouseHeroTitle,
              subtitle: l10n.warehouseHeroSubtitle,
              icon: Icons.warehouse_rounded,
              accent: context.appColors.primary,
              badge: data.pendingOrders > 0
                  ? l10n.warehousePendingOrders(data.pendingOrders)
                  : l10n.warehouseOrdersUpToDate,
            ),
            const SizedBox(height: 22),
            RoleSectionHeader(
              title: l10n.warehouseOpsStatus,
              subtitle: l10n.warehouseOpsStatusSubtitle,
            ),
            const SizedBox(height: 11),
            RoleMetricsGrid(
              items: [
                RoleMetricData(
                  label: l10n.supplyActiveBatches,
                  value: '${data.activeBatches}',
                  icon: Icons.inventory_2_rounded,
                  color: context.appColors.primary,
                ),
                RoleMetricData(
                  label: l10n.supplyLowStock,
                  value: '${data.lowStockBatches}',
                  icon: Icons.warning_amber_rounded,
                  color: context.appColors.primary,
                ),
                RoleMetricData(
                  label: l10n.supplyExpiringSoon,
                  value: '${data.expiringBatches}',
                  icon: Icons.event_busy_outlined,
                  color: context.appColors.primary,
                ),
                RoleMetricData(
                  label: l10n.supplyActiveDeliveries,
                  value: '${data.activeDeliveries}',
                  icon: Icons.local_shipping_rounded,
                  color: context.appColors.primary,
                ),
              ],
            ),
            const SizedBox(height: 24),
            RoleNoticeCard(
              title: l10n.warehouseInventoryValueTitle,
              message: l10n.warehouseInventoryValueMessage(_money(data.inventoryValue)),
              icon: Icons.account_balance_wallet_outlined,
              color: context.appColors.primary,
              onTap: () => context.go('/supply-chain'),
            ),
            const SizedBox(height: 24),
            RoleSectionHeader(
              title: l10n.warehouseQuickOps,
              subtitle: l10n.warehouseQuickOpsSubtitle,
            ),
            const SizedBox(height: 11),
            RoleActionsGrid(
              items: [
                RoleActionData(
                  title: l10n.warehouseManage,
                  subtitle: l10n.warehouseManageSubtitle,
                  badge: data.lowStockBatches > 0
                      ? '${data.lowStockBatches}'
                      : null,
                  icon: Icons.inventory_rounded,
                  color: context.appColors.primary,
                  onTap: () => context.go('/supply-chain'),
                ),
                RoleActionData(
                  title: l10n.warehouseSupplyOrders,
                  subtitle: l10n.warehouseSupplyOrdersSubtitle,
                  badge: data.pendingOrders > 0
                      ? '${data.pendingOrders}'
                      : null,
                  icon: Icons.receipt_long_rounded,
                  color: context.appColors.primary,
                  onTap: () => context.go('/supply-chain'),
                ),
                RoleActionData(
                  title: l10n.warehouseShipping,
                  subtitle: l10n.warehouseShippingSubtitle,
                  badge: data.activeDeliveries > 0
                      ? '${data.activeDeliveries}'
                      : null,
                  icon: Icons.local_shipping_outlined,
                  color: context.appColors.primary,
                  onTap: () => context.go('/supply-chain'),
                ),
                RoleActionData(
                  title: l10n.warehouseInventoryAnalysis,
                  subtitle: l10n.warehouseInventoryAnalysisSubtitle,
                  icon: Icons.auto_graph_rounded,
                  color: context.appColors.primary,
                  onTap: () => context.push('/intelligence'),
                ),
              ],
            ),
            if (data.alerts.isNotEmpty) ...[
              const SizedBox(height: 24),
              RoleSectionHeader(
                title: l10n.warehouseAlertsTitle,
                subtitle: l10n.warehouseAlertsSubtitle,
                action: TextButton(
                  onPressed: () => context.go('/supply-chain'),
                  child: Text(l10n.viewAll),
                ),
              ),
              const SizedBox(height: 10),
              ...data.alerts
                  .take(3)
                  .map(
                    (batch) => Padding(
                      padding: const EdgeInsets.only(bottom: 9),
                      child: RoleNoticeCard(
                        title: batch.medicineName,
                        message: l10n.warehouseBatchAlert(batch.batchNumber, batch.sellableQuantity),
                        icon: batch.sellableQuantity <= 0
                            ? Icons.remove_circle_outline_rounded
                            : Icons.inventory_2_outlined,
                        color: context.appColors.primary,
                        onTap: () => context.go('/supply-chain'),
                      ),
                    ),
                  ),
            ],
            if (data.recentOrders.isNotEmpty) ...[
              const SizedBox(height: 24),
              RoleSectionHeader(
                title: l10n.warehouseRecentOrders,
                subtitle: l10n.warehouseRecentOrdersSubtitle,
              ),
              const SizedBox(height: 10),
              ...data.recentOrders
                  .take(3)
                  .map(
                    (order) => Padding(
                      padding: const EdgeInsets.only(bottom: 9),
                      child: RoleNoticeCard(
                        title: order.pharmacyName,
                        message: l10n.warehouseOrderSummary(
                          order.orderCode,
                          _orderStatus(l10n, order.status),
                          _money(order.totalAmount),
                        ),
                        icon: Icons.receipt_long_outlined,
                        color: _orderColor(context.appColors, order.status),
                        onTap: () => context.go('/supply-chain'),
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

String _money(double value) {
  final digits = value.round().toString();
  return digits.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => '،');
}

String _orderStatus(AppLocalizations l10n, String status) => switch (status) {
  'Submitted' => l10n.newLabel,
  'Accepted' => l10n.supplyStatusAccepted,
  'Preparing' => l10n.supplyStatusPreparing,
  'ReadyForDispatch' => l10n.supplyStatusReadyForDispatch,
  'OutForDelivery' => l10n.supplyStatusOutForDelivery,
  'Delivered' => l10n.supplyStatusDelivered,
  'Rejected' => l10n.supplyStatusRejected,
  'Cancelled' => l10n.statusCancelled,
  _ => status,
};

Color _orderColor(AppColors colors, String status) => switch (status) {
  'Delivered' => colors.primary,
  'Rejected' || 'Cancelled' => colors.primary,
  'OutForDelivery' => colors.primary,
  _ => colors.primary,
};
