import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/async_states.dart';
import '../../../dashboard/presentation/widgets/role_dashboard_widgets.dart';
import '../controllers/organization_providers.dart';

class OrganizationHomePage extends ConsumerWidget {
  const OrganizationHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(organizationDashboardProvider);
    return state.when(
      loading: () => const AppLoadingState(label: 'نجهّز مساحة المنظمة...'),
      error: (error, _) => AppErrorState(
        error: error,
        onRetry: () => ref.invalidate(organizationDashboardProvider),
      ),
      data: (data) => RefreshIndicator(
        onRefresh: () => ref.refresh(organizationDashboardProvider.future),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 112),
          children: [
            RoleDashboardHero(
              title: data.organizationName,
              subtitle: 'تابع أثر حملاتك واستجابتك لاحتياجات المستفيدين بوضوح.',
              icon: Icons.volunteer_activism_rounded,
              accent: const Color(0xFF286C64),
              badge: data.isApproved
                  ? 'منظمة معتمدة · ${_verificationLabel(data.verificationStatus)}'
                  : 'الحساب بانتظار الاعتماد',
            ),
            const SizedBox(height: 22),
            const RoleSectionHeader(
              title: 'أثر المنظمة',
              subtitle: 'مؤشرات الحملات والطلبات الحالية',
            ),
            const SizedBox(height: 11),
            RoleMetricsGrid(
              items: [
                RoleMetricData(
                  label: 'إجمالي الحملات',
                  value: '${data.totalCampaignsCount}',
                  icon: Icons.campaign_rounded,
                  color: context.appColors.primary,
                ),
                RoleMetricData(
                  label: 'حملات نشطة',
                  value: '${data.activeCampaignsCount}',
                  icon: Icons.track_changes_rounded,
                  color: context.appColors.primary,
                ),
                RoleMetricData(
                  label: 'عروض بانتظارك',
                  value: '${data.pendingDonationOffersCount}',
                  icon: Icons.inventory_2_outlined,
                  color: context.appColors.primaryDeep,
                ),
                RoleMetricData(
                  label: 'طلبات مساعدة',
                  value: '${data.openAssistanceRequestsCount}',
                  icon: Icons.support_agent_rounded,
                  color: context.appColors.primaryDark,
                ),
              ],
            ),
            const SizedBox(height: 24),
            const RoleSectionHeader(
              title: 'إدارة العمل',
              subtitle: 'كل مسار يفتح في قسمه مباشرة',
            ),
            const SizedBox(height: 11),
            RoleActionsGrid(
              items: [
                RoleActionData(
                  title: 'الحملات',
                  subtitle: 'إنشاء وتحديث حالة الحملات',
                  badge: data.activeCampaignsCount > 0
                      ? '${data.activeCampaignsCount}'
                      : null,
                  icon: Icons.campaign_outlined,
                  color: context.appColors.primary,
                  onTap: () =>
                      context.go('/organization/workspace?section=campaigns'),
                ),
                RoleActionData(
                  title: 'عروض التبرع',
                  subtitle: 'مراجعة الأدوية المعروضة',
                  badge: data.pendingDonationOffersCount > 0
                      ? '${data.pendingDonationOffersCount}'
                      : null,
                  icon: Icons.volunteer_activism_outlined,
                  color: context.appColors.primaryDeep,
                  onTap: () =>
                      context.go('/organization/workspace?section=donations'),
                ),
                RoleActionData(
                  title: 'طلبات المساعدة',
                  subtitle: 'متابعة الحالات والاستجابة لها',
                  badge: data.openAssistanceRequestsCount > 0
                      ? '${data.openAssistanceRequestsCount}'
                      : null,
                  icon: Icons.support_agent_rounded,
                  color: context.appColors.primaryDark,
                  onTap: () => context.push(
                    '/organization/workspace?section=assistance',
                  ),
                ),
                RoleActionData(
                  title: 'ملف المنظمة',
                  subtitle: 'البيانات ووثائق التحقق',
                  icon: Icons.verified_user_outlined,
                  color: context.appColors.primary,
                  onTap: () =>
                      context.go('/organization/workspace?section=profile'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            RoleNoticeCard(
              title: 'حالة التحقق',
              message: data.verificationDocumentsCount > 0
                  ? '${_verificationLabel(data.verificationStatus)} · ${data.verificationDocumentsCount} وثائق مرفوعة'
                  : 'أكمل وثائق التحقق لتعزيز موثوقية المنظمة.',
              icon: data.verificationDocumentsCount > 0
                  ? Icons.verified_outlined
                  : Icons.upload_file_outlined,
              color: data.isApproved
                  ? context.appColors.primary
                  : context.appColors.primaryDark,
              onTap: () =>
                  context.go('/organization/workspace?section=profile'),
            ),
            if (data.recentCampaigns.isNotEmpty) ...[
              const SizedBox(height: 24),
              RoleSectionHeader(
                title: 'أحدث الحملات',
                subtitle: 'آخر المبادرات المضافة إلى حساب المنظمة',
                action: TextButton(
                  onPressed: () =>
                      context.go('/organization/workspace?section=campaigns'),
                  child: const Text('عرض الكل'),
                ),
              ),
              const SizedBox(height: 10),
              ...data.recentCampaigns
                  .take(3)
                  .map(
                    (campaign) => Padding(
                      padding: const EdgeInsets.only(bottom: 9),
                      child: RoleNoticeCard(
                        title: campaign.title,
                        message:
                            '${_campaignStatus(campaign.status)}${campaign.area == null ? '' : ' · ${campaign.area}'}',
                        icon: campaign.isUrgent
                            ? Icons.priority_high_rounded
                            : Icons.campaign_outlined,
                        color: campaign.isUrgent
                            ? context.appColors.primaryDark
                            : context.appColors.primary,
                        onTap: () => context.push(
                          '/organization/workspace?section=campaigns',
                        ),
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

String _verificationLabel(String status) => switch (status.toLowerCase()) {
  'verified' || 'approved' => 'موثقة',
  'pending' || 'underreview' => 'قيد المراجعة',
  'needsupdate' => 'تحتاج تحديثاً',
  'rejected' => 'غير معتمدة',
  _ => 'حالة التحقق غير محددة',
};

String _campaignStatus(String status) => switch (status.toLowerCase()) {
  'active' => 'نشطة',
  'draft' => 'مسودة',
  'paused' => 'متوقفة مؤقتاً',
  'completed' => 'مكتملة',
  'cancelled' => 'ملغاة',
  _ => status,
};
