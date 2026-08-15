import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/async_states.dart';
import '../../../dashboard/presentation/widgets/home_ticker_panel.dart';
import '../../../dashboard/presentation/widgets/role_dashboard_widgets.dart';
import '../../data/models/admin_models.dart';
import '../controllers/admin_providers.dart';

class AdminHomePage extends ConsumerWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminDashboardProvider);
    return state.when(
      loading: () => const AppLoadingState(label: 'نجهّز مؤشرات المنصة...'),
      error: (error, _) => AppErrorState(
        error: error,
        onRetry: () => ref.invalidate(adminDashboardProvider),
      ),
      data: (data) {
        final pendingApprovals =
            data.pendingPharmacies +
            data.pendingOrganizations +
            data.pendingWarehouses +
            data.pendingOrganizationVerifications;
        return RefreshIndicator(
          onRefresh: () => ref.refresh(adminDashboardProvider.future),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 112),
            children: [
              RoleDashboardHero(
                title: 'منصة واضحة تحت إدارتك',
                subtitle:
                    'تابع الاعتمادات والحسابات ونشاط المنصة من نقطة واحدة.',
                icon: Icons.admin_panel_settings_rounded,
                accent: context.appColors.primaryDark,
                badge: pendingApprovals > 0
                    ? '$pendingApprovals عناصر بانتظار المراجعة'
                    : 'جميع المراجعات محدثة',
              ),
              const SizedBox(height: 22),
              const RoleSectionHeader(
                title: 'نظرة المنصة',
                subtitle: 'إحصاءات مباشرة من قاعدة البيانات',
              ),
              const SizedBox(height: 11),
              RoleMetricsGrid(
                items: [
                  RoleMetricData(
                    label: 'المستخدمون',
                    value: '${data.totalUsers}',
                    caption: '${data.activeUsers} نشط',
                    icon: Icons.people_alt_rounded,
                    color: context.appColors.primary,
                  ),
                  RoleMetricData(
                    label: 'الصيدليات',
                    value: '${data.totalPharmacies}',
                    caption: '${data.pendingPharmacies} معلقة',
                    icon: Icons.local_pharmacy_rounded,
                    color: context.appColors.primaryDeep,
                  ),
                  RoleMetricData(
                    label: 'المنظمات',
                    value: '${data.totalOrganizations}',
                    caption: '${data.pendingOrganizations} معلقة',
                    icon: Icons.apartment_rounded,
                    color: context.appColors.primaryDark,
                  ),
                  RoleMetricData(
                    label: 'المستودعات',
                    value: '${data.totalWarehouses}',
                    caption: '${data.approvedWarehouses} معتمد',
                    icon: Icons.warehouse_rounded,
                    color: context.appColors.primary,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _AiServicesCard(
                state: ref.watch(adminAiServicesHealthProvider),
                onRefresh: () => ref.invalidate(adminAiServicesHealthProvider),
              ),
              const SizedBox(height: 24),
              const RoleSectionHeader(
                title: 'مركز التحكم',
                subtitle: 'انتقل مباشرة إلى العملية المطلوبة',
              ),
              const SizedBox(height: 11),
              RoleActionsGrid(
                items: [
                  RoleActionData(
                    title: 'الموافقات',
                    subtitle: 'صيدليات ومنظمات ومستودعات',
                    badge: pendingApprovals > 0 ? '$pendingApprovals' : null,
                    icon: Icons.fact_check_rounded,
                    color: context.appColors.primary,
                    onTap: () =>
                        context.go('/admin/workspace?section=approvals'),
                  ),
                  RoleActionData(
                    title: 'الحسابات',
                    subtitle: 'متابعة الحالة والصلاحية',
                    icon: Icons.manage_accounts_rounded,
                    color: context.appColors.primaryDeep,
                    onTap: () =>
                        context.go('/admin/workspace?section=accounts'),
                  ),
                  RoleActionData(
                    title: 'شريط المنصة',
                    subtitle: 'الإعلانات والصيدليات المناوبة',
                    icon: Icons.campaign_rounded,
                    color: context.appColors.primaryDark,
                    onTap: () =>
                        context.go('/admin/workspace?section=ticker'),
                  ),
                  RoleActionData(
                    title: 'دليل الأدوية',
                    subtitle: 'مراجعة وإضافة بيانات الدواء',
                    icon: Icons.medication_rounded,
                    color: context.appColors.primary,
                    onTap: () => context.go('/medicines'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              RoleNoticeCard(
                title: 'العمليات المفتوحة',
                message:
                    '${data.pendingMedicineRequests} طلب دواء معلق · ${data.openAssistanceRequests} طلب مساعدة مفتوح · ${data.totalDonationOffers} عروض تبرع',
                icon: Icons.monitor_heart_outlined,
                color: pendingApprovals > 0
                    ? context.appColors.primaryDark
                    : context.appColors.success,
                onTap: () => context.go('/admin/workspace'),
              ),
              const SizedBox(height: 14),
              const HomeTickerPanel(),
            ],
          ),
        );
      },
    );
  }
}

class _AiServicesCard extends StatelessWidget {
  const _AiServicesCard({required this.state, required this.onRefresh});
  final AsyncValue<AdminAiServicesHealth> state;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: context.appColors.surface,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: context.appColors.border),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.hub_rounded, color: context.appColors.primary),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  'خدمات المعالجة الذكية',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                onPressed: onRefresh,
                tooltip: 'تحديث الحالة',
                icon: const Icon(Icons.refresh_rounded, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 10),
          state.when(
            loading: () => const LinearProgressIndicator(minHeight: 3),
            error: (_, _) => Text(
              'تعذر قراءة حالة الخدمات حالياً.',
              style: TextStyle(color: context.appColors.danger, fontSize: 12),
            ),
            data: (health) => Column(
              children: [
                _service(context, 'مراجعة التراخيص', health.licenseVerification),
                _service(context, 'البحث الدوائي', health.drugSearch),
                _service(context, 'المساعد الدوائي', health.smartPharmacyBot),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget _service(BuildContext context, String label, AdminAiServiceStatus status) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      children: [
        Icon(
          status.available ? Icons.check_circle_rounded : Icons.error_rounded,
          color: status.available ? context.appColors.primary : context.appColors.primaryDark,
          size: 18,
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 12))),
        Text(
          status.available ? 'يعمل' : 'غير متاح',
          style: TextStyle(
            color: status.available ? context.appColors.primary : context.appColors.primaryDark,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}
