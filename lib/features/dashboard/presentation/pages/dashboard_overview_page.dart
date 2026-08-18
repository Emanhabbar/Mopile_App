import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_roles.dart';
import '../../../../core/constants/layout.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../auth/data/models/auth_session.dart';
import '../../data/role_modules.dart';
import '../navigation/module_navigation.dart';
import '../widgets/module_card.dart';
import '../widgets/home_ticker_panel.dart';

class DashboardOverviewPage extends StatelessWidget {
  const DashboardOverviewPage({required this.user, super.key});

  final AuthUser user;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final role = user.primaryRole;
    final modules = modulesForRole(l10n, role);
    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= 700 ? 3 : 2;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          sliver: SliverList.list(
            children: [
              Text(
                l10n.dashboardWelcome(user.fullName.split(' ').first),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 6),
              Text(
                _subtitle(l10n, role),
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: context.appColors.textMuted),
              ),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      context.appColors.primary,
                      context.appColors.primaryDark,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: [
                    BoxShadow(
                      color: context.appColors.primary.withValues(alpha: 0.2),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _bannerTitle(l10n, role),
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _bannerDescription(l10n, role),
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.84),
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(19),
                      ),
                      child: const Icon(
                        Icons.health_and_safety_rounded,
                        color: Colors.white,
                        size: 31,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const HomeTickerPanel(),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.quickAccessTitle,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Text(
                    l10n.dashboardServicesCount(modules.length),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: context.appColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
            ],
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, kBottomNavReserved),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate((context, index) {
              final module = modules[index];
              final location = moduleLocationFor(role, module.routeName);
              return ModuleCard(
                module: module,
                onTap: location == null ? null : () => context.push(location),
              );
            }, childCount: modules.length),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: width >= 700 ? 1.25 : 0.94,
            ),
          ),
        ),
      ],
    );
  }

  String _subtitle(AppLocalizations l10n, AppRole role) => switch (role) {
    AppRole.user => l10n.dashboardUserSubtitle,
    AppRole.pharmacy => l10n.dashboardPharmacySubtitle,
    AppRole.organization => l10n.dashboardOrganizationSubtitle,
    AppRole.admin => l10n.dashboardAdminSubtitle,
    AppRole.warehouse => l10n.dashboardWarehouseSubtitle,
    AppRole.representative => l10n.dashboardRepresentativeSubtitle,
  };

  String _bannerTitle(AppLocalizations l10n, AppRole role) => switch (role) {
    AppRole.user => l10n.dashboardBannerUser,
    AppRole.pharmacy => l10n.dashboardBannerPharmacy,
    AppRole.organization => l10n.dashboardBannerOrganization,
    AppRole.admin => l10n.dashboardBannerAdmin,
    AppRole.warehouse => l10n.dashboardBannerWarehouse,
    AppRole.representative => l10n.dashboardBannerRepresentative,
  };

  String _bannerDescription(AppLocalizations l10n, AppRole role) => switch (role) {
    AppRole.user => l10n.dashboardBannerDescUser,
    AppRole.pharmacy => l10n.dashboardBannerDescPharmacy,
    AppRole.organization => l10n.dashboardBannerDescOrganization,
    AppRole.admin => l10n.dashboardBannerDescAdmin,
    AppRole.warehouse => l10n.dashboardBannerDescWarehouse,
    AppRole.representative => l10n.dashboardBannerDescRepresentative,
  };
}
