import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

class DonationsDemo extends StatelessWidget {
  const DonationsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: colors.background,
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('التبرعات'),
              Text(
                'ساعد غيرك وكن سبباً بالشفاء',
                style: TextStyle(
                  color: colors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            _Hero(colors: colors),
            const SizedBox(height: 15),
            _SegmentSwitcher(colors: colors),
            const SizedBox(height: 13),
            _StatusChips(colors: colors),
            const SizedBox(height: 15),
            _DonationCard(
              colors: colors,
              campaign: 'حملة رمضان الخيرية',
              detail: 'باراسيتامول ٥٠٠ ملغ – علبتان',
              date: 'قبل يومين',
              status: 'قيد المراجعة',
            ),
            const SizedBox(height: 11),
            _DonationCard(
              colors: colors,
              campaign: 'ساعدوا مرضى السرطان',
              detail: 'مسكنات وأدوية داعمة – ٣ علب',
              date: 'قبل أسبوع',
              status: 'مقبول',
            ),
            const SizedBox(height: 11),
            _DonationCard(
              colors: colors,
              campaign: 'أدوية لمعسكرات النزوح',
              detail: 'مضادات حيوية – ٥ علب',
              date: 'قبل شهر',
              status: 'تم التسليم',
            ),
          ],
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [colors.primaryDeep, colors.primary],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.volunteer_activism_rounded,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ساهم بإنقاذ حياة',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'تبرع بأدويتك الزائدة أو قدّم طلب مساعدة',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.78),
                    fontSize: 12.5,
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

class _SegmentSwitcher extends StatelessWidget {
  const _SegmentSwitcher({required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.surfaceSoft,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(13),
                boxShadow: [
                  BoxShadow(
                    color: colors.shadow.withValues(alpha: 0.08),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Text(
                'عروضي',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 13.5,
                  color: colors.primary,
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'طلباتي',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13.5,
                  color: colors.textMuted,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChips extends StatelessWidget {
  const _StatusChips({required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    const labels = ['الكل', 'قيد المراجعة', 'مقبول', 'مكتمل'];
    return Row(
      children: [
        for (var i = 0; i < labels.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: i == 0 ? colors.primary : colors.surfaceSoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              labels[i],
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: i == 0 ? Colors.white : colors.textMuted,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _DonationCard extends StatelessWidget {
  const _DonationCard({
    required this.colors,
    required this.campaign,
    required this.detail,
    required this.date,
    required this.status,
  });

  final AppColors colors;
  final String campaign;
  final String detail;
  final String date;
  final String status;

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
              child: Icon(
                Icons.volunteer_activism_rounded,
                color: colors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          campaign,
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(color: colors.text),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: colors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: colors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    detail,
                    style: TextStyle(fontSize: 12.5, color: colors.textMuted),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      Icon(
                        Icons.history_rounded,
                        size: 15,
                        color: colors.textMuted,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: colors.textMuted,
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
}
