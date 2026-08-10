import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

class AppBrand extends StatelessWidget {
  const AppBrand({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: compact ? 42 : 54,
          height: compact ? 42 : 54,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [context.appColors.primary, context.appColors.primaryDark],
            ),
            borderRadius: BorderRadius.circular(compact ? 14 : 18),
            boxShadow: [
              BoxShadow(
                color: context.appColors.shadow.withValues(alpha: 0.14),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: EdgeInsets.all(compact ? 5 : 6),
            child: Image.asset(
              'assets/brand/dawaai-icon-foreground.png',
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
              cacheWidth: compact ? 96 : 128,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'دوائي',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: context.appColors.text,
                fontSize: compact ? 17 : 22,
                letterSpacing: -0.25,
              ),
            ),
            if (!compact)
              Text(
                'دواؤك أقرب',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
