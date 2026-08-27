import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/layout.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../../core/widgets/app_reveal.dart';
import '../../../../core/widgets/async_states.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../donations/data/models/donation_models.dart';
import '../../data/models/organization_models.dart';
import '../../data/repositories/organization_repository.dart';
import '../controllers/organization_providers.dart';

class OrganizationWorkspacePage extends ConsumerStatefulWidget {
  const OrganizationWorkspacePage({
    this.initialSection = 0,
    super.key,
  });

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
    final l10n = AppLocalizations.of(context);

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
            Text(l10n.organizationManagement),
            const SizedBox(height: 2),
            Text(
              l10n.orgManagementSubtitle,
              style: TextStyle(
                color: context.appColors.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _refresh,
            tooltip: l10n.refreshDataTooltip,
            icon: const Icon(Icons.refresh_rounded),
          ),
          PopupMenuButton<String>(
            tooltip: l10n.moreLabel,
            icon: const Icon(Icons.more_horiz_rounded),
            onSelected: (value) {
              if (value == 'profile') {
                _loadAndEditProfile();
              }

              if (value == 'document') {
                _uploadDocument();
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'profile',
                child: ListTile(
                  leading: const Icon(Icons.edit_outlined),
                  title: Text(l10n.editOrganizationData),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: 'document',
                child: ListTile(
                  leading: const Icon(Icons.upload_file_outlined),
                  title: Text(l10n.uploadVerificationDocument),
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
          padding: EdgeInsets.fromLTRB(
            20,
            18,
            20,
            kBottomNavReserved + 24,
          ),
          children: [
            AppReveal(
              child: dashboard.when(
                loading: () => const _HeroSkeleton(),
                error: (error, _) => AppErrorState(
                  error: error,
                  onRetry: () =>
                      ref.invalidate(organizationDashboardProvider),
                ),
                data: (data) => _OrganizationHero(
                  data: data,
                  onCreateCampaign: _createCampaign,
                ),
              ),
            ),
            const SizedBox(height: 22),
            AppReveal(
              delay: const Duration(milliseconds: 80),
              child: _SectionNavigation(
                selectedIndex: _selectedSection,
                onSelected: (value) {
                  setState(() => _selectedSection = value);
                },
                pendingOffers:
                    dashboard.valueOrNull?.pendingDonationOffersCount,
                openRequests:
                    dashboard.valueOrNull?.openAssistanceRequestsCount,
              ),
            ),
            const SizedBox(height: 28),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, .025),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
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

  // ============================================================
  // CREATE CAMPAIGN
  // ============================================================

  Future<void> _createCampaign() async {
    final l10n = AppLocalizations.of(context);

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
      backgroundColor: context.appColors.background,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                20,
                20,
                20 + MediaQuery.viewInsetsOf(context).bottom,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 42,
                        height: 4,
                        decoration: BoxDecoration(
                          color: context.appColors.border,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
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
                                l10n.newCampaign,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                l10n.addCampaignInfoSubtitle,
                                style: TextStyle(
                                  color: context.appColors.textMuted,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),

                    _Field(
                      controller: title,
                      hint: l10n.campaignTitleField,
                    ),

                    _Field(
                      controller: description,
                      hint: l10n.campaignDescriptionField,
                      lines: 3,
                    ),

                    _Field(
                      controller: medicines,
                      hint: l10n.requestedMedicinesField,
                      lines: 2,
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: _Field(
                            controller: city,
                            hint: l10n.cityLabel,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _Field(
                            controller: area,
                            hint: l10n.areaLabel,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    Container(
                      decoration: BoxDecoration(
                        color: context.appColors.surfaceSoft,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: context.appColors.border,
                        ),
                      ),
                      child: Column(
                        children: [
                          SwitchListTile(
                            title: Text(l10n.urgentCampaign),
                            subtitle: Text(l10n.urgentCampaignSubtitle),
                            secondary: const Icon(
                              Icons.priority_high_rounded,
                            ),
                            value: isUrgent,
                            onChanged: (value) {
                              setSheetState(() {
                                isUrgent = value;
                              });
                            },
                          ),
                          Divider(
                            height: 1,
                            color: context.appColors.border,
                          ),
                          SwitchListTile(
                            title: Text(l10n.acceptPublicDonations),
                            subtitle: Text(
                              l10n.acceptPublicDonationsSubtitle,
                            ),
                            secondary: const Icon(
                              Icons.volunteer_activism_outlined,
                            ),
                            value: acceptsDonations,
                            onChanged: (value) {
                              setSheetState(() {
                                acceptsDonations = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Expanded(
                          child: _DateSelector(
                            label: l10n.startDateLabel,
                            value: startsAt,
                            onTap: () async {
                              final value = await _pickCampaignDate(
                                context,
                                initial: startsAt,
                              );

                              if (value != null) {
                                setSheetState(() {
                                  startsAt = value;
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _DateSelector(
                            label: l10n.endDateLabel,
                            value: endsAt,
                            onTap: () async {
                              final value = await _pickCampaignDate(
                                context,
                                initial: endsAt,
                              );

                              if (value != null) {
                                setSheetState(() {
                                  endsAt = value;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 22),

                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {
                          Navigator.pop(sheetContext, true);
                        },
                        icon: const Icon(Icons.arrow_forward_rounded),
                        label: Text(l10n.createCampaign),
                      ),
                    ),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            );
          },
        );
      },
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      title.dispose();
      description.dispose();
      medicines.dispose();
      city.dispose();
      area.dispose();
    });
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

  // ============================================================
  // EDIT ORGANIZATION PROFILE
  // ============================================================

  Future<void> _editProfile(OrganizationDashboard current) async {
    final l10n = AppLocalizations.of(context);

    final name = TextEditingController(
      text: current.organizationName,
    );

    final registration = TextEditingController(
      text: current.registrationNumber,
    );

    final phone = TextEditingController(
      text: current.phoneNumber,
    );

    final city = TextEditingController(
      text: current.city,
    );

    final area = TextEditingController(
      text: current.area,
    );

    final address = TextEditingController(
      text: current.address,
    );

    final description = TextEditingController(
      text: current.description,
    );

    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: context.appColors.background,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            20 + MediaQuery.viewInsetsOf(sheetContext).bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: context.appColors.border,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: context.appColors.surfaceSoft,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        Icons.apartment_outlined,
                        color: context.appColors.primary,
                        size: 25,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.organizationData,
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            l10n.editOrganizationData,
                            style: TextStyle(
                              color: context.appColors.textMuted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                _Field(
                  controller: name,
                  hint: l10n.organizationNameField,
                ),

                _Field(
                  controller: registration,
                  hint: l10n.registrationNumberField,
                ),

                _Field(
                  controller: phone,
                  hint: l10n.phoneLabel,
                ),

                Row(
                  children: [
                    Expanded(
                      child: _Field(
                        controller: city,
                        hint: l10n.cityLabel,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _Field(
                        controller: area,
                        hint: l10n.areaLabel,
                      ),
                    ),
                  ],
                ),

                _Field(
                  controller: address,
                  hint: l10n.addressLabel,
                ),

                _Field(
                  controller: description,
                  hint: l10n.organizationDescriptionField,
                  lines: 4,
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.pop(sheetContext, true);
                    },
                    icon: const Icon(Icons.save_outlined),
                    label: Text(l10n.save),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(sheetContext, false);
                    },
                    child: Text(l10n.cancel),
                  ),
                ),

                const SizedBox(height: 60),
              ],
            ),
          ),
        );
      },
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
    setState(() {
      _workingId = 'load-profile';
    });

    try {
      final profile =
          await ref.read(organizationProfileProvider.future);

      if (mounted) {
        await _editProfile(profile);
      }
    } catch (error) {
      _message(
        _errorText(AppLocalizations.of(context), error),
        true,
      );
    } finally {
      if (mounted && _workingId == 'load-profile') {
        setState(() {
          _workingId = null;
        });
      }
    }
  }

  // ============================================================
  // DOCUMENT
  // ============================================================

  Future<void> _uploadDocument() async {
    final l10n = AppLocalizations.of(context);

    final types = {
      'RegistrationCertificate':
          l10n.docRegistrationCertificate,
      'OperatingLicense':
          l10n.docOperatingLicense,
      'ManagerIdentityDocument':
          l10n.docManagerIdentity,
      'TaxOrLegalDocument':
          l10n.docTaxOrLegal,
      'Other':
          l10n.docOther,
    };

    String selected = 'RegistrationCertificate';

    final documentType = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.documentTypeTitle),
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              return DropdownButtonFormField<String>(
                initialValue: selected,
                items: types.entries
                    .map(
                      (item) => DropdownMenuItem<String>(
                        value: item.key,
                        child: Text(item.value),
                      ),
                    )
                    .toList(growable: false),
                onChanged: (value) {
                  setDialogState(() {
                    selected = value ?? selected;
                  });
                },
              );
            },
          ),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.pop(context, selected);
              },
              child: Text(l10n.chooseFile),
            ),
          ],
        );
      },
    );

    if (documentType == null) return;

    const group = XTypeGroup(
      label: 'verification',
      extensions: [
        'pdf',
        'png',
        'jpg',
        'jpeg',
      ],
    );

    final file = await openFile(
      acceptedTypeGroups: const [group],
    );

    if (file == null) return;

    if (await file.length() > 10 * 1024 * 1024) {
      _message(l10n.documentSizeLimit, true);
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

  // ============================================================
  // ACTIONS
  // ============================================================

  Future<void> _updateCampaign(
    String id,
    String status,
  ) =>
      _run(id, () async {
        await ref
            .read(organizationRepositoryProvider)
            .updateCampaignStatus(
              id,
              status,
            );

        ref.invalidate(organizationCampaignsProvider);
      });

  Future<void> _reviewOffer(
    String id,
    String status,
  ) =>
      _run(id, () async {
        await ref
            .read(organizationRepositoryProvider)
            .reviewOffer(
              id,
              status: status,
            );

        ref
          ..invalidate(organizationOffersProvider)
          ..invalidate(organizationDashboardProvider);
      });

  Future<void> _updateRequest(
    String id,
    String status,
  ) =>
      _run(id, () async {
        await ref
            .read(organizationRepositoryProvider)
            .updateAssistanceStatus(
              id,
              status: status,
            );

        ref
          ..invalidate(organizationAssistanceProvider)
          ..invalidate(organizationDashboardProvider);
      });

  Future<void> _run(
    String id,
    Future<void> Function() action,
  ) async {
    setState(() {
      _workingId = id;
    });

    try {
      await action();

      _message(
        AppLocalizations.of(context).updateSaved,
        false,
      );
    } catch (error) {
      _message(
        _errorText(
          AppLocalizations.of(context),
          error,
        ),
        true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _workingId = null;
        });
      }
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

  void _message(
    String text,
    bool error,
  ) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor:
            error ? context.appColors.danger : null,
      ),
    );
  }
}

// ============================================================
// SECTION NAVIGATION
// ============================================================

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
    final l10n = AppLocalizations.of(context);

    final items =
        <({String label, IconData icon, int? count})>[
      (
        label: l10n.summaryLabel,
        icon: Icons.grid_view_rounded,
        count: null,
      ),
      (
        label: l10n.campaignsLabel,
        icon: Icons.campaign_outlined,
        count: null,
      ),
      (
        label: l10n.donationsLabel,
        icon: Icons.volunteer_activism_outlined,
        count: pendingOffers,
      ),
      (
        label: l10n.assistanceLabel,
        icon: Icons.health_and_safety_outlined,
        count: openRequests,
      ),
      (
        label: l10n.profileLabel,
        icon: Icons.apartment_outlined,
        count: null,
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items.asMap().entries.map((entry) {
          final selected = selectedIndex == entry.key;
          final item = entry.value;

          return Padding(
            padding: const EdgeInsetsDirectional.only(end: 9),
            child: Material(
              color: selected
                  ? context.appColors.primary
                  : context.appColors.surface,
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
                        color: selected
                            ? Colors.white
                            : context.appColors.primary,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        item.label,
                        style: TextStyle(
                          color: selected
                              ? Colors.white
                              : context.appColors.text,
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                      ),
                      if ((item.count ?? 0) > 0) ...[
                        const SizedBox(width: 7),
                        Container(
                          constraints:
                              const BoxConstraints(minWidth: 20),
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
                              color:
                                  context.appColors.primaryDeep,
                              fontSize: 11,
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
        }).toList(growable: false),
      ),
    );
  }
}

// ============================================================
// OVERVIEW
// ============================================================

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
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeading(
          eyebrow: l10n.quickAccess,
          title: l10n.whatDoYouWantToDo,
          subtitle: l10n.orgOperationsReady,
        ),

        const SizedBox(height: 15),

        Row(
          children: [
            Expanded(
              child: _QuickAction(
                icon: Icons.add_rounded,
                label: l10n.newCampaign,
                onTap: onCreateCampaign,
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: _QuickAction(
                icon: Icons.upload_file_outlined,
                label: l10n.uploadDocument,
                onTap: onUploadDocument,
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: _QuickAction(
                icon: Icons.edit_outlined,
                label: l10n.editProfileLabel,
                onTap: onEditProfile,
              ),
            ),
          ],
        ),

        const SizedBox(height: 28),

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

        const SizedBox(height: 30),

        _SectionHeading(
          eyebrow: l10n.currentImpact,
          title: l10n.workSummary,
          subtitle: l10n.workSummarySubtitle,
        ),

        const SizedBox(height: 15),

        dashboard.when(
          loading: () => const LinearProgressIndicator(),
          error: (error, _) =>
              Text(_errorText(l10n, error)),
          data: (data) => GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.55,
            mainAxisSpacing: 11,
            crossAxisSpacing: 11,
            children: [
              _ImpactMetric(
                label: l10n.allCampaigns,
                value: data.totalCampaignsCount,
                icon: Icons.campaign_outlined,
                color: context.appColors.primary,
              ),
              _ImpactMetric(
                label: l10n.activeCampaigns,
                value: data.activeCampaignsCount,
                icon: Icons.bolt_rounded,
                color: context.appColors.primary,
              ),
              _ImpactMetric(
                label: l10n.pendingOffers,
                value: data.pendingDonationOffersCount,
                icon: Icons.volunteer_activism_outlined,
                color: context.appColors.primary,
              ),
              _ImpactMetric(
                label: l10n.openRequests,
                value: data.openAssistanceRequestsCount,
                icon: Icons.favorite_outline_rounded,
                color: context.appColors.primary,
              ),
            ],
          ),
        ),

        const SizedBox(height: 30),

        _SectionHeading(
          eyebrow: l10n.latestUpdates,
          title: l10n.recentCampaigns,
          subtitle: l10n.recentCampaignsSubtitle,
        ),

        const SizedBox(height: 14),

        campaigns.when(
          loading: () => const LinearProgressIndicator(),
          error: (error, _) =>
              Text(_errorText(l10n, error)),
          data: (items) {
            if (items.isEmpty) {
              return _Empty(
                text: l10n.startFirstCampaign,
                icon: Icons.campaign_outlined,
              );
            }

            return Column(
              children: items
                  .take(2)
                  .map(
                    (item) => _CompactCampaignCard(
                      item: item,
                    ),
                  )
                  .toList(growable: false),
            );
          },
        ),
      ],
    );
  }
}

// ============================================================
// CAMPAIGNS
// ============================================================

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
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeading(
          eyebrow: l10n.manageInitiatives,
          title: l10n.orgCampaigns,
          subtitle: l10n.orgCampaignsSubtitle,
          action: IconButton.filled(
            onPressed: onCreate,
            tooltip: l10n.createCampaignTooltip,
            icon: const Icon(Icons.add_rounded),
          ),
        ),

        const SizedBox(height: 18),

        state.when(
          loading: () => const LinearProgressIndicator(),
          error: (error, _) =>
              Text(_errorText(l10n, error)),
          data: (items) {
            if (items.isEmpty) {
              return _Empty(
                text: l10n.noCampaignsYet,
                icon: Icons.campaign_outlined,
              );
            }

            return Column(
              children: items.asMap().entries.map((entry) {
                final item = entry.value;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: AppReveal(
                    delay: Duration(
                      milliseconds: entry.key * 45,
                    ),
                    child: _CampaignCard(
                      item: item,
                      working:
                          workingId == item.campaignId,
                      onUpdate: (status) => onUpdate(
                        item.campaignId,
                        status,
                      ),
                    ),
                  ),
                );
              }).toList(growable: false),
            );
          },
        ),
      ],
    );
  }
}

