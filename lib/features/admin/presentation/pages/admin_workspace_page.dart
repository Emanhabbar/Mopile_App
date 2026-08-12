import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../../core/widgets/app_reveal.dart';
import '../../../../core/widgets/async_states.dart';
import '../../../pharmacy_discovery/data/repositories/pharmacy_discovery_repository.dart';
import '../../data/models/admin_models.dart';
import '../../data/repositories/admin_repository.dart';
import '../controllers/admin_providers.dart';

class AdminWorkspacePage extends ConsumerStatefulWidget {
  const AdminWorkspacePage({this.initialSection = 0, super.key});

  final int initialSection;

  @override
  ConsumerState<AdminWorkspacePage> createState() => _AdminWorkspacePageState();
}

class _AdminWorkspacePageState extends ConsumerState<AdminWorkspacePage> {
  String? _workingId;
  late int _selectedSection;

  @override
  void initState() {
    super.initState();
    _selectedSection = widget.initialSection.clamp(0, 3);
  }

  @override
  void didUpdateWidget(covariant AdminWorkspacePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSection != widget.initialSection) {
      _selectedSection = widget.initialSection.clamp(0, 3);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dashboard = ref.watch(adminDashboardProvider);
    final pending = dashboard.valueOrNull == null
        ? null
        : dashboard.valueOrNull!.pendingPharmacies +
              dashboard.valueOrNull!.pendingOrganizationVerifications +
              dashboard.valueOrNull!.pendingWarehouses;
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('مركز الإدارة'),
            Text(
              'إدارة منصة دوائي ومتابعة عملياتها',
              style: TextStyle(
                color: Color(0xFF668087),
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _refreshCurrentSection,
            tooltip: 'تحديث',
            icon: const Icon(Icons.refresh_rounded),
          ),
          IconButton(
            onPressed: _workingId == 'location-service'
                ? null
                : _showLocationService,
            tooltip: 'خدمة مواقع الصيدليات',
            icon: const Icon(Icons.cloud_sync_outlined),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
            child: AppReveal(
              child: _AdminSectionNavigation(
                selectedIndex: _selectedSection,
                pendingCount: pending,
                onSelected: (value) => setState(() => _selectedSection = value),
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, .018),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              ),
              child: KeyedSubtree(
                key: ValueKey(_selectedSection),
                child: switch (_selectedSection) {
                  0 => const _DashboardTab(),
                  1 => _ApprovalsTab(
                    workingId: _workingId,
                    onPharmacy: _approvePharmacy,
                    onOrganization: _reviewOrganization,
                    onWarehouse: _approveWarehouse,
                  ),
                  2 => _AccountsTab(
                    workingId: _workingId,
                    onStatus: _updateAccount,
                  ),
                  _ => _TickerTab(
                    workingId: _workingId,
                    onSave: _saveTicker,
                    onDelete: _deleteTicker,
                  ),
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _refreshCurrentSection() {
    switch (_selectedSection) {
      case 0:
        ref.invalidate(adminDashboardProvider);
        break;
      case 1:
        _refreshApprovals();
        break;
      case 2:
        ref.invalidate(adminAccountsProvider);
        break;
      default:
        ref.invalidate(adminTickerProvider);
    }
  }

  Future<void> _approvePharmacy(String id, bool approved) => _run(id, () async {
    await ref.read(adminRepositoryProvider).approvePharmacy(id, approved);
    _refreshApprovals();
  });

  Future<void> _approveWarehouse(String id, bool approved) =>
      _run(id, () async {
        await ref.read(adminRepositoryProvider).approveWarehouse(id, approved);
        _refreshApprovals();
      });

  Future<void> _reviewOrganization(
    AdminOrganization organization,
    bool approved,
  ) => _run(organization.organizationId, () async {
    if (organization.verificationDocumentsCount > 0) {
      await ref
          .read(adminRepositoryProvider)
          .reviewOrganization(
            organization.organizationId,
            status: approved ? 'Approved' : 'NeedsUpdate',
            notes: approved
                ? 'تمت مراجعة وثائق المنظمة واعتمادها.'
                : 'يرجى تحديث وثائق التحقق المطلوبة.',
          );
    } else {
      await ref
          .read(adminRepositoryProvider)
          .approveOrganization(organization.organizationId, approved);
    }
    _refreshApprovals();
  });

  Future<void> _updateAccount(AdminAccount account) async {
    String? reason;
    if (account.isActive) {
      final controller = TextEditingController();
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('إيقاف الحساب'),
          content: TextField(
            controller: controller,
            minLines: 3,
            maxLines: 5,
            maxLength: 500,
            decoration: const InputDecoration(
              labelText: 'سبب الإيقاف',
              helperText: 'اكتب سببًا واضحًا لا يقل عن 10 أحرف.',
              alignLabelWithHint: true,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('إلغاء'),
            ),
            FilledButton(
              onPressed: () {
                if (controller.text.trim().length < 10) return;
                Navigator.pop(dialogContext, true);
              },
              child: const Text('إيقاف الحساب'),
            ),
          ],
        ),
      );
      reason = controller.text.trim();
      controller.dispose();
      if (confirmed != true) return;
    }
    await _run(account.userId, () async {
      await ref
          .read(adminRepositoryProvider)
          .updateAccountStatus(
            account.userId,
            !account.isActive,
            reason: reason,
          );
      ref.invalidate(adminAccountsProvider);
    });
  }

  Future<void> _saveTicker(HomeTickerItem? item) async {
    final pharmacies = await ref
        .read(adminRepositoryProvider)
        .getTickerPharmacies();
    if (!mounted) return;
    final title = TextEditingController(text: item?.title);
    final message = TextEditingController(text: item?.message);
    var active = item?.isActive ?? true;
    var type = item?.type ?? 'Announcement';
    String? pharmacyId = item?.pharmacyProfileId;
    final save = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            0,
            20,
            20 + MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 47,
                      height: 47,
                      decoration: BoxDecoration(
                        color: context.appColors.surfaceSoft,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.campaign_outlined,
                        color: Color(0xFF216474),
                      ),
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item == null ? 'محتوى جديد' : 'تعديل المحتوى',
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const Text(
                            'سيظهر هذا المحتوى في الصفحة الرئيسية للمستخدمين.',
                            style: TextStyle(
                              color: Color(0xFF668087),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                DropdownButtonFormField<String>(
                  initialValue: type,
                  decoration: const InputDecoration(
                    labelText: 'نوع المحتوى',
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Announcement',
                      child: Text('إعلان عام'),
                    ),
                    DropdownMenuItem(
                      value: 'DutyPharmacy',
                      child: Text('صيدلية مناوبة'),
                    ),
                  ],
                  onChanged: (value) =>
                      setSheetState(() => type = value ?? type),
                ),
                if (type == 'DutyPharmacy') ...[
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    initialValue:
                        pharmacies.any((item) => item.id == pharmacyId)
                        ? pharmacyId
                        : null,
                    decoration: const InputDecoration(
                      labelText: 'الصيدلية المناوبة',
                      prefixIcon: Icon(Icons.local_pharmacy_outlined),
                    ),
                    items: pharmacies
                        .map(
                          (pharmacy) => DropdownMenuItem(
                            value: pharmacy.id,
                            child: Text(pharmacy.name),
                          ),
                        )
                        .toList(growable: false),
                    onChanged: (value) =>
                        setSheetState(() => pharmacyId = value),
                  ),
                ],
                const SizedBox(height: 10),
                TextField(
                  controller: title,
                  maxLength: 150,
                  decoration: const InputDecoration(
                    labelText: 'العنوان',
                    prefixIcon: Icon(Icons.title_rounded),
                  ),
                ),
                TextField(
                  controller: message,
                  maxLength: 500,
                  minLines: 3,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'النص الظاهر للمستخدم',
                    alignLabelWithHint: true,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: context.appColors.surfaceSoft,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: SwitchListTile(
                    title: const Text('نشر المحتوى'),
                    subtitle: Text(
                      active ? 'ظاهر حاليًا للمستخدمين' : 'محفوظ دون نشر',
                    ),
                    secondary: Icon(
                      active
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    value: active,
                    onChanged: (value) => setSheetState(() => active = value),
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => Navigator.pop(sheetContext, true),
                    icon: const Icon(Icons.check_rounded),
                    label: const Text('حفظ المحتوى'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (save == true &&
        title.text.trim().length >= 2 &&
        message.text.trim().length >= 2 &&
        (type != 'DutyPharmacy' || pharmacyId != null)) {
      await _run(item?.id ?? 'ticker-new', () async {
        await ref
            .read(adminRepositoryProvider)
            .saveTicker(
              id: item?.id,
              type: type,
              title: title.text.trim(),
              message: message.text.trim(),
              active: active,
              pharmacyProfileId: pharmacyId,
            );
        ref.invalidate(adminTickerProvider);
      });
    }
    title.dispose();
    message.dispose();
  }

  Future<void> _deleteTicker(String id) => _run(id, () async {
    await ref.read(adminRepositoryProvider).deleteTicker(id);
    ref.invalidate(adminTickerProvider);
  });

  Future<void> _showLocationService() async {
    setState(() => _workingId = 'location-service');
    try {
      final health = await ref
          .read(pharmacyDiscoveryRepositoryProvider)
          .getHealth();
      if (!mounted) return;
      final clear = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('خدمة مواقع الصيدليات'),
          content: Row(
            children: [
              Icon(
                health.isHealthy
                    ? Icons.check_circle_rounded
                    : Icons.error_outline_rounded,
                color: health.isHealthy ? context.appColors.primary : context.appColors.danger,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  health.isHealthy
                      ? 'الخدمة تعمل بصورة طبيعية.'
                      : 'الخدمة لا تستجيب بالصورة المتوقعة.',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('إغلاق'),
            ),
            FilledButton.tonalIcon(
              onPressed: () => Navigator.pop(dialogContext, true),
              icon: const Icon(Icons.cleaning_services_outlined),
              label: const Text('تنظيف البيانات القديمة'),
            ),
          ],
        ),
      );
      if (clear == true) {
        final message = await ref
            .read(pharmacyDiscoveryRepositoryProvider)
            .clearCache();
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
        }
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_error(error)),
            backgroundColor: context.appColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _workingId = null);
    }
  }

  void _refreshApprovals() {
    ref
      ..invalidate(adminPendingPharmaciesProvider)
      ..invalidate(adminPendingOrganizationsProvider)
      ..invalidate(adminPendingWarehousesProvider)
      ..invalidate(adminDashboardProvider);
  }

  Future<void> _run(String id, Future<void> Function() action) async {
    setState(() => _workingId = id);
    try {
      await action();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('تم حفظ التحديث.')));
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_error(error)),
            backgroundColor: context.appColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _workingId = null);
    }
  }
}

