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
      loading: () => AppLoadingState(
        label: l10n.orgHomeLoading,
      ),
      error: (error, _) => AppErrorState(
        error: error,
        onRetry: () => ref.invalidate(
          organizationDashboardProvider,
        ),
      ),
      data: (data) => RefreshIndicator(
        onRefresh: () => ref.refresh(
          organizationDashboardProvider.future,
        ),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            20,
            14,
            20,
            kBottomNavReserved + 12,
          ),
          children: [
            // ==============================================================
            // HERO
            // ==============================================================

            _OrganizationHero(
              organizationName: data.organizationName,
              isApproved: data.isApproved,
              verificationStatus: data.verificationStatus,
            ),

            const SizedBox(height: 30),

            // ==============================================================
            // IMPACT
            // ==============================================================

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

            const SizedBox(height: 32),

            // ==============================================================
            // WORK MANAGEMENT
            // ==============================================================

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
                  onTap: () => context.go(
                    '/organization/workspace?section=campaigns',
                  ),
                ),
                RoleActionData(
                  title: l10n.donationOffersTitle,
                  subtitle: l10n.reviewOfferedMedicines,
                  badge: data.pendingDonationOffersCount > 0
                      ? '${data.pendingDonationOffersCount}'
                      : null,
                  icon: Icons.volunteer_activism_outlined,
                  color: context.appColors.primary,
                  onTap: () => context.go(
                    '/organization/workspace?section=donations',
                  ),
                ),
                RoleActionData(
                  title: l10n.assistanceRequestsTitle,
                  subtitle: l10n.followCasesAndRespond,
                  badge: data.openAssistanceRequestsCount > 0
                      ? '${data.openAssistanceRequestsCount}'
                      : null,
                  icon: Icons.support_agent_rounded,
                  color: context.appColors.primary,
                  onTap: () => context.go(
                    '/organization/workspace?section=assistance',
                  ),
                ),
                RoleActionData(
                  title: l10n.orgProfile,
                  subtitle: l10n.dataAndVerificationDocs,
                  icon: Icons.verified_user_outlined,
                  color: context.appColors.primary,
                  onTap: () => context.go(
                    '/organization/workspace?section=profile',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // ==============================================================
            // VERIFICATION
            // ==============================================================

            RoleNoticeCard(
              title: l10n.verificationStatusTitle,
              message: data.verificationDocumentsCount > 0
                  ? l10n.verificationDocsCount(
                      _verificationLabel(
                        l10n,
                        data.verificationStatus,
                      ),
                      data.verificationDocumentsCount,
                    )
                  : l10n.completeVerificationDocs,
              icon: data.verificationDocumentsCount > 0
                  ? Icons.verified_outlined
                  : Icons.upload_file_outlined,
              color: data.isApproved
                  ? context.appColors.primary
                  : context.appColors.warning,
              onTap: () => context.go(
                '/organization/workspace?section=profile',
              ),
            ),

            // ==============================================================
            // RECENT CAMPAIGNS
            // ==============================================================

            if (data.recentCampaigns.isNotEmpty) ...[
              const SizedBox(height: 28),

              RoleSectionHeader(
                title: l10n.recentCampaigns,
                subtitle: l10n.recentCampaignsAddedSubtitle,
                action: TextButton(
                  onPressed: () => context.go(
                    '/organization/workspace?section=campaigns',
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(l10n.viewAll),
                      const SizedBox(width: 5),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 20,
                        color: context.appColors.primary,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 11),

              ...data.recentCampaigns.take(3).map(
                (campaign) => Padding(
                  padding: const EdgeInsets.only(
                    bottom: 9,
                  ),
                  child: RoleNoticeCard(
                    title: campaign.title,
                    message:
                        '${_campaignStatus(l10n, campaign.status)}'
                        '${campaign.area == null ? '' : ' · ${campaign.area}'}',
                    icon: campaign.isUrgent
                        ? Icons.priority_high_rounded
                        : Icons.campaign_outlined,
                    color: campaign.isUrgent
                        ? context.appColors.warning
                        : context.appColors.primary,
                    onTap: () => context.go(
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

// ============================================================================
// ORGANIZATION HERO
// ============================================================================

class _OrganizationHero extends StatelessWidget {
  const _OrganizationHero({
    required this.organizationName,
    required this.isApproved,
    required this.verificationStatus,
  });

  final String organizationName;
  final bool isApproved;
  final String verificationStatus;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final verificationLabel = _verificationLabel(
      l10n,
      verificationStatus,
    );

    final statusText = isApproved
        ? l10n.verifiedBadge(verificationLabel)
        : l10n.accountPendingApproval;

    final statusColor = isApproved
        ? Colors.amber
        : Colors.white70;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: context.appColors.primary,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: context.appColors.primaryLight.withValues(
            alpha: 0.25,
          ),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================================================================
          // TOP ROW
          // ================================================================

          Row(
            children: [
              // ICON
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(
                    alpha: 0.10,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  Icons.volunteer_activism_rounded,
                  color: context.appColors.primaryLight,
                  size: 28,
                ),
              ),

              const Spacer(),

              // STATUS
              Container(
                constraints: const BoxConstraints(
                  maxWidth: 130,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(
                    alpha: 0.12,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: statusColor.withValues(
                      alpha: 0.16,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isApproved
                          ? Icons.verified_rounded
                          : Icons.schedule_rounded,
                      color: statusColor,
                      size: 11,
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        statusText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ================================================================
          // ORGANIZATION NAME
          // ================================================================

          Row(
            children: [
              Expanded(
                child: Text(
                  organizationName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),

              const SizedBox(width: 10),

              if (isApproved)
                Icon(
                  Icons.verified_rounded,
                  color: context.appColors.primaryLight,
                  size: 26,
                ),
            ],
          ),

          const SizedBox(height: 8),

          // ================================================================
          // SUBTITLE
          // بدون أيقونة التبرع
          // ================================================================

          Text(
            l10n.orgHeroSubtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withValues(
                alpha: 0.78,
              ),
              fontWeight: FontWeight.w600,
              fontSize: 13,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// VERIFICATION STATUS
// ============================================================================

String _verificationLabel(
  AppLocalizations l10n,
  String status,
) =>
    switch (status.toLowerCase()) {
      'verified' || 'approved' => l10n.verifiedShort,
      'pending' || 'underreview' => l10n.underReviewShort,
      'needsupdate' => l10n.needsUpdate,
      'rejected' => l10n.notApproved,
      _ => l10n.verificationStatusUnknown,
    };

// ============================================================================
// CAMPAIGN STATUS
// ============================================================================

String _campaignStatus(
  AppLocalizations l10n,
  String status,
) =>
    switch (status.toLowerCase()) {
      'active' => l10n.campaignActive,
      'draft' => l10n.campaignDraft,
      'paused' => l10n.campaignPaused,
      'completed' => l10n.campaignCompleted,
      'cancelled' => l10n.campaignCancelled,
      _ => status,
    };