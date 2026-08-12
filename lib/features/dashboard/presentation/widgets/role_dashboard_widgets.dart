import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/app_reveal.dart';

class RoleDashboardHero extends StatelessWidget {
  const RoleDashboardHero({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    super.key,
    this.badge,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final String? badge;

  @override
  Widget build(BuildContext context) => Container(
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: AlignmentDirectional.topStart,
        end: AlignmentDirectional.bottomEnd,
        colors: [context.appColors.primaryDeep, accent],
      ),
      borderRadius: BorderRadius.circular(30),
      boxShadow: [
        BoxShadow(
          color: accent.withValues(alpha: .2),
          blurRadius: 28,
          offset: const Offset(0, 13),
        ),
      ],
    ),
    child: Stack(
      children: [
        PositionedDirectional(
          top: -55,
          end: -40,
          child: _GlowCircle(
            size: 145,
            color: Colors.white.withValues(alpha: .07),
          ),
        ),
        PositionedDirectional(
          bottom: -50,
          start: -35,
          child: _GlowCircle(size: 120, color: accent.withValues(alpha: .18)),
        ),
        Padding(
          padding: const EdgeInsets.all(21),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (badge != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .11),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          badge!,
                          style: TextStyle(
                            color: context.appColors.secondary,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 13),
                    ],
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(color: Colors.white, fontSize: 22),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: .78),
                        height: 1.55,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(21),
                  border: Border.all(color: Colors.white.withValues(alpha: .1)),
                ),
                child: Icon(icon, color: context.appColors.secondary, size: 31),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class RoleMetricData {
  const RoleMetricData({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.caption,
  });

  final String label;
  final String value;
  final String? caption;
  final IconData icon;
  final Color color;
}

class RoleMetricsGrid extends StatelessWidget {
  const RoleMetricsGrid({required this.items, super.key});

  final List<RoleMetricData> items;

  @override
  Widget build(BuildContext context) => GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: EdgeInsets.zero,
    itemCount: items.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.85,
    ),
    itemBuilder: (context, index) {
      final item = items[index];
      return AppReveal(
        delay: Duration(milliseconds: 50 + (index * 35)),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
              colors: [
                item.color.withValues(alpha: 0.06),
                context.appColors.surface,
              ],
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: item.color.withValues(alpha: 0.12)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      item.color.withValues(alpha: 0.18),
                      item.color.withValues(alpha: 0.08),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(item.icon, color: item.color, size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: item.color,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (item.caption != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          item.caption!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: item.color,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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

class RoleActionData {
  const RoleActionData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
    this.badge,
  });

  final String title;
  final String subtitle;
  final String? badge;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
}

class RoleActionsGrid extends StatelessWidget {
  const RoleActionsGrid({required this.items, super.key});

  final List<RoleActionData> items;

  @override
  Widget build(BuildContext context) => GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: EdgeInsets.zero,
    itemCount: items.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.15,
    ),
    itemBuilder: (context, index) {
      final item = items[index];
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: item.onTap,
          borderRadius: BorderRadius.circular(24),
          child: Ink(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: AlignmentDirectional.topStart,
                end: AlignmentDirectional.bottomEnd,
                colors: [
                  item.color.withValues(alpha: .14),
                  item.color.withValues(alpha: .04),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: item.color.withValues(alpha: .12)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .9),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: item.color.withValues(alpha: 0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(item.icon, color: item.color, size: 23),
                    ),
                    const Spacer(),
                    if (item.badge != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: item.color,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          item.badge!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      )
                    else
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: item.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.arrow_back_rounded,
                          color: item.color,
                          size: 15,
                        ),
                      ),
                  ],
                ),
                const Spacer(),
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 10.5,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class RoleSectionHeader extends StatelessWidget {
  const RoleSectionHeader({
    required this.title,
    required this.subtitle,
    super.key,
    this.action,
  });

  final String title;
  final String subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 4,
        height: 20,
        decoration: BoxDecoration(
          color: context.appColors.primary,
          borderRadius: BorderRadius.circular(3),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
      ?action,
    ],
  );
}

class RoleNoticeCard extends StatelessWidget {
  const RoleNoticeCard({
    required this.title,
    required this.message,
    required this.icon,
    required this.color,
    super.key,
    this.onTap,
  });

  final String title;
  final String message;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: color.withValues(alpha: .075),
    borderRadius: BorderRadius.circular(21),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(21),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 3),
                  Text(message, style: Theme.of(context).textTheme.bodySmall),
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

class _GlowCircle extends StatelessWidget {
  const _GlowCircle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}
