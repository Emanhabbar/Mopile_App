import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/async_states.dart';
import '../../../dashboard/presentation/widgets/role_dashboard_widgets.dart';
import '../controllers/supply_chain_providers.dart';

class WarehouseHomePage extends ConsumerWidget {
  const WarehouseHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(supplyDashboardProvider);
    return state.when(
      loading: () => const AppLoadingState(label: 'نجهّز مركز المستودع...'),
      error: (error, _) => AppErrorState(
        error: error,
        onRetry: () => ref.invalidate(supplyDashboardProvider),
      ),
      data: (data) => RefreshIndicator(
        onRefresh: () => ref.refresh(supplyDashboardProvider.future),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 112),
          children: [
            RoleDashboardHero(
              title: 'توريد منظم من المخزون للتسليم',
              subtitle:
                  'راقب التشغيلات والطلبات والشحنات قبل أن تتحول إلى تأخير.',
              icon: Icons.warehouse_rounded,
              accent: const Color(0xFF166E64),
              badge: data.pendingOrders > 0
                  ? '${data.pendingOrders} طلبات توريد بانتظارك'
                  : 'الطلبات محدثة',
            ),
            const SizedBox(height: 22),
            const RoleSectionHeader(
              title: 'حالة التشغيل',
              subtitle: 'مؤشرات حية من مخزون المستودع',
            ),
            const SizedBox(height: 11),
            RoleMetricsGrid(
              items: [
                RoleMetricData(
                  label: 'تشغيلات نشطة',
                  value: '${data.activeBatches}',
                  icon: Icons.inventory_2_rounded,
                  color: context.appColors.primary,
                ),
                RoleMetricData(
                  label: 'مخزون منخفض',
                  value: '${data.lowStockBatches}',
                  icon: Icons.warning_amber_rounded,
                  color: context.appColors.primaryDeep,
                ),
                RoleMetricData(
                  label: 'قريبة الانتهاء',
                  value: '${data.expiringBatches}',
                  icon: Icons.event_busy_outlined,
                  color: context.appColors.primaryDark,
                ),
                RoleMetricData(
                  label: 'شحنات نشطة',
                  value: '${data.activeDeliveries}',
                  icon: Icons.local_shipping_rounded,
                  color: context.appColors.primary,
                ),
              ],
            ),
            const SizedBox(height: 24),
            RoleNoticeCard(
              title: 'قيمة المخزون الحالية',
              message:
                  '${_money(data.inventoryValue)} ل.س ضمن التشغيلات النشطة',
              icon: Icons.account_balance_wallet_outlined,
              color: context.appColors.primary,
              onTap: () => context.go('/supply-chain'),
            ),
            const SizedBox(height: 24),
            const RoleSectionHeader(
              title: 'تشغيل سريع',
              subtitle: 'اختصارات لأهم أعمال المستودع',
            ),
            const SizedBox(height: 11),
            RoleActionsGrid(
              items: [
                RoleActionData(
                  title: 'إدارة المستودع',
                  subtitle: 'التشغيلات والمخزون',
                  badge: data.lowStockBatches > 0
                      ? '${data.lowStockBatches}'
                      : null,
                  icon: Icons.inventory_rounded,
                  color: context.appColors.primary,
                  onTap: () => context.go('/supply-chain'),
                ),
                RoleActionData(
                  title: 'طلبات التوريد',
                  subtitle: 'قبول وتجهيز وإسناد الطلبات',
                  badge: data.pendingOrders > 0
                      ? '${data.pendingOrders}'
                      : null,
                  icon: Icons.receipt_long_rounded,
                  color: context.appColors.primaryDeep,
                  onTap: () => context.go('/supply-chain'),
                ),
                RoleActionData(
                  title: 'الشحن والتوصيل',
                  subtitle: 'المندوبون وحالة الشحنات',
                  badge: data.activeDeliveries > 0
                      ? '${data.activeDeliveries}'
                      : null,
                  icon: Icons.local_shipping_outlined,
                  color: context.appColors.primaryDark,
                  onTap: () => context.go('/supply-chain'),
                ),
                RoleActionData(
                  title: 'تحليل المخزون',
                  subtitle: 'توقع النفاد ودعم قرار التوريد',
                  icon: Icons.auto_graph_rounded,
                  color: context.appColors.primary,
                  onTap: () => context.push('/intelligence'),
                ),
              ],
            ),
            if (data.alerts.isNotEmpty) ...[
              const SizedBox(height: 24),
              RoleSectionHeader(
                title: 'تنبيهات المخزون',
                subtitle: 'التشغيلات التي تحتاج تدخلاً قريباً',
                action: TextButton(
                  onPressed: () => context.go('/supply-chain'),
                  child: const Text('عرض الكل'),
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
                        message:
                            'تشغيلة ${batch.batchNumber} · ${batch.sellableQuantity} عبوات متاحة',
                        icon: batch.sellableQuantity <= 0
                            ? Icons.remove_circle_outline_rounded
                            : Icons.inventory_2_outlined,
                        color: batch.sellableQuantity <= 0
                            ? context.appColors.primaryDark
                            : context.appColors.primary,
                        onTap: () => context.go('/supply-chain'),
                      ),
                    ),
                  ),
            ],
            if (data.recentOrders.isNotEmpty) ...[
              const SizedBox(height: 24),
              const RoleSectionHeader(
                title: 'أحدث الطلبات',
                subtitle: 'آخر طلبات التوريد الواردة للمستودع',
              ),
              const SizedBox(height: 10),
              ...data.recentOrders
                  .take(3)
                  .map(
                    (order) => Padding(
                      padding: const EdgeInsets.only(bottom: 9),
                      child: RoleNoticeCard(
                        title: order.pharmacyName,
                        message:
                            '${order.orderCode} · ${_orderStatus(order.status)} · ${_money(order.totalAmount)} ل.س',
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

String _orderStatus(String status) => switch (status) {
  'Submitted' => 'جديد',
  'Accepted' => 'مقبول',
  'Preparing' => 'قيد التجهيز',
  'ReadyForDispatch' => 'جاهز للشحن',
  'OutForDelivery' => 'في الطريق',
  'Delivered' => 'تم التسليم',
  'Rejected' => 'مرفوض',
  'Cancelled' => 'ملغى',
  _ => status,
};

Color _orderColor(AppColors colors, String status) => switch (status) {
  'Delivered' => colors.primary,
  'Rejected' || 'Cancelled' => colors.primaryDark,
  'OutForDelivery' => colors.primaryDeep,
  _ => colors.primary,
};
