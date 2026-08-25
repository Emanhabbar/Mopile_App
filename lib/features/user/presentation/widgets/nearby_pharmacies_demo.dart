import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

class NearbyPharmaciesDemo extends StatelessWidget {
  const NearbyPharmaciesDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: colors.background,
        appBar: AppBar(
          title: const Text('الصيدليات القريبة'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.my_location_rounded),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 32),
          children: [
            _LocationBar(colors: colors),
            const SizedBox(height: 14),
            _RadiusChips(colors: colors),
            const SizedBox(height: 14),
            _MapCard(colors: colors),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '٣ صيدليات داخل نطاق ٣ كلم',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: colors.text),
                  ),
                ),
                _Pill(
                  colors: colors,
                  label: 'الأقرب أولاً',
                  icon: Icons.sort_rounded,
                  fg: colors.primary,
                  bg: colors.surfaceSoft,
                ),
              ],
            ),
            const SizedBox(height: 12),
            _PharmacyCard(
              colors: colors,
              name: 'صيدلية الشفاء',
              distance: '٧٥٠ م',
              open: true,
              hours: '٩:٠٠ صباحاً – ١١:٠٠ مساءً',
            ),
            const SizedBox(height: 11),
            _PharmacyCard(
              colors: colors,
              name: 'صيدلية النور',
              distance: '١٫٢ كلم',
              open: true,
              hours: '٢٤ ساعة',
            ),
            const SizedBox(height: 11),
            _PharmacyCard(
              colors: colors,
              name: 'صيدلية الحياة',
              distance: '٢٫٤ كلم',
              open: false,
              hours: '١٠:٠٠ صباحاً – ٨:٠٠ مساءً',
            ),
          ],
        ),
      ),
    );
  }
}

class _LocationBar extends StatelessWidget {
  const _LocationBar({required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.location_on_rounded, color: colors.primary),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'موقعك الحالي',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: colors.text),
                ),
                const SizedBox(height: 2),
                Text(
                  'دمشق – المزة، طريق المطار',
                  style: TextStyle(color: colors.textMuted, fontSize: 12.5),
                ),
              ],
            ),
          ),
          Icon(Icons.gps_fixed_rounded, color: colors.primary, size: 20),
        ],
      ),
    );
  }
}

class _RadiusChips extends StatelessWidget {
  const _RadiusChips({required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    const values = ['1 كلم', '3 كلم', '5 كلم', '10 كلم'];
    return Row(
      children: [
        for (var i = 0; i < values.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: i == 1 ? colors.primary : colors.surface,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: i == 1 ? colors.primary : colors.border,
                ),
              ),
              child: Text(
                values[i],
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: i == 1 ? Colors.white : colors.textMuted,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _MapCard extends StatelessWidget {
  const _MapCard({required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: 215,
        child: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    colors.surfaceSoft,
                    colors.primaryLight.withValues(alpha: 0.55),
                    colors.surfaceSoft,
                  ],
                ),
              ),
            ),
            Positioned(
              top: 34,
              right: 46,
              child: Icon(
                Icons.location_on_rounded,
                color: colors.primaryDark,
                size: 34,
              ),
            ),
            Positioned(
              bottom: 62,
              left: 58,
              child: Icon(
                Icons.location_on_rounded,
                color: colors.primaryDark,
                size: 34,
              ),
            ),
            Positioned(
              top: 88,
              left: 132,
              child: Icon(
                Icons.location_on_rounded,
                color: colors.danger,
                size: 30,
              ),
            ),
            Center(
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: colors.shadow.withValues(alpha: 0.25),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person_pin_circle_rounded,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              right: 12,
              bottom: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 11,
                ),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: colors.shadow.withValues(alpha: 0.18),
                      blurRadius: 14,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.storefront_rounded, color: colors.primary),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        'صيدلية الشفاء • ٧٥٠ م',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5,
                          color: colors.text,
                        ),
                      ),
                    ),
                    Text(
                      'مفتوحة الآن',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: colors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PharmacyCard extends StatelessWidget {
  const _PharmacyCard({
    required this.colors,
    required this.name,
    required this.distance,
    required this.open,
    required this.hours,
  });

  final AppColors colors;
  final String name;
  final String distance;
  final bool open;
  final String hours;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.13),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.local_pharmacy_rounded, color: colors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: colors.text),
                  ),
                  const SizedBox(height: 7),
                  Wrap(
                    spacing: 7,
                    runSpacing: 7,
                    children: [
                      _Pill(
                        colors: colors,
                        label: distance,
                        icon: Icons.near_me_rounded,
                        fg: colors.textMuted,
                        bg: colors.surfaceSoft,
                      ),
                      _Pill(
                        colors: colors,
                        label: open ? 'مفتوحة الآن' : 'مغلقة حالياً',
                        icon: Icons.schedule_rounded,
                        fg: open ? colors.primary : colors.textMuted,
                        bg: open
                            ? colors.primary.withValues(alpha: 0.1)
                            : colors.surfaceSoft,
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_filled_rounded,
                        size: 15,
                        color: colors.textMuted,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        hours,
                        style: TextStyle(
                          fontSize: 12.5,
                          color: colors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 38,
              height: 38,
              margin: const EdgeInsetsDirectional.only(start: 8),
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.call_rounded, size: 19, color: colors.primary),
            ),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.colors,
    required this.label,
    required this.fg,
    required this.bg,
    this.icon,
  });

  final AppColors colors;
  final String label;
  final Color fg;
  final Color bg;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}
