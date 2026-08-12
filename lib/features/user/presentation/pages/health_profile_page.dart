import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/async_states.dart';
import '../../data/models/user_models.dart';
import '../controllers/user_providers.dart';

class HealthProfilePage extends ConsumerStatefulWidget {
  const HealthProfilePage({super.key});

  @override
  ConsumerState<HealthProfilePage> createState() => _HealthProfilePageState();
}

class _HealthProfilePageState extends ConsumerState<HealthProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _emergencyName = TextEditingController();
  final _emergencyPhone = TextEditingController();
  final _emergencyNotes = TextEditingController();
  DateTime? _dateOfBirth;
  String? _bloodType;
  List<String> _allergies = [];
  List<String> _conditions = [];
  List<String> _medications = [];
  bool _initialized = false;
  int _selectedSection = 0;

  static const _bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  @override
  void dispose() {
    _emergencyName.dispose();
    _emergencyPhone.dispose();
    _emergencyNotes.dispose();
    super.dispose();
  }

  void _initialize(UserMedicalProfile profile) {
    if (_initialized) return;
    _dateOfBirth = profile.dateOfBirth;
    _bloodType = profile.bloodType;
    _allergies = [...profile.allergies];
    _conditions = [...profile.chronicConditions];
    _medications = [...profile.currentMedications];
    _emergencyName.text = profile.emergencyContactName ?? '';
    _emergencyPhone.text = profile.emergencyContactPhoneNumber ?? '';
    _emergencyNotes.text = profile.emergencyNotes ?? '';
    _initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final medicalState = ref.watch(userMedicalProfileProvider);
    final healthCardState = ref.watch(userHealthCardProvider);

    ref.listen(userMedicalProfileProvider, (previous, next) {
      final error = next.error;
      if (error == null || previous?.error == error || !mounted) return;
      final message = error is ApiException
          ? error.message
          : 'تعذر حفظ الملف الصحي.';
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
    });

    return Scaffold(
      appBar: AppBar(title: const Text('ملفي الصحي')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 5),
            child: _SectionSwitcher(
              selectedIndex: _selectedSection,
              onChanged: (value) => setState(() => _selectedSection = value),
            ),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: _selectedSection == 0
                  ? medicalState.when(
                      loading: () => const AppLoadingState(
                        label: 'جاري تحميل ملفك الصحي...',
                      ),
                      error: (error, _) => AppErrorState(
                        error: error,
                        onRetry: () {
                          _initialized = false;
                          ref.invalidate(userMedicalProfileProvider);
                        },
                      ),
                      data: (profile) {
                        _initialize(profile);
                        return _MedicalProfileForm(
                          key: const ValueKey('medical-profile'),
                          formKey: _formKey,
                          dateOfBirth: _dateOfBirth,
                          bloodType: _bloodType,
                          bloodTypes: _bloodTypes,
                          allergies: _allergies,
                          conditions: _conditions,
                          medications: _medications,
                          emergencyName: _emergencyName,
                          emergencyPhone: _emergencyPhone,
                          emergencyNotes: _emergencyNotes,
                          isSaving: medicalState.isLoading,
                          onPickDate: _pickDate,
                          onBloodTypeChanged: (value) =>
                              setState(() => _bloodType = value),
                          onAllergiesChanged: (value) =>
                              setState(() => _allergies = value),
                          onConditionsChanged: (value) =>
                              setState(() => _conditions = value),
                          onMedicationsChanged: (value) =>
                              setState(() => _medications = value),
                          onSave: _save,
                        );
                      },
                    )
                  : healthCardState.when(
                      loading: () => const AppLoadingState(
                        label: 'جاري إعداد البطاقة الصحية...',
                      ),
                      error: (error, _) => AppErrorState(
                        error: error,
                        onRetry: () => ref.invalidate(userHealthCardProvider),
                      ),
                      data: (card) => _HealthCardView(
                        key: const ValueKey('health-card'),
                        card: card,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime(now.year - 20),
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year, now.month, now.day),
      helpText: 'تاريخ الميلاد',
      cancelText: 'إلغاء',
      confirmText: 'اختيار',
    );
    if (picked != null) setState(() => _dateOfBirth = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final saved = await ref
        .read(userMedicalProfileProvider.notifier)
        .save(
          UpdateMedicalProfileRequest(
            dateOfBirth: _dateOfBirth,
            bloodType: _bloodType,
            allergies: _allergies,
            chronicConditions: _conditions,
            currentMedications: _medications,
            emergencyContactName: _emergencyName.text,
            emergencyContactPhoneNumber: _emergencyPhone.text,
            emergencyNotes: _emergencyNotes.text,
          ),
        );
    if (!mounted || !saved) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('تم حفظ الملف الصحي بنجاح.')),
      );
  }
}

