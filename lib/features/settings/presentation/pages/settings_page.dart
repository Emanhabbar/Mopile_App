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
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 112),
      children: [
        Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.surfaceSoft,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.tune_rounded, color: AppColors.primary),
            ),
            const SizedBox(width: 10),
            Text('حسابي', style: Theme.of(context).textTheme.headlineSmall),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'بياناتك وتفضيلات استخدام التطبيق',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 18),
        AppReveal(
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow.withValues(alpha: 0.15),
                  blurRadius: 22,
                  offset: const Offset(0, 9),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(19),
              child: Row(
                children: [
                  ProfileAvatar(user: user, radius: 30),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.fullName,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(color: Colors.white, fontSize: 18),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          user.email,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.white70),
                        ),
                        const SizedBox(height: 7),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            _roleLabel(user.primaryRole),
                            style: const TextStyle(
                              color: AppColors.secondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const _SettingsSectionTitle(
          icon: Icons.settings_suggest_outlined,
          title: 'التفضيلات والحساب',
          subtitle: 'إدارة بياناتك وطريقة استخدام التطبيق',
        ),
        const SizedBox(height: 9),
        Card(
          child: Column(
            children: [
              ListTile(
                onTap: () => context.push('/account/profile'),
                leading: const _SettingsIcon(
                  icon: Icons.person_outline_rounded,
                ),
                title: const Text('الملف الشخصي'),
                subtitle: const Text('الاسم ورقم الهاتف والصورة'),
                trailing: const Icon(Icons.chevron_left_rounded),
              ),
              const Divider(height: 1, indent: 20, endIndent: 20),
              ListTile(
                leading: const _SettingsIcon(icon: Icons.language_rounded),
                title: const Text('لغة التطبيق'),
                subtitle: Text(
                  locale.languageCode == 'ar' ? 'العربية' : 'English',
                ),
                trailing: Switch(
                  value: locale.languageCode == 'en',
                  onChanged: (_) =>
                      ref.read(localeControllerProvider.notifier).toggle(),
                ),
              ),
              const Divider(height: 1, indent: 20, endIndent: 20),
              ListTile(
                onTap: () => context.push('/settings/appearance'),
                leading: const _SettingsIcon(icon: Icons.palette_outlined),
                title: const Text('المظهر'),
                subtitle: const Text('فاتح أو داكن أو حسب إعداد الجهاز'),
                trailing: const Icon(Icons.chevron_left_rounded),
              ),
              const Divider(height: 1, indent: 20, endIndent: 20),
              ListTile(
                onTap: () => context.push('/settings/notifications'),
                leading: _SettingsIcon(icon: Icons.notifications_none_rounded),
                title: const Text('تفضيلات الإشعارات'),
                subtitle: const Text('الطلبات والتذكيرات والحملات'),
                trailing: const Icon(Icons.chevron_left_rounded),
              ),
              const Divider(height: 1, indent: 20, endIndent: 20),
              ListTile(
                onTap: () => context.push('/account/password'),
                leading: const _SettingsIcon(icon: Icons.lock_outline_rounded),
                title: const Text('تغيير كلمة المرور'),
                subtitle: const Text('تحديث كلمة مرور حسابك'),
                trailing: const Icon(Icons.chevron_left_rounded),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        const _SettingsSectionTitle(
          icon: Icons.security_outlined,
          title: 'الخصوصية والمساعدة',
          subtitle: 'الصلاحيات والمعلومات المهمة عن استخدام دوائي',
        ),
        const SizedBox(height: 9),
        Card(
          child: Column(
            children: [
              ListTile(
                onTap: () => context.push('/notifications'),
                leading: const _SettingsIcon(icon: Icons.inbox_outlined),
                title: const Text('مركز الإشعارات'),
                subtitle: const Text('عرض التنبيهات الواردة وحالتها'),
                trailing: const Icon(Icons.chevron_left_rounded),
              ),
              const Divider(height: 1, indent: 20, endIndent: 20),
              ListTile(
                onTap: () => context.push('/settings/permissions'),
                leading: const _SettingsIcon(
                  icon: Icons.admin_panel_settings_outlined,
                ),
                title: const Text('صلاحيات الجهاز'),
                subtitle: const Text('الموقع والكاميرا والملفات'),
                trailing: const Icon(Icons.chevron_left_rounded),
              ),
              const Divider(height: 1, indent: 20, endIndent: 20),
              ListTile(
                onTap: () => context.push('/settings/privacy'),
                leading: const _SettingsIcon(icon: Icons.shield_outlined),
                title: const Text('الخصوصية'),
                trailing: const Icon(Icons.chevron_left_rounded),
              ),
              const Divider(height: 1, indent: 20, endIndent: 20),
              ListTile(
                onTap: () => context.push('/settings/terms'),
                leading: const _SettingsIcon(icon: Icons.description_outlined),
                title: const Text('شروط الاستخدام'),
                trailing: const Icon(Icons.chevron_left_rounded),
              ),
              const Divider(height: 1, indent: 20, endIndent: 20),
              ListTile(
                onTap: () => context.push('/settings/help'),
                leading: const _SettingsIcon(icon: Icons.help_outline_rounded),
                title: const Text('المساعدة'),
                trailing: const Icon(Icons.chevron_left_rounded),
              ),
              const Divider(height: 1, indent: 20, endIndent: 20),
              ListTile(
                onTap: () => context.push('/settings/about'),
                leading: const _SettingsIcon(icon: Icons.info_outline_rounded),
                title: const Text('عن دوائي'),
                subtitle: const Text('الإصدار 1.0.0'),
                trailing: const Icon(Icons.chevron_left_rounded),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        OutlinedButton.icon(
          onPressed: () => _confirmLogout(context, ref),
          icon: const Icon(Icons.logout_rounded),
          label: const Text('تسجيل الخروج'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(54),
            foregroundColor: AppColors.danger,
            side: const BorderSide(color: Color(0xFFE8CACA)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
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

  String _roleLabel(AppRole role) => switch (role) {
    AppRole.user => 'مستخدم',
    AppRole.pharmacy => 'صيدلية',
    AppRole.organization => 'منظمة',
    AppRole.warehouse => 'مستودع أدوية',
    AppRole.representative => 'مندوب مستودع',
    AppRole.admin => 'إدارة المنصة',
  };
}

class _SettingsSectionTitle extends StatelessWidget {
  const _SettingsSectionTitle({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  final IconData icon;
  final String title, subtitle;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, color: AppColors.primary, size: 21),
      const SizedBox(width: 8),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
            Text(
              subtitle,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
            ),
          ],
        ),
      ),
    ],
  );
}

class _SettingsIcon extends StatelessWidget {
  const _SettingsIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      color: AppColors.surfaceSoft,
      borderRadius: BorderRadius.circular(13),
    ),
    child: Icon(icon, color: AppColors.primary, size: 21),
  );
}
