import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../../core/widgets/async_states.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/models/pharmacy_models.dart';
import '../../data/repositories/pharmacy_repository.dart';
import '../controllers/pharmacy_providers.dart';

class PharmacyWorkingHoursPage extends ConsumerStatefulWidget {
  const PharmacyWorkingHoursPage({super.key});
  @override
  ConsumerState<PharmacyWorkingHoursPage> createState() =>
      _PharmacyWorkingHoursPageState();
}

class _PharmacyWorkingHoursPageState
    extends ConsumerState<PharmacyWorkingHoursPage> {
  List<PharmacyWorkingPeriod>? _periods;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pharmacyWorkingHoursProvider);
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.workingHoursTitle),
        actions: [
          _saving
              ? const Padding(
                  padding: EdgeInsetsDirectional.only(end: 12),
                  child: SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  ),
                )
              : IconButton(
                  onPressed: _save,
                  tooltip: l10n.saveTooltip,
                  icon: const Icon(Icons.save_rounded),
                ),
          const SizedBox(width: 4),
          IconButton(
            onPressed: () {
              _periods = null;
              ref.invalidate(pharmacyWorkingHoursProvider);
            },
            tooltip: l10n.restoreSavedHours,
            icon: const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: state.when(
        loading: () => AppLoadingState(label: l10n.workingHoursLoading),
        error: (error, _) => AppErrorState(
          error: error,
          onRetry: () => ref.invalidate(pharmacyWorkingHoursProvider),
        ),
        data: (data) {
          _periods ??= List.generate(7, (day) {
            final found = data.where((item) => item.dayOfWeek == day);
            return found.isEmpty
                ? PharmacyWorkingPeriod(dayOfWeek: day, isClosed: true)
                : found.first;
          });
          final openDays = _periods!.where((period) => !period.isClosed).length;
          final overnight = _periods!.where(_isOvernight).length;
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            children: [
              _HoursOverview(openDays: openDays, overnight: overnight),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: context.appColors.surfaceWarm,
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Row(
                  children: [
                    Icon(Icons.nights_stay_outlined, color: context.appColors.warning),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        l10n.overnightHint,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              ...List.generate(7, _dayEditor),
            ],
          );
        },
      ),
    );
  }

  Widget _dayEditor(int index) {
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
    final period = _periods![index];
    final overnight = _isOvernight(period);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 41,
                  height: 41,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: period.isClosed
                        ? context.appColors.background
                        : context.appColors.surfaceSoft,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Text(
                    days[index].substring(0, 2),
                    style: TextStyle(
                      color: period.isClosed
                          ? context.appColors.textMuted
                          : context.appColors.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        days[index],
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                      Text(
                        period.isClosed
                            ? l10n.pharmacyClosed
                            : overnight
                            ? l10n.overnightShift
                            : '${period.openTime!.substring(0, 5)} – ${period.closeTime!.substring(0, 5)}',
                        style: TextStyle(
                          color: overnight
                              ? context.appColors.warning
                              : context.appColors.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: !period.isClosed,
                  onChanged: (open) => setState(() {
                    _periods![index] = PharmacyWorkingPeriod(
                      dayOfWeek: index,
                      isClosed: !open,
                      openTime: open ? period.openTime ?? '08:00:00' : null,
                      closeTime: open ? period.closeTime ?? '22:00:00' : null,
                    );
                  }),
                ),
              ],
            ),
            if (!period.isClosed) ...[
              const Divider(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _TimeButton(
                      label: l10n.timeFrom,
                      value: period.openTime!,
                      onTap: () => _pickTime(index, true),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _TimeButton(
                      label: l10n.timeTo,
                      value: period.closeTime!,
                      onTap: () => _pickTime(index, false),
                    ),
                  ),
                ],
              ),
              if (overnight) ...[
                const SizedBox(height: 9),
                Row(
                  children: [
                    Icon(
                      Icons.dark_mode_outlined,
                      size: 15,
                      color: context.appColors.warning,
                    ),
                    SizedBox(width: 5),
                    Text(
                      l10n.endsNextDay,
                      style: TextStyle(
                        color: context.appColors.warning,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _pickTime(int index, bool opening) async {
    final l10n = AppLocalizations.of(context);
    final period = _periods![index];
    final current = _parse(opening ? period.openTime : period.closeTime);
    final picked = await showTimePicker(
      context: context,
      initialTime: current,
      helpText: opening ? l10n.openingTimeHelp : l10n.closingTimeHelp,
    );
    if (picked == null) return;
    final value =
        '${picked.hour.toString().padLeft(2, '0')}:'
        '${picked.minute.toString().padLeft(2, '0')}:00';
    setState(() {
      _periods![index] = PharmacyWorkingPeriod(
        dayOfWeek: index,
        isClosed: false,
        openTime: opening ? value : period.openTime,
        closeTime: opening ? period.closeTime : value,
      );
    });
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    for (final period in _periods!) {
      if (!period.isClosed && period.openTime == period.closeTime) {
        _message(l10n.timesMustDiffer, true);
        return;
      }
    }
    setState(() => _saving = true);
    try {
      await ref
          .read(pharmacyRepositoryProvider)
          .remote
          .updateWorkingHours(_periods!);
      ref
        ..invalidate(pharmacyWorkingHoursProvider)
        ..invalidate(pharmacyDashboardProvider);
      _message(l10n.workingHoursSaved, false);
    } catch (error) {
      _message(
        error is ApiException ? error.localize(l10n) : l10n.workingHoursSaveFailed,
        true,
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
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

  TimeOfDay _parse(String? value) {
    final parts = value?.split(':') ?? const [];
    return TimeOfDay(
      hour: parts.isEmpty ? 8 : int.tryParse(parts[0]) ?? 8,
      minute: parts.length < 2 ? 0 : int.tryParse(parts[1]) ?? 0,
    );
  }

  bool _isOvernight(PharmacyWorkingPeriod period) {
    if (period.isClosed ||
        period.openTime == null ||
        period.closeTime == null) {
      return false;
    }
    return period.closeTime!.compareTo(period.openTime!) < 0;
  }
}

class _HoursOverview extends StatelessWidget {
  const _HoursOverview({required this.openDays, required this.overnight});

  final int openDays;
  final int overnight;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
    padding: const EdgeInsets.all(19),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [context.appColors.primaryDeep, context.appColors.primary],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ),
      borderRadius: BorderRadius.circular(25),
    ),
    child: Row(
      children: [
        Container(
          width: 51,
          height: 51,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .12),
            borderRadius: BorderRadius.circular(17),
          ),
          child: Icon(
            Icons.schedule_rounded,
            color: context.appColors.secondary,
            size: 28,
          ),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.scheduleTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                l10n.scheduleSubtitle,
                style: const TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ],
          ),
        ),
        _HourFact(value: '$openDays', label: l10n.workDays),
        const SizedBox(width: 11),
        _HourFact(value: '$overnight', label: l10n.overnightLabel),
      ],
    ),
    );
  }
}

class _HourFact extends StatelessWidget {
  const _HourFact({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 19,
          fontWeight: FontWeight.w900,
        ),
      ),
      Text(label, style: const TextStyle(color: Colors.white60, fontSize: 9)),
    ],
  );
}

class _TimeButton extends StatelessWidget {
  const _TimeButton({
    required this.label,
    required this.value,
    required this.onTap,
  });
  final String label;
  final String value;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => OutlinedButton(
    onPressed: onTap,
    child: Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 3),
        Text(
          value.substring(0, 5),
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ],
    ),
  );
}