class _SectionSwitcher extends StatelessWidget {
  const _SectionSwitcher({
    required this.selectedIndex,
    required this.onChanged,
  });

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          _SwitcherItem(
            label: 'البيانات الصحية',
            icon: Icons.favorite_outline_rounded,
            selected: selectedIndex == 0,
            onTap: () => onChanged(0),
          ),
          _SwitcherItem(
            label: 'البطاقة الصحية',
            icon: Icons.badge_outlined,
            selected: selectedIndex == 1,
            onTap: () => onChanged(1),
          ),
        ],
      ),
    );
  }
}

class _SwitcherItem extends StatelessWidget {
  const _SwitcherItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 19,
                color: selected ? Colors.white : AppColors.textMuted,
              ),
              const SizedBox(width: 7),
              Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : AppColors.text,
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

class _MedicalProfileForm extends StatelessWidget {
  const _MedicalProfileForm({
    required this.formKey,
    required this.dateOfBirth,
    required this.bloodType,
    required this.bloodTypes,
    required this.allergies,
    required this.conditions,
    required this.medications,
    required this.emergencyName,
    required this.emergencyPhone,
    required this.emergencyNotes,
    required this.isSaving,
    required this.onPickDate,
    required this.onBloodTypeChanged,
    required this.onAllergiesChanged,
    required this.onConditionsChanged,
    required this.onMedicationsChanged,
    required this.onSave,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final DateTime? dateOfBirth;
  final String? bloodType;
  final List<String> bloodTypes;
  final List<String> allergies;
  final List<String> conditions;
  final List<String> medications;
  final TextEditingController emergencyName;
  final TextEditingController emergencyPhone;
  final TextEditingController emergencyNotes;
  final bool isSaving;
  final VoidCallback onPickDate;
  final ValueChanged<String?> onBloodTypeChanged;
  final ValueChanged<List<String>> onAllergiesChanged;
  final ValueChanged<List<String>> onConditionsChanged;
  final ValueChanged<List<String>> onMedicationsChanged;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 32),
        children: [
          const _PageIntro(
            icon: Icons.health_and_safety_rounded,
            title: 'معلومات تساعدك وقت الحاجة',
            subtitle:
                'احتفظ بحساسياتك وأدويتك الحالية وبيانات التواصل الضرورية محدثة.',
          ),
          const SizedBox(height: 22),
          const _FormTitle(
            title: 'المعلومات الأساسية',
            icon: Icons.person_outline_rounded,
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: _SelectionField(
                  label: 'تاريخ الميلاد',
                  value: dateOfBirth == null
                      ? 'اختر التاريخ'
                      : _formatDate(dateOfBirth!),
                  icon: Icons.calendar_today_rounded,
                  onTap: onPickDate,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: _BloodTypeField(
                  value: bloodType,
                  values: bloodTypes,
                  onChanged: onBloodTypeChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          const _FormTitle(
            title: 'التفاصيل الصحية',
            icon: Icons.monitor_heart_outlined,
          ),
          const SizedBox(height: 14),
          _TagEditor(
            label: 'الحساسيات',
            hint: 'مثال: البنسلين',
            values: allergies,
            maximum: 20,
            icon: Icons.warning_amber_rounded,
            onChanged: onAllergiesChanged,
          ),
          const SizedBox(height: 16),
          _TagEditor(
            label: 'الحالات المزمنة',
            hint: 'مثال: السكري',
            values: conditions,
            maximum: 20,
            icon: Icons.monitor_heart_rounded,
            onChanged: onConditionsChanged,
          ),
          const SizedBox(height: 16),
          _TagEditor(
            label: 'الأدوية الحالية',
            hint: 'اكتب اسم الدواء',
            values: medications,
            maximum: 30,
            icon: Icons.medication_outlined,
            onChanged: onMedicationsChanged,
          ),
          const SizedBox(height: 25),
          const _FormTitle(
            title: 'جهة الاتصال عند الحاجة',
            icon: Icons.emergency_outlined,
          ),
          const SizedBox(height: 14),
          AppTextField(
            label: 'اسم جهة الاتصال',
            controller: emergencyName,
            hint: 'الاسم الكامل',
            icon: Icons.person_outline_rounded,
            validator: (value) =>
                (value?.trim().length ?? 0) > 150 ? 'الاسم طويل جدًا.' : null,
          ),
          const SizedBox(height: 15),
          AppTextField(
            label: 'رقم الهاتف',
            controller: emergencyPhone,
            hint: 'مثال: 09XXXXXXXX',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: (value) => (value?.trim().length ?? 0) > 30
                ? 'رقم الهاتف طويل جدًا.'
                : null,
          ),
          const SizedBox(height: 15),
          AppTextField(
            label: 'ملاحظات مهمة',
            controller: emergencyNotes,
            hint: 'أي معلومات تساعد جهة الاتصال',
            icon: Icons.notes_rounded,
            minLines: 3,
            maxLines: 5,
            validator: (value) => (value?.trim().length ?? 0) > 1000
                ? 'الملاحظات تتجاوز الحد المسموح.'
                : null,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: isSaving ? null : onSave,
            icon: isSaving
                ? const SizedBox.square(
                    dimension: 19,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.3,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.check_rounded),
            label: Text(isSaving ? 'جاري الحفظ...' : 'حفظ التغييرات'),
          ),
        ],
      ),
    );
  }
}

class _HealthCardView extends StatelessWidget {
  const _HealthCardView({required this.card, super.key});

