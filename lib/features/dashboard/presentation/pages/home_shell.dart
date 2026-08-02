import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_roles.dart';
import '../../../../core/widgets/app_brand.dart';
import '../../../../shared/widgets/profile_avatar.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../admin/presentation/pages/admin_home_page.dart';
import '../../../notifications/presentation/controllers/notifications_providers.dart';
import '../../../organization/presentation/pages/organization_home_page.dart';
import '../../../pharmacy/presentation/pages/pharmacy_dashboard_page.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import '../../../supply_chain/presentation/pages/representative_home_page.dart';
import '../../../supply_chain/presentation/pages/warehouse_home_page.dart';
import '../../../user/presentation/pages/user_dashboard_page.dart';

class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  int _activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(authControllerProvider).valueOrNull;
    if (session == null) return const SizedBox.shrink();
    final user = session.user;
    final unreadNotifications =
        ref.watch(notificationUnreadCountProvider).valueOrNull?.unreadCount ??
        0;
    final accountIndex = switch (user.primaryRole) {
      AppRole.admin => 3,
      AppRole.organization => 2,
      AppRole.warehouse || AppRole.representative => 2,
      _ => 4,
    };
    final dashboard = switch (user.primaryRole) {
      AppRole.user => UserDashboardPage(
        user: user,
        onOpenServices: () => context.push('/user/search'),
      ),
      AppRole.pharmacy => PharmacyDashboardPage(
        onOpenServices: () => context.push('/pharmacy/inventory'),
      ),
      AppRole.admin => const AdminHomePage(),
      AppRole.organization => const OrganizationHomePage(),
      AppRole.warehouse => const WarehouseHomePage(),
      AppRole.representative => const RepresentativeHomePage(),
    };
    final destinations = _destinationsForRole(
      user.primaryRole,
      onHome: () => setState(() => _activeIndex = 0),
      onAccount: () => setState(() => _activeIndex = accountIndex),
      onOpen: context.push,
    );
    final showAccount = _activeIndex == accountIndex;

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
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
              backgroundColor: AppColors.secondary,
              child: const Icon(Icons.notifications_none_rounded, size: 22),
            ),
          ),
          const SizedBox(width: 9),
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 16),
            child: ProfileAvatar(user: user, radius: 18),
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 360),
        reverseDuration: const Duration(milliseconds: 260),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          final slide = Tween<Offset>(
            begin: const Offset(0.035, 0),
            end: Offset.zero,
          ).animate(animation);
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(position: slide, child: child),
          );
        },
        child: KeyedSubtree(
          key: ValueKey(showAccount ? 'account' : 'dashboard'),
          child: showAccount ? SettingsPage(user: user) : dashboard,
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(14, 0, 14, 12),
        child: _DawaaiBottomBar(
          activeIndex: _activeIndex,
          destinations: destinations,
        ),
      ),
    );
  }
}

