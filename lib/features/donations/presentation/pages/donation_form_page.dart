import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../../core/widgets/app_reveal.dart';
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
  final _notes = TextEditingController();
  String _searchTerm = '';
  String? _medicineId;
  String? _reviewingPharmacyId;
  String? _organizationId;
  String? _campaignId;
  int _packageCount = 1;
  DateTime? _date;
  bool _isSealed = true;
  bool _saving = false;

  bool get _isOffer => widget.mode == DonationFormMode.offer;

  @override
  void dispose() {
    _medicineSearch.dispose();
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text(_isOffer ? 'تقديم عرض تبرع' : 'طلب مساعدة دوائية'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            AppReveal(child: _DonationFormHero(isOffer: _isOffer)),
            const SizedBox(height: 22),
            const _FormSectionTitle(
              number: '01',
              title: 'اختيار الدواء',
              subtitle: 'ابحث في دليل الأدوية وحدد الصنف المطلوب',
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _medicineSearch,
                    textInputAction: TextInputAction.search,
                    decoration: const InputDecoration(
                      hintText: 'ابحث باسم الدواء',
                      prefixIcon: Icon(Icons.search_rounded),
                    ),
                    onSubmitted: _searchMedicines,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: () => _searchMedicines(_medicineSearch.text),
                  icon: const Icon(Icons.search_rounded),
                ),
              ],
            ),
            const SizedBox(height: 10),
            medicines.when(
              loading: () => const LinearProgressIndicator(),
              error: (_, _) => const Text('تعذر تحميل دليل الأدوية.'),
              data: (page) => DropdownButtonFormField<String>(
                initialValue: page.items.any((item) => item.id == _medicineId)
                    ? _medicineId
                    : null,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'الدواء',
                  prefixIcon: Icon(Icons.medication_outlined),
                ),
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
                validator: (value) =>
                    value == null ? 'اختر الدواء من الدليل.' : null,
              ),
            ),
            const SizedBox(height: 16),
            if (_isOffer) ...[
              const _FormSectionTitle(
                number: '02',
                title: 'صيدلية التحقق والاستلام',
                subtitle: 'ستتأكد الصيدلية من سلامة العبوات قبل تسليمها',
              ),
              const SizedBox(height: 10),
              verificationPharmacies.when(
                loading: () => const LinearProgressIndicator(),
                error: (_, _) =>
                    const Text('تعذر تحميل صيدليات التحقق المعتمدة.'),
                data: (items) => DropdownButtonFormField<String>(
                  initialValue: _reviewingPharmacyId,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'صيدلية التحقق',
                    prefixIcon: Icon(Icons.verified_outlined),
                  ),
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
                      ? 'اختر الصيدلية التي ستتحقق من التبرع.'
                      : null,
                ),
              ),
              const SizedBox(height: 16),
            ],
            _FormSectionTitle(
              number: _isOffer ? '03' : '02',
              title: 'الجهة والتفاصيل',
              subtitle: _isOffer
                  ? 'حدد الجهة المستفيدة وبيانات العبوات'
                  : 'حدد الجهة المستهدفة واحتياجك الدوائي',
            ),
            const SizedBox(height: 10),
            organizations.when(
              loading: () => const LinearProgressIndicator(),
              error: (_, _) => const Text('تعذر تحميل المنظمات.'),
              data: (items) => DropdownButtonFormField<String>(
                initialValue: _organizationId,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'المنظمة',
                  prefixIcon: Icon(Icons.apartment_rounded),
                ),
                items: [
                  if (_isOffer)
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('بدون منظمة محددة'),
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
                    ? 'اختر المنظمة المستهدفة.'
                    : null,
              ),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String?>(
              initialValue: _campaignId,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'الحملة (اختياري)',
                prefixIcon: Icon(Icons.campaign_outlined),
              ),
              items: [
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('بدون حملة محددة'),
                ),
                ...campaignItems.map(
                  (campaign) => DropdownMenuItem<String?>(
                    value: campaign.campaignId,
                    child: Text(campaign.title),
                  ),
                ),
              ],
              onChanged: _organizationId == null
                  ? null
                  : (value) => setState(() => _campaignId = value),
            ),
            const SizedBox(height: 14),
            TextFormField(
              initialValue: '1',
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: _isOffer
                    ? 'عدد العبوات المتبرع بها'
                    : 'عدد العبوات المطلوبة',
                prefixIcon: const Icon(Icons.numbers_rounded),
              ),
              onChanged: (value) => _packageCount = int.tryParse(value) ?? 0,
              validator: (value) {
                final count = int.tryParse(value ?? '');
                return count == null || count < 1 || count > 1000
                    ? 'أدخل عددًا بين 1 و1000.'
                    : null;
              },
            ),
            const SizedBox(height: 14),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: context.appColors.border),
              ),
              leading: const Icon(Icons.event_outlined),
              title: Text(_isOffer ? 'تاريخ انتهاء الدواء' : 'مطلوب قبل تاريخ'),
              subtitle: Text(
                _date == null
                    ? 'اختياري'
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
                title: const Text('العبوات مغلقة ولم تُفتح'),
                subtitle: const Text('تأكد من سلامة العبوة قبل تقديم العرض.'),
                value: _isSealed,
                onChanged: (value) => setState(() => _isSealed = value),
              ),
            ],
            const SizedBox(height: 8),
            TextField(
              controller: _notes,
              maxLength: 1000,
              minLines: 3,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'ملاحظات (اختياري)',
                alignLabelWithHint: true,
              ),
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
                    ? 'جاري الإرسال...'
                    : _isOffer
                    ? 'إرسال عرض التبرع'
                    : 'إرسال طلب المساعدة',
              ),
            ),
          ],
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
    final medicineId = _medicineId;
    final organizationId = _organizationId;
    final reviewingPharmacyId = _reviewingPharmacyId;
    if (medicineId == null ||
        (!_isOffer && organizationId == null) ||
        (_isOffer && reviewingPharmacyId == null)) {
      return;
    }
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
                packageCount: _packageCount,
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
                requestedPackageCount: _packageCount,
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
            _isOffer
                ? 'تم إرسال العرض إلى صيدلية التحقق بنجاح.'
                : 'تم إرسال طلب المساعدة إلى المنظمة.',
          ),
        ),
      );
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error is ApiException
                ? error.message
                : 'تعذر إرسال البيانات حاليًا.',
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
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: isOffer ? context.appColors.surfaceWarm : context.appColors.surfaceSoft,
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
            color: isOffer ? context.appColors.secondary : context.appColors.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            isOffer
                ? Icons.volunteer_activism_rounded
                : Icons.health_and_safety_outlined,
            color: isOffer ? context.appColors.primaryDeep : Colors.white,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isOffer ? 'عرض تبرع دوائي' : 'طلب مساعدة دوائية',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                isOffer
                    ? 'أدخل بيانات دقيقة لتسهيل التحقق والاستلام.'
                    : 'أدخل احتياجك واختر المنظمة المناسبة للطلب.',
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
          color: context.appColors.primaryDeep,
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
              style: TextStyle(color: context.appColors.textMuted, fontSize: 9.5),
            ),
          ],
        ),
      ),
    ],
  );
}
