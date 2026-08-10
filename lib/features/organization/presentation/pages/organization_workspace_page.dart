import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../../core/widgets/app_reveal.dart';
import '../../../../core/widgets/async_states.dart';
import '../../../donations/data/models/donation_models.dart';
import '../../../donations/presentation/pages/donations_page.dart';
import '../../data/models/organization_models.dart';
import '../../data/repositories/organization_repository.dart';
import '../controllers/organization_providers.dart';

class OrganizationWorkspacePage extends ConsumerStatefulWidget {
  const OrganizationWorkspacePage({this.initialSection = 0, super.key});

  final int initialSection;

  @override
  ConsumerState<OrganizationWorkspacePage> createState() =>
      _OrganizationWorkspacePageState();
}

class _OrganizationWorkspacePageState
    extends ConsumerState<OrganizationWorkspacePage> {
  String? _workingId;
  late int _selectedSection;

  @override
  void initState() {
    super.initState();
    _selectedSection = widget.initialSection.clamp(0, 4);
  }

  @override
  void didUpdateWidget(covariant OrganizationWorkspacePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSection != widget.initialSection) {
      _selectedSection = widget.initialSection.clamp(0, 4);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dashboard = ref.watch(organizationDashboardProvider);
    final campaigns = ref.watch(organizationCampaignsProvider);
    final offers = ref.watch(organizationOffersProvider);
    final requests = ref.watch(organizationAssistanceProvider);
    final verification = ref.watch(organizationVerificationProvider);
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('إدارة المنظمة'),
            Text(
              'المبادرات والتبرعات والمستفيدون',
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
            onPressed: _refresh,
            tooltip: 'تحديث البيانات',
            icon: const Icon(Icons.refresh_rounded),
          ),
          PopupMenuButton<String>(
            tooltip: 'المزيد',
            icon: const Icon(Icons.more_horiz_rounded),
            onSelected: (value) {
              if (value == 'profile') _loadAndEditProfile();
              if (value == 'document') _uploadDocument();
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'profile',
                child: ListTile(
                  leading: Icon(Icons.edit_outlined),
                  title: Text('تعديل بيانات المنظمة'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: 'document',
                child: ListTile(
                  leading: Icon(Icons.upload_file_outlined),
                  title: Text('رفع وثيقة تحقق'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            AppReveal(
              child: dashboard.when(
                loading: () => const _HeroSkeleton(),
                error: (error, _) => AppErrorState(
                  error: error,
                  onRetry: () => ref.invalidate(organizationDashboardProvider),
                ),
                data: (data) => _OrganizationHero(
                  data: data,
                  onCreateCampaign: _createCampaign,
                ),
              ),
            ),
            const SizedBox(height: 16),
            AppReveal(
              delay: const Duration(milliseconds: 80),
              child: _SectionNavigation(
                selectedIndex: _selectedSection,
                onSelected: (value) => setState(() => _selectedSection = value),
                pendingOffers:
                    dashboard.valueOrNull?.pendingDonationOffersCount,
                openRequests:
                    dashboard.valueOrNull?.openAssistanceRequestsCount,
              ),
            ),
            const SizedBox(height: 20),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, .025),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              ),
              child: KeyedSubtree(
                key: ValueKey(_selectedSection),
                child: switch (_selectedSection) {
                  0 => _OverviewSection(
                    dashboard: dashboard,
                    verification: verification,
                    campaigns: campaigns,
                    onCreateCampaign: _createCampaign,
                    onUploadDocument: _uploadDocument,
                    onEditProfile: _loadAndEditProfile,
                  ),
                  1 => _CampaignsSection(
                    state: campaigns,
                    workingId: _workingId,
                    onCreate: _createCampaign,
                    onUpdate: _updateCampaign,
                  ),
                  2 => _DonationOffersSection(
                    state: offers,
                    workingId: _workingId,
                    onReview: _reviewOffer,
                  ),
                  3 => _AssistanceSection(
                    state: requests,
                    workingId: _workingId,
                    onUpdate: _updateRequest,
                  ),
                  _ => _OrganizationProfileSection(
                    dashboard: dashboard,
                    verification: verification,
                    onEdit: _loadAndEditProfile,
                    onUpload: _uploadDocument,
                  ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createCampaign() async {
    final title = TextEditingController();
    final description = TextEditingController();
    final medicines = TextEditingController();
    final city = TextEditingController();
    final area = TextEditingController();
    var isUrgent = false;
    var acceptsDonations = true;
    DateTime? startsAt;
    DateTime? endsAt;
    final result = await showModalBottomSheet<bool>(
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
                      child: Icon(
                        Icons.campaign_outlined,
                        color: context.appColors.primary,
                      ),
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'حملة جديدة',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            'أضف معلومات واضحة تساعد المتبرعين.',
                            style: TextStyle(
                              color: context.appColors.textMuted,
                              fontSize: 11.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _Field(controller: title, label: 'عنوان الحملة'),
                _Field(controller: description, label: 'وصف الحملة', lines: 3),
                _Field(
                  controller: medicines,
                  label: 'الأدوية المطلوبة (اختياري)',
                  lines: 2,
                ),
                Row(
                  children: [
                    Expanded(
                      child: _Field(controller: city, label: 'المدينة'),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: _Field(controller: area, label: 'المنطقة'),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: context.appColors.surfaceSoft,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text('حملة عاجلة'),
                        subtitle: const Text('تظهر بأولوية بصرية أعلى.'),
                        secondary: const Icon(Icons.priority_high_rounded),
                        value: isUrgent,
                        onChanged: (value) =>
                            setSheetState(() => isUrgent = value),
                      ),
                      const Divider(),
                      SwitchListTile(
                        title: const Text('استقبال تبرعات عامة'),
                        subtitle: const Text(
                          'يمكن للمستخدمين دعم الحملة مباشرة.',
                        ),
                        secondary: const Icon(
                          Icons.volunteer_activism_outlined,
                        ),
                        value: acceptsDonations,
                        onChanged: (value) =>
                            setSheetState(() => acceptsDonations = value),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _DateSelector(
                        label: 'تاريخ البداية',
                        value: startsAt,
                        onTap: () async {
                          final value = await _pickCampaignDate(
                            context,
                            initial: startsAt,
                          );
                          if (value != null) {
                            setSheetState(() => startsAt = value);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: _DateSelector(
                        label: 'تاريخ النهاية',
                        value: endsAt,
                        onTap: () async {
                          final value = await _pickCampaignDate(
                            context,
                            initial: endsAt,
                          );
                          if (value != null) {
                            setSheetState(() => endsAt = value);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => Navigator.pop(sheetContext, true),
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: const Text('إنشاء الحملة'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (result == true &&
        title.text.trim().isNotEmpty &&
        description.text.trim().isNotEmpty) {
      await _run('new-campaign', () async {
        await ref
            .read(organizationRepositoryProvider)
            .createCampaign(
              title: title.text.trim(),
              description: description.text.trim(),
              requestedMedicinesSummary: medicines.text.trim(),
              city: city.text.trim(),
              area: area.text.trim(),
              isUrgent: isUrgent,
              acceptsPublicDonations: acceptsDonations,
              startsAtUtc: startsAt,
              endsAtUtc: endsAt,
            );
        ref
          ..invalidate(organizationCampaignsProvider)
          ..invalidate(organizationDashboardProvider);
      });
    }
    for (final controller in [title, description, medicines, city, area]) {
      controller.dispose();
    }
  }

  Future<DateTime?> _pickCampaignDate(
    BuildContext context, {
    DateTime? initial,
  }) {
    final now = DateTime.now();
    return showDatePicker(
      context: context,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 3),
      initialDate: initial ?? now,
    );
  }

  Future<void> _editProfile(OrganizationDashboard current) async {
    final name = TextEditingController(text: current.organizationName);
    final registration = TextEditingController(
      text: current.registrationNumber,
    );
    final phone = TextEditingController(text: current.phoneNumber);
    final city = TextEditingController(text: current.city);
    final area = TextEditingController(text: current.area);
    final address = TextEditingController(text: current.address);
    final description = TextEditingController(text: current.description);
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('بيانات المنظمة'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Field(controller: name, label: 'اسم المنظمة'),
              _Field(controller: registration, label: 'رقم التسجيل'),
              _Field(controller: phone, label: 'رقم الهاتف'),
              _Field(controller: city, label: 'المدينة'),
              _Field(controller: area, label: 'المنطقة'),
              _Field(controller: address, label: 'العنوان'),
              _Field(controller: description, label: 'وصف المنظمة', lines: 3),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
    if (saved == true) {
      await _run('profile', () async {
        await ref
            .read(organizationRepositoryProvider)
            .updateProfile(
              current,
              organizationName: name.text.trim(),
              registrationNumber: registration.text.trim(),
              phoneNumber: phone.text.trim(),
              city: city.text.trim(),
              area: area.text.trim(),
              address: address.text.trim(),
              description: description.text.trim(),
            );
        ref
          ..invalidate(organizationDashboardProvider)
          ..invalidate(organizationProfileProvider);
      });
    }
    for (final controller in [
      name,
      registration,
      phone,
      city,
      area,
      address,
      description,
    ]) {
      controller.dispose();
    }
  }

  Future<void> _loadAndEditProfile() async {
    setState(() => _workingId = 'load-profile');
    try {
      final profile = await ref.read(organizationProfileProvider.future);
      if (mounted) await _editProfile(profile);
    } catch (error) {
      _message(_errorText(error), true);
    } finally {
      if (mounted && _workingId == 'load-profile') {
        setState(() => _workingId = null);
      }
    }
  }

  Future<void> _uploadDocument() async {
    const types = {
      'RegistrationCertificate': 'شهادة التسجيل',
      'OperatingLicense': 'ترخيص العمل',
      'ManagerIdentityDocument': 'هوية المدير',
      'TaxOrLegalDocument': 'وثيقة قانونية',
      'Other': 'أخرى',
    };
    String selected = 'RegistrationCertificate';
    final documentType = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('نوع الوثيقة'),
        content: StatefulBuilder(
          builder: (context, setDialogState) => DropdownButtonFormField<String>(
            initialValue: selected,
            items: types.entries
                .map(
                  (item) => DropdownMenuItem(
                    value: item.key,
                    child: Text(item.value),
                  ),
                )
                .toList(growable: false),
            onChanged: (value) =>
                setDialogState(() => selected = value ?? selected),
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context, selected),
            child: const Text('اختيار ملف'),
          ),
        ],
      ),
    );
    if (documentType == null) return;
    const group = XTypeGroup(
      label: 'verification',
      extensions: ['pdf', 'png', 'jpg', 'jpeg'],
    );
    final file = await openFile(acceptedTypeGroups: const [group]);
    if (file == null) return;
    if (await file.length() > 10 * 1024 * 1024) {
      _message('حجم الوثيقة يجب ألا يتجاوز 10 ميغابايت.', true);
      return;
    }
    await _run('document', () async {
      await ref
          .read(organizationRepositoryProvider)
          .uploadDocument(
            documentType: documentType,
            filePath: file.path,
            fileName: file.name,
          );
      ref
        ..invalidate(organizationVerificationProvider)
        ..invalidate(organizationDashboardProvider);
    });
  }

  Future<void> _updateCampaign(String id, String status) => _run(id, () async {
    await ref
        .read(organizationRepositoryProvider)
        .updateCampaignStatus(id, status);
    ref.invalidate(organizationCampaignsProvider);
  });

  Future<void> _reviewOffer(String id, String status) => _run(id, () async {
    await ref
        .read(organizationRepositoryProvider)
        .reviewOffer(id, status: status);
    ref
      ..invalidate(organizationOffersProvider)
      ..invalidate(organizationDashboardProvider);
  });

  Future<void> _updateRequest(String id, String status) => _run(id, () async {
    await ref
        .read(organizationRepositoryProvider)
        .updateAssistanceStatus(id, status: status);
    ref
      ..invalidate(organizationAssistanceProvider)
      ..invalidate(organizationDashboardProvider);
  });

  Future<void> _run(String id, Future<void> Function() action) async {
    setState(() => _workingId = id);
    try {
      await action();
      _message('تم حفظ التحديث.', false);
    } catch (error) {
      _message(_errorText(error), true);
    } finally {
      if (mounted) setState(() => _workingId = null);
    }
  }

  Future<void> _refresh() async {
    ref
      ..invalidate(organizationDashboardProvider)
      ..invalidate(organizationProfileProvider)
      ..invalidate(organizationVerificationProvider)
      ..invalidate(organizationCampaignsProvider)
      ..invalidate(organizationOffersProvider)
      ..invalidate(organizationAssistanceProvider);
    await ref.read(organizationDashboardProvider.future);
  }

  void _message(String text, bool error) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: error ? context.appColors.danger : null,
      ),
    );
  }
}

class _SectionNavigation extends StatelessWidget {
  const _SectionNavigation({
    required this.selectedIndex,
    required this.onSelected,
    this.pendingOffers,
    this.openRequests,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final int? pendingOffers;
  final int? openRequests;

  @override
  Widget build(BuildContext context) {
    final items = <({String label, IconData icon, int? count})>[
      (label: 'الملخص', icon: Icons.grid_view_rounded, count: null),
      (label: 'الحملات', icon: Icons.campaign_outlined, count: null),
      (
        label: 'التبرعات',
        icon: Icons.volunteer_activism_outlined,
        count: pendingOffers,
      ),
      (
        label: 'المساعدة',
        icon: Icons.health_and_safety_outlined,
        count: openRequests,
      ),
      (label: 'الملف', icon: Icons.apartment_outlined, count: null),
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
                              fontWeight: FontWeight.w800,
                              fontSize: 12.5,
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
                                color: selected
                                    ? context.appColors.secondary
                                    : context.appColors.surfaceWarm,
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

class _OverviewSection extends StatelessWidget {
  const _OverviewSection({
    required this.dashboard,
    required this.verification,
    required this.campaigns,
    required this.onCreateCampaign,
    required this.onUploadDocument,
    required this.onEditProfile,
  });

  final AsyncValue<OrganizationDashboard> dashboard;
  final AsyncValue<OrganizationVerification> verification;
  final AsyncValue<List<DonationCampaign>> campaigns;
  final VoidCallback onCreateCampaign;
  final VoidCallback onUploadDocument;
  final VoidCallback onEditProfile;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const _SectionHeading(
        eyebrow: 'وصول سريع',
        title: 'ما الذي تريد إنجازه؟',
        subtitle: 'أهم عمليات المنظمة جاهزة من مكان واحد.',
      ),
      const SizedBox(height: 12),
      Row(
        children: [
          Expanded(
            child: _QuickAction(
              icon: Icons.add_rounded,
              label: 'حملة جديدة',
              color: context.appColors.primary,
              onTap: onCreateCampaign,
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: _QuickAction(
              icon: Icons.upload_file_outlined,
              label: 'رفع وثيقة',
              color: const Color(0xFF3977C4),
              onTap: onUploadDocument,
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: _QuickAction(
              icon: Icons.edit_outlined,
              label: 'تعديل الملف',
              color: const Color(0xFF8A5AC2),
              onTap: onEditProfile,
            ),
          ),
        ],
      ),
      const SizedBox(height: 24),
      verification.when(
        loading: () => const LinearProgressIndicator(),
        error: (_, _) => const SizedBox.shrink(),
        data: (data) => _VerificationCard(
          status: data.verificationStatus,
          documents: data.documents.length,
          notes: data.verificationNotes,
          onUpload: onUploadDocument,
        ),
      ),
      const SizedBox(height: 24),
      const _SectionHeading(
        eyebrow: 'الأثر الحالي',
        title: 'ملخص العمل',
        subtitle: 'قراءة سريعة لحركة المبادرات والطلبات.',
      ),
      const SizedBox(height: 12),
      dashboard.when(
        loading: () => const LinearProgressIndicator(),
        error: (error, _) => Text(_errorText(error)),
        data: (data) => GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.55,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: [
            _ImpactMetric(
              label: 'جميع الحملات',
              value: data.totalCampaignsCount,
              icon: Icons.campaign_outlined,
              color: context.appColors.primary,
            ),
            _ImpactMetric(
              label: 'الحملات النشطة',
              value: data.activeCampaignsCount,
              icon: Icons.bolt_rounded,
              color: context.appColors.success,
            ),
            _ImpactMetric(
              label: 'عروض تنتظر',
              value: data.pendingDonationOffersCount,
              icon: Icons.volunteer_activism_outlined,
              color: context.appColors.warning,
            ),
            _ImpactMetric(
              label: 'طلبات مفتوحة',
              value: data.openAssistanceRequestsCount,
              icon: Icons.favorite_outline_rounded,
              color: const Color(0xFFD14E62),
            ),
          ],
        ),
      ),
      const SizedBox(height: 24),
      const _SectionHeading(
        eyebrow: 'آخر التحديثات',
        title: 'الحملات الأخيرة',
        subtitle: 'آخر المبادرات التي عملت عليها المنظمة.',
      ),
      const SizedBox(height: 10),
      campaigns.when(
        loading: () => const LinearProgressIndicator(),
        error: (error, _) => Text(_errorText(error)),
        data: (items) => items.isEmpty
            ? const _Empty(
                text: 'ابدأ بإنشاء أول حملة للمنظمة.',
                icon: Icons.campaign_outlined,
              )
            : Column(
                children: items
                    .take(2)
                    .map((item) => _CompactCampaignCard(item: item))
                    .toList(growable: false),
              ),
      ),
    ],
  );
}

class _CampaignsSection extends StatelessWidget {
  const _CampaignsSection({
    required this.state,
    required this.workingId,
    required this.onCreate,
    required this.onUpdate,
  });
  final AsyncValue<List<DonationCampaign>> state;
  final String? workingId;
  final VoidCallback onCreate;
  final Future<void> Function(String, String) onUpdate;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      _SectionHeading(
        eyebrow: 'إدارة المبادرات',
        title: 'حملات المنظمة',
        subtitle: 'أنشئ الحملة وحدد حالتها وفق تقدم العمل.',
        action: IconButton.filled(
          onPressed: onCreate,
          tooltip: 'إنشاء حملة',
          icon: const Icon(Icons.add_rounded),
        ),
      ),
      const SizedBox(height: 14),
      state.when(
        loading: () => const LinearProgressIndicator(),
        error: (error, _) => Text(_errorText(error)),
        data: (items) => items.isEmpty
            ? const _Empty(
                text: 'لا توجد حملات بعد. أنشئ أول مبادرة الآن.',
                icon: Icons.campaign_outlined,
              )
            : Column(
                children: items
                    .asMap()
                    .entries
                    .map((entry) {
                      final item = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 11),
                        child: AppReveal(
                          delay: Duration(milliseconds: entry.key * 45),
                          child: _CampaignCard(
                            item: item,
                            working: workingId == item.campaignId,
                            onUpdate: (status) =>
                                onUpdate(item.campaignId, status),
                          ),
                        ),
                      );
                    })
                    .toList(growable: false),
              ),
      ),
    ],
  );
}

class _DonationOffersSection extends StatelessWidget {
  const _DonationOffersSection({
    required this.state,
    required this.workingId,
    required this.onReview,
  });
  final AsyncValue<List<OrganizationDonationOffer>> state;
  final String? workingId;
  final Future<void> Function(String, String) onReview;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      const _SectionHeading(
        eyebrow: 'شبكة العطاء',
        title: 'عروض التبرع',
        subtitle: 'راجع العروض التي اجتازت التحقق وتابع استلامها.',
      ),
      const SizedBox(height: 14),
      state.when(
        loading: () => const LinearProgressIndicator(),
        error: (error, _) => Text(_errorText(error)),
        data: (items) => items.isEmpty
            ? const _Empty(
                text: 'لا توجد عروض تبرع موجهة للمنظمة.',
                icon: Icons.volunteer_activism_outlined,
              )
            : Column(
                children: items
                    .map(
                      (offer) => Padding(
                        padding: const EdgeInsets.only(bottom: 11),
                        child: _DonationOfferCard(
                          offer: offer,
                          working: workingId == offer.offerId,
                          onReview: (status) => onReview(offer.offerId, status),
                        ),
                      ),
                    )
                    .toList(growable: false),
              ),
      ),
    ],
  );
}

class _AssistanceSection extends StatelessWidget {
  const _AssistanceSection({
    required this.state,
    required this.workingId,
    required this.onUpdate,
  });
  final AsyncValue<List<OrganizationAssistanceRequest>> state;
  final String? workingId;
  final Future<void> Function(String, String) onUpdate;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      const _SectionHeading(
        eyebrow: 'رعاية المستفيدين',
        title: 'طلبات المساعدة',
        subtitle: 'تابع الحالات من الطلب الأول حتى اكتمال المساعدة.',
      ),
      const SizedBox(height: 14),
      state.when(
        loading: () => const LinearProgressIndicator(),
        error: (error, _) => Text(_errorText(error)),
        data: (items) => items.isEmpty
            ? const _Empty(
                text: 'لا توجد طلبات مساعدة حاليًا.',
                icon: Icons.health_and_safety_outlined,
              )
            : Column(
                children: items
                    .map(
                      (request) => Padding(
                        padding: const EdgeInsets.only(bottom: 11),
                        child: _AssistanceCard(
                          request: request,
                          working: workingId == request.requestId,
                          onUpdate: (status) =>
                              onUpdate(request.requestId, status),
                        ),
                      ),
                    )
                    .toList(growable: false),
              ),
      ),
    ],
  );
}

class _OrganizationProfileSection extends StatelessWidget {
  const _OrganizationProfileSection({
    required this.dashboard,
    required this.verification,
    required this.onEdit,
    required this.onUpload,
  });
  final AsyncValue<OrganizationDashboard> dashboard;
  final AsyncValue<OrganizationVerification> verification;
  final VoidCallback onEdit;
  final VoidCallback onUpload;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _SectionHeading(
        eyebrow: 'بيانات موثوقة',
        title: 'ملف المنظمة',
        subtitle: 'حافظ على دقة بيانات التواصل ووثائق الاعتماد.',
        action: IconButton.filledTonal(
          onPressed: onEdit,
          tooltip: 'تعديل الملف',
          icon: const Icon(Icons.edit_outlined),
        ),
      ),
      const SizedBox(height: 14),
      dashboard.when(
        loading: () => const LinearProgressIndicator(),
        error: (error, _) => Text(_errorText(error)),
        data: (data) => _ProfileDetailsCard(data: data),
      ),
      const SizedBox(height: 16),
      verification.when(
        loading: () => const LinearProgressIndicator(),
        error: (error, _) => Text(_errorText(error)),
        data: (data) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _VerificationCard(
              status: data.verificationStatus,
              documents: data.documents.length,
              notes: data.verificationNotes,
              onUpload: onUpload,
            ),
            const SizedBox(height: 18),
            _SectionHeading(
              eyebrow: 'المستندات',
              title: 'وثائق الاعتماد',
              subtitle: '${data.documents.length} ملفات مرفوعة للمراجعة.',
              action: IconButton.outlined(
                onPressed: onUpload,
                icon: const Icon(Icons.add_rounded),
              ),
            ),
            const SizedBox(height: 10),
            if (data.documents.isEmpty)
              const _Empty(
                text: 'لم تُرفع وثائق اعتماد بعد.',
                icon: Icons.folder_open_outlined,
              )
            else
              ...data.documents.map(
                (document) => _DocumentTile(document: document),
              ),
          ],
        ),
      ),
    ],
  );
}

class _OrganizationHero extends StatelessWidget {
  const _OrganizationHero({required this.data, required this.onCreateCampaign});

  final OrganizationDashboard data;
  final VoidCallback onCreateCampaign;

  @override
  Widget build(BuildContext context) {
    final verified =
        data.verificationStatus.toLowerCase() == 'verified' ||
        data.verificationStatus.toLowerCase() == 'approved';
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [context.appColors.primaryDeep, context.appColors.primary],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(27),
        boxShadow: [
          BoxShadow(
            color: context.appColors.primaryDeep.withValues(alpha: .14),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          PositionedDirectional(
            top: -62,
            end: -38,
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: .055),
              ),
            ),
          ),
          PositionedDirectional(
            bottom: -74,
            start: -46,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.appColors.secondary.withValues(alpha: .075),
              ),
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
                        color: Colors.white.withValues(alpha: .12),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Icon(
                        Icons.apartment_rounded,
                        color: context.appColors.secondary,
                        size: 29,
                      ),
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.organizationName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                          Text(
                            '${data.city}، ${data.area}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            verified
                                ? Icons.verified_rounded
                                : Icons.hourglass_top_rounded,
                            color: verified
                                ? context.appColors.secondary
                                : Colors.white70,
                            size: 16,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            _verificationShort(data.verificationStatus),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
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
                    _HeroCount(
                      label: 'حملات نشطة',
                      value: data.activeCampaignsCount,
                    ),
                    _HeroCount(
                      label: 'عروض تنتظر',
                      value: data.pendingDonationOffersCount,
                    ),
                    _HeroCount(
                      label: 'طلبات مفتوحة',
                      value: data.openAssistanceRequestsCount,
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: onCreateCampaign,
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(0, 46),
                          backgroundColor: context.appColors.secondary,
                          foregroundColor: context.appColors.primaryDeep,
                        ),
                        icon: const Icon(Icons.add_rounded, size: 19),
                        label: const Text('إنشاء حملة جديدة'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .1),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: .13),
                        ),
                      ),
                      child: const Icon(
                        Icons.auto_awesome_outlined,
                        color: Colors.white,
                      ),
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

class _HeroCount extends StatelessWidget {
  const _HeroCount({required this.label, required this.value});
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      margin: const EdgeInsetsDirectional.only(end: 7),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
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
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white60, fontSize: 9),
          ),
        ],
      ),
    ),
  );
}

