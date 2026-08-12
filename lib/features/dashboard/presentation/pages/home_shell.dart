import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_roles.dart';
import '../../../../core/widgets/app_brand.dart';
import '../../../../shared/widgets/profile_avatar.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../notifications/presentation/controllers/notifications_providers.dart';
import '../../../settings/presentation/pages/settings_page.dart';

class HomeShell extends ConsumerWidget {
  const HomeShell({required this.navigationShell, required this.role, super.key});

  final StatefulNavigationShell navigationShell;

  /// الدور الذي بُنيت فروع الشل على أساسه.
  /// يُستخدم لضمان تطابق عدد التبويبات مع عدد الفروع في الراوتر دائماً.
  final AppRole role;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final destinations = _destinationsForRole(role);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (navigationShell.currentIndex != 0) {
          navigationShell.goBranch(0);
        }
      },
      child: Scaffold(
        extendBody: true,
        body: navigationShell,
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.fromLTRB(14, 0, 14, 12),
          child: _DawaaiBottomBar(
            activeIndex: navigationShell.currentIndex,
            destinations: destinations,
            onTap: (index) =>
                navigationShell.goBranch(index, initialLocation: true),
          ),
        ),
      ),
    );
  }
}

/// يلف صفحة تبويب بشريط العلامة التجارية (الشعار + الإشعارات + الصورة).
/// يُستخدم لتبويبي "الرئيسية" و"حسابي" اللذين لا يملكان AppBar خاصاً.
class HomeTabShell extends StatelessWidget {
  const HomeTabShell({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final user = ref.watch(authControllerProvider).valueOrNull?.user;
      return Scaffold(
        appBar: user == null ? null : HomeShellAppBar(user: user),
        body: child,
      );
    });
  }
}

class AccountTabPage extends ConsumerWidget {
  const AccountTabPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).valueOrNull?.user;
    if (user == null) return const SizedBox.shrink();
    return HomeTabShell(child: SettingsPage(user: user));
  }
}

class HomeShellAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const HomeShellAppBar({required this.user, super.key});

  final dynamic user;

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadNotifications =
        ref.watch(notificationUnreadCountProvider).valueOrNull?.unreadCount ??
        0;
    return AppBar(
      toolbarHeight: 70,
      titleSpacing: 18,
      title: const AppBrand(compact: true),
      actions: [
        _HeaderAction(
          tooltip: 'الإشعارات',
          onPressed: () => context.push('/notifications'),
          child: Badge(
            isLabelVisible: unreadNotifications > 0,
            label: Text(
              unreadNotifications > 99 ? '99+' : '$unreadNotifications',
            ),
            backgroundColor: context.appColors.secondary,
            offset: const Offset(-2, 2),
            child: const Icon(Icons.notifications_none_rounded, size: 22),
          ),
        ),
        const SizedBox(width: 9),
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 16),
          child: ProfileAvatar(user: user, radius: 18),
        ),
      ],
    );
  }
}

