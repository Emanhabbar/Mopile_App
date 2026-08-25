import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

class UserDashboardDemo extends StatelessWidget {
  const UserDashboardDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: colors.background,
        body: SafeArea(
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 32),
                sliver: SliverList.list(
                  children: [
                    _Hero(colors: colors),
                    const SizedBox(height: 20),
                    _Ticker(
                      colors: colors,
                      icon: Icons.campaign_outlined,
                      title: 'عرض جديد متاح',
                      message:
                          'باراسيتامول ٥٠٠ ملغ بسعر ٤٬٥٠٠ ل.س في الصيدليات القريبة منك',
                      pharmacy: 'صيدلية الشفاء',
                      showArrow: true,
                    ),
                    const SizedBox(height: 10),
                    _Ticker(
                      colors: colors,
                      icon: Icons.local_pharmacy_outlined,
                      title: 'صيدلية Duty النشطة',
                      message:
                          'صيدلية النور تعمل حتى الساعة ١١ مساءً مع خدمة التوصيل المجاني',
                      pharmacy: 'صيدلية النور',
                    ),
                    const SizedBox(height: 22),
                    _SectionHeader(title: 'نظرة عامة', colors: colors),
                    const SizedBox(height: 10),
                    _MetricsGrid(colors: colors),
                    const SizedBox(height: 22),
                    _SectionHeader(
                      title: 'الوصول السريع',
                      subtitle: 'أبواب التطبيق المهمة',
                      colors: colors,
                    ),
                    const SizedBox(height: 10),
                    _ActionsGrid(colors: colors),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colors.primaryDark.withValues(alpha: 0.35)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(30),
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
                          color: colors.primaryLight,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.favorite_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'مرحباً أحمد',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w800,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'هل تبحث عن دواء اليوم؟',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 13.5,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(Icons.search_rounded, color: colors.secondary, size: 22),
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
                      color: colors.secondary,
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
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.add_location_alt_rounded,
                    color: Colors.white.withValues(alpha: 0.6),
                    size: 17,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'أضف موقعك للوصول لأقرب صيدلية',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.65),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white.withValues(alpha: 0.4),
                    size: 18,
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

class _Ticker extends StatelessWidget {
  const _Ticker({
    required this.colors,
    required this.icon,
    required this.title,
    required this.message,
    required this.pharmacy,
    this.showArrow = false,
  });

  final AppColors colors;
  final IconData icon;
  final String title;
  final String message;
  final String pharmacy;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colors.primary.withValues(alpha: 0.07),
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colors.primary.withValues(alpha: 0.2),
                    colors.primary.withValues(alpha: 0.08),
                  ],
                ),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, color: colors.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colors.text,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.4,
                      color: colors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    pharmacy,
                    style: TextStyle(
                      color: colors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (showArrow) ...[
              const SizedBox(width: 10),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: colors.primary,
                  size: 18,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.colors,
    required this.title,
    this.subtitle,
  });

  final AppColors colors;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: colors.text),
        ),
        if (subtitle != null)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              subtitle!,
              style: TextStyle(color: colors.textMuted, fontSize: 12),
            ),
          ),
      ],
    );
  }
}

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid({required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    const data = [
      (icon: Icons.bolt_rounded, value: '٣', label: 'طلبات نشطة'),
      (icon: Icons.schedule_rounded, value: '٥', label: 'قيد المراجعة'),
      (icon: Icons.task_alt_rounded, value: '١٢', label: 'طلبات مكتملة'),
      (icon: Icons.local_pharmacy_rounded, value: '٤', label: 'صيدليات مفتوحة'),
    ];
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.85,
      children: [
        for (final d in data)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(d.icon, color: colors.primary, size: 21),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        d.value,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: colors.primary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        d.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: colors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _ActionsGrid extends StatelessWidget {
  const _ActionsGrid({required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    const data = [
      (
        icon: Icons.receipt_long_rounded,
        title: 'وصفاتي الطبية',
        subtitle: 'عرض وإدارة',
      ),
      (
        icon: Icons.volunteer_activism_rounded,
        title: 'التبرعات',
        subtitle: 'ساهم في العطاء',
      ),
      (
        icon: Icons.apartment_rounded,
        title: 'المنظمات',
        subtitle: 'تصفح وانضم',
      ),
      (
        icon: Icons.chat_bubble_rounded,
        title: 'المساعد الذكي',
        subtitle: 'اسأل المساعد',
      ),
      (
        icon: Icons.compare_arrows_rounded,
        title: 'بديل الدواء',
        subtitle: 'ابحث عن بديل',
      ),
      (
        icon: Icons.history_rounded,
        title: 'سجل البحث',
        subtitle: 'عمليات البحث',
      ),
    ];
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.15,
      children: [
        for (final d in data)
          Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: colors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(d.icon, color: colors.primary, size: 21),
                  ),
                  const Spacer(),
                  Text(
                    d.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colors.text,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    d.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11.5, color: colors.textMuted),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
