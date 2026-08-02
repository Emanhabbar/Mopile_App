import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../../core/widgets/async_states.dart';
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
  static const _days = [
    'الأحد',
    'الاثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
  ];

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pharmacyWorkingHoursProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('ساعات العمل'),
        actions: [
          IconButton(
            onPressed: () {
              _periods = null;
              ref.invalidate(pharmacyWorkingHoursProvider);
            },
            tooltip: 'استعادة الساعات المحفوظة',
            icon: const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: state.when(
        loading: () =>
            const AppLoadingState(label: 'جاري تحميل ساعات العمل...'),
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
                  color: AppColors.surfaceWarm,
                  borderRadius: BorderRadius.circular(17),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.nights_stay_outlined, color: AppColors.warning),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'للدوام بعد منتصف الليل اختر وقت إغلاق أسبق من وقت الفتح، وسيُحفظ لليوم التالي تلقائيًا.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              ...List.generate(7, _dayEditor),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: _saving ? null : _save,
                icon: _saving
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save_rounded),
                label: Text(_saving ? 'جاري الحفظ...' : 'حفظ ساعات العمل'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _dayEditor(int index) {
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
                        ? AppColors.background
                        : AppColors.surfaceSoft,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Text(
                    _days[index].substring(0, 2),
                    style: TextStyle(
                      color: period.isClosed
                          ? AppColors.textMuted
                          : AppColors.primary,
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
                        _days[index],
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                      Text(
                        period.isClosed
                            ? 'الصيدلية مغلقة'
                            : overnight
                            ? 'دوام ممتد لليوم التالي'
                            : '${period.openTime!.substring(0, 5)} – ${period.closeTime!.substring(0, 5)}',
                        style: TextStyle(
                          color: overnight
                              ? AppColors.warning
                              : AppColors.textMuted,
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
                      label: 'من',
                      value: period.openTime!,
                      onTap: () => _pickTime(index, true),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _TimeButton(
                      label: 'إلى',
                      value: period.closeTime!,
                      onTap: () => _pickTime(index, false),
                    ),
                  ),
                ],
              ),
              if (overnight) ...[
                const SizedBox(height: 9),
                const Row(
                  children: [
                    Icon(
                      Icons.dark_mode_outlined,
                      size: 15,
                      color: AppColors.warning,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'ينتهي الدوام في اليوم التالي',
                      style: TextStyle(
                        color: AppColors.warning,
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
    final period = _periods![index];
    final current = _parse(opening ? period.openTime : period.closeTime);
    final picked = await showTimePicker(
      context: context,
      initialTime: current,
      helpText: opening ? 'وقت بدء الدوام' : 'وقت انتهاء الدوام',
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
    for (final period in _periods!) {
      if (!period.isClosed && period.openTime == period.closeTime) {
        _message('وقت الفتح والإغلاق يجب أن يكونا مختلفين.', true);
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
      _message('تم حفظ ساعات العمل.', false);
    } catch (error) {
      _message(
        error is ApiException ? error.message : 'تعذر حفظ ساعات العمل.',
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
        backgroundColor: error ? AppColors.danger : null,
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
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(19),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [AppColors.primaryDeep, AppColors.primary],
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
          child: const Icon(
            Icons.schedule_rounded,
            color: AppColors.secondary,
            size: 28,
          ),
        ),
        const SizedBox(width: 13),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'جدول الصيدلية',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                'حدّد أوقات استقبال طلبات المستخدمين',
                style: TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ],
          ),
        ),
        _HourFact(value: '$openDays', label: 'أيام عمل'),
        const SizedBox(width: 11),
        _HourFact(value: '$overnight', label: 'ليلي'),
      ],
    ),
  );
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
