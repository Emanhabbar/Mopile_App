import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../../core/widgets/app_reveal.dart';
import '../../../../core/widgets/async_states.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/models/user_request_models.dart';
import '../../data/repositories/user_repository.dart';
import '../controllers/user_providers.dart';

class PharmacyDetailsPage extends ConsumerStatefulWidget {
  const PharmacyDetailsPage({
    required this.pharmacyId,
    this.initialMedicineId,
    super.key,
  });

  final String pharmacyId;
  final String? initialMedicineId;

  @override
  ConsumerState<PharmacyDetailsPage> createState() =>
      _PharmacyDetailsPageState();
}

class _PharmacyDetailsPageState extends ConsumerState<PharmacyDetailsPage> {
  final _note = TextEditingController();
  final _ratingComment = TextEditingController();
  String? _medicineId;
  int _quantity = 1;
  int _rating = 0;
  bool _initialized = false;
  bool _sending = false;
  bool _ratingSaving = false;

  @override
  void initState() {
    super.initState();
    _medicineId = widget.initialMedicineId;
  }

  @override
  void dispose() {
    _note.dispose();
    _ratingComment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final details = ref.watch(userPharmacyDetailsProvider(widget.pharmacyId));
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.pharmacyDetailsTitle)),
      body: details.when(
        loading: () => AppLoadingState(label: l10n.pharmacyDetailsLoading),
        error: (error, _) => AppErrorState(
          error: error,
          onRetry: () =>
              ref.invalidate(userPharmacyDetailsProvider(widget.pharmacyId)),
        ),
        data: (data) {
          _initialize(data);
          return RefreshIndicator(
            onRefresh: () => ref.refresh(
              userPharmacyDetailsProvider(widget.pharmacyId).future,
            ),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              children: [
                AppReveal(child: _PharmacyHero(pharmacy: data.pharmacy)),
                const SizedBox(height: 22),
                AppReveal(
                  delay: const Duration(milliseconds: 70),
                  child: _SectionTitle(
                    title: l10n.availableMedicines,
                    subtitle: l10n.medicinesAvailableCount(
                      data.availableMedicinesCount,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (data.availableMedicines.isEmpty)
                  const _EmptyMedicines()
                else
                  ...data.availableMedicines.asMap().entries.map(
                    (entry) => AppReveal(
                      delay: Duration(
                        milliseconds: 100 + (entry.key.clamp(0, 4) * 40),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _MedicineChoice(
                          medicine: entry.value,
                          selected: entry.value.medicineId == _medicineId,
                          onTap: () => setState(
                            () => _medicineId = entry.value.medicineId,
                          ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 18),
                AppReveal(
                  delay: const Duration(milliseconds: 170),
                  child: _RequestForm(
                    medicines: data.availableMedicines,
                    selectedMedicineId: _medicineId,
                    quantity: _quantity,
                    note: _note,
                    sending: _sending,
                    onMedicineChanged: (value) =>
                        setState(() => _medicineId = value),
                    onQuantityChanged: (value) =>
                        setState(() => _quantity = value),
                    onSubmit: _submitRequest,
                  ),
                ),
                const SizedBox(height: 17),
                AppReveal(
                  delay: const Duration(milliseconds: 210),
                  child: _RatingForm(
                    rating: _rating,
                    comment: _ratingComment,
                    saving: _ratingSaving,
                    onRatingChanged: (value) => setState(() => _rating = value),
                    onSubmit: _submitRating,
                  ),
                ),
                const SizedBox(height: 22),
                _SectionTitle(
                  title: l10n.workingHours,
                  subtitle: l10n.workingHoursSubtitle,
                ),
                const SizedBox(height: 12),
                AppReveal(
                  delay: const Duration(milliseconds: 250),
                  child: _WorkingHours(hours: data.workingHours),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _initialize(UserPharmacyDetails details) {
    if (_initialized) return;
    if (_medicineId != null &&
        !details.availableMedicines.any(
          (medicine) => medicine.medicineId == _medicineId,
        )) {
      _medicineId = null;
    }
    _rating = details.currentUserRating ?? 0;
    _ratingComment.text = details.currentUserComment ?? '';
    _initialized = true;
  }

  Future<void> _submitRequest() async {
    final l10n = AppLocalizations.of(context);
    final medicineId = _medicineId;
    if (medicineId == null) {
      _message(l10n.chooseMedicineFirst, error: true);
      return;
    }
    setState(() => _sending = true);
    try {
      final result = await ref
          .read(userRepositoryProvider)
          .createMedicineRequest(
            widget.pharmacyId,
            CreateMedicineRequest(
              medicineId: medicineId,
              requestedQuantity: _quantity,
              note: _note.text,
            ),
          );
      ref
        ..invalidate(userMedicineRequestsProvider)
        ..invalidate(userDashboardProvider);
      if (!mounted) return;
      _note.clear();
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          icon: const Icon(
            Icons.check_circle_rounded,
            color: Color(0xFF167D5A),
            size: 42,
          ),
          title: Text(l10n.requestSentTitle),
          content: Text(
            l10n.requestSentContent(result.requestCode),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.close),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                context.push('/user/requests/${result.requestId}');
              },
              child: Text(l10n.viewRequest),
            ),
          ],
        ),
      );
    } catch (error) {
      _message(_errorMessage(error), error: true);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _submitRating() async {
    final l10n = AppLocalizations.of(context);
    if (_rating < 1) {
      _message(l10n.chooseStarsFirst, error: true);
      return;
    }
    setState(() => _ratingSaving = true);
    try {
      await ref
          .read(userRepositoryProvider)
          .ratePharmacy(
            widget.pharmacyId,
            score: _rating,
            comment: _ratingComment.text.trim().isEmpty
                ? null
                : _ratingComment.text.trim(),
          );
      ref
        ..invalidate(userPharmacyDetailsProvider(widget.pharmacyId))
        ..invalidate(userDashboardProvider);
      _message(l10n.ratingSaved);
    } catch (error) {
      _message(_errorMessage(error), error: true);
    } finally {
      if (mounted) setState(() => _ratingSaving = false);
    }
  }

  void _message(String message, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: error ? context.appColors.danger : null,
        ),
      );
  }

String _errorMessage(Object error) =>
    error is ApiException
        ? error.message
        : AppLocalizations.of(context).operationFailed;
}

class _PharmacyHero extends StatelessWidget {
  const _PharmacyHero({required this.pharmacy});

  final UserPharmacyProfile pharmacy;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: context.appColors.primary,
        borderRadius: BorderRadius.circular(27),
        boxShadow: [
          BoxShadow(
            color: context.appColors.primary.withValues(alpha: 0.18),
            blurRadius: 28,
            offset: const Offset(0, 13),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _HeroPill(
                icon: Icons.schedule_rounded,
                text: pharmacy.statusText,
                color: pharmacy.isOpenNow
                    ? const Color(0xFF8BD0CB)
                    : Colors.white60,
              ),
              if (pharmacy.hasDeliveryService)
                _HeroPill(
                  icon: Icons.delivery_dining_rounded,
                  text: l10n.deliveryAvailable,
                  color: context.appColors.secondary,
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            pharmacy.pharmacyName,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontSize: 27,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            [
              pharmacy.address,
              pharmacy.area,
              pharmacy.city,
            ].where((item) => item.isNotEmpty).join('، '),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Icon(
                Icons.star_rounded,
                color: context.appColors.secondary,
                size: 19,
              ),
              const SizedBox(width: 5),
              Text(
                '${pharmacy.averageRating.toStringAsFixed(1)} (${pharmacy.ratingsCount})',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 17),
              Text(
                _distance(l10n, pharmacy.distanceMeters),
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              if (pharmacy.phoneNumber case final phone?)
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => launchUrl(Uri.parse('tel:$phone')),
                    icon: const Icon(Icons.phone_rounded),
                    label: Text(l10n.call),
                    style: FilledButton.styleFrom(
                      backgroundColor: context.appColors.secondary,
                      foregroundColor: const Color(0xFF173D46),
                    ),
                  ),
                ),
              if (pharmacy.phoneNumber != null &&
                  pharmacy.locationGoogleMapsUrl != null)
                const SizedBox(width: 9),
              if (pharmacy.locationGoogleMapsUrl case final url?)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => launchUrl(
                      Uri.parse(url),
                      mode: LaunchMode.externalApplication,
                    ),
                    icon: const Icon(Icons.navigation_rounded),
                    label: Text(l10n.directions),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MedicineChoice extends StatelessWidget {
  const _MedicineChoice({
    required this.medicine,
    required this.selected,
    required this.onTap,
  });

  final UserPharmacyMedicine medicine;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(19),
        side: BorderSide(
          color: selected
              ? context.appColors.primary
              : context.appColors.border,
          width: selected ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: context.appColors.primary.withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.medication_rounded,
                  color: context.appColors.primary,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medicine.medicineDisplayName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      [
                        if (medicine.arabicMedicineName != null)
                          medicine.medicineName,
                        medicine.arabicScientificName ??
                            medicine.scientificName,
                        medicine.dosageForm,
                        medicine.capacity,
                      ].whereType<String>().join(' · '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _price(l10n, medicine.sellingPrice),
                    style: TextStyle(
                      color: context.appColors.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  if (medicine.requiresPrescription)
                    Text(
                      l10n.requiresPrescription,
                      style: const TextStyle(
                        color: Color(0xFFB47618),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  if (selected)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Icon(
                        Icons.check_circle_rounded,
                        color: context.appColors.primary,
                        size: 18,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RequestForm extends StatelessWidget {
  const _RequestForm({
    required this.medicines,
    required this.selectedMedicineId,
    required this.quantity,
    required this.note,
    required this.sending,
    required this.onMedicineChanged,
    required this.onQuantityChanged,
    required this.onSubmit,
  });

  final List<UserPharmacyMedicine> medicines;
  final String? selectedMedicineId;
  final int quantity;
  final TextEditingController note;
  final bool sending;
  final ValueChanged<String?> onMedicineChanged;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FormHeading(
              icon: Icons.inventory_2_outlined,
              title: l10n.requestMedicineTitle,
              subtitle: l10n.requestMedicineSubtitle,
            ),
            const SizedBox(height: 17),
            DropdownButtonFormField<String>(
              initialValue: selectedMedicineId,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: l10n.medicineLabel,
                prefixIcon: const Icon(Icons.medication_outlined),
              ),
              items: medicines
                  .map(
                    (medicine) => DropdownMenuItem(
                      value: medicine.medicineId,
                      child: Text(medicine.medicineDisplayName),
                    ),
                  )
                  .toList(growable: false),
              onChanged: onMedicineChanged,
            ),
            const SizedBox(height: 13),
            Row(
              children: [
                Text(
                  l10n.quantityRequested,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const Spacer(),
                IconButton.filledTonal(
                  onPressed: quantity > 1
                      ? () => onQuantityChanged(quantity - 1)
                      : null,
                  icon: const Icon(Icons.remove_rounded),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Text(
                    '$quantity',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton.filledTonal(
                  onPressed: quantity < 1000
                      ? () => onQuantityChanged(quantity + 1)
                      : null,
                  icon: const Icon(Icons.add_rounded),
                ),
              ],
            ),
            const SizedBox(height: 13),
            TextField(
              controller: note,
              maxLength: 1000,
              minLines: 3,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: l10n.noteToPharmacyOptional,
                alignLabelWithHint: true,
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: medicines.isEmpty || sending ? null : onSubmit,
                icon: sending
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.send_rounded),
                label: Text(
                  sending ? l10n.sendingProgress : l10n.sendRequest,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RatingForm extends StatelessWidget {
  const _RatingForm({
    required this.rating,
    required this.comment,
    required this.saving,
    required this.onRatingChanged,
    required this.onSubmit,
  });

  final int rating;
  final TextEditingController comment;
  final bool saving;
  final ValueChanged<int> onRatingChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FormHeading(
              icon: Icons.star_outline_rounded,
              title: l10n.rateExperienceTitle,
              subtitle: l10n.rateExperienceSubtitle,
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              textDirection: TextDirection.ltr,
              children: List.generate(
                5,
                (index) => IconButton(
                  onPressed: () => onRatingChanged(index + 1),
                  iconSize: 31,
                  icon: Icon(
                    Icons.star_rounded,
                    color: index < rating
                        ? context.appColors.secondary
                        : context.appColors.border,
                  ),
                ),
              ),
            ),
            TextField(
              controller: comment,
              maxLength: 1000,
              minLines: 2,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: l10n.ratingHint,
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: rating < 1 || saving ? null : onSubmit,
                icon: const Icon(Icons.star_rounded),
                label: Text(saving ? l10n.savingProgress : l10n.saveRating),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkingHours extends StatelessWidget {
  const _WorkingHours({required this.hours});

  final List<PharmacyWorkingHour> hours;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final days = [
      l10n.daySunday,
      l10n.dayMonday,
      l10n.dayTuesday,
      l10n.dayWednesday,
      l10n.dayThursday,
      l10n.dayFriday,
      l10n.daySaturday,
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: hours
              .map((hour) {
                final day = hour.dayOfWeek >= 0 && hour.dayOfWeek < days.length
                    ? days[hour.dayOfWeek]
                    : l10n.dayFallback;
                return ListTile(
                  dense: true,
                  title: Text(
                    day,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  trailing: Text(
                    hour.isClosed
                        ? l10n.closed
                        : '${_time(hour.openTime)} - ${_time(hour.closeTime)}',
                    style: TextStyle(
                      color: hour.isClosed
                          ? context.appColors.textMuted
                          : context.appColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
              })
              .toList(growable: false),
        ),
      ),
    );
  }
}

class _FormHeading extends StatelessWidget {
  const _FormHeading({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 43,
          height: 43,
          decoration: BoxDecoration(
            color: context.appColors.primary.withValues(alpha: 0.09),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, color: context.appColors.primary),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 3),
      Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
    ],
  );
}

class _HeroPill extends StatelessWidget {
  const _HeroPill({
    required this.icon,
    required this.text,
    required this.color,
  });
  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 5),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: 11,
          ),
        ),
      ],
    ),
  );
}

class _EmptyMedicines extends StatelessWidget {
  const _EmptyMedicines();

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          const Icon(
            Icons.medication_outlined,
            color: Color(0xFF668087),
            size: 34,
          ),
          const SizedBox(height: 10),
          Text(AppLocalizations.of(context).noMedicinesAvailable),
        ],
      ),
    ),
  );
}

String _price(AppLocalizations l10n, double? value) => value == null
    ? l10n.priceNotAnnounced
    : l10n.currencySYP(value.toStringAsFixed(0));
String _distance(AppLocalizations l10n, double meters) => meters < 1000
    ? l10n.distanceMeters('${meters.round()}')
    : l10n.distanceKm((meters / 1000).toStringAsFixed(1));
String _time(String? value) =>
    value == null || value.length < 5 ? '--:--' : value.substring(0, 5);
