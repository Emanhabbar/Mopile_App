import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../auth/data/models/auth_session.dart';
import '../../data/role_modules.dart';
import '../navigation/module_navigation.dart';
import '../widgets/module_card.dart';

class ModulesPage extends StatelessWidget {
  const ModulesPage({required this.user, super.key});

  final AuthUser user;

  @override
  Widget build(BuildContext context) {
    final modules = modulesForRole(user.primaryRole);
    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= 900
        ? 4
        : width >= 600
        ? 3
        : 2;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
          sliver: SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: context.appColors.surfaceSoft,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: context.appColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: context.appColors.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.grid_view_rounded,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'خدماتك',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'كل ما تحتاجه في مكان واضح وسريع',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 112),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate((context, index) {
              final module = modules[index];
              final location = moduleLocationFor(
                user.primaryRole,
                module.routeName,
              );
              return ModuleCard(
                module: module,
                onTap: location == null ? null : () => context.push(location),
              );
            }, childCount: modules.length),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 11,
              mainAxisSpacing: 11,
              childAspectRatio: width >= 600 ? 1.28 : 1.03,
            ),
          ),
        ),
      ],
    );
  }
}
