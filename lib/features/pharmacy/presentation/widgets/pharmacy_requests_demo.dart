import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

class PharmacyRequestsDemo extends StatelessWidget {
  const PharmacyRequestsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: colors.background,
        appBar: AppBar(
          title: const Text('طلبات الأدوية'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.refresh_rounded),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
              child: Column(
                children: [
                  _Overview(colors: colors),
                  const SizedBox(height: 13),
                  _SearchBox(colors: colors),
                  const SizedBox(height: 11),
                  _StatusChips(colors: colors),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 32),
                itemCount: 4,
                separatorBuilder: (_, _) => const SizedBox(height: 11),
                itemBuilder: (_, index) {
                  const data = [
                    (
                      'باراسيتامول ٥٠٠ ملغ',
                      'أحمد محمد',
                      'بانتظار الرد',
                      'الكمية المطلوبة: ٢',
                      'REQ-2415',
                      true,
                    ),
                    (
                      'أموكسيسيلين ٥٠٠ ملغ',
                      'سارة خليل',
                      'تم الرد',
                      'الكمية المطلوبة: ١',
                      'REQ-2398',
                      false,
                    ),
                    (
                      'إنسولين لانتوس',
                      'عمر الحسن',
                      'قيد التجهيز',
                      'الكمية المطلوبة: ٣',
                      'REQ-2371',
                      false,
                    ),
                    (
                      'فيتامين د ٥٠٠٠ وحدة',
                      'ليان عبدالله',
                      'بانتظار الرد',
                      'الكمية المطلوبة: ٤',
                      'REQ-2366',
                      true,
                    ),
                  ];
                  final item = data[index];
                  return _RequestCard(
                    colors: colors,
                    medicine: item.$1,
                    user: item.$2,
                    status: item.$3,
                    quantity: item.$4,
                    code: item.$5,
                    canRespond: item.$6,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  const _Overview({required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.14),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Icon(
              Icons.assignment_turned_in_outlined,
              color: colors.primaryLight,
              size: 28,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'نظرة عامة على طلباتك',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'لديك طلبان بانتظار الرد',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          const _Number(label: 'متاح', value: '١٢'),
          const SizedBox(width: 8),
          const _Number(label: 'الطلبات', value: '٤'),
        ],
      ),
    );
  }
}

class _Number extends StatelessWidget {
  const _Number({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(label, style: TextStyle(color: Colors.white60, fontSize: 10)),
      ],
    );
  }
}

class _SearchBox extends StatelessWidget {
  const _SearchBox({required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          Icon(Icons.search_rounded, color: colors.textMuted),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'ابحث عن طلب...',
              style: TextStyle(color: colors.textMuted, fontSize: 13.5),
            ),
          ),
          Icon(Icons.arrow_forward_rounded, size: 20, color: colors.primary),
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
    const labels = ['الكل', 'بانتظار الرد', 'تم الرد', 'قيد التجهيز'];
    return Row(
      children: [
        for (var i = 0; i < labels.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: i == 1 ? colors.primary : colors.surfaceSoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              labels[i],
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: i == 1 ? Colors.white : colors.textMuted,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({
    required this.colors,
    required this.medicine,
    required this.user,
    required this.status,
    required this.quantity,
    required this.code,
    required this.canRespond,
  });

  final AppColors colors;
  final String medicine;
  final String user;
  final String status;
  final String quantity;
  final String code;
  final bool canRespond;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(width: 5, color: colors.primary),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 43,
                          height: 43,
                          decoration: BoxDecoration(
                            color: colors.primary.withValues(alpha: 0.09),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            Icons.medication_rounded,
                            color: colors.primary,
                          ),
                        ),
                        const SizedBox(width: 11),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                medicine,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(color: colors.text),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                user,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colors.textMuted,
                                ),
                              ),
                            ],
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
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              color: colors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 13),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: colors.surfaceSoft,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.numbers_rounded,
                            size: 15,
                            color: colors.textMuted,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            quantity,
                            style: TextStyle(
                              fontSize: 11.5,
                              color: colors.text,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(width: 1, height: 16, color: colors.border),
                          const SizedBox(width: 10),
                          Icon(
                            Icons.tag_rounded,
                            size: 15,
                            color: colors.textMuted,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            code,
                            style: TextStyle(
                              fontSize: 11.5,
                              color: colors.text,
                            ),
                          ),
                          const Spacer(),
                          if (canRespond)
                            Row(
                              children: [
                                Text(
                                  'رد الآن',
                                  style: TextStyle(
                                    color: colors.primary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(width: 3),
                                Icon(
                                  Icons.arrow_back_rounded,
                                  size: 16,
                                  color: colors.primary,
                                ),
                              ],
                            ),
                        ],
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