// ============================================================
// DONATION OFFERS
// ============================================================

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
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeading(
          eyebrow: l10n.givingNetwork,
          title: l10n.donationOffersTitle,
          subtitle: l10n.donationOffersSubtitle,
        ),

        const SizedBox(height: 18),

        state.when(
          loading: () => const LinearProgressIndicator(),
          error: (error, _) =>
              Text(_errorText(l10n, error)),
          data: (items) {
            if (items.isEmpty) {
              return _Empty(
                text: l10n.noDonationOffers,
                icon:
                    Icons.volunteer_activism_outlined,
              );
            }

            return Column(
              children: items.map((offer) {
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 16,
                  ),
                  child: _DonationOfferCard(
                    offer: offer,
                    working:
                        workingId == offer.offerId,
                    onReview: (status) => onReview(
                      offer.offerId,
                      status,
                    ),
                  ),
                );
              }).toList(growable: false),
            );
          },
        ),
      ],
    );
  }
}

// ============================================================
// ASSISTANCE
// ============================================================

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
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeading(
          eyebrow: l10n.beneficiaryCare,
          title: l10n.assistanceRequestsTitle,
          subtitle: l10n.assistanceRequestsSubtitle,
        ),

        const SizedBox(height: 18),

        state.when(
          loading: () => const LinearProgressIndicator(),
          error: (error, _) =>
              Text(_errorText(l10n, error)),
          data: (items) {
            if (items.isEmpty) {
              return _Empty(
                text: l10n.noAssistanceRequests,
                icon:
                    Icons.health_and_safety_outlined,
              );
            }

            return Column(
              children: items.map((request) {
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 16,
                  ),
                  child: _AssistanceCard(
                    request: request,
                    working:
                        workingId == request.requestId,
                    onUpdate: (status) => onUpdate(
                      request.requestId,
                      status,
                    ),
                  ),
                );
              }).toList(growable: false),
            );
          },
        ),
      ],
    );
  }
}

