import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/constants/demo_flags.dart';
import '../../../../core/widgets/app_reveal.dart';
import '../../../../core/widgets/async_states.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../auth/data/models/auth_session.dart';
import '../../../dashboard/presentation/controllers/home_ticker_provider.dart';
import '../../../dashboard/presentation/widgets/home_ticker_panel.dart';
import '../../../dashboard/presentation/widgets/role_dashboard_widgets.dart';
import '../../data/models/user_models.dart';
import '../controllers/user_providers.dart';
import '../widgets/user_dashboard_demo.dart';

class UserDashboardPage extends ConsumerWidget {
  const UserDashboardPage({
    required this.user,
    super.key,
  });

  final AuthUser user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (kScreenshotDemo) {
      return const UserDashboardDemo();
    }

    final dashboard = ref.watch(userDashboardProvider);

    return dashboard.when(
      loading: () => AppLoadingState(
        label: AppLocalizations.of(context).dashboardLoading,
      ),
      error: (error, _) => AppErrorState(
        error: error,
        onRetry: () => ref.invalidate(userDashboardProvider),
      ),
      data: (data) => RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(homeTickerProvider);

          await Future.wait([
            ref.refresh(userDashboardProvider.future),
            ref.read(homeTickerProvider.future),
          ]);
        },
        child: _DashboardContent(
          data: data,
          fallbackUser: user,
        ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({
    required this.data,
    required this.fallbackUser,
  });

  final UserDashboard data;
  final AuthUser fallbackUser;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final displayName = data.profile.fullName.isNotEmpty
        ? data.profile.fullName
        : fallbackUser.fullName;

    final firstName = displayName
        .trim()
        .split(RegExp(r'\s+'))
        .first;

    final pharmacies =
        data.locationContext?.registeredNearbyPharmacies ?? const [];

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            20,
            14,
            20,
            112,
          ),
          sliver: SliverList.list(
            children: [
              // ============================================================
              // HERO
              // ============================================================

              AppReveal(
                child: _HeroSection(
                  firstName: firstName,
                  data: data,
                ),
              ),

              const SizedBox(height: AppSpace.lg),

              // ============================================================
              // HOME TICKER
              // ============================================================

              HomeTickerPanel(
                onPharmacyTap: (pharmacyId) {
                  context.push(
                    '/user/pharmacies/$pharmacyId',
                  );
                },
              ),

              const SizedBox(height: AppSpace.lg),

              // ============================================================
              // METRICS
              // ============================================================

              AppReveal(
                delay: const Duration(milliseconds: 80),
                child: RoleMetricsGrid(
                  items: [
                    RoleMetricData(
                      label: l10n.metricActiveRequests,
                      value: '${data.activeRequestsCount}',
                      icon: Icons.bolt_rounded,
                      color: context.appColors.primary,
                    ),
                    RoleMetricData(
                      label: l10n.underReview,
                      value: '${data.pendingRequestsCount}',
                      icon: Icons.schedule_rounded,
                      color: context.appColors.primary,
                    ),
                    RoleMetricData(
                      label: l10n.metricCompletedRequests,
                      value: '${data.completedRequestsCount}',
                      icon: Icons.task_alt_rounded,
                      color: context.appColors.primary,
                    ),
                    RoleMetricData(
                      label: l10n.metricOpenPharmacies,
                      value: '${data.openNearbyPharmaciesCount}',
                      icon: Icons.local_pharmacy_rounded,
                      color: context.appColors.primary,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ============================================================
              // QUICK ACCESS
              // ============================================================

              RoleSectionHeader(
                title: l10n.quickAccessTitle,
                subtitle: l10n.quickAccessSubtitle,
              ),

              const SizedBox(height: 6),

              AppReveal(
                delay: const Duration(milliseconds: 120),
                child: RoleActionsGrid(
                  items: [
                    RoleActionData(
                      title: l10n.myPrescriptions,
                      subtitle: l10n.myPrescriptionsSubtitle,
                      icon: Icons.receipt_long_rounded,
                      color: context.appColors.primary,
                      onTap: () {
                        context.push('/user/prescriptions');
                      },
                    ),
                    RoleActionData(
                      title: l10n.donations,
                      subtitle: l10n.donationsSubtitle,
                      icon: Icons.volunteer_activism_rounded,
                      color: context.appColors.primaryDark,
                      onTap: () {
                        context.push('/user/donations');
                      },
                    ),
                    RoleActionData(
                      title: l10n.organizations,
                      subtitle: l10n.organizationsSubtitle,
                      icon: Icons.apartment_rounded,
                      color: context.appColors.primary,
                      onTap: () {
                        context.push('/organizations');
                      },
                    ),
                    RoleActionData(
                      title: l10n.pharmacyAssistant,
                      subtitle: l10n.pharmacyAssistantSubtitle,
                      icon: Icons.chat_bubble_rounded,
                      color: context.appColors.primary,
                      onTap: () {
                        context.push('/user/chat');
                      },
                    ),
                    RoleActionData(
                      title: l10n.medicineAlternatives,
                      subtitle: l10n.medicineAlternativesSubtitle,
                      icon: Icons.compare_arrows_rounded,
                      color: context.appColors.primary,
                      onTap: () {
                        context.push('/intelligence');
                      },
                    ),
                    RoleActionData(
                      title: l10n.searchHistoryTitle,
                      subtitle: l10n.searchHistorySubtitle,
                      icon: Icons.history_rounded,
                      color: context.appColors.primaryDark,
                      onTap: () {
                        context.push('/user/search-history');
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ============================================================
              // LOCATION
              // ============================================================

              RoleSectionHeader(
                title: l10n.locationSectionTitle,
                subtitle: l10n.locationSectionSubtitle,
              ),

              const SizedBox(height: 6),

              AppReveal(
                delay: const Duration(milliseconds: 150),
                child: _LocationSummary(
                  profile: data.profile,
                  contextData: data.locationContext,
                  onTap: () {
                    context.go('/user/nearby-pharmacies');
                  },
                ),
              ),

              if (pharmacies.isNotEmpty) ...[
                const SizedBox(height: AppSpace.md),

                SizedBox(
                  height: 172,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: pharmacies.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      return _NearbyPharmacyCard(
                        pharmacy: pharmacies[index],
                        onTap: () {
                          context.push(
                            '/user/pharmacies/'
                            '${pharmacies[index].pharmacyId}',
                          );
                        },
                      );
                    },
                  ),
                ),
              ],

              const SizedBox(height: 28),

              // ============================================================
              // LATEST REQUESTS
              // ============================================================

              RoleSectionHeader(
                title: l10n.latestRequestsTitle,
                subtitle: l10n.latestRequestsSubtitle,
              ),

              const SizedBox(height: 6),

              if (data.recentRequests.isEmpty)
                _EmptyActivity(
                  icon: Icons.inventory_2_outlined,
                  text: l10n.emptyRequestsActivity,
                )
              else
                ...data.recentRequests.map(
                  (request) => Padding(
                    padding: const EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: _RequestCard(
                      request: request,
                      onTap: () {
                        context.push(
                          '/user/requests/${request.requestId}',
                        );
                      },
                    ),
                  ),
                ),

              const SizedBox(height: 28),

              // ============================================================
              // SEARCH ACTIVITY
              // ============================================================

              RoleSectionHeader(
                title: l10n.searchActivityTitle,
                subtitle: l10n.searchActivitySubtitle,
              ),

              const SizedBox(height: 6),

              if (data.recentSearches.isEmpty)
                _EmptyActivity(
                  icon: Icons.search_off_rounded,
                  text: l10n.emptySearchActivity,
                )
              else
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: context.appColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: context.appColors.border,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Column(
                      children: data.recentSearches
                          .map(
                            (item) => _SearchActivity(
                              item: item,
                              onTap: () {
                                _openSearchActivity(
                                  context,
                                  item,
                                );
                              },
                            ),
                          )
                          .toList(growable: false),
                    ),
                  ),
                ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// HERO
// ============================================================================

class _HeroSection extends StatelessWidget {
  const _HeroSection({
    required this.firstName,
    required this.data,
  });

  final String firstName;
  final UserDashboard data;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hasLocation = data.profile.hasSavedLocation;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: context.appColors.primary,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: context.appColors.primaryDark.withValues(
            alpha: 0.35,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          22,
          22,
          22,
          20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(
                            alpha: 0.1,
                          ),
                          borderRadius:
                              BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.medical_services_rounded,
                              color: Color(0xFF8BD0CB),
                              size: 14,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              l10n.healthSpace,
                              style: TextStyle(
                                color: context
                                    .appColors
                                    .primaryLight,
                                fontWeight:
                                    FontWeight.w700,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Health shortcut
                GestureDetector(
                  onTap: () {
                    context.push('/user/health');
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(
                        alpha: 0.1,
                      ),
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.favorite_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Text(
              l10n.welcomeName(firstName),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(
                    color: Colors.white,
                    fontSize: 26,
                    height: 1.3,
                  ),
            ),

            const SizedBox(height: 8),

            Text(
              l10n.heroSubtitle,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                    color: Colors.white.withValues(
                      alpha: 0.7,
                    ),
                    fontSize: 13.5,
                    height: 1.6,
                  ),
            ),

            const SizedBox(height: 18),

            // ============================================================
            // SEARCH
            // ============================================================

            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  context.go('/user/search');
                },
                borderRadius:
                    BorderRadius.circular(14),
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 13,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(
                      alpha: 0.1,
                    ),
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search_rounded,
                        color:
                            context.appColors.secondary,
                        size: 22,
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Text(
                          l10n.searchPlaceholder,
                          style: TextStyle(
                            color: Colors.white
                                .withValues(alpha: 0.5),
                            fontSize: 14,
                            fontWeight:
                                FontWeight.w500,
                          ),
                        ),
                      ),

                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color:
                              context.appColors.secondary,
                          borderRadius:
                              BorderRadius.circular(10),
                        ),
                        child: Text(
                          l10n.searchCta,
                          style: const TextStyle(
                            color: Color(0xFF173D46),
                            fontSize: 11,
                            fontWeight:
                                FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ============================================================
            // LOCATION STATUS
            //
            // ملاحظة:
            // السهم الذي كان موجوداً هنا تم حذفه نهائياً.
            // ============================================================

            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  context.go('/user/nearby-pharmacies');
                },
                borderRadius:
                    BorderRadius.circular(10),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(
                      alpha: 0.07,
                    ),
                    borderRadius:
                        BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        hasLocation
                            ? Icons.location_on_rounded
                            : Icons
                                .add_location_alt_rounded,
                        color: hasLocation
                            ? context
                                .appColors
                                .secondary
                            : Colors.white.withValues(
                                alpha: 0.6,
                              ),
                        size: 17,
                      ),

                      const SizedBox(width: 8),

                      Flexible(
                        child: Text(
                          hasLocation
                              ? l10n.locationSavedHero
                              : l10n.addLocationHero,
                          style: TextStyle(
                            color: Colors.white
                                .withValues(alpha: 0.65),
                            fontSize: 12,
                            fontWeight:
                                FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// LOCATION SUMMARY
// ============================================================================

class _LocationSummary extends StatelessWidget {
  const _LocationSummary({
    required this.profile,
    required this.contextData,
    required this.onTap,
  });

  final UserProfile profile;
  final UserLocationContext? contextData;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hasLocation = profile.hasSavedLocation;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: context.appColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: context.appColors.border,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: hasLocation
                      ? context.appColors.primary
                          .withValues(alpha: 0.1)
                      : context.appColors.secondary
                          .withValues(alpha: 0.1),
                  borderRadius:
                      BorderRadius.circular(14),
                ),
                child: Icon(
                  hasLocation
                      ? Icons.my_location_rounded
                      : Icons.add_location_alt_rounded,
                  color: hasLocation
                      ? context.appColors.primary
                      : context.appColors.secondary,
                  size: 22,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasLocation
                          ? l10n.locationSavedTitle
                          : l10n.setLocationTitle,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                            fontWeight:
                                FontWeight.w700,
                          ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      hasLocation
                          ? l10n.locationSummarySubtitle(
                              (contextData
                                          ?.radiusInMeters ??
                                      5000) ~/
                                  1000,
                              contextData
                                      ?.registeredCount ??
                                  0,
                            )
                          : l10n.addLocationSubtitle,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                            fontSize: 12.5,
                          ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // ============================================================
              // FINAL LOCATION ARROW
              //
              // ثابت على >
              // صغير مثل التصميم السابق
              // ============================================================

              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: hasLocation
                      ? context.appColors.primary
                          .withValues(alpha: 0.08)
                      : context.appColors.secondary
                          .withValues(alpha: 0.1),
                  borderRadius:
                      BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: hasLocation
                      ? context.appColors.primary
                      : context.appColors.secondary,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// NEARBY PHARMACY CARD
// ============================================================================

class _NearbyPharmacyCard extends StatelessWidget {
  const _NearbyPharmacyCard({
    required this.pharmacy,
    required this.onTap,
  });

  final UserPharmacySummary pharmacy;
  final VoidCallback onTap;

  static const Color _distanceColor =
      Color(0xFFDFAE0D);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SizedBox(
      width: 255,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: context.appColors.primary
                            .withValues(alpha: 0.1),
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.local_pharmacy_rounded,
                        color:
                            context.appColors.primary,
                        size: 21,
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            pharmacy.pharmacyName,
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight:
                                      FontWeight.w700,
                                ),
                          ),

                          const SizedBox(height: 2),

                          Text(
                            '${pharmacy.area}، ${pharmacy.city}',
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontSize: 12,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                Row(
                  children: [
                    _SmallPill(
                      icon: Icons.route_rounded,
                      text: _formatDistance(
                        l10n,
                        pharmacy.distanceMeters,
                      ),
                      color: _distanceColor,
                    ),

                    const SizedBox(width: 7),

                    _SmallPill(
                      icon: Icons.circle,
                      text: pharmacy.statusText.isEmpty
                          ? pharmacy.isOpenNow
                              ? l10n.openLabel
                              : l10n.closedLabel
                          : pharmacy.statusText,
                      color: pharmacy.isOpenNow
                          ? context.appColors.success
                          : context.appColors.textMuted,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// REQUEST CARD
// ============================================================================

class _RequestCard extends StatelessWidget {
  const _RequestCard({
    required this.request,
    required this.onTap,
  });

  final UserMedicineRequestSummary request;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: context.appColors.primary
                      .withValues(alpha: 0.1),
                  borderRadius:
                      BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.medication_rounded,
                  color:
                      context.appColors.primary,
                  size: 23,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.medicineDisplayName,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                            fontWeight:
                                FontWeight.w700,
                          ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      '${request.pharmacyName} — '
                      '${l10n.requestQuantity} '
                      '${request.requestedQuantity}',
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                            fontSize: 12.5,
                          ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: context.appColors.primary
                      .withValues(alpha: 0.08),
                  borderRadius:
                      BorderRadius.circular(10),
                ),
                child: Text(
                  request.statusDisplayText.isEmpty
                      ? request.status
                      : request.statusDisplayText,
                  style: TextStyle(
                    color:
                        context.appColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 11.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// SEARCH ACTIVITY
// ============================================================================

class _SearchActivity extends StatelessWidget {
  const _SearchActivity({
    required this.item,
    required this.onTap,
  });

  final UserSearchHistory item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 7,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color:
                    context.appColors.surfaceSoft,
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.search_rounded,
                color:
                    context.appColors.primary,
                size: 21,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    item.query.isEmpty
                        ? l10n.searchForPharmacy
                        : item.query,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                          fontSize: 14,
                          fontWeight:
                              FontWeight.w600,
                        ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    _searchType(
                      l10n,
                      item.searchType,
                    ),
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(
                          fontSize: 11.5,
                          color: context
                              .appColors
                              .textMuted,
                        ),
                  ),
                ],
              ),
            ),

            Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: context.appColors.primary
                    .withValues(alpha: 0.08),
                borderRadius:
                    BorderRadius.circular(10),
              ),
              child: Text(
                l10n.searchResultCount(
                  item.resultCount,
                ),
                style: TextStyle(
                  color:
                      context.appColors.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// EMPTY ACTIVITY
// ============================================================================

class _EmptyActivity extends StatelessWidget {
  const _EmptyActivity({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 28,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius:
            BorderRadius.circular(16),
        border: Border.all(
          color: context.appColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color:
                  context.appColors.surfaceSoft,
              borderRadius:
                  BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color:
                  context.appColors.textMuted,
              size: 23,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                    color:
                        context.appColors.textMuted,
                    height: 1.5,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// SMALL PILL
// ============================================================================

class _SmallPill extends StatelessWidget {
  const _SmallPill({
    required this.icon,
    required this.text,
    this.color,
  });

  final IconData icon;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final pillColor =
        color ?? context.appColors.primary;

    return Expanded(
      child: Container(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: pillColor.withValues(
            alpha: 0.08,
          ),
          borderRadius:
              BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: pillColor,
              size: 12,
            ),

            const SizedBox(width: 4),

            Flexible(
              child: Text(
                text,
                maxLines: 1,
                overflow:
                    TextOverflow.ellipsis,
                style: TextStyle(
                  color: pillColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 10.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// HELPERS
// ============================================================================

String _formatDistance(
  AppLocalizations l10n,
  double meters,
) {
  if (meters < 1000) {
    return l10n.distanceMeters(
      '${meters.round()}',
    );
  }

  return l10n.distanceKm(
    (meters / 1000).toStringAsFixed(1),
  );
}

String _searchType(
  AppLocalizations l10n,
  String value,
) =>
    switch (value.toLowerCase()) {
      'medicine' ||
      'medicines' ||
      'medicinesearch' =>
        l10n.searchForMedicine,

      'pharmacy' ||
      'pharmacies' ||
      'nearestpharmacies' ||
      'pharmacydetails' =>
        l10n.searchForPharmacy,

      'medicinerequest' =>
        l10n.medicineRequestType,

      _ =>
        l10n.searchActivityTitle,
    };

void _openSearchActivity(
  BuildContext context,
  UserSearchHistory item,
) {
  final type = item.searchType.toLowerCase();

  if (type.contains('medicine') &&
      type != 'medicinerequest' &&
      item.query.trim().isNotEmpty) {
    context.go(
      '/user/search',
      extra: item.query.trim(),
    );
    return;
  }

  context.go('/user/nearby-pharmacies');
}