class _HeroSkeleton extends StatelessWidget {
  const _HeroSkeleton();
  @override
  Widget build(BuildContext context) => Container(
    height: 258,
    decoration: BoxDecoration(
      color: context.appColors.surfaceSoft,
      borderRadius: BorderRadius.circular(27),
    ),
    child: const Center(child: CircularProgressIndicator()),
  );
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
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
              style: TextStyle(
                color: context.appColors.primary,
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

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: color.withValues(alpha: .075),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: BorderSide(color: color.withValues(alpha: .12)),
    ),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
        child: Column(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: .09),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Icon(icon, color: color, size: 21),
            ),
            const SizedBox(height: 9),
            Text(
              label,
              maxLines: 1,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    ),
  );
}

class _ImpactMetric extends StatelessWidget {
  const _ImpactMetric({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
  final String label;
  final int value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: context.appColors.surface,
      borderRadius: BorderRadius.circular(21),
      border: Border.all(color: context.appColors.border),
    ),
    child: Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: color.withValues(alpha: .085),
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
                '$value',
                style: TextStyle(
                  color: context.appColors.text,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
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

class _CompactCampaignCard extends StatelessWidget {
  const _CompactCampaignCard({required this.item});
  final DonationCampaign item;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 9),
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: context.appColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: item.isUrgent
                  ? context.appColors.danger.withValues(alpha: .08)
                  : context.appColors.surfaceSoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              item.isUrgent ? Icons.priority_high_rounded : Icons.campaign,
              color: item.isUrgent ? context.appColors.danger : context.appColors.primary,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                Text(
                  item.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          _StatusPill(
            label: _campaignStatus(item.status),
                color: _campaignColor(context.appColors, item.status),
          ),
        ],
      ),
    ),
  );
}