class _AdminSectionNavigation extends StatelessWidget {
  const _AdminSectionNavigation({
    required this.selectedIndex,
    required this.onSelected,
    this.pendingCount,
  });
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final int? pendingCount;

  @override
  Widget build(BuildContext context) {
    final items = <({String label, IconData icon, int? count})>[
      (label: 'الملخص', icon: Icons.grid_view_rounded, count: null),
      (
        label: 'الموافقات',
        icon: Icons.fact_check_outlined,
        count: pendingCount,
      ),
      (label: 'الحسابات', icon: Icons.manage_accounts_outlined, count: null),
      (label: 'الإعلانات', icon: Icons.campaign_outlined, count: null),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items
            .asMap()
            .entries
            .map((entry) {
              final selected = selectedIndex == entry.key;
              final item = entry.value;
              return Padding(
                padding: const EdgeInsetsDirectional.only(end: 8),
                child: Material(
                  color: selected ? context.appColors.primaryDeep : context.appColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                    side: BorderSide(
                      color: selected
                          ? context.appColors.primaryDeep
                          : context.appColors.border,
                    ),
                  ),
                  child: InkWell(
                    onTap: () => onSelected(entry.key),
                    borderRadius: BorderRadius.circular(17),
                    child: AnimatedPadding(
                      duration: const Duration(milliseconds: 220),
                      padding: EdgeInsets.symmetric(
                        horizontal: selected ? 17 : 14,
                        vertical: 11,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            item.icon,
                            size: 19,
                            color: selected ? Colors.white : context.appColors.primary,
                          ),
                          const SizedBox(width: 7),
                          Text(
                            item.label,
                            style: TextStyle(
                              color: selected ? Colors.white : context.appColors.text,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          if ((item.count ?? 0) > 0) ...[
                            const SizedBox(width: 7),
                            Container(
                              constraints: const BoxConstraints(minWidth: 20),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: context.appColors.secondary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${item.count}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xFF102F37),
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            })
            .toList(growable: false),
      ),
    );
  }
}

class _DashboardTab extends ConsumerWidget {
  const _DashboardTab();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminDashboardProvider);
    return state.when(
      loading: () => const AppLoadingState(label: 'جاري تحميل المؤشرات...'),
      error: (error, _) => AppErrorState(
        error: error,
        onRetry: () => ref.invalidate(adminDashboardProvider),
      ),
      data: (data) {
        final values = [
          ('المستخدمون', data.totalUsers, Icons.people_rounded),
          ('حسابات نشطة', data.activeUsers, Icons.verified_user_rounded),
          ('الصيدليات', data.totalPharmacies, Icons.local_pharmacy_rounded),
          (
            'صيدليات معلقة',
            data.pendingPharmacies,
            Icons.hourglass_top_rounded,
          ),
          ('المنظمات', data.totalOrganizations, Icons.apartment_rounded),
          ('المستودعات', data.totalWarehouses, Icons.warehouse_rounded),
          (
            'مستودعات معلقة',
            data.pendingWarehouses,
            Icons.inventory_2_outlined,
          ),
          (
            'تحقق منظمات',
            data.pendingOrganizationVerifications,
            Icons.fact_check_outlined,
          ),
          (
            'طلبات الأدوية',
            data.totalMedicineRequests,
            Icons.receipt_long_rounded,
          ),
          (
            'تبرعات',
            data.totalDonationOffers,
            Icons.volunteer_activism_rounded,
          ),
        ];
        return RefreshIndicator(
          onRefresh: () => ref.refresh(adminDashboardProvider.future),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
            children: [
              AppReveal(child: _AdminHero(data: data)),
              const SizedBox(height: 22),
              const _AdminSectionHeading(
                eyebrow: 'المشهد العام',
                title: 'مؤشرات المنصة',
                subtitle:
                    'الأرقام الأساسية وحالات الاعتماد التي تتطلب المتابعة.',
              ),
              const SizedBox(height: 11),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: values.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.45,
                ),
                itemBuilder: (context, index) => _MetricCard(
                  label: values[index].$1,
                  value: values[index].$2,
                  icon: values[index].$3,
                  highlighted:
                      values[index].$1.contains('معلقة') ||
                      values[index].$1.contains('تحقق'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AdminHero extends StatelessWidget {
  const _AdminHero({required this.data});

  final AdminDashboard data;

  @override
  Widget build(BuildContext context) {
    final pending =
        data.pendingPharmacies +
        data.pendingOrganizationVerifications +
        data.pendingWarehouses;
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF102F37), Color(0xFF216474)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(27),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          PositionedDirectional(
            top: -75,
            end: -45,
            child: Container(
              width: 190,
              height: 190,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: .055),
              ),
            ),
          ),
          PositionedDirectional(
            bottom: -60,
            start: -40,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.appColors.secondary.withValues(alpha: .065),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .12),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        Icons.admin_panel_settings_rounded,
                        color: Color(0xFFF5CB72),
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 13),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'نبض منصة دوائي',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            'نظرة موحدة على الحسابات والجهات والخدمات',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: pending > 0
                            ? context.appColors.secondary.withValues(alpha: .18)
                            : Colors.white.withValues(alpha: .1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: .09),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '$pending',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const Text(
                            'تحتاج قرارًا',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 8.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    _AdminHeroMetric(
                      label: 'حساب نشط',
                      value: data.activeUsers,
                    ),
                    _AdminHeroMetric(
                      label: 'نقاط دوائية',
                      value: data.totalPharmacies + data.totalWarehouses,
                    ),
                    _AdminHeroMetric(
                      label: 'منظمات',
                      value: data.totalOrganizations,
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

class _AdminHeroMetric extends StatelessWidget {
  const _AdminHeroMetric({required this.label, required this.value});
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      margin: const EdgeInsetsDirectional.only(end: 7),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            '$value',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            label,
            maxLines: 1,
            style: const TextStyle(color: Colors.white60, fontSize: 9),
          ),
        ],
      ),
    ),
  );
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.highlighted,
  });
  final String label;
  final int value;
  final IconData icon;
  final bool highlighted;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: highlighted ? context.appColors.surfaceWarm : Colors.white,
      borderRadius: BorderRadius.circular(19),
      border: Border.all(
        color: highlighted
            ? context.appColors.secondary.withValues(alpha: .38)
            : context.appColors.border,
      ),
    ),
    child: Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: highlighted
                ? context.appColors.secondary.withValues(alpha: .18)
                : context.appColors.surfaceSoft,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(
            icon,
            color: highlighted ? context.appColors.warning : context.appColors.primary,
            size: 21,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$value',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _ApprovalsTab extends ConsumerWidget {
  const _ApprovalsTab({
    required this.workingId,
    required this.onPharmacy,
    required this.onOrganization,
    required this.onWarehouse,
  });
  final String? workingId;
  final Future<void> Function(String, bool) onPharmacy;
  final Future<void> Function(AdminOrganization, bool) onOrganization;
  final Future<void> Function(String, bool) onWarehouse;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pharmacies = ref.watch(adminPendingPharmaciesProvider);
    final organizations = ref.watch(adminPendingOrganizationsProvider);
    final warehouses = ref.watch(adminPendingWarehousesProvider);
    return RefreshIndicator(
      onRefresh: () async {
        ref
          ..invalidate(adminPendingPharmaciesProvider)
          ..invalidate(adminPendingOrganizationsProvider)
          ..invalidate(adminPendingWarehousesProvider);
        await Future.wait([
          ref.read(adminPendingPharmaciesProvider.future),
          ref.read(adminPendingOrganizationsProvider.future),
          ref.read(adminPendingWarehousesProvider.future),
        ]);
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
        children: [
          const _AdminSectionHeading(
            eyebrow: 'قرارات الاعتماد',
            title: 'طلبات تحتاج مراجعتك',
            subtitle: 'تحقق من بيانات الجهة قبل منحها صلاحية العمل على المنصة.',
          ),
          const SizedBox(height: 16),
          _ApprovalGroup<AdminPharmacy>(
            title: 'الصيدليات',
            icon: Icons.local_pharmacy_outlined,
            color: context.appColors.primary,
            state: pharmacies,
            builder: (item) => _ApprovalCard(
              icon: Icons.local_pharmacy_outlined,
              color: context.appColors.primary,
              title: item.pharmacyName,
              subtitle: '${item.ownerFullName} · ${item.licenseNumber}',
              location: '${item.city}، ${item.area}',
              working: workingId == item.pharmacyId,
              onApprove: () => onPharmacy(item.pharmacyId, true),
              onReject: () => onPharmacy(item.pharmacyId, false),
              onDetails: () => _showPharmacyLicense(context, ref, item),
            ),
          ),
          const SizedBox(height: 18),
          _ApprovalGroup<AdminOrganization>(
            title: 'المنظمات',
            icon: Icons.apartment_outlined,
            color: const Color(0xFF8A5AC2),
            state: organizations,
            builder: (item) => _ApprovalCard(
              icon: Icons.apartment_outlined,
              color: const Color(0xFF8A5AC2),
              title: item.organizationName,
              subtitle:
                  '${item.ownerFullName} · ${item.verificationDocumentsCount} وثائق',
              location: '${item.city}، ${item.area}',
              working: workingId == item.organizationId,
              onApprove: () => onOrganization(item, true),
              onReject: () => onOrganization(item, false),
            ),
          ),
          const SizedBox(height: 18),
          _ApprovalGroup<AdminWarehouse>(
            title: 'المستودعات',
            icon: Icons.warehouse_outlined,
            color: const Color(0xFF3977C4),
            state: warehouses,
            builder: (item) => _ApprovalCard(
              icon: Icons.warehouse_outlined,
              color: const Color(0xFF3977C4),
              title: item.warehouseName,
              subtitle: '${item.ownerFullName} · ${item.licenseNumber}',
              location: '${item.city}، ${item.area}',
              working: workingId == item.warehouseId,
              onApprove: () => onWarehouse(item.warehouseId, true),
              onReject: () => onWarehouse(item.warehouseId, false),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showPharmacyLicense(
    BuildContext context,
    WidgetRef ref,
    AdminPharmacy pharmacy,
  ) async {
    try {
      final verification = await ref
          .read(adminRepositoryProvider)
          .getPharmacyLicenseVerification(pharmacy.pharmacyId);
      if (!context.mounted) return;
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('تفاصيل ترخيص الصيدلية'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _licenseRow('الحالة', verification.status),
                _licenseRow('الاسم المسجل', verification.registeredName),
                if (verification.extractedName != null)
                  _licenseRow('الاسم في الوثيقة', verification.extractedName!),
                if (verification.registryNumber != null)
                  _licenseRow('رقم السجل', verification.registryNumber!),
                if (verification.matchScore != null)
                  _licenseRow(
                    'درجة التطابق',
                    '${(verification.matchScore! * 100).toStringAsFixed(1)}%',
                  ),
                if (verification.rejectionReason != null)
                  _licenseRow('سبب الرفض', verification.rejectionReason!),
                if (verification.failureReason != null)
                  _licenseRow('مشكلة القراءة', verification.failureReason!),
                if (verification.manualReviewNote != null)
                  _licenseRow(
                    'ملاحظة المراجعة',
                    verification.manualReviewNote!,
                  ),
              ],
            ),
          ),
          actions: [
            TextButton.icon(
              onPressed: () => _showLicenseDocument(
                dialogContext,
                ref,
                pharmacy.pharmacyId,
                verification.verificationId,
              ),
              icon: const Icon(Icons.image_outlined),
              label: const Text('عرض الوثيقة'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('إغلاق'),
            ),
          ],
        ),
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_error(error)),
          backgroundColor: context.appColors.danger,
        ),
      );
    }
  }

  Widget _licenseRow(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text('$label: $value'),
  );

  Future<void> _showLicenseDocument(
    BuildContext context,
    WidgetRef ref,
    String pharmacyId,
    String verificationId,
  ) async {
    try {
      final document = await ref
          .read(adminRepositoryProvider)
          .getPharmacyLicenseDocument(pharmacyId, verificationId);
      if (!context.mounted) return;
      await showDialog<void>(
        context: context,
        builder: (documentContext) => Dialog(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: InteractiveViewer(
              minScale: .8,
              maxScale: 5,
              child: Image.memory(
                Uint8List.fromList(document.bytes),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_error(error)),
          backgroundColor: context.appColors.danger,
        ),
      );
    }
  }
}

class _AccountsTab extends ConsumerStatefulWidget {
  const _AccountsTab({required this.workingId, required this.onStatus});
  final String? workingId;
  final Future<void> Function(AdminAccount) onStatus;

  @override
  ConsumerState<_AccountsTab> createState() => _AccountsTabState();
}

class _AccountsTabState extends ConsumerState<_AccountsTab> {
  final _search = TextEditingController();
  String _query = '';
  String? _role;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminAccountsProvider);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Column(
            children: [
              const _AdminSectionHeading(
                eyebrow: 'دليل الحسابات',
                title: 'مستخدمو المنصة',
                subtitle: 'ابحث عن الحسابات وراجع حالتها ودورها.',
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _search,
                onChanged: (value) => setState(() => _query = value.trim()),
                decoration: InputDecoration(
                  hintText: 'ابحث بالاسم أو البريد الإلكتروني',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            _search.clear();
                            setState(() => _query = '');
                          },
                          icon: const Icon(Icons.close_rounded),
                        ),
                ),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _RoleFilter(
                      label: 'الكل',
                      selected: _role == null,
                      onTap: () => setState(() => _role = null),
                    ),
                    for (final role in const [
                      'User',
                      'Pharmacy',
                      'Organization',
                      'Warehouse',
                      'Representative',
                    ])
                      _RoleFilter(
                        label: _roleLabel(role),
                        selected: _role == role,
                        onTap: () => setState(() => _role = role),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: state.when(
            loading: () =>
                const AppLoadingState(label: 'جاري تحميل الحسابات...'),
            error: (error, _) => AppErrorState(
              error: error,
              onRetry: () => ref.invalidate(adminAccountsProvider),
            ),
            data: (items) {
              final query = _query.toLowerCase();
              final filtered = items
                  .where((item) {
                    final matchesRole = _role == null || item.role == _role;
                    final matchesQuery =
                        query.isEmpty ||
                        item.fullName.toLowerCase().contains(query) ||
                        item.email.toLowerCase().contains(query) ||
                        (item.profileName?.toLowerCase().contains(query) ??
                            false);
                    return matchesRole && matchesQuery;
                  })
                  .toList(growable: false);
              if (filtered.isEmpty) {
                return const _AdminEmptyState(
                  icon: Icons.manage_search_rounded,
                  title: 'لا توجد نتائج مطابقة',
                  subtitle: 'غيّر كلمات البحث أو اختر دورًا آخر.',
                );
              }
              return RefreshIndicator(
                onRefresh: () => ref.refresh(adminAccountsProvider.future),
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 30),
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 9),
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    return _AccountCard(
                      account: item,
                      working: widget.workingId == item.userId,
                      onStatus: () => widget.onStatus(item),
                      onDetails: () => _showAccountDetails(item),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _showAccountDetails(AdminAccount account) async {
    try {
      final details = await ref
          .read(adminRepositoryProvider)
          .getAccountDetails(account.userId);
      if (!mounted) return;
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (context) =>
            _AccountDetailsSheet(account: account, details: details),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_error(error)),
          backgroundColor: context.appColors.danger,
        ),
      );
    }
  }
}

class _TickerTab extends ConsumerWidget {
  const _TickerTab({
    required this.workingId,
    required this.onSave,
    required this.onDelete,
  });
  final String? workingId;
  final Future<void> Function(HomeTickerItem?) onSave;
  final Future<void> Function(String) onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminTickerProvider);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
          child: _AdminSectionHeading(
            eyebrow: 'المحتوى المباشر',
            title: 'شريط الصفحة الرئيسية',
            subtitle:
                'أدر الإعلانات العامة والصيدليات المناوبة الظاهرة للمستخدمين.',
            action: IconButton.filled(
              onPressed: () => onSave(null),
              tooltip: 'إضافة إعلان',
              icon: const Icon(Icons.add_rounded),
            ),
          ),
        ),
        Expanded(
          child: state.when(
            loading: () => const AppLoadingState(label: 'جاري التحميل...'),
            error: (error, _) => AppErrorState(
              error: error,
              onRetry: () => ref.invalidate(adminTickerProvider),
            ),
            data: (items) => items.isEmpty
                ? const _AdminEmptyState(
                    icon: Icons.campaign_outlined,
                    title: 'لا يوجد محتوى منشور',
                    subtitle: 'أضف إعلانًا أو صيدلية مناوبة لتظهر في الرئيسية.',
                  )
                : RefreshIndicator(
                    onRefresh: () => ref.refresh(adminTickerProvider.future),
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                      itemCount: items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return _TickerCard(
                          item: item,
                          working: workingId == item.id,
                          onEdit: () => onSave(item),
                          onDelete: () => onDelete(item.id),
                        );
                      },
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

class _AdminSectionHeading extends StatelessWidget {
  const _AdminSectionHeading({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    this.action,
  });
  final String eyebrow;
  final String title;
  final String subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              eyebrow,
              style: const TextStyle(
                color: Color(0xFF216474),
                fontSize: 10.5,
                fontWeight: FontWeight.w900,
                letterSpacing: .3,
              ),
            ),
            const SizedBox(height: 2),
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

class _ApprovalGroup<T> extends StatelessWidget {
  const _ApprovalGroup({
    required this.title,
    required this.icon,
    required this.color,
    required this.state,
    required this.builder,
  });
  final String title;
  final IconData icon;
  final Color color;
  final AsyncValue<List<T>> state;
  final Widget Function(T) builder;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .08),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(title, style: Theme.of(context).textTheme.titleMedium),
          ),
          if (state.valueOrNull != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                color: color.withValues(alpha: .08),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                '${state.valueOrNull!.length}',
                style: TextStyle(color: color, fontWeight: FontWeight.w900),
              ),
            ),
        ],
      ),
      const SizedBox(height: 10),
      state.when(
        loading: () => const LinearProgressIndicator(),
        error: (error, _) => Text(_error(error)),
        data: (items) => items.isEmpty
            ? Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: context.appColors.surfaceSoft,
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Row(
                  children: [
                    Icon(Icons.task_alt_rounded, color: color, size: 19),
                    const SizedBox(width: 8),
                    Text('لا توجد طلبات معلقة ضمن هذا القسم.'),
                  ],
                ),
              )
            : Column(
                children: items
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 9),
                        child: builder(item),
                      ),
                    )
                    .toList(growable: false),
              ),
      ),
    ],
  );
}

