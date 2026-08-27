import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../l10n/generated/app_localizations.dart';

class AppBrand extends StatelessWidget {
  const AppBrand({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(compact ? 12 : 14),
          child: Image.asset(
            Theme.of(context).brightness == Brightness.dark
                ? 'assets/brand/newlogodark.png'
                : 'assets/brand/newlogo.png',
            width: compact ? 48 : 58,
            height: compact ? 48 : 58,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
            cacheWidth: compact ? 120 : 150,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.appTitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: context.appColors.text,
                fontSize: compact ? 17 : 22,
                letterSpacing: -0.25,
              ),
            ),
            if (!compact)
              Text(
                l10n.appTagline,
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
