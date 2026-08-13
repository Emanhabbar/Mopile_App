import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_roles.dart';
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
    final role = user.primaryRole;
    final modules = modulesForRole(role);
    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= 700 ? 3 : 2;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          sliver: SliverList.list(
            children: [
              Text(
                'مرحبًا، ${user.fullName.split(' ').first}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 6),
              Text(
                _subtitle(role),
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
                            _bannerTitle(role),
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _bannerDescription(role),
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
                      'وصول سريع',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Text(
                    '${modules.length} خدمات',
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
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 112),
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

  String _subtitle(AppRole role) => switch (role) {
    AppRole.user => 'كل ما تحتاجه لصحتك ودوائك في مكان واحد.',
    AppRole.pharmacy => 'تابع عمل الصيدلية والطلبات بسهولة.',
    AppRole.organization => 'أدر المبادرات وطلبات المساعدة بوضوح.',
    AppRole.admin => 'راقب المنصة وأدر العمليات الأساسية.',
    AppRole.warehouse => 'أدر المخزون والطلبات والتوزيع من مكان واحد.',
    AppRole.representative => 'تابع الشحنات المسندة إليك خطوة بخطوة.',
  };

  String _bannerTitle(AppRole role) => switch (role) {
    AppRole.user => 'صحتك تبدأ بخطوة',
    AppRole.pharmacy => 'خدمة أسرع للمستخدمين',
    AppRole.organization => 'أثر يصل لمن يحتاجه',
    AppRole.admin => 'نظرة موحدة على المنصة',
    AppRole.warehouse => 'توريد منظم وموثوق',
    AppRole.representative => 'كل شحنة في موعدها',
  };

  String _bannerDescription(AppRole role) => switch (role) {
    AppRole.user => 'ابحث عن الدواء واعثر على أقرب صيدلية بثقة.',
    AppRole.pharmacy => 'حدّث المخزون وتابع الطلبات من لوحة واحدة.',
    AppRole.organization => 'تابع الحملات والتبرعات وطلبات المساعدة.',
    AppRole.admin => 'الموافقات والحسابات والإعلانات بين يديك.',
    AppRole.warehouse => 'تابع التشغيلات والطلبات والشحنات والمدفوعات.',
    AppRole.representative => 'حدّث حالة التوصيل حتى استلام الصيدلية.',
  };
}