class _CampaignCard extends StatelessWidget {
  const _CampaignCard({
    required this.item,
    required this.working,
    required this.onUpdate,
  });
  final DonationCampaign item;
  final bool working;
  final ValueChanged<String> onUpdate;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: item.isUrgent
                        ? const [Color(0xFFE96A78), Color(0xFFC94256)]
                        : [context.appColors.primary, context.appColors.primaryDeep],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  item.isUrgent
                      ? Icons.notifications_active_outlined
                      : Icons.campaign_outlined,
                  color: Colors.white,
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
                    const SizedBox(height: 3),
                    Text(
                      item.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                enabled: !working,
                onSelected: onUpdate,
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'Active', child: Text('تفعيل الحملة')),
                  PopupMenuItem(value: 'Closed', child: Text('إغلاق الحملة')),
                  PopupMenuItem(
                    value: 'Cancelled',
                    child: Text('إلغاء الحملة'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 13),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              _StatusPill(
                label: _campaignStatus(item.status),
            color: _campaignColor(context.appColors, item.status),
              ),
              if (item.isUrgent)
                _StatusPill(label: 'عاجلة', color: context.appColors.danger),
              if (item.acceptsPublicDonations)
                _StatusPill(
                  label: 'تستقبل التبرعات',
                  color: context.appColors.success,
                ),
            ],
          ),
          if (item.endsAtUtc != null) ...[
            const Divider(height: 24),
            Row(
              children: [
                Icon(
                  Icons.event_outlined,
                  size: 18,
                  color: context.appColors.textMuted,
                ),
                const SizedBox(width: 6),
                Text(
                  'تنتهي في ${_shortDate(item.endsAtUtc!)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ],
      ),
    ),
  );
}