class _ApprovalCard extends StatelessWidget {
  const _ApprovalCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.location,
    required this.working,
    required this.onApprove,
    required this.onReject,
    this.onDetails,
  });
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String location;
  final bool working;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback? onDetails;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .08),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 11),
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
              if (working)
                const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 17,
                color: Color(0xFF668087),
              ),
              const SizedBox(width: 5),
              Text(location, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
          const Divider(height: 23),
          if (onDetails != null) ...[
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: working ? null : onDetails,
                icon: const Icon(Icons.badge_outlined),
                label: const Text('مراجعة الترخيص والوثيقة'),
              ),
            ),
            const SizedBox(height: 4),
          ],
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: working ? null : onApprove,
                  child: const Text('اعتماد الجهة'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: working ? null : onReject,
                  child: const Text('رفض'),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class _RoleFilter extends StatelessWidget {
  const _RoleFilter({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.only(end: 7),
    child: ChoiceChip(
      label: Text(label),
      selected: selected,
      showCheckmark: false,
      onSelected: (_) => onTap(),
      labelStyle: TextStyle(
        color: selected ? Colors.white : context.appColors.text,
        fontWeight: FontWeight.w800,
      ),
      selectedColor: context.appColors.primaryDeep,
      backgroundColor: context.appColors.surface,
      side: BorderSide(
        color: selected ? context.appColors.primaryDeep : context.appColors.border,
      ),
    ),
  );
}

class _AccountCard extends StatelessWidget {
  const _AccountCard({
    required this.account,
    required this.working,
    required this.onStatus,
    required this.onDetails,
  });
  final AdminAccount account;
  final bool working;
  final VoidCallback onStatus;
  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) {
    final color = _roleColor(account.role);
    return Card(
      child: InkWell(
        onTap: onDetails,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .09),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(_roleIcon(account.role), color: color),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account.profileName ?? account.fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    Text(
                      account.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        _AdminPill(
                          label: _roleLabel(account.role),
                          color: color,
                        ),
                        const SizedBox(width: 6),
                        _AdminPill(
                          label: account.isActive ? 'نشط' : 'موقوف',
                          color: account.isActive
                              ? context.appColors.success
                              : context.appColors.danger,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Switch(
                value: account.isActive,
                onChanged: working ? null : (_) => onStatus(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccountDetailsSheet extends StatelessWidget {
  const _AccountDetailsSheet({required this.account, required this.details});
  final AdminAccount account;
  final Map<String, dynamic> details;

  @override
  Widget build(BuildContext context) {
    final rows = <({String label, String value, IconData icon})>[
      (
        label: 'الاسم',
        value: details['profileName']?.toString() ?? account.fullName,
        icon: Icons.person_outline_rounded,
      ),
      (label: 'البريد', value: account.email, icon: Icons.mail_outline_rounded),
      (
        label: 'الدور',
        value: _roleLabel(account.role),
        icon: Icons.badge_outlined,
      ),
      if (details['phoneNumber']?.toString().isNotEmpty == true)
        (
          label: 'الهاتف',
          value: details['phoneNumber'].toString(),
          icon: Icons.phone_outlined,
        ),
      if (details['city']?.toString().isNotEmpty == true)
        (
          label: 'الموقع',
          value:
              '${details['city'] ?? ''}، ${details['area'] ?? ''} · ${details['address'] ?? ''}',
          icon: Icons.location_on_outlined,
        ),
      if (details['licenseOrRegistrationNumber']?.toString().isNotEmpty == true)
        (
          label: 'رقم الاعتماد',
          value: details['licenseOrRegistrationNumber'].toString(),
          icon: Icons.verified_outlined,
        ),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _roleColor(account.role).withValues(alpha: .09),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  _roleIcon(account.role),
                  color: _roleColor(account.role),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account.profileName ?? account.fullName,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      account.isActive ? 'حساب نشط' : 'حساب موقوف',
                      style: TextStyle(
                        color: account.isActive
                            ? context.appColors.success
                            : context.appColors.danger,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ...rows.map(
            (row) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(row.icon, color: context.appColors.primary, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          row.label,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          row.value,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TickerCard extends StatelessWidget {
  const _TickerCard({
    required this.item,
    required this.working,
    required this.onEdit,
    required this.onDelete,
  });
  final HomeTickerItem item;
  final bool working;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final duty = item.type == 'DutyPharmacy';
    final color = duty ? const Color(0xFF3977C4) : context.appColors.primary;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: .09),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    duty
                        ? Icons.local_pharmacy_outlined
                        : Icons.campaign_outlined,
                    color: color,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        duty ? 'صيدلية مناوبة' : 'إعلان عام',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                _AdminPill(
                  label: item.isActive ? 'منشور' : 'متوقف',
                  color: item.isActive
                      ? context.appColors.success
                      : context.appColors.textMuted,
                ),
                PopupMenuButton<String>(
                  enabled: !working,
                  onSelected: (value) =>
                      value == 'edit' ? onEdit() : onDelete(),
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'edit', child: Text('تعديل')),
                    PopupMenuItem(value: 'delete', child: Text('حذف')),
                  ],
                ),
              ],
            ),
            const Divider(height: 23),
            Text(item.message, style: const TextStyle(height: 1.55)),
            if (item.pharmacyName != null) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(
                    Icons.local_pharmacy_rounded,
                    size: 17,
                    color: Color(0xFF216474),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    item.pharmacyName!,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AdminPill extends StatelessWidget {
  const _AdminPill({required this.label, required this.color});
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    decoration: BoxDecoration(
      color: color.withValues(alpha: .09),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Text(
      label,
      style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w900),
    ),
  );
}

class _AdminEmptyState extends StatelessWidget {
  const _AdminEmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) => ListView(
    physics: const AlwaysScrollableScrollPhysics(),
    padding: const EdgeInsets.fromLTRB(20, 70, 20, 30),
    children: [
      Center(
        child: Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: context.appColors.surfaceSoft,
            borderRadius: BorderRadius.circular(19),
          ),
          child: Icon(icon, color: context.appColors.primary, size: 28),
        ),
      ),
      const SizedBox(height: 14),
      Text(
        title,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      const SizedBox(height: 4),
      Text(
        subtitle,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    ],
  );
}

String _error(Object error) =>
    error is ApiException ? error.message : 'تعذر إكمال العملية.';
String _roleLabel(String role) => switch (role.toLowerCase()) {
  'admin' => 'إدارة',
  'pharmacy' => 'صيدلية',
  'organization' => 'منظمة',
  'warehouse' => 'مستودع',
  'representative' => 'مندوب',
  _ => 'مستخدم',
};
IconData _roleIcon(String role) => switch (role.toLowerCase()) {
  'admin' => Icons.admin_panel_settings_outlined,
  'pharmacy' => Icons.local_pharmacy_outlined,
  'organization' => Icons.apartment_outlined,
  'warehouse' => Icons.warehouse_outlined,
  'representative' => Icons.delivery_dining_outlined,
  _ => Icons.person_outline_rounded,
};
Color _roleColor(String role) => switch (role.toLowerCase()) {
  'admin' => const Color(0xFFD14E62),
  'pharmacy' => Color(0xFF216474),
  'organization' => const Color(0xFF8A5AC2),
  'warehouse' => const Color(0xFF3977C4),
  'representative' => Color(0xFFB7791F),
  _ => const Color(0xFF4E6B8B),
};
