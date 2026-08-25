import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

class PharmacyInventoryDemo extends StatelessWidget {
  const PharmacyInventoryDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: colors.background,
        appBar: AppBar(
          title: const Text('إدارة المخزون'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.qr_code_scanner_rounded),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.refresh_rounded),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 32),
          children: [
            _Overview(colors: colors),
            const SizedBox(height: 13),
            _SearchBox(colors: colors),
            const SizedBox(height: 11),
            _FilterChips(colors: colors),
            const SizedBox(height: 14),
            _InventoryCard(
              colors: colors,
              name: 'باراسيتامول ٥٠٠ ملغ',
              brand: 'مصنع ابن سينا للأدوية',
              quantity: '٤٢',
              price: '٤٬٥٠٠ ل.س',
              statusLabel: 'متوفر',
              chips: const ['أقراص', 'يتطلب وصفة', 'الصلاحية ٠٢/٢٠٢٧'],
              showBarcode: true,
            ),
            const SizedBox(height: 12),
            _InventoryCard(
              colors: colors,
              name: 'أموكسيسيلين ٥٠٠ ملغ',
              brand: 'شركة تاميك فارما',
              quantity: '٦',
              price: '١٢٬٠٠٠ ل.س',
              statusLabel: 'منخفض',
              chips: const ['كبسولات', 'يتطلب وصفة', 'الصلاحية ٠٩/٢٠٢٦'],
            ),
            const SizedBox(height: 12),
            _InventoryCard(
              colors: colors,
              name: 'إنسولين لانتوس',
              brand: 'سانوفي أفينتيس',
              quantity: '٢',
              price: '٨٦٬٥٠٠ ل.س',
              statusLabel: 'ينتهي قريباً',
              chips: const ['قلم حقن', 'تبريد ٢-٨°', 'تنتهي خلال ٢٠ يوم'],
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
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [colors.primary, colors.primaryDark],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _Fact(colors: colors, label: 'متاح', value: '١٢٨'),
              const SizedBox(width: 10),
              _Fact(colors: colors, label: 'منخفض', value: '٦'),
              const SizedBox(width: 10),
              _Fact(colors: colors, label: 'نفدت', value: '٢'),
            ],
          ),
          const SizedBox(height: 13),
          Container(
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.secondary,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_circle_rounded, color: colors.primaryDeep),
                const SizedBox(width: 7),
                Text(
                  'إضافة دواء للمخزون',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: colors.primaryDeep,
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

class _Fact extends StatelessWidget {
  const _Fact({required this.colors, required this.label, required this.value});

  final AppColors colors;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.75),
                fontSize: 11.5,
              ),
            ),
          ],
        ),
      ),
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
          Text(
            'ابحث عن دواء أو مادة فعالة...',
            style: TextStyle(color: colors.textMuted, fontSize: 13.5),
          ),
          const Spacer(),
          Container(width: 1, height: 22, color: colors.border),
          const SizedBox(width: 12),
          Icon(Icons.mic_none_rounded, color: colors.textMuted, size: 20),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    const labels = ['الكل', 'متوفر', 'منخفض', 'نفدت'];
    return Row(
      children: [
        for (var i = 0; i < labels.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
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

class _InventoryCard extends StatelessWidget {
  const _InventoryCard({
    required this.colors,
    required this.name,
    required this.brand,
    required this.quantity,
    required this.price,
    required this.statusLabel,
    required this.chips,
    this.showBarcode = false,
  });

  final AppColors colors;
  final String name;
  final String brand;
  final String quantity;
  final String price;
  final String statusLabel;
  final List<String> chips;
  final bool showBarcode;

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
                Icons.medication_rounded,
                color: colors.primary,
                size: 24,
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
                          name,
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(color: colors.text),
                        ),
                      ),
                      Icon(
                        Icons.more_vert_rounded,
                        size: 19,
                        color: colors.textMuted,
                      ),
                    ],
                  ),
                  Text(
                    brand,
                    style: TextStyle(fontSize: 12, color: colors.textMuted),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: colors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colors.border),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: 'الكمية ',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: colors.textMuted,
                            ),
                            children: [
                              TextSpan(
                                text: quantity,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: colors.text,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        Container(width: 1, height: 16, color: colors.border),
                        const SizedBox(width: 14),
                        Text(
                          price,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: colors.text,
                          ),
                        ),
                        if (showBarcode) ...[
                          const SizedBox(width: 12),
                          _BarcodeStrip(color: colors.text),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final chip in chips)
                        _MiniChip(colors: colors, label: chip),
                      _MiniChip(
                        colors: colors,
                        label: statusLabel,
                        fg: Colors.white,
                        bg: colors.primary,
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

class _BarcodeStrip extends StatelessWidget {
  const _BarcodeStrip({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    const widths = [2.0, 4.0, 2.0, 6.0, 3.0, 2.0, 5.0, 2.0, 4.0];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < widths.length; i++) ...[
          Container(width: widths[i], height: 18, color: color),
          if (i != widths.length - 1) const SizedBox(width: 2),
        ],
      ],
    );
  }
}

class _MiniChip extends StatelessWidget {
  const _MiniChip({
    required this.colors,
    required this.label,
    this.fg,
    this.bg,
  });

  final AppColors colors;
  final String label;
  final Color? fg;
  final Color? bg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: bg ?? colors.surfaceSoft,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: fg ?? colors.textMuted,
        ),
      ),
    );
  }
}