class _DonationOfferCard extends StatelessWidget {
  const _DonationOfferCard({
    required this.offer,
    required this.working,
    required this.onReview,
  });
  final OrganizationDonationOffer offer;
  final bool working;
  final ValueChanged<String> onReview;

  @override
  Widget build(BuildContext context) {
    final state = donationStatus(context.appColors, offer.status);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 47,
                  height: 47,
                  decoration: BoxDecoration(
                    color: context.appColors.surfaceWarm,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    Icons.medication_liquid_outlined,
                    color: context.appColors.warning,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        offer.medicineName,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '${offer.packageCount} عبوات · ${offer.donorFullName}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                _StatusPill(label: state.label, color: state.color),
              ],
            ),
            if (offer.campaignTitle != null || offer.expiryDateUtc != null) ...[
              const Divider(height: 24),
              if (offer.campaignTitle != null)
                _InlineDetail(
                  icon: Icons.campaign_outlined,
                  text: offer.campaignTitle!,
                ),
              if (offer.reviewingPharmacyName != null)
                _InlineDetail(
                  icon: Icons.verified_outlined,
                  text: 'تم التحقق عبر ${offer.reviewingPharmacyName}',
                ),
              if (offer.expiryDateUtc != null)
                _InlineDetail(
                  icon: Icons.event_outlined,
                  text: 'الصلاحية حتى ${_shortDate(offer.expiryDateUtc!)}',
                ),
            ],
            if (offer.status == 'PendingReview') ...[
              const SizedBox(height: 13),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: working ? null : () => onReview('Approved'),
                      icon: const Icon(Icons.check_rounded, size: 18),
                      label: const Text('قبول العرض'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: working ? null : () => onReview('Rejected'),
                    child: const Text('رفض'),
                  ),
                ],
              ),
            ] else if (offer.status == 'Approved') ...[
              const SizedBox(height: 13),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: working ? null : () => onReview('Received'),
                  icon: const Icon(Icons.inventory_2_outlined),
                  label: const Text('تأكيد استلام التبرع'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AssistanceCard extends StatelessWidget {
  const _AssistanceCard({
    required this.request,
    required this.working,
    required this.onUpdate,
  });
  final OrganizationAssistanceRequest request;
  final bool working;
  final ValueChanged<String> onUpdate;

  @override
  Widget build(BuildContext context) {
    final state = donationStatus(context.appColors, request.status);
    final active = request.status == 'Open' || request.status == 'UnderReview';
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 47,
                  height: 47,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD14E62).withValues(alpha: .08),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.favorite_outline_rounded,
                    color: Color(0xFFD14E62),
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.medicineName,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '${request.requestedPackageCount} عبوات · ${request.requesterFullName}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                _StatusPill(label: state.label, color: state.color),
              ],
            ),
            if (request.neededBeforeUtc != null ||
                request.campaignTitle != null) ...[
              const Divider(height: 24),
              if (request.campaignTitle != null)
                _InlineDetail(
                  icon: Icons.campaign_outlined,
                  text: request.campaignTitle!,
                ),
              if (request.neededBeforeUtc != null)
                _InlineDetail(
                  icon: Icons.schedule_outlined,
                  text: 'مطلوب قبل ${_shortDate(request.neededBeforeUtc!)}',
                ),
            ],
            if (active) ...[
              const SizedBox(height: 13),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (request.status == 'Open')
                    OutlinedButton.icon(
                      onPressed: working ? null : () => onUpdate('UnderReview'),
                      icon: const Icon(Icons.visibility_outlined, size: 18),
                      label: const Text('بدء المراجعة'),
                    ),
                  FilledButton.icon(
                    onPressed: working ? null : () => onUpdate('Fulfilled'),
                    icon: const Icon(Icons.done_all_rounded, size: 18),
                    label: const Text('تمت المساعدة'),
                  ),
                  TextButton(
                    onPressed: working ? null : () => onUpdate('Rejected'),
                    child: const Text('تعذر التلبية'),
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

class _ProfileDetailsCard extends StatelessWidget {
  const _ProfileDetailsCard({required this.data});
  final OrganizationDashboard data;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(17),
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.apartment_outlined,
            label: 'اسم المنظمة',
            value: data.organizationName,
          ),
          _InfoRow(
            icon: Icons.badge_outlined,
            label: 'رقم التسجيل',
            value: data.registrationNumber,
          ),
          _InfoRow(
            icon: Icons.location_on_outlined,
            label: 'العنوان',
            value: '${data.city}، ${data.area} · ${data.address}',
          ),
          if (data.phoneNumber != null)
            _InfoRow(
              icon: Icons.phone_outlined,
              label: 'التواصل',
              value: data.phoneNumber!,
            ),
          if (data.description != null)
            _InfoRow(
              icon: Icons.notes_rounded,
              label: 'نبذة',
              value: data.description!,
              last: true,
            ),
        ],
      ),
    ),
  );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.last = false,
  });
  final IconData icon;
  final String label;
  final String value;
  final bool last;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 39,
              height: 39,
              decoration: BoxDecoration(
                color: context.appColors.surfaceSoft,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, size: 19, color: context.appColors.primary),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      if (!last) const Divider(),
    ],
  );
}

