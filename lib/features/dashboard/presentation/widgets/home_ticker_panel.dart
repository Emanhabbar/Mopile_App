import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../data/models/home_ticker_item.dart';
import '../controllers/home_ticker_provider.dart';

class HomeTickerPanel extends ConsumerWidget {
  const HomeTickerPanel({super.key, this.onPharmacyTap});

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
                            ? () => onPharmacyTap!(item.pharmacyProfileId!)
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
  const _TickerCard({required this.item, this.onTap});

  final HomeTickerItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = item.isDutyPharmacy
        ? const Color(0xFF3977C4)
        : AppColors.primary;
    return Material(
      color: color.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  item.isDutyPharmacy
                      ? Icons.local_pharmacy_outlined
                      : Icons.campaign_outlined,
                  color: color,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.message,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    if (item.pharmacyName != null) ...[
                      const SizedBox(height: 5),
                      Text(
                        item.pharmacyName!,
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (onTap != null) Icon(Icons.chevron_left_rounded, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