List<_BottomDestination> _destinationsForRole(AppRole role) {
  return switch (role) {
    AppRole.user => [
      const _BottomDestination(
        label: 'الرئيسية',
        icon: Icons.home_outlined,
        selectedIcon: Icons.home_rounded,
      ),
      const _BottomDestination(
        label: 'البحث',
        icon: Icons.search_rounded,
        selectedIcon: Icons.manage_search_rounded,
      ),
      const _BottomDestination(
        label: 'الصيدليات',
        icon: Icons.location_on_outlined,
        selectedIcon: Icons.location_on_rounded,
      ),
      const _BottomDestination(
        label: 'طلباتي',
        icon: Icons.receipt_long_outlined,
        selectedIcon: Icons.receipt_long_rounded,
      ),
      const _BottomDestination(
        label: 'حسابي',
        icon: Icons.person_outline_rounded,
        selectedIcon: Icons.person_rounded,
      ),
    ],
    AppRole.pharmacy => [
      const _BottomDestination(
        label: 'الرئيسية',
        icon: Icons.home_outlined,
        selectedIcon: Icons.home_rounded,
      ),
      const _BottomDestination(
        label: 'المخزون',
        icon: Icons.inventory_2_outlined,
        selectedIcon: Icons.inventory_2_rounded,
      ),
      const _BottomDestination(
        label: 'الطلبات',
        icon: Icons.assignment_outlined,
        selectedIcon: Icons.assignment_rounded,
      ),
      const _BottomDestination(
        label: 'التوريد',
        icon: Icons.local_shipping_outlined,
        selectedIcon: Icons.local_shipping_rounded,
      ),
      const _BottomDestination(
        label: 'حسابي',
        icon: Icons.person_outline_rounded,
        selectedIcon: Icons.person_rounded,
      ),
    ],
    AppRole.admin => [
      const _BottomDestination(
        label: 'الرئيسية',
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard_rounded,
      ),
      const _BottomDestination(
        label: 'الإدارة',
        icon: Icons.admin_panel_settings_outlined,
        selectedIcon: Icons.admin_panel_settings_rounded,
      ),
      const _BottomDestination(
        label: 'الأدوية',
        icon: Icons.medication_outlined,
        selectedIcon: Icons.medication_rounded,
      ),
      const _BottomDestination(
        label: 'حسابي',
        icon: Icons.person_outline_rounded,
        selectedIcon: Icons.person_rounded,
      ),
    ],
    AppRole.organization => [
      const _BottomDestination(
        label: 'الرئيسية',
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard_rounded,
      ),
      const _BottomDestination(
        label: 'إدارة المنظمة',
        icon: Icons.apartment_outlined,
        selectedIcon: Icons.apartment_rounded,
      ),
      const _BottomDestination(
        label: 'حسابي',
        icon: Icons.person_outline_rounded,
        selectedIcon: Icons.person_rounded,
      ),
    ],
    AppRole.warehouse => [
      const _BottomDestination(
        label: 'الرئيسية',
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard_rounded,
      ),
      const _BottomDestination(
        label: 'المستودع',
        icon: Icons.warehouse_outlined,
        selectedIcon: Icons.warehouse_rounded,
      ),
      const _BottomDestination(
        label: 'حسابي',
        icon: Icons.person_outline_rounded,
        selectedIcon: Icons.person_rounded,
      ),
    ],
    AppRole.representative => [
      const _BottomDestination(
        label: 'الرئيسية',
        icon: Icons.home_outlined,
        selectedIcon: Icons.home_rounded,
      ),
      const _BottomDestination(
        label: 'مهامي',
        icon: Icons.delivery_dining_outlined,
        selectedIcon: Icons.delivery_dining_rounded,
      ),
      const _BottomDestination(
        label: 'حسابي',
        icon: Icons.person_outline_rounded,
        selectedIcon: Icons.person_rounded,
      ),
    ],
  };
}

class _BottomDestination {
  const _BottomDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

class _DawaaiBottomBar extends StatelessWidget {
  const _DawaaiBottomBar({
    required this.activeIndex,
    required this.destinations,
    required this.onTap,
  });

  final int activeIndex;
  final List<_BottomDestination> destinations;
  final void Function(int index) onTap;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(26),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
      child: Container(
        height: 76,
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: context.appColors.surface.withValues(alpha: 0.75),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: context.appColors.border.withValues(alpha: 0.4),
          ),
          boxShadow: [
            BoxShadow(
              color: context.appColors.shadow.withValues(alpha: 0.06),
              blurRadius: 30,
              spreadRadius: -6,
              offset: const Offset(0, 10),
            ),
          ],
        ),
    child: Row(
      children: List.generate(destinations.length, (index) {
        final destination = destinations[index];
        final isSelected = index == activeIndex;
        return Expanded(
          child: Semantics(
            selected: isSelected,
            button: true,
            label: destination.label,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  HapticFeedback.selectionClick();
                  onTap(index);
                },
                borderRadius: BorderRadius.circular(20),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeOutCubic,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? context.appColors.primary.withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedScale(
                        scale: isSelected ? 1.1 : 1,
                        duration: const Duration(milliseconds: 280),
                        curve: Curves.easeOutBack,
                        child: Icon(
                          isSelected
                              ? destination.selectedIcon
                              : destination.icon,
                          color: isSelected
                              ? context.appColors.primary
                              : context.appColors.textMuted,
                          size: 23,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        destination.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isSelected
                              ? context.appColors.primary
                              : context.appColors.textMuted,
                          fontSize: destinations.length >= 5 ? 10 : 11,
                          fontWeight: isSelected
                              ? FontWeight.w800
                              : FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    ),
    ),
    ),
  );
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({
    required this.tooltip,
    required this.onPressed,
    required this.child,
  });

  final String tooltip;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: tooltip,
    child: Material(
      color: context.appColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: context.appColors.border),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(width: 40, height: 40, child: Center(child: child)),
      ),
    ),
  );
}