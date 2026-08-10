import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/app_reveal.dart';
import '../../../../core/widgets/async_states.dart';
import '../../../auth/data/models/auth_session.dart';
import '../../../dashboard/presentation/controllers/home_ticker_provider.dart';
import '../../../dashboard/presentation/widgets/home_ticker_panel.dart';
import '../../data/models/user_models.dart';
import '../controllers/user_providers.dart';

class UserDashboardPage extends ConsumerWidget {
  const UserDashboardPage({
    required this.user,
    required this.onOpenServices,
    super.key,
  });

  final AuthUser user;
  final VoidCallback onOpenServices;

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
        child: _DashboardContent(
          data: data,
          fallbackUser: user,
          onOpenServices: onOpenServices,
        ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({
    required this.data,
    required this.fallbackUser,
    required this.onOpenServices,
  });

  final UserDashboard data;
  final AuthUser fallbackUser;
  final VoidCallback onOpenServices;

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
                child: _HeroSection(
                  firstName: firstName,
                  hasSavedLocation: data.profile.hasSavedLocation,
                  onOpenServices: onOpenServices,
                  onOpenHealth: () => context.push('/user/health'),
                ),
              ),
              const SizedBox(height: 14),
              HomeTickerPanel(
                onPharmacyTap: (pharmacyId) =>
                    context.push('/user/pharmacies/$pharmacyId'),
              ),
              const SizedBox(height: 14),
              AppReveal(
                delay: const Duration(milliseconds: 80),
                child: _StatisticsGrid(data: data),
              ),
              const SizedBox(height: 22),
              const _SectionHeader(
                title: 'وصول سريع',
                subtitle: 'الخدمات التي قد تحتاجها اليوم',
              ),
              const SizedBox(height: 12),
              AppReveal(
                delay: const Duration(milliseconds: 120),
                child: _QuickActions(
                  onPrescriptions: () => context.push('/user/prescriptions'),
                  onDonations: () => context.push('/user/donations'),
                  onOrganizations: () => context.push('/organizations'),
                  onAssistant: () => context.push('/user/chat'),
                  onIntelligence: () => context.push('/intelligence'),
                  onSearchHistory: () => context.push('/user/search-history'),
                ),
              ),
              const SizedBox(height: 24),
              _SectionHeader(
                title: 'الموقع والصيدليات',
                subtitle: 'نتائج قريبة اعتمادًا على موقعك المحفوظ',
              ),
              const SizedBox(height: 12),
              AppReveal(
                delay: const Duration(milliseconds: 150),
                child: _LocationSummary(
                  profile: data.profile,
                  contextData: data.locationContext,
                  onTap: () => context.push('/user/nearby-pharmacies'),
                ),
              ),
              if (pharmacies.isNotEmpty) ...[
                const SizedBox(height: 14),
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
              const SizedBox(height: 27),
              _SectionHeader(
                title: 'أحدث الطلبات',
                subtitle: 'آخر المستجدات على طلبات الأدوية',
              ),
              const SizedBox(height: 12),
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
              const SizedBox(height: 17),
              _SectionHeader(
                title: 'نشاط البحث',
                subtitle: 'عمليات البحث الحديثة',
              ),
              const SizedBox(height: 12),
              if (data.recentSearches.isEmpty)
                const _EmptyActivity(
                  icon: Icons.search_off_rounded,
                  text: 'لم تبدأ البحث بعد.',
                )
              else
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
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
  const _HeroSection({
    required this.firstName,
    required this.hasSavedLocation,
    required this.onOpenServices,
    required this.onOpenHealth,
  });

  final String firstName;
  final bool hasSavedLocation;
  final VoidCallback onOpenServices;
  final VoidCallback onOpenHealth;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 17),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF174B57), Color(0xFF0B3540)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF174B57).withValues(alpha: 0.2),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_awesome_rounded, color: Color(0xFF8BD0CB)),
              SizedBox(width: 7),
              Text(
                'مساحتك الصحية',
                style: TextStyle(
                  color: Color(0xFF8BD0CB),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'أهلًا $firstName',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'ابحث عن دوائك، تابع طلباتك واحتفظ بمعلوماتك الصحية المهمة في مكان واحد.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.72),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: onOpenServices,
                  icon: const Icon(Icons.search_rounded),
                  label: const Text('ابحث عن دواء'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFF5CB72),
                    foregroundColor: const Color(0xFF173D46),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton.filledTonal(
                onPressed: onOpenHealth,
                tooltip: 'ملفي الصحي',
                icon: const Icon(Icons.favorite_rounded),
                style: IconButton.styleFrom(
                  minimumSize: const Size(53, 53),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          Row(
            children: [
              Icon(
                hasSavedLocation
                    ? Icons.location_on_rounded
                    : Icons.location_off_rounded,
                color: const Color(0xFFF5CB72),
                size: 19,
              ),
              const SizedBox(width: 7),
              Text(
                hasSavedLocation
                    ? 'موقعك محفوظ لعرض النتائج الأقرب'
                    : 'أضف موقعك لعرض الصيدليات الأقرب',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.74),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatisticsGrid extends StatelessWidget {
  const _StatisticsGrid({required this.data});

  final UserDashboard data;

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        'طلبات نشطة',
        data.activeRequestsCount,
        Icons.bolt_rounded,
        const Color(0xFF16869A),
      ),
      (
        'قيد المراجعة',
        data.pendingRequestsCount,
        Icons.schedule_rounded,
        const Color(0xFFBC7A17),
      ),
      (
        'طلبات مكتملة',
        data.completedRequestsCount,
        Icons.task_alt_rounded,
        const Color(0xFF21815B),
      ),
      (
        'صيدليات مفتوحة',
        data.openNearbyPharmaciesCount,
        Icons.local_pharmacy_rounded,
        const Color(0xFF7557B7),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 11,
        mainAxisSpacing: 11,
        childAspectRatio: 1.72,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(13),
            child: Row(
              children: [
                Container(
                  width: 39,
                  height: 39,
                  decoration: BoxDecoration(
                    color: item.$4.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(item.$3, color: item.$4, size: 21),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${item.$2}',
                        style: Theme.of(
                          context,
                        ).textTheme.titleLarge?.copyWith(fontSize: 21),
                      ),
                      Text(
                        item.$1,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(fontSize: 11.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({
    required this.onPrescriptions,
    required this.onDonations,
    required this.onOrganizations,
    required this.onAssistant,
    required this.onIntelligence,
    required this.onSearchHistory,
  });

  final VoidCallback onPrescriptions;
  final VoidCallback onDonations;
  final VoidCallback onOrganizations;
  final VoidCallback onAssistant;
  final VoidCallback onIntelligence;
  final VoidCallback onSearchHistory;

  @override
  Widget build(BuildContext context) {
    final actions = [
      (
        'وصفاتي',
        'إدارة الوصفات والطلبات',
        Icons.receipt_long_rounded,
        context.appColors.primary,
        onPrescriptions,
      ),
      (
        'التبرعات',
        'قدّم دواءً أو اطلب مساعدة',
        Icons.volunteer_activism_rounded,
        const Color(0xFFB7791F),
        onDonations,
      ),
      (
        'المنظمات',
        'اكتشف الحملات الفعّالة',
        Icons.apartment_rounded,
        const Color(0xFF6D5AA8),
        onOrganizations,
      ),
      (
        'المساعد الدوائي',
        'اسأل وتابع محادثاتك',
        Icons.chat_bubble_rounded,
        const Color(0xFF177C70),
        onAssistant,
      ),
      (
        'البدائل الدوائية',
        'قارن البدائل المتاحة',
        Icons.compare_arrows_rounded,
        const Color(0xFF5C6BC0),
        onIntelligence,
      ),
      (
        'سجل البحث',
        'ارجع لعمليات البحث السابقة',
        Icons.history_rounded,
        const Color(0xFF4E6B8B),
        onSearchHistory,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: actions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 11,
        mainAxisSpacing: 11,
        childAspectRatio: 1.48,
      ),
      itemBuilder: (context, index) {
        final action = actions[index];
        return _QuickActionTile(
          title: action.$1,
          subtitle: action.$2,
          icon: action.$3,
          color: action.$4,
          onTap: action.$5,
        );
      },
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(21),
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                color.withValues(alpha: 0.13),
                color.withValues(alpha: 0.055),
              ],
            ),
            borderRadius: BorderRadius.circular(21),
            border: Border.all(color: color.withValues(alpha: 0.15)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.86),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_back_rounded,
                    color: color.withValues(alpha: 0.72),
                    size: 18,
                  ),
                ],
              ),
              const Spacer(),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontSize: 14.5),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontSize: 10.5),
              ),
            ],
          ),
        ),
      ),
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
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: hasLocation
                ? context.appColors.primary.withValues(alpha: 0.07)
                : const Color(0xFFFFF9EC),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: hasLocation
                  ? context.appColors.primary.withValues(alpha: 0.15)
                  : const Color(0xFFF1DDAF),
            ),
          ),
          child: Row(
            children: [
              Icon(
                hasLocation
                    ? Icons.my_location_rounded
                    : Icons.add_location_alt,
                color: hasLocation
                    ? context.appColors.primary
                    : const Color(0xFFB57920),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasLocation ? 'موقعك محفوظ' : 'لم تحدد موقعك بعد',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      hasLocation
                          ? 'نطاق البحث ${(contextData?.radiusInMeters ?? 5000) ~/ 1000} كم · ${contextData?.registeredCount ?? 0} صيدليات مسجلة'
                          : 'أضف موقعك من خدمة الصيدليات القريبة.',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(fontSize: 12.5),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_left_rounded),
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
      width: 245,
      child: Card(
        clipBehavior: Clip.antiAlias,
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
                      width: 41,
                      height: 41,
                      decoration: BoxDecoration(
                        color: context.appColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Icon(
                        Icons.local_pharmacy_rounded,
                        color: context.appColors.primary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        pharmacy.pharmacyName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  '${pharmacy.area}، ${pharmacy.city}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
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
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: context.appColors.primary.withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.medication_rounded,
                  color: context.appColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.medicineName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${request.pharmacyName} · الكمية ${request.requestedQuantity}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF5DE),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  request.statusDisplayText.isEmpty
                      ? request.status
                      : request.statusDisplayText,
                  style: const TextStyle(
                    color: Color(0xFF9B681C),
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
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
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: Row(
          children: [
            Container(
              width: 39,
              height: 39,
              decoration: BoxDecoration(
                color: context.appColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.search_rounded,
                color: context.appColors.primary,
                size: 21,
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.query.isEmpty ? 'بحث عن صيدلية' : item.query,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontSize: 14),
                  ),
                  Text(
                    _searchType(item.searchType),
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(fontSize: 11.5),
                  ),
                ],
              ),
            ),
            Text(
              '${item.resultCount} نتيجة',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: context.appColors.primary,
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 3),
        Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
      ],
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
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: context.appColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: context.appColors.textMuted, size: 30),
          const SizedBox(height: 10),
          Text(
            text,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
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
    this.color,
  });

  final IconData icon;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final pillColor = color ?? context.appColors.primary;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
        decoration: BoxDecoration(
          color: pillColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: pillColor, size: 11),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
    context.push('/user/search', extra: item.query.trim());
    return;
  }
  context.push('/user/nearby-pharmacies');
}
