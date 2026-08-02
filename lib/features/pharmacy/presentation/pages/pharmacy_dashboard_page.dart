import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/app_reveal.dart';
import '../../../../core/widgets/async_states.dart';
import '../../data/models/pharmacy_models.dart';
import '../controllers/pharmacy_providers.dart';

class PharmacyDashboardPage extends ConsumerWidget {
  const PharmacyDashboardPage({required this.onOpenServices, super.key});

  final VoidCallback onOpenServices;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pharmacyDashboardProvider);
    final openStatus = ref.watch(pharmacyOpenStatusProvider);
    return state.when(
      loading: () =>
          const AppLoadingState(label: 'نجهّز مركز تشغيل الصيدلية...'),
      error: (error, _) => AppErrorState(
        error: error,
        onRetry: () => ref.invalidate(pharmacyDashboardProvider),
      ),
      data: (data) => RefreshIndicator(
        onRefresh: () async {
          ref
            ..invalidate(pharmacyDashboardProvider)
            ..invalidate(pharmacyOpenStatusProvider);
          await Future.wait([
            ref.read(pharmacyDashboardProvider.future),
            ref.read(pharmacyOpenStatusProvider.future),
          ]);
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 112),
              sliver: SliverList.list(
                children: [
                  AppReveal(
                    child: _PharmacyHero(
                      data: data,
                      openStatus: openStatus.valueOrNull,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const _SectionHeader(
                    title: 'تشغيل الصيدلية',
                    subtitle: 'اختصارات لأهم مهامك اليومية',
                  ),
                  const SizedBox(height: 11),
                  AppReveal(
                    delay: const Duration(milliseconds: 70),
                    child: _OperationsGrid(
                      pendingRequests: data.pendingRequestsCount,
                      lowStock: data.lowStockCount,
                      onInventory: onOpenServices,
                      onRequests: () => context.push('/pharmacy/requests'),
                      onHours: () => context.push('/pharmacy/working-hours'),
                      onProfile: () => context.push('/pharmacy/profile'),
                    ),
                  ),
                  const SizedBox(height: 22),
                  const _SectionHeader(
                    title: 'نظرة سريعة',
                    subtitle: 'مؤشرات المخزون والطلبات الحالية',
                  ),
                  const SizedBox(height: 11),
                  AppReveal(
                    delay: const Duration(milliseconds: 120),
                    child: _MetricsGrid(data: data),
                  ),
                  const SizedBox(height: 22),
                  AppReveal(
                    delay: const Duration(milliseconds: 160),
                    child: _ReadinessCard(
                      data: data,
                      onLocation: () => context.push('/pharmacy/profile'),
                      onHours: () => context.push('/pharmacy/working-hours'),
                      onInventory: onOpenServices,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _SectionHeader(
                    title: 'تنبيهات المخزون',
                    subtitle: 'الأصناف التي تحتاج تدخلك قريبًا',
                    action: TextButton.icon(
                      onPressed: onOpenServices,
                      icon: const Icon(Icons.arrow_back_rounded, size: 17),
                      label: const Text('عرض الكل'),
                    ),
                  ),
                  const SizedBox(height: 11),
                  if ([
                    ...data.lowStockItems,
                    ...data.expiringSoonItems,
                  ].isEmpty)
                    const _HealthyInventoryCard()
                  else
                    ...[...data.lowStockItems, ...data.expiringSoonItems]
                        .take(5)
                        .toList()
                        .asMap()
                        .entries
                        .map(
                          (entry) => Padding(
                            padding: const EdgeInsets.only(bottom: 9),
                            child: AppReveal(
                              delay: Duration(
                                milliseconds: 200 + (entry.key * 45),
                              ),
                              child: _InventoryAlertCard(
                                alert: entry.value,
                                onTap: onOpenServices,
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => context.push('/pharmacy/prescriptions'),
                    icon: const Icon(Icons.receipt_long_rounded),
                    label: const Text('إدارة الوصفات الطبية'),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => context.push('/pharmacy/donations'),
                          icon: const Icon(Icons.verified_outlined),
                          label: const Text('التبرعات'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => context.push('/intelligence'),
                          icon: const Icon(Icons.auto_graph_rounded),
                          label: const Text('تحليل المخزون'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PharmacyHero extends StatelessWidget {
  const _PharmacyHero({required this.data, this.openStatus});

  final PharmacyDashboard data;
  final PharmacyOpenStatus? openStatus;

  @override
  Widget build(BuildContext context) {
    final isOpen = openStatus?.isOpenNow ?? data.isOpenNow;
    final status = openStatus?.statusText.isNotEmpty == true
        ? openStatus!.statusText
        : data.statusText.isNotEmpty
        ? data.statusText
        : isOpen
        ? 'مفتوحة الآن'
        : 'مغلقة الآن';
    final location = [
      data.area,
      data.city,
    ].where((part) => part.trim().isNotEmpty).join('، ');

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [AppColors.primaryDeep, Color(0xFF174F5B)],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.22),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          PositionedDirectional(
            top: -70,
            end: -55,
            child: _Orb(
              size: 180,
              color: AppColors.primary.withValues(alpha: 0.42),
            ),
          ),
          PositionedDirectional(
            bottom: -70,
            start: -50,
            child: _Orb(
              size: 150,
              color: AppColors.primaryLight.withValues(alpha: 0.07),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.12),
                        ),
                      ),
                      child: const Icon(
                        Icons.local_pharmacy_rounded,
                        color: AppColors.secondary,
                        size: 28,
                      ),
                    ),
                    const Spacer(),
                    _StatusPill(
                      text: status,
                      icon: isOpen
                          ? Icons.circle_rounded
                          : Icons.schedule_rounded,
                      color: isOpen ? AppColors.primaryLight : Colors.white70,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        data.pharmacyName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(color: Colors.white, fontSize: 25),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      data.isApproved
                          ? Icons.verified_rounded
                          : Icons.hourglass_top_rounded,
                      color: AppColors.secondary,
                      size: 23,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      data.hasLocation
                          ? Icons.location_on_rounded
                          : Icons.location_off_rounded,
                      color: Colors.white.withValues(alpha: 0.62),
                      size: 17,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        data.hasLocation && location.isNotEmpty
                            ? location
                            : 'أضف موقع الصيدلية لتظهر للمستخدمين',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _CompletionProgress(value: data.profileCompletionPercentage),
                const SizedBox(height: 15),
                Row(
                  children: [
                    _HeroMetric(
                      icon: Icons.star_rounded,
                      label: 'التقييم',
                      value: data.ratingsCount == 0
                          ? 'جديد'
                          : data.averageRating.toStringAsFixed(1),
                    ),
                    const SizedBox(width: 10),
                    _HeroMetric(
                      icon: Icons.assignment_rounded,
                      label: 'طلبات نشطة',
                      value: '${data.activeRequestsCount}',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OperationsGrid extends StatelessWidget {
  const _OperationsGrid({
    required this.pendingRequests,
    required this.lowStock,
    required this.onInventory,
    required this.onRequests,
    required this.onHours,
    required this.onProfile,
  });

  final int pendingRequests;
  final int lowStock;
  final VoidCallback onInventory;
  final VoidCallback onRequests;
  final VoidCallback onHours;
  final VoidCallback onProfile;

  @override
  Widget build(BuildContext context) {
    final operations = [
      (
        'المخزون',
        lowStock > 0 ? '$lowStock منخفض' : 'إدارة الأصناف',
        Icons.inventory_2_rounded,
        AppColors.primary,
        onInventory,
      ),
      (
        'الطلبات',
        pendingRequests > 0 ? '$pendingRequests بانتظارك' : 'متابعة الردود',
        Icons.assignment_rounded,
        const Color(0xFFB7791F),
        onRequests,
      ),
      (
        'ساعات العمل',
        'تنظيم الدوام',
        Icons.schedule_rounded,
        const Color(0xFF6D5AA8),
        onHours,
      ),
      (
        'ملف الصيدلية',
        'الموقع والبيانات',
        Icons.storefront_rounded,
        const Color(0xFF177C70),
        onProfile,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: operations.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 11,
        mainAxisSpacing: 11,
        childAspectRatio: 1.68,
      ),
      itemBuilder: (context, index) {
        final operation = operations[index];
        return _OperationCard(
          title: operation.$1,
          subtitle: operation.$2,
          icon: operation.$3,
          color: operation.$4,
          onTap: operation.$5,
        );
      },
    );
  }
}

class _OperationCard extends StatelessWidget {
  const _OperationCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(21),
        child: Ink(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.075),
            borderRadius: BorderRadius.circular(21),
            border: Border.all(color: color.withValues(alpha: 0.14)),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 21),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(fontSize: 13.5),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(fontSize: 10.5),
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

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid({required this.data});

  final PharmacyDashboard data;

  @override
  Widget build(BuildContext context) {
    final metrics = [
      (
        'أصناف المخزون',
        data.inventoryItemsCount,
        Icons.medication_rounded,
        AppColors.primary,
      ),
      (
        'متوفر',
        data.inStockCount,
        Icons.check_circle_rounded,
        AppColors.success,
      ),
      (
        'مخزون منخفض',
        data.lowStockCount,
        Icons.warning_amber_rounded,
        const Color(0xFFB7791F),
      ),
      (
        'نافد',
        data.outOfStockCount,
        Icons.remove_circle_outline_rounded,
        AppColors.danger,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: metrics.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.78,
      ),
      itemBuilder: (context, index) {
        final metric = metrics[index];
        return Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: metric.$4.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(metric.$3, color: metric.$4, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${metric.$2}',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(fontSize: 21),
                    ),
                    Text(
                      metric.$1,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(fontSize: 10.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ReadinessCard extends StatelessWidget {
  const _ReadinessCard({
    required this.data,
    required this.onLocation,
    required this.onHours,
    required this.onInventory,
  });

  final PharmacyDashboard data;
  final VoidCallback onLocation;
  final VoidCallback onHours;
  final VoidCallback onInventory;

  @override
  Widget build(BuildContext context) {
    final steps = [
      (
        data.isApproved,
        'اعتماد حساب الصيدلية',
        data.isApproved ? 'مكتمل' : 'بانتظار المراجعة',
        null,
      ),
      (
        data.hasLocation,
        'موقع الصيدلية',
        data.hasLocation ? 'تم تحديده' : 'مطلوب للظهور للمستخدمين',
        onLocation,
      ),
      (
        data.hasWorkingHoursConfigured,
        'ساعات العمل',
        data.hasWorkingHoursConfigured ? 'تم إعدادها' : 'حدد أوقات الدوام',
        onHours,
      ),
      (
        data.inventoryItemsCount > 0,
        'مخزون الأدوية',
        data.inventoryItemsCount > 0
            ? '${data.inventoryItemsCount} صنف'
            : 'أضف أول دواء',
        onInventory,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: AppColors.surfaceWarm,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.fact_check_rounded,
                  color: Color(0xFFB7791F),
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'جاهزية الصيدلية',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      '${data.profileCompletionPercentage}٪ من الملف مكتمل',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: data.profileCompletionPercentage.clamp(0, 100) / 100,
              minHeight: 7,
              backgroundColor: AppColors.surfaceSoft,
              color: data.profileCompletionPercentage >= 100
                  ? AppColors.success
                  : AppColors.secondary,
            ),
          ),
          const SizedBox(height: 14),
          ...steps.map(
            (step) => _ReadinessStep(
              complete: step.$1,
              title: step.$2,
              subtitle: step.$3,
              onTap: step.$1 ? null : step.$4,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadinessStep extends StatelessWidget {
  const _ReadinessStep({
    required this.complete,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final bool complete;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Icon(
                complete
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: complete ? AppColors.success : AppColors.textMuted,
                size: 22,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                const Icon(
                  Icons.chevron_left_rounded,
                  color: AppColors.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InventoryAlertCard extends StatelessWidget {
  const _InventoryAlertCard({required this.alert, required this.onTap});

  final PharmacyInventoryAlert alert;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final expiring = alert.alertType.toLowerCase().contains('expir');
    final color = expiring ? AppColors.danger : const Color(0xFFB7791F);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(19),
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.055),
            borderRadius: BorderRadius.circular(19),
            border: Border.all(color: color.withValues(alpha: 0.13)),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  expiring
                      ? Icons.event_busy_rounded
                      : Icons.warning_amber_rounded,
                  color: color,
                  size: 21,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alert.medicineName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      alert.daysUntilExpiry == null
                          ? 'الكمية ${alert.quantity} · الحد الأدنى ${alert.lowStockThreshold}'
                          : 'متبقي ${alert.daysUntilExpiry} يومًا على الانتهاء',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_left_rounded,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HealthyInventoryCard extends StatelessWidget {
  const _HealthyInventoryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.065),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.14)),
      ),
      child: const Row(
        children: [
          Icon(Icons.task_alt_rounded, color: AppColors.success),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'المخزون مستقر ولا توجد تنبيهات عاجلة',
              style: TextStyle(
                color: AppColors.success,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
    this.action,
  });

  final String title;
  final String subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 2),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
        ?action,
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.text,
    required this.icon,
    required this.color,
  });

  final String text;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 11),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompletionProgress extends StatelessWidget {
  const _CompletionProgress({required this.value});

  final int value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: value.clamp(0, 100) / 100,
              minHeight: 6,
              color: AppColors.secondary,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'اكتمال الملف $value٪',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.72),
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.075),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.secondary, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.55),
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    value,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Orb extends StatelessWidget {
  const _Orb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
