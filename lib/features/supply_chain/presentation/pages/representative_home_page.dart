import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/async_states.dart';
import '../../../dashboard/presentation/widgets/role_dashboard_widgets.dart';
import '../../data/models/supply_chain_models.dart';
import '../controllers/supply_chain_providers.dart';

class RepresentativeHomePage extends ConsumerWidget {
  const RepresentativeHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(supplyOrdersProvider);
    return state.when(
      loading: () => const AppLoadingState(label: 'نجهّز جدول التوصيل...'),
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
                    ? 'جاهز لمهمتك القادمة'
                    : 'مهمتك الحالية إلى ${current.pharmacyName}',
                subtitle: current == null
                    ? 'ستظهر هنا أي شحنة جديدة يسندها المستودع إليك.'
                    : '${current.pharmacyArea}، ${current.pharmacyCity} · ${_shipmentStatus(current.shipment!.status)}',
                icon: Icons.delivery_dining_rounded,
                accent: const Color(0xFF176F65),
                badge: active.isEmpty
                    ? 'لا توجد مهمة نشطة'
                    : '${active.length} مهام نشطة',
              ),
              const SizedBox(height: 22),
              const RoleSectionHeader(
                title: 'ملخص الرحلات',
                subtitle: 'حالة الشحنات المسندة إلى حسابك',
              ),
              const SizedBox(height: 11),
              RoleMetricsGrid(
                items: [
                  RoleMetricData(
                    label: 'إجمالي المهام',
                    value: '${deliveries.length}',
                    icon: Icons.route_rounded,
                    color: AppColors.primary,
                  ),
                  RoleMetricData(
                    label: 'مهام نشطة',
                    value: '${active.length}',
                    icon: Icons.local_shipping_outlined,
                    color: const Color(0xFF3977C4),
                  ),
                  RoleMetricData(
                    label: 'تم تسليمها',
                    value: '$completed',
                    icon: Icons.task_alt_rounded,
                    color: AppColors.success,
                  ),
                  RoleMetricData(
                    label: 'متعثرة',
                    value:
                        '${deliveries.where((x) => {'Failed', 'Returned'}.contains(x.shipment!.status)).length}',
                    icon: Icons.report_problem_outlined,
                    color: AppColors.danger,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              RoleActionsGrid(
                items: [
                  RoleActionData(
                    title: 'مهام التوصيل',
                    subtitle: 'العناوين وتحديث حالة الشحنة',
                    badge: active.isNotEmpty ? '${active.length}' : null,
                    icon: Icons.delivery_dining_rounded,
                    color: AppColors.primary,
                    onTap: () => context.push('/supply-chain'),
                  ),
                  RoleActionData(
                    title: 'الإشعارات',
                    subtitle: 'التكليفات وآخر تحديثات المستودع',
                    icon: Icons.notifications_active_outlined,
                    color: const Color(0xFF3977C4),
                    onTap: () => context.push('/notifications'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              RoleSectionHeader(
                title: 'المهام النشطة',
                subtitle: active.isEmpty
                    ? 'لا توجد رحلة تتطلب إجراء الآن'
                    : 'ابدأ بالأقدم وحدّث الحالة عند كل مرحلة',
                action: active.isEmpty
                    ? null
                    : TextButton(
                        onPressed: () => context.push('/supply-chain'),
                        child: const Text('عرض الكل'),
                      ),
              ),
              const SizedBox(height: 10),
              if (active.isEmpty)
                RoleNoticeCard(
                  title: 'أنت متاح لمهمة جديدة',
                  message:
                      'عند إسناد شحنة ستصلك عبر الإشعارات وتظهر في هذه الصفحة.',
                  icon: Icons.check_circle_outline_rounded,
                  color: AppColors.success,
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
                          onTap: () => context.push('/supply-chain'),
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
    final shipment = order.shipment!;
    return RoleNoticeCard(
      title: order.pharmacyName,
      message:
          '${shipment.shipmentCode} · ${order.pharmacyArea}، ${order.pharmacyCity} · ${_shipmentStatus(shipment.status)}',
      icon: _shipmentIcon(shipment.status),
      color: _shipmentColor(shipment.status),
      onTap: onTap,
    );
  }
}

bool _closed(String status) =>
    {'Delivered', 'Failed', 'Returned'}.contains(status);

String _shipmentStatus(String status) => switch (status) {
  'Assigned' => 'تم إسنادها',
  'Loading' => 'جاري التحميل',
  'OutForDelivery' => 'في الطريق',
  'Arrived' => 'وصلت للصيدلية',
  'Delivered' => 'تم التسليم',
  'Failed' => 'تعذر التسليم',
  'Returned' => 'أُعيدت للمستودع',
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

Color _shipmentColor(String status) => switch (status) {
  'Delivered' => AppColors.success,
  'Failed' || 'Returned' => AppColors.danger,
  'OutForDelivery' || 'Arrived' => const Color(0xFF3977C4),
  _ => AppColors.primary,
};
