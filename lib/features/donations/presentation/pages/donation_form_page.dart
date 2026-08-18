import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../../core/widgets/app_reveal.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../medicines/presentation/controllers/medicines_providers.dart';
import '../../data/models/donation_models.dart';
import '../../data/repositories/donations_repository.dart';
import '../controllers/donations_providers.dart';

enum DonationFormMode { offer, assistance }

class DonationFormPage extends ConsumerStatefulWidget {
  const DonationFormPage({required this.mode, super.key});

  final DonationFormMode mode;

  @override
  ConsumerState<DonationFormPage> createState() => _DonationFormPageState();
}

class _DonationFormPageState extends ConsumerState<DonationFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _medicineSearch = TextEditingController();
  final _package = TextEditingController(text: '1');
  final _notes = TextEditingController();
  String _searchTerm = '';
  String? _medicineId;
  String? _reviewingPharmacyId;
  String? _organizationId;
  String? _campaignId;
  DateTime? _date;
  bool _isSealed = true;
  bool _saving = false;

  bool get _isOffer => widget.mode == DonationFormMode.offer;

  @override
  void dispose() {
    _medicineSearch.dispose();
    _package.dispose();
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final medicines = ref.watch(
      medicinesProvider((searchTerm: _searchTerm, pageNumber: 1, pageSize: 30)),
    );
    final organizations = ref.watch(publicOrganizationsProvider);
    final verificationPharmacies = ref.watch(
      donationVerificationPharmaciesProvider,
    );
    final campaigns = ref.watch(activeCampaignsProvider(_organizationId));
    final campaignItems =
        campaigns.valueOrNull
            ?.where((item) => !_isOffer || item.acceptsPublicDonations)
            .toList(growable: false) ??
        const <DonationCampaign>[];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isOffer ? l10n.offerDonationTitle : l10n.assistanceRequestPageTitle,
        ),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              children: [
                AppReveal(child: _DonationFormHero(isOffer: _isOffer)),
                const SizedBox(height: 22),
                _FormSectionTitle(
                  number: '01',
                  title: l10n.chooseMedicineSection,
                  subtitle: l10n.chooseMedicineSectionSubtitle,
                ),
                const SizedBox(height: 10),
                AppTextField(
                  label: l10n.medicineSearchLabel,
                  hint: l10n.medicineSearchHint,
                  controller: _medicineSearch,
                  icon: Icons.search_rounded,
                  textInputAction: TextInputAction.search,
                  onSubmitted: _searchMedicines,
                  suffixIcon: IconButton.filled(
                    onPressed: () => _searchMedicines(_medicineSearch.text),
                    icon: const Icon(Icons.search_rounded),
                    tooltip: l10n.searchLabel,
                  ),
                ),
                const SizedBox(height: 10),
                medicines.when(
                  loading: () => const LinearProgressIndicator(),
                  error: (_, _) => Text(l10n.catalogLoadFailed),
                  data: (page) => _FormDropdown<String>(
                    label: l10n.medicineDropdownLabel,
                    hint: l10n.medicineDropdownHint,
                    icon: Icons.medication_outlined,
                    initialValue:
                        page.items.any((item) => item.id == _medicineId)
                        ? _medicineId
                        : null,
                    items: page.items
                        .map(
                          (medicine) => DropdownMenuItem(
                            value: medicine.id,
                            child: Text(
                              medicine.scientificName == null
                                  ? medicine.name
                                  : '${medicine.name} · ${medicine.scientificName}',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(growable: false),
                    onChanged: (value) => setState(() => _medicineId = value),
                    validator: (value) => value == null
                        ? l10n.chooseMedicineFromCatalog
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                if (_isOffer) ...[
                  _FormSectionTitle(
                    number: '02',
                    title: l10n.verificationPharmacySection,
                    subtitle: l10n.verificationPharmacySectionSubtitle,
                  ),
                  const SizedBox(height: 10),
                  verificationPharmacies.when(
                    loading: () => const LinearProgressIndicator(),
                    error: (_, _) => Text(l10n.verificationPharmaciesLoadFailed),
                    data: (items) => _FormDropdown<String>(
                      label: l10n.verificationPharmacyLabel,
                      hint: l10n.verificationPharmacyHint,
                      icon: Icons.verified_outlined,
                      initialValue: _reviewingPharmacyId,
                      items: items
                          .map(
                            (pharmacy) => DropdownMenuItem(
                              value: pharmacy.pharmacyId,
                              child: Text(
                                '${pharmacy.pharmacyName} · ${pharmacy.area}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(growable: false),
                      onChanged: (value) =>
                          setState(() => _reviewingPharmacyId = value),
                      validator: (value) => value == null
                          ? l10n.chooseVerificationPharmacy
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                _FormSectionTitle(
                  number: _isOffer ? '03' : '02',
                  title: l10n.organizationSection,
                  subtitle: _isOffer
                      ? l10n.organizationSectionOfferSubtitle
                      : l10n.organizationSectionRequestSubtitle,
                ),
                const SizedBox(height: 10),
                organizations.when(
                  loading: () => const LinearProgressIndicator(),
                  error: (_, _) => Text(l10n.organizationsLoadFailed),
                  data: (items) => _FormDropdown<String>(
                    label: l10n.organizationDropdownLabel,
                    hint: _isOffer
                        ? l10n.organizationDropdownOfferHint
                        : l10n.organizationDropdownRequestHint,
                    icon: Icons.apartment_rounded,
                    initialValue: _organizationId,
                    items: [
                      if (_isOffer)
                        DropdownMenuItem<String>(
                          value: null,
                          child: Text(l10n.noSpecificOrganization),
                        ),
                      ...items.map(
                        (organization) => DropdownMenuItem(
                          value: organization.organizationId,
                          child: Text(organization.organizationName),
                        ),
                      ),
                    ],
                    onChanged: (value) => setState(() {
                      _organizationId = value;
                      _campaignId = null;
                    }),
                    validator: (value) => !_isOffer && value == null
                        ? l10n.chooseTargetOrganization
                        : null,
                  ),
                ),
                const SizedBox(height: 14),
                _FormDropdown<String?>(
                  label: l10n.campaignOptionalLabel,
                  hint: l10n.noSpecificCampaign,
                  icon: Icons.campaign_outlined,
                  initialValue: _campaignId,
                  enabled: _organizationId != null,
                  items: [
                    DropdownMenuItem<String?>(
                      value: null,
                      child: Text(l10n.noSpecificCampaign),
                    ),
                    ...campaignItems.map(
                      (campaign) => DropdownMenuItem<String?>(
                        value: campaign.campaignId,
                        child: Text(campaign.title),
                      ),
                    ),
                  ],
                  onChanged: (value) => setState(() => _campaignId = value),
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: _isOffer
                      ? l10n.donatedPackagesLabel
                      : l10n.requestedPackagesLabel,
                  hint: l10n.packageCountHint,
                  controller: _package,
                  icon: Icons.numbers_rounded,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final count = int.tryParse(value ?? '');
                    return count == null || count < 1 || count > 1000
                        ? l10n.packageCountInvalid
                        : null;
                  },
                ),
                const SizedBox(height: 14),
                ListTile(
                  tileColor: context.appColors.surfaceSoft,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide.none,
                  ),
                  leading: const Icon(Icons.event_outlined),
                  title: Text(
                    _isOffer ? l10n.medicineExpiryDate : l10n.neededBeforeDate,
                  ),
                  subtitle: Text(
                    _date == null
                        ? l10n.optionalHint
                        : '${_date!.year}/${_date!.month}/${_date!.day}',
                  ),
                  trailing: _date == null
                      ? const Icon(Icons.chevron_left_rounded)
                      : IconButton(
                          onPressed: () => setState(() => _date = null),
                          icon: const Icon(Icons.close_rounded),
                        ),
                  onTap: _pickDate,
                ),
                if (_isOffer) ...[
                  const SizedBox(height: 8),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.sealedPackagesTitle),
                    subtitle: Text(l10n.sealedPackagesSubtitle),
                    value: _isSealed,
                    onChanged: (value) => setState(() => _isSealed = value),
                  ),
                ],
                const SizedBox(height: 8),
                AppTextField(
                  label: l10n.notesOptionalLabel,
                  hint: l10n.notesHint,
                  controller: _notes,
                  minLines: 3,
                  maxLines: 5,
                ),
                const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: _saving ? null : _submit,
                  icon: _saving
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Icon(
                          _isOffer
                              ? Icons.volunteer_activism_rounded
                              : Icons.support_agent_rounded,
                        ),
                  label: Text(
                    _saving
                        ? l10n.sendingProgress
                        : _isOffer
                        ? l10n.offerDonationTitle
                        : l10n.assistanceRequestPageTitle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _searchMedicines(String value) {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _searchTerm = value.trim();
      _medicineId = null;
    });
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final firstDate = _isOffer
        ? DateTime(now.year, now.month, now.day + 1)
        : DateTime(now.year, now.month, now.day);
    final value = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: DateTime(now.year + 5),
      initialDate: _date ?? firstDate,
    );
    if (value != null) setState(() => _date = value);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context);
    final medicineId = _medicineId;
    final organizationId = _organizationId;
    final reviewingPharmacyId = _reviewingPharmacyId;
    if (medicineId == null ||
        (!_isOffer && organizationId == null) ||
        (_isOffer && reviewingPharmacyId == null)) {
      return;
    }
    final packageCount = int.tryParse(_package.text) ?? 0;
    setState(() => _saving = true);
    try {
      if (_isOffer) {
        await ref
            .read(donationsRepositoryProvider)
            .createOffer(
              CreateDonationOffer(
                medicineId: medicineId,
                reviewingPharmacyId: reviewingPharmacyId!,
                targetOrganizationId: organizationId,
                campaignId: _campaignId,
                packageCount: packageCount,
                expiryDateUtc: _date,
                isSealed: _isSealed,
                notes: _notes.text,
              ),
            );
        ref.invalidate(myDonationOffersProvider);
      } else {
        await ref
            .read(donationsRepositoryProvider)
            .createAssistanceRequest(
              CreateAssistanceRequest(
                medicineId: medicineId,
                targetOrganizationId: organizationId!,
                campaignId: _campaignId,
                requestedPackageCount: packageCount,
                neededBeforeUtc: _date,
                notes: _notes.text,
              ),
            );
        ref.invalidate(myAssistanceRequestsProvider);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isOffer ? l10n.offerSubmitted : l10n.assistanceSubmitted,
          ),
        ),
      );
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error is ApiException ? error.localize(l10n) : l10n.submitFailed,
          ),
          backgroundColor: context.appColors.danger,
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

class _DonationFormHero extends StatelessWidget {
  const _DonationFormHero({required this.isOffer});
  final bool isOffer;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: isOffer
          ? context.appColors.surfaceWarm
          : context.appColors.surfaceSoft,
      borderRadius: BorderRadius.circular(23),
      border: Border.all(
        color: isOffer
            ? context.appColors.secondary.withValues(alpha: .45)
            : context.appColors.primaryLight.withValues(alpha: .45),
      ),
    ),
    child: Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: isOffer
                ? context.appColors.secondary
                : context.appColors.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            isOffer
                ? Icons.volunteer_activism_rounded
                : Icons.health_and_safety_outlined,
            color: isOffer ? context.appColors.primary : Colors.white,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isOffer ? l10n.donationOfferHeroTitle : l10n.assistanceHeroTitle,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                isOffer
                    ? l10n.donationOfferHeroSubtitle
                    : l10n.assistanceHeroSubtitle,
                style: TextStyle(
                  color: context.appColors.textMuted,
                  fontSize: 10.5,
                  height: 1.5,
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

class _FormSectionTitle extends StatelessWidget {
  const _FormSectionTitle({
    required this.number,
    required this.title,
    required this.subtitle,
  });
  final String number, title, subtitle;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: context.appColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          number,
          style: TextStyle(
            color: context.appColors.secondary,
            fontSize: 11,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      const SizedBox(width: 9),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
            Text(
              subtitle,
              style: TextStyle(
                color: context.appColors.textMuted,
                fontSize: 9.5,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label, required this.child});
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          color: context.appColors.text,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 1.3,
        ),
      ),
      const SizedBox(height: 8),
      child,
    ],
  );
}

class _FormDropdown<T> extends StatelessWidget {
  const _FormDropdown({
    required this.label,
    required this.hint,
    required this.icon,
    required this.initialValue,
    required this.items,
    required this.onChanged,
    super.key,
    this.validator,
    this.enabled = true,
  });

  final String label;
  final String hint;
  final IconData icon;
  final T? initialValue;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? Function(T?)? validator;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return _FieldLabel(
      label: label,
      child: DropdownButtonFormField<T>(
        initialValue: initialValue,
        isExpanded: true,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: colors.textMuted.withValues(alpha: 0.6),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor: colors.surfaceSoft,
          prefixIcon: Icon(icon, size: 21, color: colors.primary),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 46,
            minHeight: 52,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 15,
          ),
          errorStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: colors.danger,
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
              color: colors.primary.withValues(alpha: 0.4),
              width: 1.2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: colors.danger.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: colors.danger.withValues(alpha: 0.7),
              width: 1.2,
            ),
          ),
        ),
        items: items,
        onChanged: enabled ? onChanged : null,
        validator: validator,
        style: TextStyle(
          color: colors.text,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        icon: Icon(Icons.keyboard_arrow_down_rounded, color: colors.textMuted),
      ),
    );
  }
}
