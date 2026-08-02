import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/models/medicine_models.dart';
import '../../data/repositories/medicines_repository.dart';
import '../controllers/medicines_providers.dart';

class CreateMedicinePage extends ConsumerStatefulWidget {
  const CreateMedicinePage({super.key});

  @override
  ConsumerState<CreateMedicinePage> createState() => _CreateMedicinePageState();
}

class _CreateMedicinePageState extends ConsumerState<CreateMedicinePage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _scientificName = TextEditingController();
  final _purchasePrice = TextEditingController(text: '0');
  final _sellingPrice = TextEditingController(text: '0');
  final _quantity = TextEditingController(text: '0');
  final _manufacturer = TextEditingController();
  final _dosageForm = TextEditingController();
  final _packageSize = TextEditingController();
  final _capacity = TextEditingController();
  final _composition = TextEditingController();
  final _description = TextEditingController();
  bool _requiresPrescription = false;
  bool _saving = false;

  Iterable<TextEditingController> get _controllers => [
    _name,
    _scientificName,
    _purchasePrice,
    _sellingPrice,
    _quantity,
    _manufacturer,
    _dosageForm,
    _packageSize,
    _capacity,
    _composition,
    _description,
  ];

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إضافة دواء')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
          children: [
            const _Intro(),
            const SizedBox(height: 22),
            const _SectionTitle(
              icon: Icons.medication_outlined,
              title: 'البيانات الأساسية',
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'اسم الدواء',
              controller: _name,
              hint: 'الاسم التجاري',
              icon: Icons.medication_liquid_outlined,
              textInputAction: TextInputAction.next,
              validator: (value) => _requiredLength(
                value,
                maximum: 500,
                requiredMessage: 'اسم الدواء مطلوب.',
              ),
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'الاسم العلمي',
              controller: _scientificName,
              hint: 'اختياري',
              icon: Icons.science_outlined,
              textInputAction: TextInputAction.next,
              validator: (value) => _maximum(value, 2000),
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AppTextField(
                    label: 'سعر الشراء',
                    controller: _purchasePrice,
                    hint: '0',
                    icon: Icons.shopping_cart_outlined,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: _nonNegativeNumber,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: AppTextField(
                    label: 'سعر البيع',
                    controller: _sellingPrice,
                    hint: '0',
                    icon: Icons.payments_outlined,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: _nonNegativeNumber,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'الكمية المرجعية',
              controller: _quantity,
              hint: '0',
              icon: Icons.inventory_2_outlined,
              keyboardType: TextInputType.number,
              validator: _nonNegativeInteger,
            ),
            const SizedBox(height: 22),
            const _SectionTitle(
              icon: Icons.category_outlined,
              title: 'التصنيف والتصنيع',
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'الشركة المصنعة',
              controller: _manufacturer,
              hint: 'اختياري',
              icon: Icons.factory_outlined,
              textInputAction: TextInputAction.next,
              validator: (value) => _maximum(value, 200),
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AppTextField(
                    label: 'الشكل الدوائي',
                    controller: _dosageForm,
                    hint: 'أقراص، شراب...',
                    icon: Icons.category_outlined,
                    validator: (value) => _maximum(value, 100),
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: AppTextField(
                    label: 'السعة',
                    controller: _capacity,
                    hint: '500 mg',
                    icon: Icons.scale_outlined,
                    validator: (value) => _maximum(value, 100),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'حجم العبوة',
              controller: _packageSize,
              hint: 'مثال: 20 قرصًا',
              icon: Icons.inventory_outlined,
              validator: (value) => _maximum(value, 100),
            ),
            const SizedBox(height: 14),
            _PrescriptionSwitch(
              value: _requiresPrescription,
              onChanged: (value) =>
                  setState(() => _requiresPrescription = value),
            ),
            const SizedBox(height: 22),
            const _SectionTitle(
              icon: Icons.description_outlined,
              title: 'المعلومات التفصيلية',
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'التركيب',
              controller: _composition,
              hint: 'المواد الفعالة والتركيب',
              icon: Icons.biotech_outlined,
              minLines: 3,
              maxLines: 5,
              validator: (value) => _maximum(value, 2000),
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'الوصف',
              controller: _description,
              hint: 'وصف مختصر ودقيق للدواء',
              icon: Icons.notes_rounded,
              minLines: 3,
              maxLines: 5,
              validator: (value) => _maximum(value, 1000),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox.square(
                      dimension: 19,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.2,
                      ),
                    )
                  : const Icon(Icons.check_rounded),
              label: Text(_saving ? 'جاري الحفظ...' : 'حفظ الدواء'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _saving = true);
    try {
      final created = await ref
          .read(medicinesRepositoryProvider)
          .createMedicine(
            CreateMedicine(
              name: _name.text,
              scientificName: _scientificName.text,
              purchasePrice: _number(_purchasePrice.text),
              sellingPrice: _number(_sellingPrice.text),
              quantityInStock: int.parse(_quantity.text.trim()),
              manufacturer: _manufacturer.text,
              dosageForm: _dosageForm.text,
              packageSize: _packageSize.text,
              capacity: _capacity.text,
              composition: _composition.text,
              description: _description.text,
              requiresPrescription: _requiresPrescription,
            ),
          );
      ref.invalidate(medicinesProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تمت إضافة الدواء بنجاح.')));
      context.go('/medicines/${created.id}');
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error is ApiException ? error.message : 'تعذر إضافة الدواء حاليًا.',
          ),
          backgroundColor: AppColors.danger,
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

class _Intro extends StatelessWidget {
  const _Intro();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(19),
    decoration: BoxDecoration(
      color: AppColors.primary.withValues(alpha: 0.07),
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: AppColors.primary.withValues(alpha: 0.13)),
    ),
    child: const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.library_add_rounded, color: AppColors.primary),
        SizedBox(width: 11),
        Expanded(
          child: Text(
            'أدخل بيانات الدواء بدقة. سيصبح الدواء متاحًا للصيدليات لإضافته إلى مخزونها بعد الحفظ.',
          ),
        ),
      ],
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, color: AppColors.primary, size: 21),
      const SizedBox(width: 8),
      Text(title, style: Theme.of(context).textTheme.titleLarge),
    ],
  );
}

