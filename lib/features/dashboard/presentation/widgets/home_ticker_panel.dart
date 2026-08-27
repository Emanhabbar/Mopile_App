import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../data/models/home_ticker_item.dart';
import '../controllers/home_ticker_provider.dart';

class HomeTickerPanel extends ConsumerWidget {
  const HomeTickerPanel({
    super.key,
    this.onPharmacyTap,
  });

  final void Function(String pharmacyId)? onPharmacyTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeTickerProvider);

    return state.maybeWhen(
      data: (items) => items.isEmpty
          ? const SizedBox.shrink()
          : Column(
              children: items
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 9),
                      child: _TickerCard(
                        item: item,
                        onTap:
                            item.pharmacyProfileId != null &&
                                onPharmacyTap != null
                            ? () => onPharmacyTap!(
                                item.pharmacyProfileId!,
                              )
                            : null,
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _TickerCard extends StatelessWidget {
  const _TickerCard({
    required this.item,
    this.onTap,
  });

  final HomeTickerItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.appColors.primary;

    final isRtl =
        Directionality.of(context) == TextDirection.rtl;

    return Material(
      // ============================================================
      // CARD BACKGROUND
      // ============================================================
      color: color.withValues(alpha: 0.07),
      borderRadius: BorderRadius.circular(20),

      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),

        child: Padding(
          padding: const EdgeInsets.all(14),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // ======================================================
              // ICON
              // ======================================================
              //
              // تم حذف الـ gradient والخلفية بالكامل.
              // الأيقونة الآن تظهر مباشرة بدون مربع أو تموج خلفها.
              //
              SizedBox(
                width: 42,
                height: 42,
                child: Icon(
                  item.isDutyPharmacy
                      ? Icons.local_pharmacy_outlined
                      : Icons.campaign_outlined,
                  color: color,
                  size: 24,
                ),
              ),

              const SizedBox(width: 12),

              // ======================================================
              // TEXT
              // ======================================================
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      item.message,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                            height: 1.4,
                          ),
                    ),

                    if (item.pharmacyName != null) ...[
                      const SizedBox(height: 5),

                      Text(
                        item.pharmacyName!,
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // ======================================================
              // ARROW
              // ======================================================
              //
              // LTR  : >
              // RTL  : <
              //
              // يتم قلب السهم 180 درجة في اللغة العربية.
              //
              if (onTap != null) ...[
                const SizedBox(width: 10),

                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Transform.rotate(
                    angle: isRtl ? 3.14159265359 : 0,
                    child: Icon(
                      Icons.chevron_right_rounded,
                      color: color,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}