class _DocumentTile extends StatelessWidget {
  const _DocumentTile({required this.document});
  final OrganizationDocument document;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 9),
    child: Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: context.appColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: context.appColors.surfaceSoft,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              Icons.description_outlined,
              color: context.appColors.primary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document.originalFileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                Text(
                  '${_documentType(document.documentType)} · ${_fileSize(document.fileSizeBytes)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Icon(Icons.check_circle_rounded, color: context.appColors.success),
        ],
      ),
    ),
  );
}

class _InlineDetail extends StatelessWidget {
  const _InlineDetail({required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 5),
    child: Row(
      children: [
        Icon(icon, size: 17, color: context.appColors.textMuted),
        const SizedBox(width: 7),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodySmall),
        ),
      ],
    ),
  );
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
    decoration: BoxDecoration(
      color: color.withValues(alpha: .09),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: color,
        fontSize: 9.5,
        fontWeight: FontWeight.w900,
      ),
    ),
  );
}

class _Field extends StatelessWidget {
  const _Field({required this.controller, required this.label, this.lines = 1});
  final TextEditingController controller;
  final String label;
  final int lines;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: TextField(
      controller: controller,
      minLines: lines,
      maxLines: lines,
      decoration: InputDecoration(labelText: label),
    ),
  );
}

