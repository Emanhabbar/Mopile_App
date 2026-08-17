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
import '../../../dashboard/presentation/widgets/role_dashboard_widgets.dart';
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('مركز الإدارة'),
            Text(
              'إدارة منصة دوائي ومتابعة عملياتها',
              style: TextStyle(
                color: context.appColors.textMuted,
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

  Future<void> _approvePharmacy(String id, bool approved, String? reason) => _run(id, () async {
    if (approved) {
      // التحقق من حالة الترخيص قبل الموافقة
      try {
        final verification = await ref
            .read(adminRepositoryProvider)
            .getPharmacyLicenseVerification(id);
        
        if (verification.status != 'approved' && verification.status != 'verified') {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'لا يمكن الموافقة على الصيدلية. حالة الترخيص: ${verification.status}. يجب أن يكون الترخيص موثقاً أولاً.',
                ),
                backgroundColor: context.appColors.danger,
              ),
            );
          }
          return;
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('تعذر التحقق من حالة الترخيص: ${e.toString()}'),
              backgroundColor: context.appColors.danger,
            ),
          );
        }
        return;
      }
    }
    
    await ref.read(adminRepositoryProvider).approvePharmacy(id, approved, reason: reason);
    _refreshApprovals();
  });

  Future<void> _approveWarehouse(String id, bool approved, String? reason) =>
      _run(id, () async {
        await ref.read(adminRepositoryProvider).approveWarehouse(id, approved, reason: reason);
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
    final result = await showModalBottomSheet<_TickerSheetResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      useRootNavigator: true,
      builder: (_) => _TickerSheetBody(item: item, pharmacies: pharmacies),
    );
    if (result == null) return;
    if (result.title.length >= 2 &&
        result.message.length >= 2 &&
        (result.type != 'DutyPharmacy' || result.pharmacyId != null)) {
      await _run(item?.id ?? 'ticker-new', () async {
        await ref
            .read(adminRepositoryProvider)
            .saveTicker(
              id: item?.id,
              type: result.type,
              title: result.title,
              message: result.message,
              active: result.active,
              pharmacyProfileId: result.pharmacyId,
            );
        ref.invalidate(adminTickerProvider);
      });
    }
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
                  color: selected ? context.appColors.primary : context.appColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                    side: BorderSide(
                      color: selected
                          ? context.appColors.primary
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
              style: TextStyle(
                                   color: context.appColors.primaryDeep,
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

class _TickerSheetResult {
  const _TickerSheetResult({
    required this.title,
    required this.message,
    required this.type,
    required this.active,
    this.pharmacyId,
  });
  final String title;
  final String message;
  final String type;
  final bool active;
  final String? pharmacyId;
}

class _TickerSheetBody extends StatefulWidget {
  const _TickerSheetBody({required this.item, required this.pharmacies});
  final HomeTickerItem? item;
  final List<HomeTickerPharmacy> pharmacies;

  @override
  State<_TickerSheetBody> createState() => _TickerSheetBodyState();
}

class _TickerSheetBodyState extends State<_TickerSheetBody> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _messageCtrl;
  late bool _active;
  late String _type;
  String? _pharmacyId;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.item?.title);
    _messageCtrl = TextEditingController(text: widget.item?.message);
    _active = widget.item?.isActive ?? true;
    _type = widget.item?.type ?? 'Announcement';
    _pharmacyId = widget.item?.pharmacyProfileId;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final duty = _type == 'DutyPharmacy';
    final color = colors.primary;
    
    return Container(
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          20,
          0,
          20,
          20 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          color.withValues(alpha: .2),
                          color.withValues(alpha: .05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      duty ? Icons.local_pharmacy_outlined : Icons.campaign_outlined,
                      color: color,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.item == null ? 'محتوى جديد' : 'تعديل المحتوى',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: colors.text,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'سيظهر هذا المحتوى في الصفحة الرئيسية للمستخدمين.',
                          style: TextStyle(
                            color: colors.textMuted,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Type Selection
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: colors.surfaceSoft,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _type = 'Announcement'),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _type == 'Announcement' ? color : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.campaign_outlined,
                              size: 18,
                              color: _type == 'Announcement' ? Colors.white : colors.textMuted,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'إعلان عام',
                              style: TextStyle(
                                color: _type == 'Announcement' ? Colors.white : colors.textMuted,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _type = 'DutyPharmacy'),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _type == 'DutyPharmacy' ? color : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.local_pharmacy_outlined,
                              size: 18,
                              color: _type == 'DutyPharmacy' ? Colors.white : colors.textMuted,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'صيدلية مناوبة',
                              style: TextStyle(
                                color: _type == 'DutyPharmacy' ? Colors.white : colors.textMuted,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Pharmacy Selection
            if (duty) ...[
              const SizedBox(height: 8),
              Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.local_pharmacy_outlined,
                          color: color,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'الصيدلية المناوبة',
                          style: TextStyle(
                            color: colors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: widget.pharmacies.any((p) => p.id == _pharmacyId)
                          ? _pharmacyId
                          : null,
                      decoration: InputDecoration(
                        hintText: 'اختر الصيدلية',
                        filled: true,
                        fillColor: colors.surfaceSoft,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: widget.pharmacies
                          .map(
                            (p) => DropdownMenuItem(value: p.id, child: Text(p.name)),
                          )
                          .toList(growable: false),
                      onChanged: (value) => setState(() => _pharmacyId = value),
                    ),
                  ],
                ),
              ),
            ],
            
            // Title Field
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.title_rounded,
                        color: color,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'العنوان',
                        style: TextStyle(
                          color: colors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _titleCtrl,
                    maxLength: 150,
                    decoration: InputDecoration(
                      hintText: 'أدخل عنوان المحتوى',
                      filled: true,
                      fillColor: colors.surfaceSoft,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Message Field
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.description_outlined,
                        color: color,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'النص الظاهر للمستخدم',
                        style: TextStyle(
                          color: colors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _messageCtrl,
                    maxLength: 500,
                    minLines: 3,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'أدخل النص المراد إظهاره',
                      filled: true,
                      fillColor: colors.surfaceSoft,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Active Toggle
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _active ? colors.primary.withValues(alpha: .12) : colors.textMuted.withValues(alpha: .08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _active ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: _active ? colors.primary : colors.textMuted,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'نشر المحتوى',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: colors.text,
                          ),
                        ),
                        Text(
                          _active ? 'ظاهر حاليًا للمستخدمين' : 'محفوظ دون نشر',
                          style: TextStyle(
                            color: colors.textMuted,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _active,
                    onChanged: (value) => setState(() => _active = value),
                  ),
                ],
              ),
            ),
            
            // Save Button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton.icon(
                  onPressed: () => Navigator.pop(
                    context,
                    _TickerSheetResult(
                      title: _titleCtrl.text.trim(),
                      message: _messageCtrl.text.trim(),
                      type: _type,
                      active: _active,
                      pharmacyId: _pharmacyId,
                    ),
                  ),
                  icon: const Icon(Icons.check_rounded, size: 22),
                  label: const Text(
                    'حفظ المحتوى',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: color,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
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
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 112),
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
              RoleMetricsGrid(
                items: values
                    .map(
                      (v) => RoleMetricData(
                        label: v.$1,
                        value: '${v.$2}',
                        icon: v.$3,
                        color: v.$1.contains('معلقة') ||
                                v.$1.contains('تحقق')
                            ? context.appColors.secondary
                            : context.appColors.primary,
                      ),
                    )
                    .toList(),
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
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: context.appColors.primary,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: context.appColors.primaryDark.withValues(alpha: 0.35),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.admin_panel_settings_rounded,
                    color: context.appColors.secondary,
                    size: 34,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'نبض منصة دوائي',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'نظرة موحدة على الحسابات والجهات والخدمات',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: pending > 0
                        ? context.appColors.secondary.withValues(alpha: .2)
                        : Colors.white.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: .15),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '$pending',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const Text(
                        'تحتاج قرارًا',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
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
      margin: const EdgeInsetsDirectional.only(end: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: .15),
        ),
      ),
      child: Column(
        children: [
          Text(
            '$value',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 1,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}

class _ApprovalsTab extends ConsumerStatefulWidget {
  const _ApprovalsTab({
    required this.workingId,
    required this.onPharmacy,
    required this.onOrganization,
    required this.onWarehouse,
  });
  final String? workingId;
  final Future<void> Function(String, bool, String?) onPharmacy;
  final Future<void> Function(AdminOrganization, bool) onOrganization;
  final Future<void> Function(String, bool, String?) onWarehouse;

  @override
  ConsumerState<_ApprovalsTab> createState() => _ApprovalsTabState();
}

class _ApprovalsTabState extends ConsumerState<_ApprovalsTab> {
  String? _selectedRole;

  Future<void> _showReasonSheet(
    BuildContext context, {
    required String title,
    required Future<void> Function(String reason) onConfirm,
  }) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      useRootNavigator: true,
      builder: (_) => _ReasonSheetBody(title: title),
    );
    if (result != null && result.length >= 10) {
      await onConfirm(result);
    }
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
      
      final needsManualReview = verification.status == 'manual_review' || 
                                  verification.status == 'manualreview' ||
                                  verification.status == 'failed';
      final isApproved = verification.status == 'approved' || 
                         verification.status == 'verified';
      final statusMessage = isApproved 
          ? 'الترخيص موثق، يمكنك الموافقة على الصيدلية'
          : needsManualReview 
              ? 'الترخيص يحتاج إلى مراجعة يدوية. يجب أن يكون الترخيص موثقاً أولاً قبل الموافقة على الصيدلية.'
              : 'الترخيص قيد المعالجة.';
      
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
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isApproved 
                        ? context.appColors.success.withValues(alpha: .1)
                        : needsManualReview
                            ? context.appColors.warning.withValues(alpha: .1)
                            : context.appColors.primary.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isApproved 
                          ? context.appColors.success
                          : needsManualReview
                              ? context.appColors.warning
                              : context.appColors.primary,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isApproved 
                            ? Icons.check_circle_rounded
                            : needsManualReview
                                ? Icons.warning_rounded
                                : Icons.info_rounded,
                        color: isApproved 
                            ? context.appColors.success
                            : needsManualReview
                                ? context.appColors.warning
                                : context.appColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          statusMessage,
                          style: TextStyle(
                            fontSize: 12,
                            color: isApproved 
                                ? context.appColors.success
                                : needsManualReview
                                    ? context.appColors.warning
                                    : context.appColors.primary,
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

  String _error(Object error) {
    return error is ApiException ? error.message : 'حدث خطأ غير متوقع.';
  }

  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 112),
        children: [
          const _AdminSectionHeading(
            eyebrow: 'قرارات الاعتماد',
            title: 'طلبات تحتاج مراجعتك',
            subtitle: 'تحقق من بيانات الجهة قبل منحها صلاحية العمل على المنصة.',
          ),
          const SizedBox(height: 16),
          _RoleSelector(
            selectedRole: _selectedRole,
            onRoleSelected: (role) => setState(() => _selectedRole = role),
          ),
          const SizedBox(height: 20),
          if (_selectedRole == null)
            Text(
              'الصيدليات',
              style: TextStyle(
                color: context.appColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          if (_selectedRole == null)
            const SizedBox(height: 12),
          if (_selectedRole == null || _selectedRole == 'pharmacies')
            pharmacies.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, _) => Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.appColors.danger.withValues(alpha: .06),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: context.appColors.danger.withValues(alpha: .15),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      color: context.appColors.danger,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _error(error),
                        style: TextStyle(
                          color: context.appColors.danger,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              data: (items) => items.isEmpty
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: context.appColors.surfaceSoft,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.task_alt_rounded,
                            color: context.appColors.primary,
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'لا توجد طلبات معلقة ضمن هذا القسم.',
                              style: TextStyle(
                                color: context.appColors.textMuted,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: items
                          .map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _ApprovalCard(
                                icon: Icons.local_pharmacy_outlined,
                                color: context.appColors.primary,
                                title: item.pharmacyName,
                                subtitle: '${item.ownerFullName} · ${item.licenseNumber}',
                                location: '${item.city}، ${item.area}',
                                working: widget.workingId == item.pharmacyId,
                                onApprove: () => _showReasonSheet(
                                  context,
                                  title: 'اعتماد الصيدلية',
                                  onConfirm: (reason) => widget.onPharmacy(item.pharmacyId, true, reason),
                                ),
                                onReject: () => _showReasonSheet(
                                  context,
                                  title: 'رفض الصيدلية',
                                  onConfirm: (reason) => widget.onPharmacy(item.pharmacyId, false, reason),
                                ),
                                onDetails: () => _showPharmacyLicense(context, ref, item),
                                expandedChild: _ApprovalDetails(
                                  rows: [
                                    _DetailRow(label: 'المالك', value: item.ownerFullName),
                                    _DetailRow(label: 'البريد', value: item.ownerEmail),
                                    _DetailRow(label: 'رقم الترخيص', value: item.licenseNumber),
                                    _DetailRow(label: 'المدينة', value: item.city),
                                    _DetailRow(label: 'المنطقة', value: item.area),
                                    _DetailRow(label: 'العنوان', value: item.address),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(growable: false),
                    ),
            ),
          if (_selectedRole == null && pharmacies.value?.isNotEmpty == true)
            const SizedBox(height: 24),
          if (_selectedRole == null)
            Text(
              'المنظمات',
              style: TextStyle(
                color: context.appColors.primaryDark,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          if (_selectedRole == null)
            const SizedBox(height: 12),
          if (_selectedRole == null || _selectedRole == 'organizations')
            organizations.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, _) => Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.appColors.danger.withValues(alpha: .06),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: context.appColors.danger.withValues(alpha: .15),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      color: context.appColors.danger,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _error(error),
                        style: TextStyle(
                          color: context.appColors.danger,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              data: (items) => items.isEmpty
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: context.appColors.surfaceSoft,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.task_alt_rounded,
                            color: context.appColors.primaryDark,
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'لا توجد طلبات معلقة ضمن هذا القسم.',
                              style: TextStyle(
                                color: context.appColors.textMuted,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: items
                          .map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _ApprovalCard(
                                icon: Icons.apartment_outlined,
                                color: context.appColors.primaryDark,
                                title: item.organizationName,
                                subtitle:
                                    '${item.ownerFullName} · ${item.verificationDocumentsCount} وثائق',
                                location: '${item.city}، ${item.area}',
                                working: widget.workingId == item.organizationId,
                                onApprove: () => widget.onOrganization(item, true),
                                onReject: () => widget.onOrganization(item, false),
                                expandedChild: _ApprovalDetails(
                                  rows: [
                                    _DetailRow(label: 'المالك', value: item.ownerFullName),
                                    _DetailRow(label: 'البريد', value: item.ownerEmail),
                                    _DetailRow(label: 'رقم السجل', value: item.registrationNumber),
                                    _DetailRow(label: 'المدينة', value: item.city),
                                    _DetailRow(label: 'المنطقة', value: item.area),
                                    _DetailRow(label: 'حالة التحقق', value: item.verificationStatus),
                                    _DetailRow(label: 'الوثائق', value: '${item.verificationDocumentsCount}'),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(growable: false),
                    ),
            ),
          if (_selectedRole == null && organizations.value?.isNotEmpty == true)
            const SizedBox(height: 24),
          if (_selectedRole == null)
            Text(
              'المستودعات',
              style: TextStyle(
                color: context.appColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          if (_selectedRole == null)
            const SizedBox(height: 12),
          if (_selectedRole == null || _selectedRole == 'warehouses')
            warehouses.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, _) => Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.appColors.danger.withValues(alpha: .06),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: context.appColors.danger.withValues(alpha: .15),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      color: context.appColors.danger,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _error(error),
                        style: TextStyle(
                          color: context.appColors.danger,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              data: (items) => items.isEmpty
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: context.appColors.surfaceSoft,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.task_alt_rounded,
                            color: context.appColors.primary,
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'لا توجد طلبات معلقة ضمن هذا القسم.',
                              style: TextStyle(
                                color: context.appColors.textMuted,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: items
                          .map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _ApprovalCard(
                                icon: Icons.warehouse_outlined,
                                color: context.appColors.primary,
                                title: item.warehouseName,
                                subtitle: '${item.ownerFullName} · ${item.licenseNumber}',
                                location: '${item.city}، ${item.area}',
                                working: widget.workingId == item.warehouseId,
                                onApprove: () => _showReasonSheet(
                                  context,
                                  title: 'اعتماد المستودع',
                                  onConfirm: (reason) => widget.onWarehouse(item.warehouseId, true, reason),
                                ),
                                onReject: () => _showReasonSheet(
                                  context,
                                  title: 'رفض المستودع',
                                  onConfirm: (reason) => widget.onWarehouse(item.warehouseId, false, reason),
                                ),
                                expandedChild: _ApprovalDetails(
                                  rows: [
                                    _DetailRow(label: 'المالك', value: item.ownerFullName),
                                    _DetailRow(label: 'البريد', value: item.ownerEmail),
                                    _DetailRow(label: 'رقم الترخيص', value: item.licenseNumber),
                                    _DetailRow(label: 'المدينة', value: item.city),
                                    _DetailRow(label: 'المنطقة', value: item.area),
                                    _DetailRow(label: 'العنوان', value: item.address),
                                    _DetailRow(label: 'حد الطلب الأدنى', value: '${item.minimumOrderAmount} ر.س'),
                                    _DetailRow(label: 'رسوم التوصيل', value: '${item.deliveryFee} ر.س'),
                                    _DetailRow(label: 'دفعات الأدوية', value: '${item.medicineBatchesCount}'),
                                    _DetailRow(label: 'المندوبين', value: '${item.representativesCount}'),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(growable: false),
                    ),
            ),
        ],
      ),
    );
  }
}

class _RoleSelector extends StatelessWidget {
  const _RoleSelector({
    required this.selectedRole,
    required this.onRoleSelected,
  });

  final String? selectedRole;
  final Function(String?) onRoleSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Row(
      children: [
        Expanded(
          child: _RoleButton(
            label: 'الكل',
            icon: Icons.apps_rounded,
            color: colors.primary,
            isSelected: selectedRole == null,
            onTap: () => onRoleSelected(null),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _RoleButton(
            label: 'الصيدليات',
            icon: Icons.local_pharmacy_outlined,
            color: colors.primary,
            isSelected: selectedRole == 'pharmacies',
            onTap: () => onRoleSelected('pharmacies'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _RoleButton(
            label: 'المنظمات',
            icon: Icons.apartment_outlined,
            color: colors.primary,
            isSelected: selectedRole == 'organizations',
            onTap: () => onRoleSelected('organizations'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _RoleButton(
            label: 'المستودعات',
            icon: Icons.warehouse_outlined,
            color: colors.primary,
            isSelected: selectedRole == 'warehouses',
            onTap: () => onRoleSelected('warehouses'),
          ),
        ),
      ],
    );
  }
}

class _RoleButton extends StatelessWidget {
  const _RoleButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? color : colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : colors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : color,
              size: 22,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : colors.text,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'بحث',
                    style: TextStyle(
                      color: context.appColors.text,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _search,
                    onChanged: (value) => setState(() => _query = value.trim()),
                    cursorColor: context.appColors.primary,
                    cursorWidth: 1.4,
                    style: TextStyle(
                      color: context.appColors.text,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: 'ابحث بالاسم أو البريد الإلكتروني',
                      hintStyle: TextStyle(
                        color: context.appColors.textMuted.withValues(alpha: 0.6),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      filled: true,
                      fillColor: context.appColors.surfaceSoft,
                      prefixIcon: const Padding(
                        padding: EdgeInsetsDirectional.only(
                          start: 14,
                          end: 10,
                        ),
                        child: Icon(
                          Icons.search_rounded,
                          size: 21,
                        ),
                      ),
                      prefixIconConstraints: const BoxConstraints(minWidth: 46, minHeight: 52),
                      suffixIcon: _query.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                _search.clear();
                                setState(() => _query = '');
                              },
                              icon: const Icon(Icons.close_rounded),
                            ),
                      suffixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 52),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 15,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: context.appColors.primary.withValues(alpha: 0.4),
                          width: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
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
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 112),
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
        useRootNavigator: true,
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
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 112),
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
            Container(
              width: double.infinity,
              height: 3,
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: context.appColors.primary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              eyebrow,
              style: TextStyle(
                color: context.appColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
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

class _ApprovalCard extends StatefulWidget {
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
    this.expandedChild,
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
  final Widget? expandedChild;

  @override
  State<_ApprovalCard> createState() => _ApprovalCardState();
}

class _ApprovalCardState extends State<_ApprovalCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late final AnimationController _animCtrl;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    if (_expanded) {
      _animCtrl.forward();
    } else {
      _animCtrl.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return GestureDetector(
      onTap: widget.expandedChild != null ? _toggle : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _expanded ? widget.color : colors.border,
            width: _expanded ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: widget.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Icon(widget.icon, color: widget.color, size: 26),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: colors.text,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: colors.textMuted,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (widget.working)
                        const SizedBox.square(
                          dimension: 24,
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        )
                      else if (widget.expandedChild != null)
                        AnimatedRotation(
                          turns: _expanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 300),
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: widget.color,
                            size: 28,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: colors.surfaceSoft,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: widget.color,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            widget.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: colors.textMuted,
                              fontSize: 13,
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
            if (widget.onDetails != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 10),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: widget.working ? null : widget.onDetails,
                    icon: const Icon(Icons.badge_outlined, size: 18),
                    label: const Text('مراجعة الترخيص'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      foregroundColor: widget.color,
                      side: BorderSide(color: widget.color.withValues(alpha: .3)),
                    ),
                  ),
                ),
              ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: _expanded && widget.expandedChild != null
                  ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Divider(
                            height: 1,
                            color: colors.border,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                          child: widget.expandedChild,
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: widget.working ? null : widget.onApprove,
                      icon: const Icon(Icons.check_rounded, size: 20),
                      label: const Text('اعتماد'),
                      style: FilledButton.styleFrom(
                        backgroundColor: widget.color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: widget.working ? null : widget.onReject,
                      icon: const Icon(Icons.close_rounded, size: 18),
                      label: const Text('رفض'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colors.primaryDark,
                        side: BorderSide(color: colors.border),
                        padding: const EdgeInsets.symmetric(vertical: 12),
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
  }
}

class _ApprovalDetails extends StatelessWidget {
  const _ApprovalDetails({required this.rows});
  final List<_DetailRow> rows;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows
          .map(
            (row) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      row.label,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      row.value,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.text,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _ReasonSheetBody extends StatefulWidget {
  const _ReasonSheetBody({required this.title});
  final String title;

  @override
  State<_ReasonSheetBody> createState() => _ReasonSheetBodyState();
}

class _ReasonSheetBodyState extends State<_ReasonSheetBody> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        MediaQuery.of(context).viewPadding.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 6),
            Text(
              'اكتب سبب القرار (10 أحرف على الأقل)',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colors.textMuted,
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _controller,
              maxLines: 3,
              minLines: 2,
              textInputAction: TextInputAction.newline,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                hintText: 'مثال: تمت مراجعة البيانات والوثائق والاعتماد مطابق للمعايير المطلوبة.',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('إلغاء'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: _controller.text.trim().length >= 10
                        ? () => Navigator.of(context).pop(_controller.text.trim())
                        : null,
                    child: const Text('تأكيد'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _DetailRow {
  const _DetailRow({required this.label, required this.value});
  final String label;
  final String value;
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
      selectedColor: context.appColors.primary,
      backgroundColor: context.appColors.surface,
      side: BorderSide(
        color: selected ? context.appColors.primary : context.appColors.border,
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
    final colors = context.appColors;
    final color = _roleColor(colors, account.role);
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: account.isActive ? color.withValues(alpha: .3) : colors.border,
          width: account.isActive ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        onTap: onDetails,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color.withValues(alpha: .15),
                      color.withValues(alpha: .05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  _roleIcon(account.role),
                  color: color,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account.profileName ?? account.fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: colors.text,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      account.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colors.textMuted,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        _AdminPill(
                          label: _roleLabel(account.role),
                          color: color,
                        ),
                        _AdminPill(
                          label: account.isActive ? 'نشط' : 'موقوف',
                          color: account.isActive
                              ? colors.primary
                              : colors.primaryDark,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
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
    final colors = context.appColors;

    final basicInfo = <({String label, String value, IconData icon})>[
      (
        label: 'الاسم',
        value: details['profileName']?.toString() ?? account.fullName,
        icon: Icons.person_outline_rounded,
      ),
      (label: 'البريد', value: account.email, icon: Icons.mail_outline_rounded),
      (
        label: 'الدور',
        value: _roleLabel(account.role),
        icon: _roleIcon(account.role),
      ),
    ];

    final additionalInfo = <({String label, String value, IconData icon})>[
      if (details['city']?.toString().isNotEmpty == true)
        (
          label: 'الموقع',
          value:
              '${details['city'] ?? ''}، ${details['area'] ?? ''}',
          icon: Icons.location_on_outlined,
        ),
      if (details['address']?.toString().isNotEmpty == true)
        (
          label: 'العنوان',
          value: details['address'].toString(),
          icon: Icons.home_outlined,
        ),
      if (details['licenseOrRegistrationNumber']?.toString().isNotEmpty == true)
        (
          label: 'رقم الاعتماد',
          value: details['licenseOrRegistrationNumber'].toString(),
          icon: Icons.verified_outlined,
        ),
    ];

    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: colors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    _roleIcon(account.role),
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account.profileName ?? account.fullName,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: colors.text,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: account.isActive
                              ? colors.primary.withValues(alpha: .15)
                              : colors.primaryDark.withValues(alpha: .15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              account.isActive ? Icons.check_circle_outline : Icons.block_outlined,
                              size: 16,
                              color: account.isActive ? colors.primary : colors.primaryDark,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              account.isActive ? 'حساب نشط' : 'حساب موقوف',
                              style: TextStyle(
                                color: account.isActive ? colors.primary : colors.primaryDark,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
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
          ),

          // Basic Info Section
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
            child: Text(
              'المعلومات الأساسية',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: colors.primary,
                letterSpacing: 0.5,
              ),
            ),
          ),

          ...basicInfo.map(
            (row) => Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: .1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(row.icon, color: colors.primary, size: 20),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          row.label,
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          row.value,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: colors.text,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Additional Info Section
          if (additionalInfo.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
              child: Text(
                'معلومات إضافية',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: colors.primary,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            ...additionalInfo.map(
              (row) => Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.surfaceSoft,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(alpha: .08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(row.icon, color: colors.primary, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            row.label,
                            style: TextStyle(
                              fontSize: 12,
                              color: colors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            row.value,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: colors.text,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          SizedBox(height: bottomPadding + 24),
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
    final colors = context.appColors;
    final color = colors.primary;
    
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: item.isActive ? color.withValues(alpha: .3) : colors.border,
          width: item.isActive ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: color.withValues(alpha: .05),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        color.withValues(alpha: .2),
                        color.withValues(alpha: .05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    duty
                        ? Icons.local_pharmacy_outlined
                        : Icons.campaign_outlined,
                    color: color,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: colors.text,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: .12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              duty ? 'صيدلية مناوبة' : 'إعلان عام',
                              style: TextStyle(
                                color: color,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: item.isActive
                                  ? colors.primary.withValues(alpha: .12)
                                  : colors.textMuted.withValues(alpha: .08),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  item.isActive ? Icons.check_circle_outline : Icons.block_outlined,
                                  size: 12,
                                  color: item.isActive ? colors.primary : colors.textMuted,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  item.isActive ? 'منشور' : 'متوقف',
                                  style: TextStyle(
                                    color: item.isActive ? colors.primary : colors.textMuted,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  enabled: !working,
                  icon: Icon(Icons.more_vert_rounded, color: colors.textMuted),
                  onSelected: (value) =>
                      value == 'edit' ? onEdit() : onDelete(),
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'edit', child: Text('تعديل')),
                    PopupMenuItem(value: 'delete', child: Text('حذف')),
                  ],
                ),
              ],
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.message,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: colors.text,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (item.pharmacyName != null) ...[
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: .06),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.local_pharmacy_rounded,
                          size: 18,
                          color: colors.primary,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            item.pharmacyName!,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: colors.text,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
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
    padding: const EdgeInsets.fromLTRB(20, 70, 20, 112),
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
Color _roleColor(AppColors colors, String role) => switch (role.toLowerCase()) {
  'admin' => colors.primaryDark,
  'pharmacy' => colors.primaryDeep,
  'organization' => colors.primary,
  'warehouse' => colors.primaryDeep,
  'representative' => colors.primaryDark,
  _ => colors.primary,
};
