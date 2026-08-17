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

class MedicineRequestDetailsPage extends ConsumerStatefulWidget {
  const MedicineRequestDetailsPage({required this.requestId, super.key});

  final String requestId;

  @override
  ConsumerState<MedicineRequestDetailsPage> createState() =>
      _MedicineRequestDetailsPageState();
}

class _MedicineRequestDetailsPageState
    extends ConsumerState<MedicineRequestDetailsPage> {
  bool _cancelling = false;

  @override
  Widget build(BuildContext context) {
    final details = ref.watch(
      userMedicineRequestDetailsProvider(widget.requestId),
    );
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.requestDetailsTitle)),
      body: details.when(
        loading: () => AppLoadingState(label: l10n.requestDetailsLoading),
        error: (error, _) => AppErrorState(
          error: error,
          onRetry: () => ref.invalidate(
            userMedicineRequestDetailsProvider(widget.requestId),
          ),
        ),
        data: (data) => RefreshIndicator(
          onRefresh: () => ref.refresh(
            userMedicineRequestDetailsProvider(widget.requestId).future,
          ),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            children: [
              AppReveal(child: _RequestHero(details: data)),
              const SizedBox(height: 14),
              AppReveal(
                delay: const Duration(milliseconds: 70),
                child: _RequestProgress(request: data.request),
              ),
              const SizedBox(height: 18),
              AppReveal(
                delay: const Duration(milliseconds: 110),
                child: _DetailsCard(details: data),
              ),
              if (data.request.pharmacyResponseNote != null ||
                  data.request.suggestedAlternative != null) ...[
                const SizedBox(height: 14),
                AppReveal(
                  delay: const Duration(milliseconds: 150),
                  child: _PharmacyResponse(request: data.request),
                ),
              ],
              const SizedBox(height: 14),
              AppReveal(
                delay: const Duration(milliseconds: 190),
                child: _PharmacyCard(details: data),
              ),
              if (data.request.note != null) ...[
                const SizedBox(height: 14),
                AppReveal(
                  delay: const Duration(milliseconds: 230),
                  child: _NoteCard(
                    title: l10n.yourNoteToPharmacy,
                    text: data.request.note!,
                  ),
                ),
              ],
              if (data.request.canCancel) ...[
                const SizedBox(height: 22),
                OutlinedButton.icon(
                  onPressed: _cancelling ? null : _confirmCancel,
                  icon: _cancelling
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.close_rounded),
                  label: Text(
                    _cancelling ? l10n.cancellingProgress : l10n.cancelRequest,
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: context.appColors.danger,
                    side: const BorderSide(color: Color(0xFFB33A3A)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmCancel() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Color(0xFFB47618),
          size: 38,
        ),
        title: Text(l10n.cancelRequestTitle),
        content: Text(
          l10n.cancelRequestConfirm,
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.back),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: context.appColors.danger),
            child: Text(l10n.confirmCancellation),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    setState(() => _cancelling = true);
    try {
      await ref
          .read(userRepositoryProvider)
          .cancelMedicineRequest(widget.requestId);
      ref
        ..invalidate(userMedicineRequestDetailsProvider(widget.requestId))
        ..invalidate(userMedicineRequestsProvider)
        ..invalidate(userDashboardProvider);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.requestCancelled)));
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error is ApiException ? error.message : l10n.cancelRequestFailed,
            ),
            backgroundColor: context.appColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _cancelling = false);
    }
  }
}

class _RequestProgress extends StatelessWidget {
  const _RequestProgress({required this.request});

  final UserMedicineRequest request;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final status = request.status.toLowerCase();
    final isCancelled = status == 'cancelled';
    final hasResponse =
        request.hasPharmacyResponse ||
        status == 'available' ||
        status == 'unavailable';
    final steps = [
      (
        label: l10n.requestStepSent,
        icon: Icons.send_rounded,
        active: true,
        danger: false,
      ),
      (
        label: isCancelled ? l10n.requestStepCancelled : l10n.underReview,
        icon: isCancelled ? Icons.block_rounded : Icons.visibility_outlined,
        active: true,
        danger: isCancelled,
      ),
      (
        label: hasResponse ? l10n.responded : l10n.waitingForResponse,
        icon: hasResponse
            ? Icons.mark_chat_read_rounded
            : Icons.hourglass_bottom_rounded,
        active: hasResponse,
        danger: false,
      ),
    ];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 15),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.appColors.border),
      ),
      child: Row(
        children: steps
            .asMap()
            .entries
            .expand((entry) {
              final step = entry.value;
              final color = step.danger
                  ? context.appColors.danger
                  : step.active
                  ? context.appColors.primary
                  : context.appColors.textMuted;
              final widgets = <Widget>[
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(step.icon, color: color, size: 17),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        step.label,
                        maxLines: 1,
                        style: TextStyle(
                          color: color,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ];
              if (entry.key < steps.length - 1) {
                widgets.add(
                  Container(
                    width: 18,
                    height: 2,
                    color: steps[entry.key + 1].active
                        ? context.appColors.primary.withValues(alpha: 0.35)
                        : context.appColors.border,
                  ),
                );
              }
              return widgets;
            })
            .toList(growable: false),
      ),
    );
  }
}