class _DateSelector extends StatelessWidget {
  const _DateSelector({
    required this.label,
    required this.value,
    required this.onTap,
  });
  final String label;
  final DateTime? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: context.appColors.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(17),
      side: BorderSide(color: context.appColors.border),
    ),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(17),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            Icon(
              Icons.event_outlined,
              color: context.appColors.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: context.appColors.textMuted,
                      fontSize: 9.5,
                    ),
                  ),
                  Text(
                    value == null ? 'اختياري' : _shortDate(value!),
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
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

class _VerificationCard extends StatelessWidget {
  const _VerificationCard({
    required this.status,
    required this.documents,
    required this.onUpload,
    this.notes,
  });
  final String status;
  final int documents;
  final String? notes;
  final VoidCallback onUpload;
  @override
  Widget build(BuildContext context) {
    final verified =
        status.toLowerCase() == 'verified' ||
        status.toLowerCase() == 'approved';
    final rejected = status.toLowerCase() == 'rejected';
    final color = verified
        ? context.appColors.success
        : rejected
        ? context.appColors.danger
        : context.appColors.warning;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .07),
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: color.withValues(alpha: .14)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              verified
                  ? Icons.verified_user_rounded
                  : Icons.fact_check_outlined,
              color: color,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _verificationText(status),
                  style: TextStyle(color: color, fontWeight: FontWeight.w900),
                ),
                Text(
                  notes ?? '$documents وثائق مرفوعة',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          IconButton.filledTonal(
            onPressed: onUpload,
            tooltip: 'رفع وثيقة',
            icon: const Icon(Icons.upload_rounded),
          ),
        ],
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.text, this.icon = Icons.inbox_outlined});
  final String text;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
    decoration: BoxDecoration(
      color: context.appColors.surface,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: context.appColors.border),
    ),
    child: Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: context.appColors.surfaceSoft,
            borderRadius: BorderRadius.circular(17),
          ),
          child: Icon(icon, color: context.appColors.primary, size: 25),
        ),
        const SizedBox(height: 12),
        Text(text, textAlign: TextAlign.center),
      ],
    ),
  );
}