  final UserHealthCard card;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 32),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0xFF174B57), Color(0xFF087F72)],
            ),
            borderRadius: BorderRadius.circular(27),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.2),
                blurRadius: 28,
                offset: const Offset(0, 13),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.favorite_rounded, color: Color(0xFFF5CB72)),
                  SizedBox(width: 8),
                  Text(
                    'البطاقة الصحية',
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Text(
                card.fullName,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: 17),
              Wrap(
                spacing: 9,
                runSpacing: 9,
                children: [
                  _CardFact(
                    label: 'فصيلة الدم',
                    value: card.bloodType ?? 'غير محددة',
                  ),
                  _CardFact(
                    label: 'تاريخ الميلاد',
                    value: card.dateOfBirth == null
                        ? 'غير محدد'
                        : _formatDate(card.dateOfBirth!),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        _InfoCollection(
          title: 'الحساسيات',
          icon: Icons.warning_amber_rounded,
          color: const Color(0xFFD14E62),
          values: card.allergies,
          emptyText: 'لا توجد حساسيات مسجلة',
        ),
        const SizedBox(height: 13),
        _InfoCollection(
          title: 'الحالات المزمنة',
          icon: Icons.monitor_heart_rounded,
          color: const Color(0xFF8A5AC2),
          values: card.chronicConditions,
          emptyText: 'لا توجد حالات مزمنة مسجلة',
        ),
        const SizedBox(height: 13),
        _InfoCollection(
          title: 'الأدوية الحالية',
          icon: Icons.medication_rounded,
          color: AppColors.primary,
          values: card.currentMedications,
          emptyText: 'لا توجد أدوية حالية مسجلة',
        ),
        const SizedBox(height: 13),
        _EmergencyCard(card: card),
      ],
    );
  }
}

class _TagEditor extends StatefulWidget {
  const _TagEditor({
    required this.label,
    required this.hint,
    required this.values,
    required this.maximum,
    required this.icon,
    required this.onChanged,
  });

  final String label;
  final String hint;
  final List<String> values;
  final int maximum;
  final IconData icon;
  final ValueChanged<List<String>> onChanged;

  @override
  State<_TagEditor> createState() => _TagEditorState();
}