class _RequestHero extends StatelessWidget {
  const _RequestHero({required this.details});

  final UserMedicineRequestDetails details;

  @override
  Widget build(BuildContext context) {
    final request = details.request;
    final l10n = AppLocalizations.of(context);
    final style = _statusStyle(request.status);
    return Container(
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: style.color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: style.color.withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: style.color,
              borderRadius: BorderRadius.circular(19),
            ),
            child: Icon(style.icon, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 13),
          Text(
            _statusText(l10n, request),
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: style.color),
          ),
          const SizedBox(height: 5),
          Text(
            '${l10n.requestNumber} ${request.requestCode}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  const _DetailsCard({required this.details});
  final UserMedicineRequestDetails details;

  @override
  Widget build(BuildContext context) {
    final request = details.request;
    final l10n = AppLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              request.medicineDisplayName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 14),
            _Row(
              icon: Icons.numbers_rounded,
              label: l10n.quantityRequested,
              value: '${request.requestedQuantity}',
            ),
            _Row(
              icon: Icons.calendar_today_outlined,
              label: l10n.createdDate,
              value: _dateTime(request.createdAtUtc),
            ),
            if (request.statusUpdatedAtUtc != null)
              _Row(
                icon: Icons.update_rounded,
                label: l10n.lastUpdate,
                value: _dateTime(request.statusUpdatedAtUtc),
              ),
            _Row(
              icon: Icons.inventory_2_outlined,
              label: l10n.currentAvailability,
              value: details.isRequestedMedicineCurrentlyAvailable
                  ? l10n.availableInStock
                  : l10n.notAvailableNow,
            ),
          ],
        ),
      ),
    );
  }
}

class _PharmacyResponse extends StatelessWidget {
  const _PharmacyResponse({required this.request});
  final UserMedicineRequest request;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final alternative = request.suggestedAlternative;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.appColors.surfaceWarm,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.appColors.secondary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.mark_chat_read_outlined, color: Color(0xFFB47618)),
              const SizedBox(width: 8),
              Text(
                l10n.pharmacyResponse,
                style: const TextStyle(
                  color: Color(0xFF142E35),
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          if (request.pharmacyResponseNote case final note?) ...[
            const SizedBox(height: 11),
            Text(note),
          ],
          if (alternative != null) ...[
            const SizedBox(height: 13),
            const Divider(),
            Text(
              l10n.suggestedAlternative,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 5),
            Text(
              [
                alternative.medicineDisplayName,
                alternative.arabicScientificName ?? alternative.scientificName,
                alternative.dosageForm,
                alternative.capacity,
              ].whereType<String>().join(' · '),
            ),
          ],
        ],
      ),
    );
  }
}

class _PharmacyCard extends StatelessWidget {
  const _PharmacyCard({required this.details});
  final UserMedicineRequestDetails details;

  @override
  Widget build(BuildContext context) {
    final request = details.request;
    final l10n = AppLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.local_pharmacy_rounded,
                  color: Color(0xFF216474),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    request.pharmacyName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 9),
            Text(
              [
                details.pharmacyAddress,
                details.pharmacyArea,
                details.pharmacyCity,
              ].where((item) => item.isNotEmpty).join('، '),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 13),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        context.push('/user/pharmacies/${request.pharmacyId}'),
                    icon: const Icon(Icons.storefront_rounded),
                    label: Text(l10n.thePharmacy),
                  ),
                ),
                if (details.pharmacyGoogleMapsUrl != null) ...[
                  const SizedBox(width: 9),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => launchUrl(
                        Uri.parse(details.pharmacyGoogleMapsUrl!),
                        mode: LaunchMode.externalApplication,
                      ),
                      icon: const Icon(Icons.navigation_rounded),
                      label: Text(l10n.directions),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({required this.title, required this.text});
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    ),
  );
}

class _Row extends StatelessWidget {
  const _Row({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 11),
    child: Row(
      children: [
        Icon(icon, color: context.appColors.textMuted, size: 19),
        const SizedBox(width: 9),
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF142E35),
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}

({Color color, IconData icon}) _statusStyle(String status) => switch (status
    .toLowerCase()) {
  'available' => (color: Color(0xFF167D5A), icon: Icons.check_circle_rounded),
  'unavailable' => (color: Color(0xFFB33A3A), icon: Icons.cancel_rounded),
  'cancelled' => (color: Color(0xFF668087), icon: Icons.block_rounded),
  _ => (color: const Color(0xFFB47618), icon: Icons.schedule_rounded),
};

String _statusText(AppLocalizations l10n, UserMedicineRequest request) =>
    switch (request.status.toLowerCase()) {
      'available' => l10n.medicineAvailable,
      'unavailable' => l10n.medicineUnavailable,
      'cancelled' => l10n.requestCancelled,
      _ => l10n.waitingForPharmacyResponse,
    };

String _dateTime(DateTime? value) => value == null
    ? '—'
    : '${value.year}/${value.month}/${value.day} '
          '${value.hour.toString().padLeft(2, '0')}:'
          '${value.minute.toString().padLeft(2, '0')}';
