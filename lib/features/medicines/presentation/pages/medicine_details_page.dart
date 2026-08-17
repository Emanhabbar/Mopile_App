import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_roles.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../../core/widgets/async_states.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../data/models/medicine_models.dart';
import '../../data/repositories/medicines_repository.dart';
import '../controllers/medicines_providers.dart';

class MedicineDetailsPage extends ConsumerWidget {
  const MedicineDetailsPage({required this.medicineId, super.key});

  final String medicineId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicine = ref.watch(medicineDetailsProvider(medicineId));
    final isAdmin =
        ref.watch(authControllerProvider).valueOrNull?.user.primaryRole ==
        AppRole.admin;
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الدواء')),
      body: medicine.when(
        loading: () =>
            const AppLoadingState(label: 'جاري تحميل بيانات الدواء...'),
        error: (error, _) => AppErrorState(
          error: error,
          onRetry: () => ref.invalidate(medicineDetailsProvider(medicineId)),
        ),
        data: (data) => RefreshIndicator(
          onRefresh: () =>
              ref.refresh(medicineDetailsProvider(medicineId).future),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
            children: [
              _MedicineHero(medicine: data),
              const SizedBox(height: 20),
              _QuickInfoStrip(medicine: data),
              const SizedBox(height: 16),
              _Section(
                title: 'المعلومات الدوائية',
                icon: Icons.science_outlined,
                children: [
                  _InfoRow(
                    label: 'الاسم العلمي العربي',
                    value: data.arabicScientificName,
                  ),
                  _InfoRow(
                    label: 'الاسم العلمي الإنكليزي',
                    value: data.scientificName,
                  ),
                  _InfoRow(label: 'الاسم الإنكليزي', value: data.name),
                  _InfoRow(label: 'الباركود', value: data.barcode),
                  _InfoRow(label: 'التركيب', value: data.composition),
                  _InfoRow(label: 'الشكل الدوائي', value: data.dosageForm),
                  _InfoRow(label: 'السعة أو التركيز', value: data.capacity),
                  _InfoRow(label: 'حجم العبوة', value: data.packageSize),
                ],
              ),
              const SizedBox(height: 12),
              _Section(
                title: 'التصنيع والتوفر',
                icon: Icons.factory_outlined,
                children: [
                  _InfoRow(label: 'الشركة المصنعة', value: data.manufacturer),
                  _InfoRow(
                    label: 'الكمية المرجعية',
                    value: '${data.quantityInStock}',
                  ),
                  _InfoRow(
                    label: 'سعر البيع',
                    value: _currency(data.sellingPrice),
                  ),
                  if (isAdmin)
                    _InfoRow(
                      label: 'سعر الشراء',
                      value: _currency(data.purchasePrice),
                    ),
                ],
              ),
              if (data.description case final description?) ...[
                const SizedBox(height: 12),
                _Description(text: description),
              ],
              if (isAdmin) ...[
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () => _editLocalization(context, ref, data),
                  icon: const Icon(Icons.translate_rounded),
                  label: const Text('تعديل الاسم العربي وأسماء البحث'),
                ),
              ],
              const SizedBox(height: 16),
              _DisclaimerBanner(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _editLocalization(
    BuildContext context,
    WidgetRef ref,
    Medicine medicine,
  ) async {
    final arabicName = TextEditingController(text: medicine.arabicName);
    final arabicScientific = TextEditingController(
      text: medicine.arabicScientificName,
    );
    final aliases = TextEditingController(
      text: medicine.aliases
          .where((item) => item.language.toLowerCase() == 'ar')
          .map((item) => item.value)
          .join('، '),
    );
    final request = await showDialog<UpdateMedicineLocalization>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('البيانات العربية للدواء'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: arabicName,
                decoration: const InputDecoration(labelText: 'الاسم العربي'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: arabicScientific,
                decoration: const InputDecoration(
                  labelText: 'الاسم العلمي العربي',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: aliases,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'أسماء أخرى للبحث',
                  hintText: 'افصل بين الأسماء بفاصلة',
                  alignLabelWithHint: true,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () {
              final values = aliases.text
                  .split(RegExp(r'[,،]'))
                  .map((value) => value.trim())
                  .where((value) => value.isNotEmpty)
                  .map((value) => MedicineAliasInput(value: value))
                  .toList(growable: false);
              Navigator.pop(
                dialogContext,
                UpdateMedicineLocalization(
                  arabicName: arabicName.text,
                  arabicScientificName: arabicScientific.text,
                  aliases: values,
                ),
              );
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
    arabicName.dispose();
    arabicScientific.dispose();
    aliases.dispose();
    if (request == null || !context.mounted) return;
    try {
      await ref
          .read(medicinesRepositoryProvider)
          .updateLocalization(medicine.id, request);
      ref.invalidate(medicineDetailsProvider(medicine.id));
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تحديث البيانات العربية للدواء.')),
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error is ApiException ? error.message : 'تعذر حفظ البيانات.',
          ),
          backgroundColor: context.appColors.danger,
        ),
      );
    }
  }
}

class _MedicineHero extends StatelessWidget {
  const _MedicineHero({required this.medicine});

  final Medicine medicine;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: colors.primaryDark.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.medication_liquid_rounded,
                  color: Colors.white,
                  size: 34,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: medicine.requiresPrescription
                      ? colors.primaryDark.withValues(alpha: 0.2)
                      : colors.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      medicine.requiresPrescription
                          ? Icons.receipt_long_outlined
                          : Icons.health_and_safety_outlined,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      medicine.requiresPrescription ? 'يتطلب وصفة' : 'بدون وصفة',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            medicine.displayName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              height: 1.3,
            ),
          ),
          if (medicine.arabicName != null && medicine.name.trim().isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              medicine.name,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          if ((medicine.arabicScientificName ?? medicine.scientificName)
              case final name?) ...[
            const SizedBox(height: 6),
            Text(
              name,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _QuickInfoStrip extends StatelessWidget {
  const _QuickInfoStrip({required this.medicine});

  final Medicine medicine;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final items = <_QuickInfo>[
      _QuickInfo(
        icon: Icons.payments_outlined,
        label: 'سعر البيع',
        value: _currency(medicine.sellingPrice),
        color: colors.primary,
      ),
      if (medicine.dosageForm case final form?)
        _QuickInfo(
          icon: Icons.category_outlined,
          label: 'الشكل',
          value: form,
          color: colors.primary,
        ),
      _QuickInfo(
        icon: Icons.inventory_2_outlined,
        label: 'المخزون',
        value: '${medicine.quantityInStock}',
        color: colors.primary,
      ),
    ];
    return Row(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(child: _QuickInfoCard(info: items[i])),
        ],
      ],
    );
  }
}

class _QuickInfo {
  const _QuickInfo({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
}

class _QuickInfoCard extends StatelessWidget {
  const _QuickInfoCard({required this.info});

  final _QuickInfo info;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: info.color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: info.color.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        children: [
          Icon(info.icon, color: info.color, size: 22),
          const SizedBox(height: 8),
          Text(
            info.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: info.color,
              fontWeight: FontWeight.w900,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            info.label,
            style: TextStyle(
              color: colors.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final visible = children
        .where((child) => child is! _InfoRow || child.hasValue)
        .toList(growable: false);
    if (visible.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: colors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: colors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...visible,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String? value;

  bool get hasValue => value?.trim().isNotEmpty == true;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceSoft,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: colors.primary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Text(
              value ?? '—',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: value?.trim().isNotEmpty == true
                    ? colors.text
                    : colors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Description extends StatelessWidget {
  const _Description({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.notes_rounded,
                  color: colors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'الوصف',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: colors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            text,
            style: TextStyle(
              fontSize: 15,
              height: 1.65,
              color: colors.text,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _DisclaimerBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.primaryDark.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.primaryDark.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colors.primaryDark.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.info_outline_rounded,
              color: colors.primaryDark,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'هذه البيانات تعريفية. التزم بتوجيهات الطبيب أو الصيدلي ولا تغيّر علاجك دون استشارة مختص.',
              style: TextStyle(
                color: colors.text,
                fontSize: 13,
                height: 1.6,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _currency(double value) {
  final digits = value == value.roundToDouble() ? 0 : 2;
  return '${value.toStringAsFixed(digits)} ل.س';
}
