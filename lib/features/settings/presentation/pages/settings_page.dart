import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/locale_controller.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_roles.dart';
import '../../../../core/widgets/app_reveal.dart';
import '../../../../shared/widgets/profile_avatar.dart';
import '../../../auth/data/models/auth_session.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({required this.user, super.key});

  final AuthUser user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeControllerProvider);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 112),
      children: [
        Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: context.appColors.surfaceSoft,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.tune_rounded, color: context.appColors.primary),
            ),
            const SizedBox(width: 10),
            Text('حسابي', style: Theme.of(context).textTheme.headlineSmall),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'بياناتك وتفضيلات استخدام التطبيق',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: context.appColors.text,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 22),
        AppReveal(
          child: _ProfileHero(user: user),
        ),
        const SizedBox(height: 28),
        _SectionLabel(
          title: 'التفضيلات والحساب',
          subtitle: 'إدارة بياناتك وطريقة استخدام التطبيق',
        ),
        const SizedBox(height: 12),
        _AccentSettingsItem(
          accentColor: context.appColors.primary,
          icon: Icons.person_outline_rounded,
          title: 'الملف الشخصي',
          subtitle: 'الاسم ورقم الهاتف والصورة',
          onTap: () => context.push('/account/profile'),
        ),
        const SizedBox(height: 6),
        _AccentSettingsItem(
          accentColor: context.appColors.primaryDark,
          icon: Icons.language_rounded,
          title: 'لغة التطبيق',
          subtitle: locale.languageCode == 'ar' ? 'العربية' : 'English',
          onTap: () =>
              ref.read(localeControllerProvider.notifier).toggle(),
        ),
        const SizedBox(height: 6),
        _AccentSettingsItem(
          accentColor: context.appColors.primary,
          icon: Icons.palette_outlined,
          title: 'المظهر',
          subtitle: 'فاتح أو داكن أو حسب إعداد الجهاز',
          onTap: () => context.push('/settings/appearance'),
        ),
        const SizedBox(height: 6),
        _AccentSettingsItem(
          accentColor: context.appColors.primary,
          icon: Icons.notifications_none_rounded,
          title: 'تفضيلات الإشعارات',
          subtitle: 'الطلبات والتذكيرات والحملات',
          onTap: () => context.push('/settings/notifications'),
        ),
        const SizedBox(height: 6),
        _AccentSettingsItem(
          accentColor: context.appColors.primaryDark,
          icon: Icons.lock_outline_rounded,
          title: 'تغيير كلمة المرور',
          subtitle: 'تحديث كلمة مرور حسابك',
          onTap: () => context.push('/account/password'),
        ),
        const SizedBox(height: 28),
        _SectionLabel(
          title: 'الخصوصية والمساعدة',
          subtitle: 'الصلاحيات والمعلومات المهمة عن استخدام دوائي',
        ),
        const SizedBox(height: 12),
        _AccentSettingsItem(
          accentColor: context.appColors.primary,
          icon: Icons.inbox_outlined,
          title: 'مركز الإشعارات',
          subtitle: 'عرض التنبيهات الواردة وحالتها',
          onTap: () => context.push('/notifications'),
        ),
        const SizedBox(height: 6),
        _AccentSettingsItem(
          accentColor: context.appColors.primaryDark,
          icon: Icons.admin_panel_settings_outlined,
          title: 'صلاحيات الجهاز',
          subtitle: 'الموقع والكاميرا والملفات',
          onTap: () => context.push('/settings/permissions'),
        ),
        const SizedBox(height: 6),
        _AccentSettingsItem(
          accentColor: context.appColors.primaryLight,
          icon: Icons.shield_outlined,
          title: 'الخصوصية',
          subtitle: 'بياناتك الآمنة وخصوصيتك',
          onTap: () => context.push('/settings/privacy'),
        ),
        const SizedBox(height: 6),
        _AccentSettingsItem(
          accentColor: context.appColors.primary,
          icon: Icons.description_outlined,
          title: 'شروط الاستخدام',
          subtitle: 'البنود والأحكام العامة',
          onTap: () => context.push('/settings/terms'),
        ),
        const SizedBox(height: 6),
        _AccentSettingsItem(
          accentColor: context.appColors.primaryDark,
          icon: Icons.help_outline_rounded,
          title: 'المساعدة',
          subtitle: 'الدعم الفني والأسئلة الشائعة',
          onTap: () => context.push('/settings/help'),
        ),
        const SizedBox(height: 6),
        _AccentSettingsItem(
          accentColor: context.appColors.primaryLight,
          icon: Icons.info_outline_rounded,
          title: 'عن دوائي',
          subtitle: 'الإصدار 1.0.0',
          onTap: () => context.push('/settings/about'),
        ),
        const SizedBox(height: 28),
        Container(
          decoration: BoxDecoration(
            color: context.appColors.danger.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: context.appColors.danger.withValues(alpha: 0.12)),
          ),
          child: InkWell(
            onTap: () => _confirmLogout(context, ref),
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: context.appColors.danger.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(
                      Icons.logout_rounded,
                      color: context.appColors.danger,
                      size: 21,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'تسجيل الخروج',
                      style: TextStyle(
                        color: context.appColors.danger,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: context.appColors.surface,
        title: const Text('تسجيل الخروج'),
        content: const Text('هل تريد تسجيل الخروج من حسابك؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
    if (shouldLogout == true) {
      await ref.read(authControllerProvider.notifier).logout();
    }
  }
}

String _roleLabel(AppRole role) => switch (role) {
  AppRole.user => 'مستخدم',
  AppRole.pharmacy => 'صيدلية',
  AppRole.organization => 'منظمة',
  AppRole.warehouse => 'مستودع أدوية',
  AppRole.representative => 'مندوب مستودع',
  AppRole.admin => 'إدارة المنصة',
};

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({required this.user});

  final AuthUser user;

  @override
  Widget build(BuildContext context) {
    final hasImage = user.hasProfileImage;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: context.appColors.primaryDeep,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: context.appColors.primary.withValues(alpha: 0.15)),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              children: [
                Row(
                  children: [
                    ProfileAvatar(user: user, radius: 34),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.fullName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.email,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.65),
                                  fontSize: 13,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: context.appColors.surface.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        hasImage
                            ? Icons.verified_rounded
                            : Icons.person_outline_rounded,
                        color: context.appColors.secondary,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _roleLabel(user.primaryRole),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                      const Spacer(),
                      if (user.primaryRole != AppRole.admin)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: hasImage
                                ? context.appColors.secondary
                                : context.appColors.surface.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            hasImage ? 'حساب موثّق' : 'حساب غير موثّق',
                            style: TextStyle(
                              color: hasImage
                                  ? context.appColors.primaryDeep
                                  : Colors.white.withValues(alpha: 0.6),
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                    ],
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

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.title, required this.subtitle});

  final String title, subtitle;

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
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: context.appColors.text,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                color: context.appColors.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _AccentSettingsItem extends StatelessWidget {
  const _AccentSettingsItem({
    required this.accentColor,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final Color accentColor;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: context.appColors.border),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: context.appColors.surfaceSoft,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, color: accentColor, size: 21),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: context.appColors.text,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: context.appColors.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
