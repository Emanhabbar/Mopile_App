import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../../core/widgets/async_states.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/models/prescription_models.dart';
import '../../data/repositories/prescriptions_repository.dart';
import '../controllers/prescriptions_providers.dart';
import 'prescriptions_page.dart';

class PrescriptionDetailsPage extends ConsumerStatefulWidget {
  const PrescriptionDetailsPage({required this.orderId, super.key});

  final String orderId;

  @override
  ConsumerState<PrescriptionDetailsPage> createState() =>
      _PrescriptionDetailsPageState();
}

class _PrescriptionDetailsPageState
    extends ConsumerState<PrescriptionDetailsPage> {
  bool _working = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(prescriptionDetailsProvider(widget.orderId));
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.prescriptionDetailsTitle)),
      body: state.when(
        loading: () => AppLoadingState(label: l10n.prescriptionDetailsLoading),
        error: (error, _) => AppErrorState(
          error: error,
          onRetry: () =>
              ref.invalidate(prescriptionDetailsProvider(widget.orderId)),
        ),
        data: (order) => RefreshIndicator(
          onRefresh: () =>
              ref.refresh(prescriptionDetailsProvider(widget.orderId).future),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            children: [
              _StatusCard(order: order),
              if (order.warnings.isNotEmpty) ...[
                const SizedBox(height: 14),
                _WarningsCard(warnings: order.warnings),
              ],
              const SizedBox(height: 18),
              _Title(
                title: l10n.medicinesTitle,
                subtitle: l10n.itemsCount(order.items.length),
              ),
              const SizedBox(height: 10),
              ...order.items.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 9),
                  child: _MedicineItem(item: item),
                ),
              ),
              if (order.isAnalyzed) ...[
                const SizedBox(height: 16),
                _Title(
                  title: l10n.availablePharmaciesTitle,
                  subtitle: l10n.availablePharmaciesSubtitle,
                ),
                const SizedBox(height: 10),
                if (order.pharmacyMatches.isEmpty)
                  _MessageCard(text: l10n.noMatchingPharmacy)
                else
                  ...order.pharmacyMatches.map(
                    (match) => Padding(
                      padding: const EdgeInsets.only(bottom: 9),
                      child: _PharmacyMatchCard(
                        match: match,
                        disabled: _working,
                        onReserve: () => _reserve(match),
                      ),
                    ),
                  ),
              ],
              if (order.pickupCode != null) ...[
                const SizedBox(height: 16),
                _PickupCodeCard(code: order.pickupCode!),
              ],
              if (order.canActivateReminders) ...[
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: _working ? null : () => _configureReminders(order),
                  icon: const Icon(Icons.alarm_add_rounded),
                  label: Text(
                    order.doseRemindersEnabled || order.refillReminderEnabled
                        ? l10n.editReminders
                        : l10n.activateMedicineReminders,
                  ),
                ),
              ],
              if (order.canCancel) ...[
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: _working ? null : _cancel,
                  icon: const Icon(Icons.close_rounded),
                  label: Text(l10n.cancelPrescription),
                  style: TextButton.styleFrom(
                    foregroundColor: context.appColors.danger,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _reserve(PrescriptionPharmacyMatch match) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _working = true);
    try {
      await ref
          .read(prescriptionsRepositoryProvider)
          .reserve(widget.orderId, match.pharmacyId);
      _refresh();
      _message(l10n.reservedAt(match.pharmacyName));
    } catch (error) {
      _error(error, l10n.reserveFailed);
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  Future<void> _cancel() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.cancelPrescriptionTitle),
        content: Text(
          l10n.cancelPrescriptionConfirm,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.back),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: context.appColors.danger),
            child: Text(l10n.cancelPrescription),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    setState(() => _working = true);
    try {
      await ref.read(prescriptionsRepositoryProvider).cancel(widget.orderId);
      _refresh();
      _message(l10n.prescriptionCancelled);
    } catch (error) {
      _error(error, l10n.cancelFailed);
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  Future<void> _configureReminders(PrescriptionOrder order) async {
    final l10n = AppLocalizations.of(context);
    final request = await showModalBottomSheet<PrescriptionReminderRequest>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => _ReminderSheet(order: order),
    );
    if (request == null) return;
    setState(() => _working = true);
    try {
      await ref
          .read(prescriptionsRepositoryProvider)
          .activateReminders(widget.orderId, request);
      _refresh();
      _message(l10n.remindersSaved);
    } catch (error) {
      _error(error, l10n.remindersSaveFailed);
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  void _refresh() {
    ref
      ..invalidate(prescriptionDetailsProvider(widget.orderId))
      ..invalidate(myPrescriptionsProvider);
  }

  void _error(Object error, String fallback) {
    _message(
      error is ApiException
          ? error.localize(AppLocalizations.of(context))
          : fallback,
      error: true,
    );
  }

  void _message(String text, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(text),
          backgroundColor: error ? context.appColors.danger : null,
        ),
      );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.order});

  final PrescriptionOrder order;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final info = prescriptionStatusInfo(context.appColors, order.status, l10n);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: info.color.withValues(alpha: 0.1),
              child: Icon(info.icon, color: info.color),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    info.label,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    order.pharmacyName ?? order.originalFileName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Text(
              formatDate(order.createdAtUtc),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _WarningsCard extends StatelessWidget {
  const _WarningsCard({required this.warnings});

  final List<String> warnings;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: context.appColors.surfaceWarm,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: context.appColors.secondary.withValues(alpha: 0.3)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).importantWarnings,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        ...warnings.map(
          (warning) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text('• $warning'),
          ),
        ),
      ],
    ),
  );
}

