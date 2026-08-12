import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_reveal.dart';
import '../../../../core/widgets/async_states.dart';
import '../../../auth/data/models/auth_session.dart';
import '../../../dashboard/presentation/controllers/home_ticker_provider.dart';
import '../../../dashboard/presentation/widgets/home_ticker_panel.dart';
import '../../../dashboard/presentation/widgets/role_dashboard_widgets.dart';
import '../../data/models/user_models.dart';
import '../controllers/user_providers.dart';

class UserDashboardPage extends ConsumerWidget {
  const UserDashboardPage({required this.user, super.key});

  final AuthUser user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(userDashboardProvider);

    return dashboard.when(
      loading: () => const AppLoadingState(label: 'نجهز مساحتك الشخصية...'),
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
        child: _DashboardContent(data: data, fallbackUser: user),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.data, required this.fallbackUser});

  final UserDashboard data;
  final AuthUser fallbackUser;

  @override
  Widget build(BuildContext context) {
    final displayName = data.profile.fullName.isNotEmpty
        ? data.profile.fullName
        : fallbackUser.fullName;
    final firstName = displayName.trim().split(RegExp(r'\s+')).first;
    final pharmacies =
        data.locationContext?.registeredNearbyPharmacies ?? const [];

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 112),
          sliver: SliverList.list(
            children: [
              AppReveal(
                child: _HeroSection(firstName: firstName, data: data),
              ),
              const SizedBox(height: AppSpace.lg),
              HomeTickerPanel(
                onPharmacyTap: (pharmacyId) =>
                    context.push('/user/pharmacies/$pharmacyId'),
              ),
              const SizedBox(height: AppSpace.lg),
              AppReveal(
                delay: const Duration(milliseconds: 80),
                child: RoleMetricsGrid(
                  items: [
                    RoleMetricData(
                      label: 'طلبات نشطة',
                      value: '${data.activeRequestsCount}',
                      icon: Icons.bolt_rounded,
                      color: const Color(0xFF16869A),
                    ),
                    RoleMetricData(
                      label: 'قيد المراجعة',
                      value: '${data.pendingRequestsCount}',
                      icon: Icons.schedule_rounded,
                      color: const Color(0xFFBC7A17),
                    ),
                    RoleMetricData(
                      label: 'طلبات مكتملة',
                      value: '${data.completedRequestsCount}',
                      icon: Icons.task_alt_rounded,
                      color: const Color(0xFF21815B),
                    ),
                    RoleMetricData(
                      label: 'صيدليات مفتوحة',
                      value: '${data.openNearbyPharmaciesCount}',
                      icon: Icons.local_pharmacy_rounded,
                      color: const Color(0xFF7557B7),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const RoleSectionHeader(
                title: 'وصول سريع',
                subtitle: 'الخدمات التي قد تحتاجها اليوم',
              ),
              const SizedBox(height: 6),
              AppReveal(
                delay: const Duration(milliseconds: 120),
                child: RoleActionsGrid(
                  items: [
                    RoleActionData(
                      title: 'وصفاتي',
                      subtitle: 'إدارة الوصفات والطلبات',
                      icon: Icons.receipt_long_rounded,
                      color: context.appColors.primary,
                      onTap: () => context.push('/user/prescriptions'),
                    ),
                    RoleActionData(
                      title: 'التبرعات',
                      subtitle: 'قدّم دواءً أو اطلب مساعدة',
                      icon: Icons.volunteer_activism_rounded,
                      color: const Color(0xFFB7791F),
                      onTap: () => context.push('/user/donations'),
                    ),
                    RoleActionData(
                      title: 'المنظمات',
                      subtitle: 'اكتشف الحملات الفعّالة',
                      icon: Icons.apartment_rounded,
                      color: const Color(0xFF6D5AA8),
                      onTap: () => context.push('/organizations'),
                    ),
                    RoleActionData(
                      title: 'المساعد الدوائي',
                      subtitle: 'اسأل وتابع محادثاتك',
                      icon: Icons.chat_bubble_rounded,
                      color: const Color(0xFF177C70),
                      onTap: () => context.push('/user/chat'),
                    ),
                    RoleActionData(
                      title: 'البدائل الدوائية',
                      subtitle: 'قارن البدائل المتاحة',
                      icon: Icons.compare_arrows_rounded,
                      color: const Color(0xFF5C6BC0),
                      onTap: () => context.push('/intelligence'),
                    ),
                    RoleActionData(
                      title: 'سجل البحث',
                      subtitle: 'ارجع لعمليات البحث السابقة',
                      icon: Icons.history_rounded,
                      color: const Color(0xFF4E6B8B),
                      onTap: () => context.push('/user/search-history'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const RoleSectionHeader(
                title: 'الموقع والصيدليات',
                subtitle: 'نتائج قريبة اعتمادًا على موقعك المحفوظ',
              ),
              const SizedBox(height: 6),
              AppReveal(
                delay: const Duration(milliseconds: 150),
                child: _LocationSummary(
                  profile: data.profile,
                  contextData: data.locationContext,
                  onTap: () => context.go('/user/nearby-pharmacies'),
                ),
              ),
              if (pharmacies.isNotEmpty) ...[
                const SizedBox(height: AppSpace.md),
                SizedBox(
                  height: 172,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: pharmacies.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (context, index) => _NearbyPharmacyCard(
                      pharmacy: pharmacies[index],
                      onTap: () => context.push(
                        '/user/pharmacies/${pharmacies[index].pharmacyId}',
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 8),
              const RoleSectionHeader(
                title: 'أحدث الطلبات',
                subtitle: 'آخر المستجدات على طلبات الأدوية',
              ),
              const SizedBox(height: 6),
              if (data.recentRequests.isEmpty)
                const _EmptyActivity(
                  icon: Icons.inventory_2_outlined,
                  text: 'لا توجد طلبات بعد. يمكنك البدء بالبحث عن دوائك.',
                )
              else
                ...data.recentRequests.map(
                  (request) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _RequestCard(
                      request: request,
                      onTap: () =>
                          context.push('/user/requests/${request.requestId}'),
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              const RoleSectionHeader(
                title: 'نشاط البحث',
                subtitle: 'عمليات البحث الحديثة',
              ),
              const SizedBox(height: 6),
              if (data.recentSearches.isEmpty)
                const _EmptyActivity(
                  icon: Icons.search_off_rounded,
                  text: 'لم تبدأ البحث بعد.',
                )
              else
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: context.appColors.surface,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: context.appColors.border.withValues(alpha: 0.7),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Column(
                      children: data.recentSearches
                          .map(
                            (item) => _SearchActivity(
                              item: item,
                              onTap: () => _openSearchActivity(context, item),
                            ),
                          )
                          .toList(growable: false),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.firstName, required this.data});

  final String firstName;
  final UserDashboard data;

  @override
  Widget build(BuildContext context) {
    final hasLocation = data.profile.hasSavedLocation;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF1B5665), Color(0xFF103A45), Color(0xFF0B2E37)],
        ),
        borderRadius: BorderRadius.circular(AppRadius.hero),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF174B57).withValues(alpha: 0.35),
            blurRadius: 30,
            spreadRadius: -4,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -40,
            left: -30,
            child: _DecorativeOrb(
              size: 130,
              color: context.appColors.secondary.withValues(alpha: 0.08),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -20,
            child: _DecorativeOrb(
              size: 110,
              color: context.appColors.primaryLight.withValues(alpha: 0.1),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                ),
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
                    'مساحتك الصحية',
                    style: TextStyle(
                      color: context.appColors.primaryLight,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: _HealthProfileButton(
              onPressed: () => context.push('/user/health'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 58, 22, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'أهلًا $firstName',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontSize: 26,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'ابحث عن دوائك، تابع طلباتك واحتفظ\nبمعلوماتك الصحية في مكان واحد.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 13.5,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 18),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => context.go('/user/search'),
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.13),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search_rounded,
                            color: context.appColors.secondary,
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'ابحث عن دواء...',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.5),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: context.appColors.secondary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'بحث',
                              style: TextStyle(
                                color: Color(0xFF173D46),
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        hasLocation
                            ? Icons.location_on_rounded
                            : Icons.add_location_alt_rounded,
                        color: hasLocation
                            ? context.appColors.secondary
                            : Colors.white.withValues(alpha: 0.6),
                        size: 17,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          hasLocation
                              ? 'موقعك محفوظ — النتائج الأقرب لك'
                              : 'أضف موقعك لعرض الصيدليات القريبة',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.65),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_left_rounded,
                        color: Colors.white.withValues(alpha: 0.4),
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HealthProfileButton extends StatelessWidget {
  const _HealthProfileButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: IconButton(
        onPressed: onPressed,
        tooltip: 'ملفي الصحي',
        icon: const Icon(Icons.favorite_rounded, color: Colors.white, size: 20),
        padding: EdgeInsets.zero,
      ),
    );
  }
}

class _DecorativeOrb extends StatelessWidget {
  const _DecorativeOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

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
    final hasLocation = profile.hasSavedLocation;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
              colors: hasLocation
                  ? [
                      context.appColors.primary.withValues(alpha: 0.08),
                      context.appColors.surface,
                    ]
                  : [
                      const Color(0xFFFFF9EC),
                      context.appColors.surface,
                    ],
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: hasLocation
                  ? context.appColors.primary.withValues(alpha: 0.18)
                  : const Color(0xFFF1DDAF),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: hasLocation
                        ? [
                            context.appColors.primary.withValues(alpha: 0.18),
                            context.appColors.primary.withValues(alpha: 0.08),
                          ]
                        : [
                            const Color(0xFFF5CB72).withValues(alpha: 0.3),
                            const Color(0xFFF5CB72).withValues(alpha: 0.1),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  hasLocation
                      ? Icons.my_location_rounded
                      : Icons.add_location_alt_rounded,
                  color: hasLocation
                      ? context.appColors.primary
                      : const Color(0xFFB57920),
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasLocation ? 'موقعك محفوظ' : 'حدد موقعك',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hasLocation
                          ? 'نطاق ${(contextData?.radiusInMeters ?? 5000) ~/ 1000} كم — ${contextData?.registeredCount ?? 0} صيدليات مسجلة'
                          : 'أضف موقعك من خدمة الصيدليات القريبة',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: hasLocation
                      ? context.appColors.primary.withValues(alpha: 0.1)
                      : context.appColors.warning.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.chevron_left_rounded,
                  color: hasLocation
                      ? context.appColors.primary
                      : context.appColors.warning,
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

class _NearbyPharmacyCard extends StatelessWidget {
  const _NearbyPharmacyCard({required this.pharmacy, required this.onTap});

  final UserPharmacySummary pharmacy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 255,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            context.appColors.primary.withValues(alpha: 0.18),
                            context.appColors.primary.withValues(alpha: 0.08),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.local_pharmacy_rounded,
                        color: context.appColors.primary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pharmacy.pharmacyName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${pharmacy.area}، ${pharmacy.city}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontSize: 12),
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
                      text: _formatDistance(pharmacy.distanceMeters),
                    ),
                    const SizedBox(width: 7),
                    _SmallPill(
                      icon: Icons.circle,
                      text: pharmacy.statusText.isEmpty
                          ? pharmacy.isOpenNow
                                ? 'مفتوحة'
                                : 'مغلقة'
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

class _RequestCard extends StatelessWidget {
  const _RequestCard({required this.request, required this.onTap});

  final UserMedicineRequestSummary request;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      context.appColors.primary.withValues(alpha: 0.18),
                      context.appColors.primary.withValues(alpha: 0.08),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  Icons.medication_rounded,
                  color: context.appColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.medicineDisplayName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${request.pharmacyName} — الكمية ${request.requestedQuantity}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF5DE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  request.statusDisplayText.isEmpty
                      ? request.status
                      : request.statusDisplayText,
                  style: const TextStyle(
                    color: Color(0xFF9B681C),
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

class _SearchActivity extends StatelessWidget {
  const _SearchActivity({required this.item, required this.onTap});

  final UserSearchHistory item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 7),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: context.appColors.surfaceSoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.search_rounded,
                color: context.appColors.primary,
                size: 21,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.query.isEmpty ? 'بحث عن صيدلية' : item.query,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _searchType(item.searchType),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 11.5,
                      color: context.appColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: context.appColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${item.resultCount} نتيجة',
                style: TextStyle(
                  color: context.appColors.primary,
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

class _EmptyActivity extends StatelessWidget {
  const _EmptyActivity({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: context.appColors.border.withValues(alpha: 0.7),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: context.appColors.surfaceSoft,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: context.appColors.textMuted, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: context.appColors.textMuted,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallPill extends StatelessWidget {
  const _SmallPill({
    required this.icon,
    required this.text,
    this.color = const Color(0xFF216474),
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 12),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
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

String _formatDistance(double meters) {
  if (meters < 1000) return '${meters.round()} م';
  return '${(meters / 1000).toStringAsFixed(1)} كم';
}

String _searchType(String value) => switch (value.toLowerCase()) {
  'medicine' || 'medicines' || 'medicinesearch' => 'بحث عن دواء',
  'pharmacy' ||
  'pharmacies' ||
  'nearestpharmacies' ||
  'pharmacydetails' => 'بحث عن صيدلية',
  'medicinerequest' => 'طلب دواء',
  _ => 'نشاط بحث',
};

void _openSearchActivity(BuildContext context, UserSearchHistory item) {
  final type = item.searchType.toLowerCase();
  if (type.contains('medicine') &&
      type != 'medicinerequest' &&
      item.query.trim().isNotEmpty) {
    context.go('/user/search', extra: item.query.trim());
    return;
  }
  context.go('/user/nearby-pharmacies');
}
