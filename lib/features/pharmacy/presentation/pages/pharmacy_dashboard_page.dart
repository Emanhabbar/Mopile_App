import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/layout.dart';
import '../../../../core/widgets/app_reveal.dart';
import '../../../../core/widgets/async_states.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../dashboard/presentation/widgets/role_dashboard_widgets.dart';
import '../../data/models/pharmacy_models.dart';
import '../controllers/pharmacy_providers.dart';

class PharmacyDashboardPage extends ConsumerWidget {
  const PharmacyDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(pharmacyDashboardProvider);
    final openStatus = ref.watch(pharmacyOpenStatusProvider);
    return state.when(
      loading: () => AppLoadingState(label: l10n.dashboardPreparingPharmacy),
      error: (error, _) => AppErrorState(
        error: error,
        onRetry: () => ref.invalidate(pharmacyDashboardProvider),
      ),
      data: (data) => RefreshIndicator(
        onRefresh: () async {
          ref
            ..invalidate(pharmacyDashboardProvider)
            ..invalidate(pharmacyOpenStatusProvider);
          await Future.wait([
            ref.read(pharmacyDashboardProvider.future),
            ref.read(pharmacyOpenStatusProvider.future),
          ]);
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(20, 14, 20, kBottomNavReserved + 12),
              sliver: SliverList.list(
                children: [
                  AppReveal(
                    child: _PharmacyHero(
                      data: data,
                      openStatus: openStatus.valueOrNull,
                    ),
                  ),
                  const SizedBox(height: 22),
                  RoleSectionHeader(
                    title: l10n.pharmacyOperationsSection,
                    subtitle: l10n.pharmacyOperationsSectionSubtitle,
                  ),
                  const SizedBox(height: 11),
                  AppReveal(
                    delay: const Duration(milliseconds: 70),
                    child: _operations(context, data),
                  ),
                  const SizedBox(height: 24),
                  RoleSectionHeader(
                    title: l10n.quickOverviewSection,
                    subtitle: l10n.quickOverviewSectionSubtitle,
                  ),
                  const SizedBox(height: 11),
                  AppReveal(
                    delay: const Duration(milliseconds: 120),
                    child: _metrics(context, data),
                  ),
                  const SizedBox(height: 24),
                  AppReveal(
                    delay: const Duration(milliseconds: 160),
                    child: _ReadinessCard(
                      data: data,
                      onLocation: () => context.push('/pharmacy/profile'),
                      onHours: () => context.push('/pharmacy/working-hours'),
                      onInventory: () => context.go('/pharmacy/inventory'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  RoleSectionHeader(
                    title: l10n.inventoryAlertsSection,
                    subtitle: l10n.inventoryAlertsSectionSubtitle,
                    action: TextButton.icon(
                      onPressed: () => context.go('/pharmacy/inventory'),
                      icon: const Icon(Icons.arrow_back_rounded, size: 17),
                      label: Text(l10n.viewAll),
                    ),
                  ),
                  const SizedBox(height: 11),
                  if ([
                    ...data.lowStockItems,
                    ...data.expiringSoonItems,
                  ].isEmpty)
                    const _HealthyInventoryCard()
                  else
                    ...[...data.lowStockItems, ...data.expiringSoonItems]
                        .take(5)
                        .toList()
                        .asMap()
                        .entries
                        .map(
                          (entry) => Padding(
                            padding: const EdgeInsets.only(bottom: 9),
                            child: AppReveal(
                              delay: Duration(
                                milliseconds: 200 + (entry.key * 45),
                              ),
                              child: _InventoryAlertCard(
                                alert: entry.value,
                                onTap: () => context.go('/pharmacy/inventory'),
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    onPressed: () =>
                        context.push('/pharmacy/license-verification'),
                    icon: const Icon(Icons.badge_outlined),
                    label: Text(l10n.verifyPharmacyLicense),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: () => context.push('/pharmacy/prescriptions'),
                    icon: const Icon(Icons.receipt_long_rounded),
                    label: Text(l10n.managePrescriptions),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => context.push('/pharmacy/donations'),
                          icon: const Icon(Icons.verified_outlined),
                          label: Text(l10n.donationsLabel),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => context.push('/intelligence'),
                          icon: const Icon(Icons.auto_graph_rounded),
                          label: Text(l10n.analyzeInventory),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// اختصارات التشغيل السريع (تستخدم الويدجت المشتركة RoleActionsGrid
  /// لتتطابق مع لغة تصميم بقية الأدوار).
  Widget _operations(BuildContext context, PharmacyDashboard data) {
    final l10n = AppLocalizations.of(context);
    return RoleActionsGrid(
      items: [
        RoleActionData(
          title: l10n.inventoryLabel,
          subtitle: l10n.manageItems,
          icon: Icons.inventory_2_rounded,
          color: context.appColors.primary,
          onTap: () => context.go('/pharmacy/inventory'),
          badge: data.lowStockCount > 0
              ? l10n.lowStockCount(data.lowStockCount)
              : null,
        ),
        RoleActionData(
          title: l10n.ordersLabel,
          subtitle: l10n.followReplies,
          icon: Icons.assignment_rounded,
          color: context.appColors.primary,
          onTap: () => context.go('/pharmacy/requests'),
          badge: data.pendingRequestsCount > 0
              ? l10n.pendingRequestsBadge(data.pendingRequestsCount)
              : null,
        ),
        RoleActionData(
          title: l10n.workingHours,
          subtitle: l10n.organizeHours,
          icon: Icons.schedule_rounded,
          color: context.appColors.primary,
          onTap: () => context.push('/pharmacy/working-hours'),
        ),
        RoleActionData(
          title: l10n.pharmacyProfile,
          subtitle: l10n.locationAndData,
          icon: Icons.storefront_rounded,
          color: context.appColors.primary,
          onTap: () => context.push('/pharmacy/profile'),
        ),
      ],
    );
  }

  /// مؤشرات المخزون والطلبات (تستخدم الويدجت المشتركة RoleMetricsGrid).
  Widget _metrics(BuildContext context, PharmacyDashboard data) {
    final l10n = AppLocalizations.of(context);
    return RoleMetricsGrid(
      items: [
        RoleMetricData(
          label: l10n.inventoryItemsLabel,
          value: '${data.inventoryItemsCount}',
          icon: Icons.medication_rounded,
          color: context.appColors.primary,
        ),
        RoleMetricData(
          label: l10n.availableLabel,
          value: '${data.inStockCount}',
          icon: Icons.check_circle_rounded,
          color: context.appColors.primary,
        ),
        RoleMetricData(
          label: l10n.lowStockLabel,
          value: '${data.lowStockCount}',
          icon: Icons.warning_amber_rounded,
          color: context.appColors.primary,
        ),
        RoleMetricData(
          label: l10n.outOfStockLabel,
          value: '${data.outOfStockCount}',
          icon: Icons.remove_circle_outline_rounded,
          color: context.appColors.primary,
        ),
      ],
    );
  }
}

/// Hero الصيدلية: تصميم نظيف بأسلوب موحّد مع RoleDashboardHero
/// (لون ثابت + حدود) مع الحفاظ على المحتوى الحيوي الخاص بالصيدلي.
class _PharmacyHero extends StatelessWidget {
  const _PharmacyHero({required this.data, this.openStatus});

  final PharmacyDashboard data;
  final PharmacyOpenStatus? openStatus;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isOpen = openStatus?.isOpenNow ?? data.isOpenNow;
    final status = openStatus?.statusText.isNotEmpty == true
        ? openStatus!.statusText
        : data.statusText.isNotEmpty
        ? data.statusText
        : isOpen
        ? l10n.openNow
        : l10n.closedNow;
    final location = [
      data.area,
      data.city,
    ].where((part) => part.trim().isNotEmpty).join('، ');

    return Container(
      decoration: BoxDecoration(
        color: context.appColors.primary,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: context.appColors.primaryLight.withValues(alpha: 0.25),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(21),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    Icons.local_pharmacy_rounded,
                    color: context.appColors.primaryLight,
                    size: 28,
                  ),
                ),
                const Spacer(),
                _StatusPill(
                  text: status,
                  icon: isOpen
                      ? Icons.circle_rounded
                      : Icons.schedule_rounded,
                  color: isOpen
                      ? context.appColors.primaryLight
                      : Colors.white70,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    data.pharmacyName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(width: 10),
                Icon(
                  data.isApproved
                      ? Icons.verified_rounded
                      : Icons.hourglass_top_rounded,
                  color: context.appColors.primaryLight,
                  size: 26,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  data.hasLocation
                      ? Icons.location_on_rounded
                      : Icons.location_off_rounded,
                  color: Colors.white.withValues(alpha: 0.7),
                  size: 19,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    data.hasLocation && location.isNotEmpty
                        ? location
                        : l10n.addPharmacyLocation,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _CompletionProgress(value: data.profileCompletionPercentage),
            const SizedBox(height: 15),
            Row(
              children: [
                _HeroMetric(
                  icon: Icons.star_rounded,
                  label: l10n.ratingLabel,
                  value: data.ratingsCount == 0
                      ? l10n.newLabel
                      : data.averageRating.toStringAsFixed(1),
                ),
                const SizedBox(width: 10),
                _HeroMetric(
                  icon: Icons.assignment_rounded,
                  label: l10n.activeRequests,
                  value: '${data.activeRequestsCount}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// بطاقة جاهزية الصيدلية (محتوى خاص قيّم) — حافظنا عليها بتصميم منسجم
/// مع لغة الويدجتات المشتركة (radius 24 = AppRadius.card).
class _ReadinessCard extends StatelessWidget {
  const _ReadinessCard({
    required this.data,
    required this.onLocation,
    required this.onHours,
    required this.onInventory,
  });

  final PharmacyDashboard data;
  final VoidCallback onLocation;
  final VoidCallback onHours;
  final VoidCallback onInventory;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final steps = [
      (
        data.isApproved,
        l10n.approvePharmacyAccount,
        data.isApproved ? l10n.completedLabel : l10n.pendingReview,
        null,
      ),
      (
        data.hasLocation,
        l10n.pharmacyLocationTitle,
        data.hasLocation ? l10n.locationSet : l10n.requiredToAppear,
        onLocation,
      ),
      (
        data.hasWorkingHoursConfigured,
        l10n.workingHours,
        data.hasWorkingHoursConfigured ? l10n.hoursConfigured : l10n.setWorkingHours,
        onHours,
      ),
      (
        data.inventoryItemsCount > 0,
        l10n.inventoryTitle,
        data.inventoryItemsCount > 0
            ? l10n.inventoryItemsCountValue(data.inventoryItemsCount)
            : l10n.addFirstMedicine,
        onInventory,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: context.appColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: context.appColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  Icons.fact_check_rounded,
                  color: context.appColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.pharmacyReadiness,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      l10n.profileCompletionValue(data.profileCompletionPercentage),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: data.profileCompletionPercentage.clamp(0, 100) / 100,
              minHeight: 7,
              backgroundColor: context.appColors.surfaceSoft,
              color: context.appColors.primary,
            ),
          ),
          const SizedBox(height: 14),
          ...steps.map(
            (step) => _ReadinessStep(
              complete: step.$1,
              title: step.$2,
              subtitle: step.$3,
              onTap: step.$1 ? null : step.$4,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadinessStep extends StatelessWidget {
  const _ReadinessStep({
    required this.complete,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final bool complete;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Icon(
                complete
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: complete
                    ? context.appColors.primary
                    : context.appColors.textMuted,
                size: 22,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                Icon(
                  Icons.chevron_left_rounded,
                  color: context.appColors.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// تنبيه المخزون — تصميم نظيف بأسلوب موحّد مع البطاقات المشتركة.
class _InventoryAlertCard extends StatelessWidget {
  const _InventoryAlertCard({required this.alert, required this.onTap});

  final PharmacyInventoryAlert alert;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final expiring = alert.alertType.toLowerCase().contains('expir');
    final color =
        expiring ? context.appColors.danger : context.appColors.warning;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.appColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  expiring
                      ? Icons.event_busy_rounded
                      : Icons.warning_amber_rounded,
                  color: color,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alert.medicineName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      alert.daysUntilExpiry == null
                          ? l10n.inventoryAlertLowStock(
                              alert.quantity, alert.lowStockThreshold)
                          : l10n.inventoryAlertExpiry(alert.daysUntilExpiry!),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_left_rounded, color: color),
            ],
          ),
        ),
      ),
    );
  }
}

class _HealthyInventoryCard extends StatelessWidget {
  const _HealthyInventoryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appColors.primary.withValues(alpha: 0.065),
        borderRadius: BorderRadius.circular(21),
        border: Border.all(
          color: context.appColors.primary.withValues(alpha: 0.14),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.task_alt_rounded, color: context.appColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              AppLocalizations.of(context).inventoryHealthy,
              style: TextStyle(
                color: context.appColors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.text,
    required this.icon,
    required this.color,
  });

  final String text;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 11),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompletionProgress extends StatelessWidget {
  const _CompletionProgress({required this.value});

  final int value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: value.clamp(0, 100) / 100,
              minHeight: 6,
              color: context.appColors.primaryLight,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          AppLocalizations.of(context).profileCompletionLabel(value),
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.72),
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.075),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Row(
          children: [
            Icon(icon, color: context.appColors.primaryLight, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.55),
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    value,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