class _PrescriptionSwitch extends StatelessWidget {
  const _PrescriptionSwitch({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => Card(
    child: SwitchListTile(
      value: value,
      onChanged: onChanged,
      secondary: const Icon(
        Icons.receipt_long_outlined,
        color: AppColors.primary,
      ),
      title: const Text('يتطلب وصفة طبية'),
      subtitle: const Text('فعّل الخيار إذا كان صرف الدواء يحتاج وصفة'),
    ),
  );
}

String? _requiredLength(
  String? value, {
  required int maximum,
  required String requiredMessage,
}) {
  final text = value?.trim() ?? '';
  if (text.isEmpty) return requiredMessage;
  return text.length > maximum ? 'الحد الأقصى $maximum حرفًا.' : null;
}

String? _maximum(String? value, int maximum) =>
    (value?.trim().length ?? 0) > maximum
    ? 'الحد الأقصى $maximum حرفًا.'
    : null;

String? _nonNegativeNumber(String? value) {
  final number = double.tryParse((value ?? '').trim().replaceAll(',', '.'));
  if (number == null) return 'أدخل رقمًا صحيحًا.';
  return number < 0 ? 'لا يمكن أن تكون القيمة سالبة.' : null;
}

String? _nonNegativeInteger(String? value) {
  final number = int.tryParse((value ?? '').trim());
  if (number == null) return 'أدخل عددًا صحيحًا.';
  return number < 0 ? 'لا يمكن أن تكون القيمة سالبة.' : null;
}

double _number(String value) => double.parse(value.trim().replaceAll(',', '.'));
