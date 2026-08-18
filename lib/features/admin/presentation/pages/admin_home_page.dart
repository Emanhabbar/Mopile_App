import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/async_states.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../dashboard/presentation/widgets/home_ticker_panel.dart';
import '../../../dashboard/presentation/widgets/role_dashboard_widgets.dart';
import '../../data/models/admin_models.dart';
import '../controllers/admin_providers.dart';

class AdminHomePage extends ConsumerWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(adminDashboardProvider);
    return state.when(
      loading: () => AppLoadingState(label: l10n.adminLoadingIndicators),
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
                title: l10n.adminHeroTitle,
                subtitle: l10n.adminHeroDescription,
                icon: Icons.admin_panel_settings_rounded,
                accent: context.appColors.primaryDark,
                badge: pendingApprovals > 0
                    ? l10n.adminPendingReviewCount(pendingApprovals)
                    : l10n.adminReviewsUpToDate,
              ),
              const SizedBox(height: 22),
              RoleSectionHeader(
                title: l10n.adminOverviewTitle,
                subtitle: l10n.adminOverviewLiveSubtitle,
              ),
              const SizedBox(height: 11),
              RoleMetricsGrid(
                items: [
                  RoleMetricData(
                    label: l10n.adminUsers,
                    value: '${data.totalUsers}',
                    caption: '${data.activeUsers} ${l10n.adminActive}',
                    icon: Icons.people_alt_rounded,
                    color: context.appColors.primary,
                  ),
                  RoleMetricData(
                    label: l10n.adminPharmacies,
                    value: '${data.totalPharmacies}',
                    caption: '${data.pendingPharmacies} ${l10n.statusPending}',
                    icon: Icons.local_pharmacy_rounded,
                    color: context.appColors.primary,
                  ),
                  RoleMetricData(
                    label: l10n.adminOrganizations,
                    value: '${data.totalOrganizations}',
                    caption:
                        '${data.pendingOrganizations} ${l10n.statusPending}',
                    icon: Icons.apartment_rounded,
                    color: context.appColors.primary,
                  ),
                  RoleMetricData(
                    label: l10n.adminWarehouses,
                    value: '${data.totalWarehouses}',
                    caption: '${data.approvedWarehouses} ${l10n.adminApprovedShort}',
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
              RoleSectionHeader(
                title: l10n.adminControlCenter,
                subtitle: l10n.adminControlCenterSubtitle,
              ),
              const SizedBox(height: 11),
              RoleActionsGrid(
                items: [
                  RoleActionData(
                    title: l10n.adminSectionApprovals,
                    subtitle: l10n.adminApprovalsActionSubtitle,
                    badge: pendingApprovals > 0 ? '$pendingApprovals' : null,
                    icon: Icons.fact_check_rounded,
                    color: context.appColors.primary,
                    onTap: () =>
                        context.go('/admin/workspace?section=approvals'),
                  ),
                  RoleActionData(
                    title: l10n.adminSectionAccounts,
                    subtitle: l10n.adminAccountsActionSubtitle,
                    icon: Icons.manage_accounts_rounded,
                    color: context.appColors.primary,
                    onTap: () =>
                        context.go('/admin/workspace?section=accounts'),
                  ),
                  RoleActionData(
                    title: l10n.adminPlatformBar,
                    subtitle: l10n.adminPlatformBarSubtitle,
                    icon: Icons.campaign_rounded,
                    color: context.appColors.primary,
                    onTap: () =>
                        context.go('/admin/workspace?section=ticker'),
                  ),
                  RoleActionData(
                    title: l10n.adminMedicineGuide,
                    subtitle: l10n.adminMedicineGuideSubtitle,
                    icon: Icons.medication_rounded,
                    color: context.appColors.primary,
                    onTap: () => context.go('/medicines'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              RoleNoticeCard(
                title: l10n.adminOpenOperations,
                message: l10n.adminOpenOperationsMessage(
                  data.pendingMedicineRequests,
                  data.openAssistanceRequests,
                  data.totalDonationOffers,
                ),
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
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
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
                    l10n.adminAiServices,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  onPressed: onRefresh,
                  tooltip: l10n.adminRefreshStatus,
                  icon: const Icon(Icons.refresh_rounded, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 10),
            state.when(
              loading: () => const LinearProgressIndicator(minHeight: 3),
              error: (_, _) => Text(
                l10n.adminAiHealthReadFailed,
                style: TextStyle(color: context.appColors.danger, fontSize: 12),
              ),
              data: (health) => Column(
                children: [
                  _service(context, l10n, l10n.adminReviewLicense, health.licenseVerification),
                  _service(context, l10n, l10n.adminAiDrugSearch, health.drugSearch),
                  _service(context, l10n, l10n.pharmacyAssistant, health.smartPharmacyBot),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _service(BuildContext context, AppLocalizations l10n, String label, AdminAiServiceStatus status) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      children: [
        Icon(
          status.available ? Icons.check_circle_rounded : Icons.error_rounded,
          color: context.appColors.primary,
          size: 18,
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 12))),
        Text(
          status.available ? l10n.adminAiWorking : l10n.notAvailable,
          style: TextStyle(
            color: context.appColors.primary,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}