class _TagEditorState extends State<_TagEditor> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _add() {
    final value = _controller.text.trim();
    if (value.isEmpty || widget.values.length >= widget.maximum) return;
    if (value.length > 150) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يجب ألا يتجاوز النص 150 حرفًا.')),
      );
      return;
    }
    if (widget.values.any(
      (item) => item.toLowerCase() == value.toLowerCase(),
    )) {
      _controller.clear();
      return;
    }
    widget.onChanged([...widget.values, value]);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(widget.icon, size: 18, color: AppColors.primary),
            const SizedBox(width: 7),
            Text(
              widget.label,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontSize: 14),
            ),
            const Spacer(),
            Text(
              '${widget.values.length}/${widget.maximum}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 9),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _add(),
                decoration: InputDecoration(hintText: widget.hint),
              ),
            ),
            const SizedBox(width: 9),
            IconButton.filled(
              onPressed: widget.values.length >= widget.maximum ? null : _add,
              tooltip: 'إضافة',
              icon: const Icon(Icons.add_rounded),
            ),
          ],
        ),
        if (widget.values.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: widget.values
                .map(
                  (value) => InputChip(
                    label: Text(value),
                    onDeleted: () => widget.onChanged(
                      widget.values.where((item) => item != value).toList(),
                    ),
                    deleteIcon: const Icon(Icons.close_rounded, size: 17),
                  ),
                )
                .toList(growable: false),
          ),
        ],
      ],
    );
  }
}

class _PageIntro extends StatelessWidget {
  const _PageIntro({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.13)),
      ),
      child: Row(
        children: [
          Container(
            width: 49,
            height: 49,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontSize: 12.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FormTitle extends StatelessWidget {
  const _FormTitle({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 21),
        const SizedBox(width: 8),
        Text(title, style: Theme.of(context).textTheme.titleLarge),
      ],
    );
  }
}

class _SelectionField extends StatelessWidget {
  const _SelectionField({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontSize: 14),
        ),
        const SizedBox(height: 9),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: InputDecorator(
            decoration: InputDecoration(prefixIcon: Icon(icon)),
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      ],
    );
  }
}

class _BloodTypeField extends StatelessWidget {
  const _BloodTypeField({
    required this.value,
    required this.values,
    required this.onChanged,
  });

  final String? value;
  final List<String> values;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'فصيلة الدم',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontSize: 14),
        ),
        const SizedBox(height: 9),
        DropdownButtonFormField<String>(
          initialValue: values.contains(value) ? value : null,
          hint: const Text('اختر'),
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.bloodtype_outlined),
          ),
          items: values
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(growable: false),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _CardFact extends StatelessWidget {
  const _CardFact({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.65),
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCollection extends StatelessWidget {
  const _InfoCollection({
    required this.title,
    required this.icon,
    required this.color,
    required this.values,
    required this.emptyText,
  });

  final String title;
  final IconData icon;
  final Color color;
  final List<String> values;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 21),
                const SizedBox(width: 8),
                Text(title, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 13),
            if (values.isEmpty)
              Text(emptyText, style: Theme.of(context).textTheme.bodyMedium)
            else
              Wrap(
                spacing: 7,
                runSpacing: 7,
                children: values
                    .map(
                      (value) => Chip(
                        label: Text(value),
                        backgroundColor: color.withValues(alpha: 0.08),
                        side: BorderSide(color: color.withValues(alpha: 0.14)),
                      ),
                    )
                    .toList(growable: false),
              ),
          ],
        ),
      ),
    );
  }
}

class _EmergencyCard extends StatelessWidget {
  const _EmergencyCard({required this.card});

  final UserHealthCard card;

  @override
  Widget build(BuildContext context) {
    final name = card.emergencyContactName;
    final phone = card.emergencyContactPhoneNumber;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.emergency_rounded, color: Color(0xFFD14E62)),
                SizedBox(width: 8),
                Text(
                  'جهة الاتصال عند الحاجة',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 13),
            if (name == null && phone == null)
              Text(
                'لم تتم إضافة جهة اتصال بعد.',
                style: Theme.of(context).textTheme.bodyMedium,
              )
            else ...[
              if (name != null) _DetailRow(icon: Icons.person, value: name),
              if (phone != null) _DetailRow(icon: Icons.phone, value: phone),
              if (card.emergencyNotes case final notes?)
                _DetailRow(icon: Icons.notes, value: notes),
            ],
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.textMuted, size: 18),
          const SizedBox(width: 9),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

String _formatDate(DateTime value) =>
    '${value.year}/${value.month.toString().padLeft(2, '0')}/'
    '${value.day.toString().padLeft(2, '0')}';