// ============================================================
// ORGANIZATION PROFILE
// ============================================================

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
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeading(
          eyebrow: l10n.reliableData,
          title: l10n.orgProfile,
          subtitle: l10n.orgProfileSubtitle,
          action: IconButton.filledTonal(
            onPressed: onEdit,
            tooltip: l10n.editProfileLabel,
            icon: const Icon(
              Icons.edit_outlined,
            ),
          ),
        ),

        const SizedBox(height: 18),

        dashboard.when(
          loading: () => const LinearProgressIndicator(),
          error: (error, _) =>
              Text(_errorText(l10n, error)),
          data: (data) => _ProfileDetailsCard(
            data: data,
          ),
        ),

        const SizedBox(height: 28),

        verification.when(
          loading: () => const LinearProgressIndicator(),
          error: (error, _) =>
              Text(_errorText(l10n, error)),
          data: (data) => Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              _VerificationCard(
                status: data.verificationStatus,
                documents: data.documents.length,
                notes: data.verificationNotes,
                onUpload: onUpload,
              ),

              const SizedBox(height: 28),

              _SectionHeading(
                eyebrow: l10n.documentsLabel,
                title: l10n.accreditationDocs,
                subtitle: l10n.uploadedDocsCount(
                  data.documents.length,
                ),
                action: IconButton.outlined(
                  onPressed: onUpload,
                  icon: const Icon(
                    Icons.add_rounded,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              if (data.documents.isEmpty)
                _Empty(
                  text: l10n.noAccreditationDocs,
                  icon:
                      Icons.folder_open_outlined,
                )
              else
                ...data.documents.map(
                  (document) => _DocumentTile(
                    document: document,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================
// HERO
// ============================================================

class _OrganizationHero extends StatelessWidget {
  const _OrganizationHero({
    required this.data,
    required this.onCreateCampaign,
  });

  final OrganizationDashboard data;
  final VoidCallback onCreateCampaign;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final verified =
        data.verificationStatus.toLowerCase() ==
                'verified' ||
            data.verificationStatus.toLowerCase() ==
                'approved';

    return Container(
      decoration: BoxDecoration(
        color: context.appColors.primary,
        borderRadius: BorderRadius.circular(27),
        border: Border.all(
          color: Colors.white.withValues(alpha: .08),
        ),
        boxShadow: [
          BoxShadow(
            color: context.appColors.primary
                .withValues(alpha: .14),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.white
                        .withValues(alpha: .12),
                    borderRadius:
                        BorderRadius.circular(18),
                  ),
                  child: Icon(
                    Icons.apartment_rounded,
                    color:
                        context.appColors.primaryLight,
                    size: 29,
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.organizationName,
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight:
                                  FontWeight.w900,
                            ),
                      ),
                      const SizedBox(height: 2),
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
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white
                        .withValues(alpha: .1),
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        verified
                            ? Icons.verified_rounded
                            : Icons
                                .hourglass_top_rounded,
                        color: verified
                            ? context
                                .appColors
                                .primaryLight
                            : Colors.white70,
                        size: 16,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        _verificationShort(
                          l10n,
                          data.verificationStatus,
                        ),
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
                  label: l10n.activeCampaigns,
                  value: data.activeCampaignsCount,
                ),
                _HeroCount(
                  label: l10n.pendingOffers,
                  value:
                      data.pendingDonationOffersCount,
                ),
                _HeroCount(
                  label: l10n.openRequests,
                  value:
                      data.openAssistanceRequestsCount,
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
                      minimumSize:
                          const Size(0, 46),
                      backgroundColor:
                          context.appColors.secondary,
                      foregroundColor:
                          context.appColors.primaryDeep,
                    ),
                    icon: const Icon(
                      Icons.add_rounded,
                      size: 19,
                    ),
                    label: Text(
                      l10n.createNewCampaign,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white
                        .withValues(alpha: .1),
                    borderRadius:
                        BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.white
                          .withValues(alpha: .13),
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
    );
  }
}

class _HeroCount extends StatelessWidget {
  const _HeroCount({
    required this.label,
    required this.value,
  });

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsetsDirectional.only(
          end: 7,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .08),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.white.withValues(alpha: .08),
          ),
        ),
        child: Column(
          children: [
            Text(
              '$value',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroSkeleton extends StatelessWidget {
  const _HeroSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 258,
      decoration: BoxDecoration(
        color: context.appColors.surfaceSoft,
        borderRadius: BorderRadius.circular(27),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

// ============================================================
// SECTION HEADING
// ============================================================

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
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                eyebrow,
                style: TextStyle(
                  color:
                      context.appColors.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: .3,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall,
              ),
            ],
          ),
        ),
        ?action,
      ],
    );
  }
}

// ============================================================
// QUICK ACTION
// ============================================================

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.appColors.surfaceSoft,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: context.appColors.border,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 15,
          ),
          child: Column(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: context.appColors.surface,
                  borderRadius:
                      BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: context.appColors.primary
                          .withValues(alpha: .09),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color:
                      context.appColors.primary,
                  size: 21,
                ),
              ),
              const SizedBox(height: 9),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// IMPACT METRIC
// ============================================================

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
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.appColors.surfaceSoft,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(
          color: context.appColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: context.appColors.surface,
              borderRadius:
                  BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: color,
              size: 21,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  '$value',
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: TextStyle(
                    color:
                        context.appColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// COMPACT CAMPAIGN
// ============================================================

class _CompactCampaignCard
    extends StatelessWidget {
  const _CompactCampaignCard({
    required this.item,
  });

  final DonationCampaign item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.appColors.surface,
          borderRadius: BorderRadius.circular(19),
          border: Border.all(
            color: context.appColors.border,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: item.isUrgent
                    ? context.appColors.danger
                        .withValues(alpha: .08)
                    : context.appColors.surfaceSoft,
                borderRadius:
                    BorderRadius.circular(14),
              ),
              child: Icon(
                item.isUrgent
                    ? Icons.priority_high_rounded
                    : Icons.campaign,
                color: item.isUrgent
                    ? context.appColors.danger
                    : context.appColors.primary,
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.description,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _StatusPill(
              label: _campaignStatus(
                AppLocalizations.of(context),
                item.status,
              ),
              color: _campaignColor(
                context.appColors,
                item.status,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// CAMPAIGN CARD
// ============================================================

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
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: item.isUrgent
                          ? [
                              context
                                  .appColors
                                  .primaryDark,
                              context
                                  .appColors
                                  .primaryDark
                                  .withValues(
                                    alpha: .8,
                                  ),
                            ]
                          : [
                              context
                                  .appColors
                                  .primary,
                              context
                                  .appColors
                                  .primaryDeep,
                            ],
                    ),
                    borderRadius:
                        BorderRadius.circular(15),
                  ),
                  child: Icon(
                    item.isUrgent
                        ? Icons
                            .notifications_active_outlined
                        : Icons.campaign_outlined,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.description,
                        maxLines: 3,
                        overflow:
                            TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  enabled: !working,
                  onSelected: onUpdate,
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'Active',
                      child: Text(
                        l10n.activateCampaign,
                      ),
                    ),
                    PopupMenuItem(
                      value: 'Closed',
                      child: Text(
                        l10n.closeCampaign,
                      ),
                    ),
                    PopupMenuItem(
                      value: 'Cancelled',
                      child: Text(
                        l10n.cancelCampaign,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),
            Wrap(
              spacing: 7,
              runSpacing: 7,
              children: [
                _StatusPill(
                  label: _campaignStatus(
                    l10n,
                    item.status,
                  ),
                  color: _campaignColor(
                    context.appColors,
                    item.status,
                  ),
                ),
                if (item.isUrgent)
                  _StatusPill(
                    label: l10n.urgentLabel,
                    color:
                        context.appColors.primaryDark,
                  ),
                if (item.acceptsPublicDonations)
                  _StatusPill(
                    label:
                        l10n.acceptsDonationsLabel,
                    color:
                        context.appColors.primary,
                  ),
              ],
            ),
            if (item.endsAtUtc != null) ...[
              const SizedBox(height: 8),
              Divider(
                height: 24,
                color: context.appColors.border,
              ),
              Row(
                children: [
                  Icon(
                    Icons.event_outlined,
                    size: 18,
                    color:
                        context.appColors.textMuted,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    l10n.campaignEndsOn(
                      _shortDate(
                        item.endsAtUtc!,
                      ),
                    ),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall,
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

// ============================================================
// DONATION OFFER CARD
// ============================================================

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
    final l10n = AppLocalizations.of(context);

    final state = _donationStatus(
      context.appColors,
      offer.status,
      l10n,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 47,
                  height: 47,
                  decoration: BoxDecoration(
                    color:
                        context.appColors.surfaceWarm,
                    borderRadius:
                        BorderRadius.circular(15),
                  ),
                  child: Icon(
                    Icons.medication_liquid_outlined,
                    color:
                        context.appColors.warning,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        offer.medicineName,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.offerPackages(
                          offer.packageCount,
                          offer.donorFullName,
                        ),
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 7),
                _StatusPill(
                  label: state.label,
                  color: state.color,
                ),
              ],
            ),
            if (offer.campaignTitle != null ||
                offer.reviewingPharmacyName != null ||
                offer.expiryDateUtc != null) ...[
              Divider(
                height: 28,
                color: context.appColors.border,
              ),
              if (offer.campaignTitle != null)
                _InlineDetail(
                  icon: Icons.campaign_outlined,
                  text: offer.campaignTitle!,
                ),
              if (offer.reviewingPharmacyName != null)
                _InlineDetail(
                  icon: Icons.verified_outlined,
                  text: l10n.verifiedViaPharmacy(
                    offer.reviewingPharmacyName!,
                  ),
                ),
              if (offer.expiryDateUtc != null)
                _InlineDetail(
                  icon: Icons.event_outlined,
                  text: l10n.validUntil(
                    _shortDate(
                      offer.expiryDateUtc!,
                    ),
                  ),
                ),
            ],
            if (offer.status == 'PendingReview') ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: working
                          ? null
                          : () =>
                              onReview('Approved'),
                      icon: const Icon(
                        Icons.check_rounded,
                        size: 18,
                      ),
                      label: Text(
                        l10n.acceptOffer,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: working
                        ? null
                        : () =>
                            onReview('Rejected'),
                    child: Text(l10n.reject),
                  ),
                ],
              ),
            ] else if (offer.status == 'Approved') ...[
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: working
                      ? null
                      : () =>
                          onReview('Received'),
                  icon: const Icon(
                    Icons.inventory_2_outlined,
                  ),
                  label: Text(
                    l10n.confirmDonationReceived,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ============================================================
// ASSISTANCE CARD
// ============================================================

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
    final l10n = AppLocalizations.of(context);

    final state = _donationStatus(
      context.appColors,
      request.status,
      l10n,
    );

    final active =
        request.status == 'Open' ||
            request.status == 'UnderReview';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 47,
                  height: 47,
                  decoration: BoxDecoration(
                    color: context.appColors.primary
                        .withValues(alpha: .08),
                    borderRadius:
                        BorderRadius.circular(15),
                  ),
                  child: Icon(
                    Icons.favorite_outline_rounded,
                    color:
                        context.appColors.primary,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.medicineName,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.requestPackages(
                          request.requestedPackageCount,
                          request.requesterFullName,
                        ),
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 7),
                _StatusPill(
                  label: state.label,
                  color: state.color,
                ),
              ],
            ),
            if (request.neededBeforeUtc != null ||
                request.campaignTitle != null) ...[
              Divider(
                height: 28,
                color: context.appColors.border,
              ),
              if (request.campaignTitle != null)
                _InlineDetail(
                  icon: Icons.campaign_outlined,
                  text: request.campaignTitle!,
                ),
              if (request.neededBeforeUtc != null)
                _InlineDetail(
                  icon: Icons.schedule_outlined,
                  text: l10n.neededBefore(
                    _shortDate(
                      request.neededBeforeUtc!,
                    ),
                  ),
                ),
            ],
            if (active) ...[
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (request.status == 'Open')
                    OutlinedButton.icon(
                      onPressed: working
                          ? null
                          : () => onUpdate(
                                'UnderReview',
                              ),
                      icon: const Icon(
                        Icons.visibility_outlined,
                        size: 18,
                      ),
                      label: Text(
                        l10n.startReview,
                      ),
                    ),
                  FilledButton.icon(
                    onPressed: working
                        ? null
                        : () =>
                            onUpdate('Fulfilled'),
                    icon: const Icon(
                      Icons.done_all_rounded,
                      size: 18,
                    ),
                    label: Text(
                      l10n.assistanceCompleted,
                    ),
                  ),
                  TextButton(
                    onPressed: working
                        ? null
                        : () =>
                            onUpdate('Rejected'),
                    child: Text(
                      l10n.cannotFulfill,
                    ),
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

// ============================================================
// PROFILE DETAILS
// ============================================================

class _ProfileDetailsCard extends StatelessWidget {
  const _ProfileDetailsCard({
    required this.data,
  });

  final OrganizationDashboard data;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(
          children: [
            _InfoRow(
              icon: Icons.apartment_outlined,
              label:
                  l10n.organizationNameField,
              value: data.organizationName,
            ),
            _InfoRow(
              icon: Icons.badge_outlined,
              label:
                  l10n.registrationNumberField,
              value: data.registrationNumber,
            ),
            _InfoRow(
              icon: Icons.location_on_outlined,
              label: l10n.addressLabel,
              value:
                  '${data.city}، ${data.area} · ${data.address}',
            ),
            if (data.phoneNumber != null)
              _InfoRow(
                icon: Icons.phone_outlined,
                label: l10n.contactLabel,
                value: data.phoneNumber!,
              ),
            if (data.description != null)
              _InfoRow(
                icon: Icons.notes_rounded,
                label: l10n.aboutLabel,
                value: data.description!,
                last: true,
              ),
          ],
        ),
      ),
    );
  }
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 11,
          ),
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Container(
                width: 39,
                height: 39,
                decoration: BoxDecoration(
                  color:
                      context.appColors.surfaceSoft,
                  borderRadius:
                      BorderRadius.circular(13),
                ),
                child: Icon(
                  icon,
                  size: 19,
                  color:
                      context.appColors.primary,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      value,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!last)
          Divider(
            color: context.appColors.border,
            height: 1,
          ),
      ],
    );
  }
}

// ============================================================
// DOCUMENT
// ============================================================

class _DocumentTile extends StatelessWidget {
  const _DocumentTile({
    required this.document,
  });

  final OrganizationDocument document;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: context.appColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: context.appColors.border,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color:
                    context.appColors.surfaceSoft,
                borderRadius:
                    BorderRadius.circular(13),
              ),
              child: Icon(
                Icons.description_outlined,
                color:
                    context.appColors.primary,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    document.originalFileName,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${_documentType(AppLocalizations.of(context), document.documentType)} · ${_fileSize(document.fileSizeBytes)}',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.check_circle_rounded,
              color: context.appColors.success,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// INLINE DETAIL
// ============================================================

class _InlineDetail extends StatelessWidget {
  const _InlineDetail({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        children: [
          Icon(
            icon,
            size: 17,
            color: context.appColors.textMuted,
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// STATUS PILL
// ============================================================

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .09),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

// ============================================================
// FIELD
// ============================================================

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.hint,
    this.lines = 1,
  });

  final TextEditingController controller;
  final String hint;
  final int lines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppTextField(
        controller: controller,

        // النص يظهر داخل الحقل كـ Placeholder
        // وليس كعنوان فوق الحقل.
        hint: hint,

        minLines: lines,
        maxLines: lines,
      ),
    );
  }
}

// ============================================================
// DATE SELECTOR
// ============================================================

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
  Widget build(BuildContext context) {
    return Material(
      color: context.appColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(17),
        side: BorderSide(
          color: context.appColors.border,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          child: Row(
            children: [
              Icon(
                Icons.event_outlined,
                color:
                    context.appColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: context
                            .appColors
                            .textMuted,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value == null
                          ? AppLocalizations.of(
                              context,
                            ).optionalLabel
                          : _shortDate(value!),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight:
                            FontWeight.w800,
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
}

// ============================================================
// VERIFICATION
// ============================================================

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
    final l10n = AppLocalizations.of(context);

    final verified =
        status.toLowerCase() == 'verified' ||
            status.toLowerCase() == 'approved';

    final color = verified
        ? context.appColors.primary
        : context.appColors.primaryDeep;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: context.appColors.surfaceSoft,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: context.appColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: context.appColors.surface,
              borderRadius:
                  BorderRadius.circular(14),
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
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  _verificationText(
                    l10n,
                    status,
                  ),
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  notes ??
                      l10n.documentsUploaded(
                        documents,
                      ),
                  maxLines: 2,
                  overflow:
                      TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall,
                ),
              ],
            ),
          ),
          IconButton.filledTonal(
            onPressed: onUpload,
            tooltip: l10n.uploadDocument,
            icon: const Icon(
              Icons.upload_rounded,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// EMPTY
// ============================================================

class _Empty extends StatelessWidget {
  const _Empty({
    required this.text,
    this.icon = Icons.inbox_outlined,
  });

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 30,
      ),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: context.appColors.border,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color:
                  context.appColors.surfaceSoft,
              borderRadius:
                  BorderRadius.circular(17),
            ),
            child: Icon(
              icon,
              color:
                  context.appColors.primary,
              size: 25,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            text,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ============================================================
// HELPERS
// ============================================================

String _errorText(
  AppLocalizations l10n,
  Object error,
) {
  return error is ApiException
      ? error.localize(l10n)
      : l10n.operationFailed;
}

String _verificationText(
  AppLocalizations l10n,
  String status,
) {
  return switch (status.toLowerCase()) {
    'verified' || 'approved' =>
      l10n.orgVerified,
    'rejected' =>
      l10n.orgVerificationRejected,
    'underreview' || 'pending' =>
      l10n.orgVerificationUnderReview,
    _ =>
      l10n.orgVerificationIncomplete,
  };
}

String _verificationShort(
  AppLocalizations l10n,
  String status,
) {
  return switch (status.toLowerCase()) {
    'verified' || 'approved' =>
      l10n.verifiedShort,
    'rejected' =>
      l10n.rejectedShort,
    'underreview' || 'pending' =>
      l10n.underReviewShort,
    _ =>
      l10n.incompleteShort,
  };
}

String _campaignStatus(
  AppLocalizations l10n,
  String status,
) {
  return switch (status.toLowerCase()) {
    'active' =>
      l10n.campaignActive,
    'closed' =>
      l10n.campaignClosed,
    'cancelled' =>
      l10n.campaignCancelled,
    _ =>
      l10n.campaignDraft,
  };
}

Color _campaignColor(
  AppColors colors,
  String status,
) {
  return switch (status.toLowerCase()) {
    'active' =>
      colors.primary,
    'closed' =>
      colors.textMuted,
    'cancelled' =>
      colors.primary,
    _ =>
      colors.primary,
  };
}

// ============================================================
// DONATION STATUS
// ============================================================

({
  String label,
  Color color,
}) _donationStatus(
  AppColors colors,
  String status,
  AppLocalizations l10n,
) {
  final normalized = status
      .replaceAll('_', '')
      .replaceAll('-', '')
      .replaceAll(' ', '')
      .toLowerCase();

  return switch (normalized) {
    'pendingreview' => (
        label: l10n.startReview,
        color: colors.warning,
      ),
    'approved' => (
        label: l10n.acceptOffer,
        color: colors.primary,
      ),
    'received' => (
        label: l10n.confirmDonationReceived,
        color: colors.success,
      ),
    'rejected' => (
        label: l10n.reject,
        color: colors.danger,
      ),
    'open' => (
        label: l10n.startReview,
        color: colors.primary,
      ),
    'underreview' => (
        label: l10n.startReview,
        color: colors.warning,
      ),
    'fulfilled' => (
        label: l10n.assistanceCompleted,
        color: colors.success,
      ),
    _ => (
        label: status,
        color: colors.primary,
      ),
  };
}

String _shortDate(DateTime value) {
  return '${value.year}/'
      '${value.month.toString().padLeft(2, '0')}/'
      '${value.day.toString().padLeft(2, '0')}';
}

String _documentType(
  AppLocalizations l10n,
  String value,
) {
  return switch (value.toLowerCase()) {
    'registrationcertificate' =>
      l10n.docRegistrationCertificate,
    'licenseddocument' =>
      l10n.docLicensedDocument,
    'identitydocument' =>
      l10n.docIdentityDocument,
    _ =>
      l10n.docAccreditation,
  };
}

String _fileSize(int bytes) {
  if (bytes >= 1024 * 1024) {
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  if (bytes >= 1024) {
    return '${(bytes / 1024).toStringAsFixed(0)} KB';
  }

  return '$bytes B';
}