class _MedicineItem extends StatelessWidget {
  const _MedicineItem({required this.item});

  final PrescriptionItem item;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: Icon(
        item.isMatched ? Icons.medication_rounded : Icons.help_outline_rounded,
        color: item.isMatched ? context.appColors.primary : context.appColors.textMuted,
      ),
      title: Text(item.displayName),
      subtitle: Text(
        [
          item.scientificName,
          item.strength,
          item.dosageInstructions,
        ].whereType<String>().where((value) => value.isNotEmpty).join(' · '),
      ),
      trailing: Text(
        '× ${item.requestedQuantity}',
        style: const TextStyle(fontWeight: FontWeight.w900),
      ),
    ),
  );
}

class _PharmacyMatchCard extends StatelessWidget {
  const _PharmacyMatchCard({
    required this.match,
    required this.disabled,
    required this.onReserve,
  });

  final PrescriptionPharmacyMatch match;
  final bool disabled;
  final VoidCallback onReserve;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.local_pharmacy_rounded,
                color: context.appColors.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  match.pharmacyName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Text(
                '${match.matchPercentage.toStringAsFixed(0)}٪',
                style: TextStyle(
                  color: context.appColors.primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${l10n.prescriptionMedicinesAvailable(match.availableItems, match.totalItems)}'
            '${match.distanceMeters == null ? '' : ' · ${_distance(l10n, match.distanceMeters!)}'}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: disabled ? null : onReserve,
              child: Text(
                match.hasCompletePrescription
                    ? l10n.reserveFullPrescription
                    : l10n.reserveAvailableMedicines,
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }
}

class _PickupCodeCard extends StatelessWidget {
  const _PickupCodeCard({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Text(l10n.pickupCodeTitle),
          const SizedBox(height: 7),
          SelectableText(
            code,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: context.appColors.primary,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            l10n.pickupCodeNote,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    ),
    );
  }
}

class _ReminderSheet extends StatefulWidget {
  const _ReminderSheet({required this.order});

  final PrescriptionOrder order;

  @override
  State<_ReminderSheet> createState() => _ReminderSheetState();
}

class _ReminderSheetState extends State<_ReminderSheet> {
  late bool _dose = widget.order.doseRemindersEnabled;
  late bool _refill = widget.order.refillReminderEnabled;
  TimeOfDay _time = const TimeOfDay(hour: 9, minute: 0);
  int _durationDays = 30;
  int _refillAfterDays = 25;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.reminderSettingsTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.dailyDoseReminder),
            value: _dose,
            onChanged: (value) => setState(() => _dose = value),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.refillReminder),
            value: _refill,
            onChanged: (value) => setState(() => _refill = value),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.reminderTime),
            trailing: Text(_time.format(context)),
            onTap: () async {
              final value = await showTimePicker(
                context: context,
                initialTime: _time,
              );
              if (value != null) setState(() => _time = value);
            },
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: '$_durationDays',
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n.treatmentDurationLabel,
                  ),
                  onChanged: (value) =>
                      _durationDays = int.tryParse(value) ?? 30,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  initialValue: '$_refillAfterDays',
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n.refillAfterLabel,
                  ),
                  onChanged: (value) =>
                      _refillAfterDays = int.tryParse(value) ?? 25,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.pop(
                context,
                PrescriptionReminderRequest(
                  doseRemindersEnabled: _dose,
                  refillReminderEnabled: _refill,
                  reminderTime:
                      '${_time.hour.toString().padLeft(2, '0')}:'
                      '${_time.minute.toString().padLeft(2, '0')}:00',
                  durationDays: _durationDays.clamp(1, 365),
                  refillAfterDays: _refillAfterDays.clamp(1, 365),
                ),
              ),
              child: Text(l10n.save),
            ),
          ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(title, style: Theme.of(context).textTheme.titleLarge),
      ),
      Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
    ],
  );
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Center(child: Text(text)),
    ),
  );
}

String _distance(AppLocalizations l10n, double meters) => meters < 1000
    ? l10n.distanceMeters('${meters.round()}')
    : l10n.distanceKm((meters / 1000).toStringAsFixed(1));