String _errorText(Object error) =>
    error is ApiException ? error.message : 'تعذر إكمال العملية حاليًا.';
String _verificationText(String status) => switch (status.toLowerCase()) {
  'verified' || 'approved' => 'تم التحقق من المنظمة',
  'rejected' => 'تم رفض التحقق',
  'underreview' || 'pending' => 'التحقق قيد المراجعة',
  _ => 'التحقق غير مكتمل',
};
String _verificationShort(String status) => switch (status.toLowerCase()) {
  'verified' || 'approved' => 'موثقة',
  'rejected' => 'مرفوضة',
  'underreview' || 'pending' => 'قيد المراجعة',
  _ => 'غير مكتملة',
};
String _campaignStatus(String status) => switch (status.toLowerCase()) {
  'active' => 'نشطة',
  'closed' => 'مغلقة',
  'cancelled' => 'ملغاة',
  _ => 'مسودة',
};
Color _campaignColor(AppColors colors, String status) => switch (status
    .toLowerCase()) {
  'active' => colors.success,
  'closed' => colors.textMuted,
  'cancelled' => colors.danger,
  _ => colors.warning,
};
String _shortDate(DateTime value) =>
    '${value.year}/${value.month.toString().padLeft(2, '0')}/${value.day.toString().padLeft(2, '0')}';
String _documentType(String value) => switch (value.toLowerCase()) {
  'registrationcertificate' => 'شهادة التسجيل',
  'licenseddocument' => 'وثيقة الترخيص',
  'identitydocument' => 'إثبات الهوية',
  _ => 'وثيقة اعتماد',
};
String _fileSize(int bytes) {
  if (bytes >= 1024 * 1024) {
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
  return '${(bytes / 1024).toStringAsFixed(0)} KB';
}