List<_BottomDestination> _destinationsForRole(
  AppRole role, {
  required VoidCallback onHome,
  required VoidCallback onAccount,
  required Future<Object?> Function(String location) onOpen,
}) {
  return switch (role) {
    AppRole.user => [
      _BottomDestination(
        label: 'الرئيسية',
        icon: Icons.home_outlined,
        selectedIcon: Icons.home_rounded,
        onTap: onHome,
      ),
      _BottomDestination(
        label: 'البحث',
        icon: Icons.search_rounded,
        selectedIcon: Icons.manage_search_rounded,
        onTap: () => onOpen('/user/search'),
      ),
      _BottomDestination(
        label: 'الصيدليات',
        icon: Icons.location_on_outlined,
        selectedIcon: Icons.location_on_rounded,
        onTap: () => onOpen('/user/nearby-pharmacies'),
      ),
      _BottomDestination(
        label: 'طلباتي',
        icon: Icons.receipt_long_outlined,
        selectedIcon: Icons.receipt_long_rounded,
        onTap: () => onOpen('/user/requests'),
      ),
      _BottomDestination(
        label: 'حسابي',
        icon: Icons.person_outline_rounded,
        selectedIcon: Icons.person_rounded,
        onTap: onAccount,
      ),
    ],
    AppRole.pharmacy => [
      _BottomDestination(
        label: 'الرئيسية',
        icon: Icons.home_outlined,
        selectedIcon: Icons.home_rounded,
        onTap: onHome,
      ),
      _BottomDestination(
        label: 'المخزون',
        icon: Icons.inventory_2_outlined,
        selectedIcon: Icons.inventory_2_rounded,
        onTap: () => onOpen('/pharmacy/inventory'),
      ),
      _BottomDestination(
        label: 'الطلبات',
        icon: Icons.assignment_outlined,
        selectedIcon: Icons.assignment_rounded,
        onTap: () => onOpen('/pharmacy/requests'),
      ),
      _BottomDestination(
        label: 'التوريد',
        icon: Icons.local_shipping_outlined,
        selectedIcon: Icons.local_shipping_rounded,
        onTap: () => onOpen('/supply-chain'),
      ),
      _BottomDestination(
        label: 'حسابي',
        icon: Icons.person_outline_rounded,
        selectedIcon: Icons.person_rounded,
        onTap: onAccount,
      ),
    ],
    AppRole.admin => [
      _BottomDestination(
        label: 'الرئيسية',
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard_rounded,
        onTap: onHome,
      ),
      _BottomDestination(
        label: 'الإدارة',
        icon: Icons.admin_panel_settings_outlined,
        selectedIcon: Icons.admin_panel_settings_rounded,
        onTap: () => onOpen('/admin/workspace'),
      ),
      _BottomDestination(
        label: 'الأدوية',
        icon: Icons.medication_outlined,
        selectedIcon: Icons.medication_rounded,
        onTap: () => onOpen('/medicines'),
      ),
      _BottomDestination(
        label: 'حسابي',
        icon: Icons.person_outline_rounded,
        selectedIcon: Icons.person_rounded,
        onTap: onAccount,
      ),
    ],
    AppRole.organization => [
      _BottomDestination(
        label: 'الرئيسية',
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard_rounded,
        onTap: onHome,
      ),
      _BottomDestination(
        label: 'إدارة المنظمة',
        icon: Icons.apartment_outlined,
        selectedIcon: Icons.apartment_rounded,
        onTap: () => onOpen('/organization/workspace'),
      ),
      _BottomDestination(
        label: 'حسابي',
        icon: Icons.person_outline_rounded,
        selectedIcon: Icons.person_rounded,
        onTap: onAccount,
      ),
    ],
    AppRole.warehouse => [
      _BottomDestination(
        label: 'الرئيسية',
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard_rounded,
        onTap: onHome,
      ),
      _BottomDestination(
        label: 'المستودع',
        icon: Icons.warehouse_outlined,
        selectedIcon: Icons.warehouse_rounded,
        onTap: () => onOpen('/supply-chain'),
      ),
      _BottomDestination(
        label: 'حسابي',
        icon: Icons.person_outline_rounded,
        selectedIcon: Icons.person_rounded,
        onTap: onAccount,
      ),
    ],
    AppRole.representative => [
      _BottomDestination(
        label: 'الرئيسية',
        icon: Icons.home_outlined,
        selectedIcon: Icons.home_rounded,
        onTap: onHome,
      ),
      _BottomDestination(
        label: 'مهامي',
        icon: Icons.delivery_dining_outlined,
        selectedIcon: Icons.delivery_dining_rounded,
        onTap: () => onOpen('/supply-chain'),
      ),
      _BottomDestination(
        label: 'حسابي',
        icon: Icons.person_outline_rounded,
        selectedIcon: Icons.person_rounded,
        onTap: onAccount,
      ),
    ],
  };
}

class _BottomDestination {
  const _BottomDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final VoidCallback onTap;
}

class _DawaaiBottomBar extends StatelessWidget {
  const _DawaaiBottomBar({
    required this.activeIndex,
    required this.destinations,
  });

  final int activeIndex;
  final List<_BottomDestination> destinations;

  @override
  Widget build(BuildContext context) => Container(
    height: 74,
    padding: const EdgeInsets.all(7),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(25),
      border: Border.all(color: AppColors.border),
      boxShadow: [
        BoxShadow(
          color: AppColors.shadow.withValues(alpha: 0.13),
          blurRadius: 26,
          offset: const Offset(0, 11),
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
                  destination.onTap();
                },
                borderRadius: BorderRadius.circular(18),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeOutCubic,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.surfaceSoft
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedScale(
                        scale: isSelected ? 1.08 : 1,
                        duration: const Duration(milliseconds: 260),
                        curve: Curves.easeOutBack,
                        child: Icon(
                          isSelected
                              ? destination.selectedIcon
                              : destination.icon,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textMuted,
                          size: 22,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        destination.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isSelected
                              ? AppColors.primaryDark
                              : AppColors.textMuted,
                          fontSize: destinations.length >= 5 ? 9.5 : 11,
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
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(width: 40, height: 40, child: Center(child: child)),
      ),
    ),
  );
}
