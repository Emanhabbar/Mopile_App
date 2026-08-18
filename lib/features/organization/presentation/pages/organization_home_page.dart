import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/layout.dart';
import '../../../../core/widgets/async_states.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../dashboard/presentation/widgets/role_dashboard_widgets.dart';
import '../controllers/organization_providers.dart';

class OrganizationHomePage extends ConsumerWidget {
  const OrganizationHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(organizationDashboardProvider);
    return state.when(
      loading: () => AppLoadingState(label: l10n.orgHomeLoading),
      error: (error, _) => AppErrorState(
        error: error,
        onRetry: () => ref.invalidate(organizationDashboardProvider),
      ),
      data: (data) => RefreshIndicator(
        onRefresh: () => ref.refresh(organizationDashboardProvider.future),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(20, 14, 20, kBottomNavReserved + 12),
          children: [
            RoleDashboardHero(
              title: data.organizationName,
              subtitle: l10n.orgHeroSubtitle,
              icon: Icons.volunteer_activism_rounded,
              accent: context.appColors.primary,
              badge: data.isApproved
                  ? l10n.verifiedBadge(_verificationLabel(l10n, data.verificationStatus))
                  : l10n.accountPendingApproval,
            ),
            const SizedBox(height: 22),
            RoleSectionHeader(
              title: l10n.orgImpactSection,
              subtitle: l10n.orgImpactSectionSubtitle,
            ),
            const SizedBox(height: 11),
            RoleMetricsGrid(
              items: [
                RoleMetricData(
                  label: l10n.totalCampaigns,
                  value: '${data.totalCampaignsCount}',
                  icon: Icons.campaign_rounded,
                  color: context.appColors.primary,
                ),
                RoleMetricData(
                  label: l10n.activeCampaigns,
                  value: '${data.activeCampaignsCount}',
                  icon: Icons.track_changes_rounded,
                  color: context.appColors.primary,
                ),
                RoleMetricData(
                  label: l10n.offersWaiting,
                  value: '${data.pendingDonationOffersCount}',
                  icon: Icons.inventory_2_outlined,
                  color: context.appColors.primary,
                ),
                RoleMetricData(
                  label: l10n.assistanceRequests,
                  value: '${data.openAssistanceRequestsCount}',
                  icon: Icons.support_agent_rounded,
                  color: context.appColors.primary,
                ),
              ],
            ),
            const SizedBox(height: 24),
            RoleSectionHeader(
              title: l10n.workManagement,
              subtitle: l10n.workManagementSubtitle,
            ),
            const SizedBox(height: 11),
            RoleActionsGrid(
              items: [
                RoleActionData(
                  title: l10n.campaignsLabel,
                  subtitle: l10n.createUpdateCampaigns,
                  badge: data.activeCampaignsCount > 0
                      ? '${data.activeCampaignsCount}'
                      : null,
                  icon: Icons.campaign_outlined,
                  color: context.appColors.primary,
                  onTap: () =>
                      context.go('/organization/workspace?section=campaigns'),
                ),
                RoleActionData(
                  title: l10n.donationOffersTitle,
                  subtitle: l10n.reviewOfferedMedicines,
                  badge: data.pendingDonationOffersCount > 0
                      ? '${data.pendingDonationOffersCount}'
                      : null,
                  icon: Icons.volunteer_activism_outlined,
                  color: context.appColors.primary,
                  onTap: () =>
                      context.go('/organization/workspace?section=donations'),
                ),
                RoleActionData(
                  title: l10n.assistanceRequestsTitle,
                  subtitle: l10n.followCasesAndRespond,
                  badge: data.openAssistanceRequestsCount > 0
                      ? '${data.openAssistanceRequestsCount}'
                      : null,
                  icon: Icons.support_agent_rounded,
                  color: context.appColors.primary,
                  onTap: () => context.push(
                    '/organization/workspace?section=assistance',
                  ),
                ),
                RoleActionData(
                  title: l10n.orgProfile,
                  subtitle: l10n.dataAndVerificationDocs,
                  icon: Icons.verified_user_outlined,
                  color: context.appColors.primary,
                  onTap: () =>
                      context.go('/organization/workspace?section=profile'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            RoleNoticeCard(
              title: l10n.verificationStatusTitle,
              message: data.verificationDocumentsCount > 0
                  ? l10n.verificationDocsCount(
                      _verificationLabel(l10n, data.verificationStatus),
                      data.verificationDocumentsCount,
                    )
                  : l10n.completeVerificationDocs,
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
                title: l10n.recentCampaigns,
                subtitle: l10n.recentCampaignsAddedSubtitle,
                action: TextButton(
                  onPressed: () =>
                      context.go('/organization/workspace?section=campaigns'),
                  child: Text(l10n.viewAll),
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
                            '${_campaignStatus(l10n, campaign.status)}${campaign.area == null ? '' : ' · ${campaign.area}'}',
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

String _verificationLabel(AppLocalizations l10n, String status) =>
    switch (status.toLowerCase()) {
      'verified' || 'approved' => l10n.verifiedShort,
      'pending' || 'underreview' => l10n.underReviewShort,
      'needsupdate' => l10n.needsUpdate,
      'rejected' => l10n.notApproved,
      _ => l10n.verificationStatusUnknown,
    };

String _campaignStatus(AppLocalizations l10n, String status) =>
    switch (status.toLowerCase()) {
      'active' => l10n.campaignActive,
      'draft' => l10n.campaignDraft,
      'paused' => l10n.campaignPaused,
      'completed' => l10n.campaignCompleted,
      'cancelled' => l10n.campaignCancelled,
      _ => status,
    };
