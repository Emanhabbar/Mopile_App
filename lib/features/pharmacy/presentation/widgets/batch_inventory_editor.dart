import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/theme/app_colors.dart';
import '../../data/models/pharmacy_models.dart';

class BatchInventoryEditor extends StatefulWidget {
  const BatchInventoryEditor({required this.medicines, super.key});

  final List<PharmacyCatalogMedicine> medicines;

  @override
  State<BatchInventoryEditor> createState() => _BatchInventoryEditorState();
}

class _BatchInventoryEditorState extends State<BatchInventoryEditor> {
  final _formKey = GlobalKey<FormState>();
  late final List<_BatchEntry> _entries;
  var _showValidation = false;

  @override
  void initState() {
    super.initState();
    _entries = widget.medicines.map(_BatchEntry.new).toList();
    for (final entry in _entries) {
      entry.price.addListener(_refreshProgress);
    }
  }

  @override
  void dispose() {
    for (final entry in _entries) {
      entry.dispose();
    }
    super.dispose();
  }

  void _refreshProgress() {
    if (mounted) setState(() {});
  }

  int get _completedPrices => _entries
      .where((entry) => (double.tryParse(entry.price.text.trim()) ?? 0) > 0)
      .length;

  Future<void> _applyCommonSettings() async {
    final current = _entries.isEmpty ? null : _entries.first;
    if (current == null) return;
    final defaults = await showDialog<_BatchDefaults>(
      context: context,
      builder: (_) => _BatchDefaultsDialog(
        initial: _BatchDefaults(
          quantity: int.tryParse(current.quantity.text) ?? 1,
          threshold: int.tryParse(current.threshold.text) ?? 5,
          available: current.available,
          priceVisible: current.priceVisible,
        ),
      ),
    );
    if (defaults == null) return;
    setState(() {
      for (final entry in _entries) {
        entry
          ..quantity.text = '${defaults.quantity}'
          ..threshold.text = '${defaults.threshold}'
          ..available = defaults.available
          ..priceVisible = defaults.priceVisible;
      }
    });
  }

  void _removeEntry(_BatchEntry entry) {
    setState(() {
      _entries.remove(entry);
      entry.dispose();
    });
    if (_entries.isEmpty) Navigator.pop(context);
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    setState(() => _showValidation = true);
    if (!(_formKey.currentState?.validate() ?? false)) return;

    Navigator.pop(
      context,
      _entries
          .map(
            (entry) => PharmacyInventoryBatchItemInput(
              medicineId: entry.medicine.id,
              quantity: int.parse(entry.quantity.text.trim()),
              unitPrice: double.parse(entry.price.text.trim()),
              isPriceVisibleToUsers: entry.priceVisible,
              isAvailable: entry.available,
              lowStockThreshold: int.parse(entry.threshold.text.trim()),
              expiryDate: entry.expiryDate,
            ),
          )
          .toList(growable: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = _entries.isEmpty
        ? 0.0
        : _completedPrices / _entries.length;
    return FractionallySizedBox(
      heightFactor: .95,
      child: Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        clipBehavior: Clip.antiAlias,
        child: SafeArea(
          top: false,
          child: Form(
            key: _formKey,
            autovalidateMode: _showValidation
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            child: Column(
              children: [
                _header(progress),
                Expanded(
                  child: ListView.separated(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                    itemCount: _entries.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (_, index) => _BatchMedicineCard(
                      key: ValueKey(_entries[index].medicine.id),
                      index: index,
                      entry: _entries[index],
                      canRemove: _entries.length > 1,
                      onRemove: () => _removeEntry(_entries[index]),
                      onChanged: () => setState(() {}),
                    ),
                  ),
                ),
                _footer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header(double progress) => Padding(
    padding: const EdgeInsets.fromLTRB(18, 12, 18, 8),
    child: Column(
      children: [
        Container(
          width: 44,
          height: 4,
          decoration: BoxDecoration(
            color: context.appColors.border,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: context.appColors.surfaceSoft,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.playlist_add_check_circle_outlined,
                color: Color(0xFF216474),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'تجهيز الأدوية المختارة',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    'أدخل سعر كل دواء، ثم راجع باقي بيانات المخزون.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => Navigator.pop(context),
              tooltip: 'إغلاق',
              icon: const Icon(Icons.close_rounded),
            ),
          ],
        ),
        const SizedBox(height: 13),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(value: progress, minHeight: 7),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '$_completedPrices/${_entries.length} أسعار',
              style: const TextStyle(
                color: Color(0xFF216474),
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _applyCommonSettings,
            icon: const Icon(Icons.tune_rounded, size: 19),
            label: const Text('تطبيق إعدادات مشتركة على الجميع'),
          ),
        ),
      ],
    ),
  );

  Widget _footer() => Container(
    padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      border: const Border(top: BorderSide(color: Color(0xFFD9E4E5))),
    ),
    child: SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: _submit,
        icon: const Icon(Icons.add_task_rounded),
        label: Text('إضافة ${_entries.length} أدوية إلى المخزون'),
      ),
    ),
  );
}

class _BatchMedicineCard extends StatelessWidget {
  const _BatchMedicineCard({
    required this.index,
    required this.entry,
    required this.canRemove,
    required this.onRemove,
    required this.onChanged,
    super.key,
  });

  final int index;
  final _BatchEntry entry;
  final bool canRemove;
  final VoidCallback onRemove;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final details = [
      entry.medicine.arabicName,
      entry.medicine.scientificName,
      entry.medicine.arabicScientificName,
      entry.medicine.dosageForm,
      entry.medicine.capacity,
    ].whereType<String>().where((value) => value.trim().isNotEmpty).join(' · ');
    final hasPrice = (double.tryParse(entry.price.text.trim()) ?? 0) > 0;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 14, 15, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: hasPrice
                        ? context.appColors.success.withValues(alpha: .1)
                        : context.appColors.surfaceSoft,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(
                    hasPrice ? Icons.check_rounded : Icons.medication_outlined,
                    color: hasPrice ? context.appColors.success : context.appColors.primary,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${index + 1}. ${entry.medicine.name}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      if (details.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          details,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ),
                if (canRemove)
                  IconButton(
                    onPressed: onRemove,
                    tooltip: 'إزالة من القائمة',
                    icon: const Icon(Icons.close_rounded, size: 20),
                  ),
              ],
            ),
            if (entry.medicine.capacity != null ||
                entry.medicine.dosageForm != null ||
                entry.medicine.packageSize != null) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 7,
                runSpacing: 7,
                children: [
                  if (entry.medicine.capacity != null)
                    _MedicineIdentityBadge(
                      icon: Icons.straighten_rounded,
                      label: 'التركيز',
                      value: entry.medicine.capacity!,
                    ),
                  if (entry.medicine.dosageForm != null)
                    _MedicineIdentityBadge(
                      icon: Icons.category_outlined,
                      label: 'الشكل',
                      value: entry.medicine.dosageForm!,
                    ),
                  if (entry.medicine.packageSize != null)
                    _MedicineIdentityBadge(
                      icon: Icons.inventory_2_outlined,
                      label: 'العبوة',
                      value: entry.medicine.packageSize!,
                    ),
                ],
              ),
            ],
            const SizedBox(height: 14),
            TextFormField(
              key: ValueKey('batch-price-${entry.medicine.id}'),
              controller: entry.price,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textInputAction: TextInputAction.next,
              inputFormatters: [_decimalFormatter],
              decoration: const InputDecoration(
                labelText: 'سعر البيع لهذا الدواء *',
                hintText: 'مثال: 8500',
                prefixIcon: Icon(Icons.payments_outlined),
                suffixText: 'ل.س',
              ),
              validator: (value) {
                final price = double.tryParse(value?.trim() ?? '');
                return price == null || price <= 0
                    ? 'أدخل سعرًا أكبر من صفر.'
                    : null;
              },
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: entry.quantity,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: 'الكمية',
                      prefixIcon: Icon(Icons.inventory_2_outlined),
                    ),
                    validator: (value) {
                      final quantity = int.tryParse(value?.trim() ?? '');
                      if (quantity == null || quantity < 0) {
                        return 'قيمة غير صحيحة';
                      }
                      if (entry.available && quantity == 0) {
                        return 'أدخل كمية';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: entry.threshold,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: 'حد التنبيه',
                      prefixIcon: Icon(Icons.notification_important_outlined),
                    ),
                    validator: (value) {
                      final threshold = int.tryParse(value?.trim() ?? '');
                      return threshold == null || threshold < 0
                          ? 'قيمة غير صحيحة'
                          : null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 7),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ActionChip(
                  avatar: const Icon(Icons.event_outlined, size: 18),
                  label: Text(
                    entry.expiryDate == null
                        ? 'تاريخ الصلاحية'
                        : _dateLabel(entry.expiryDate!),
                  ),
                  onPressed: () async {
                    final now = DateTime.now();
                    final selected = await showDatePicker(
                      context: context,
                      initialDate:
                          entry.expiryDate ?? now.add(const Duration(days: 30)),
                      firstDate: DateTime(now.year, now.month, now.day),
                      lastDate: DateTime(now.year + 15),
                    );
                    if (selected != null) {
                      entry.expiryDate = selected;
                      onChanged();
                    }
                  },
                ),
                if (entry.expiryDate != null)
                  ActionChip(
                    label: const Text('إزالة التاريخ'),
                    onPressed: () {
                      entry.expiryDate = null;
                      onChanged();
                    },
                  ),
              ],
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              value: entry.available,
              onChanged: (value) {
                entry.available = value;
                onChanged();
              },
              title: const Text('متاح للطلب'),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              value: entry.priceVisible,
              onChanged: (value) {
                entry.priceVisible = value;
                onChanged();
              },
              title: const Text('إظهار السعر للمستخدم'),
              subtitle: const Text(
                'يمكن الاحتفاظ بالسعر داخليًا وإخفاؤه عند الحاجة',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MedicineIdentityBadge extends StatelessWidget {
  const _MedicineIdentityBadge({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
    decoration: BoxDecoration(
      color: context.appColors.primary.withValues(alpha: .07),
      borderRadius: BorderRadius.circular(11),
      border: Border.all(color: context.appColors.primary.withValues(alpha: .12)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: context.appColors.primary, size: 15),
        const SizedBox(width: 5),
        Text(
          '$label: $value',
          style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800),
        ),
      ],
    ),
  );
}

class _BatchDefaultsDialog extends StatefulWidget {
  const _BatchDefaultsDialog({required this.initial});

  final _BatchDefaults initial;

  @override
  State<_BatchDefaultsDialog> createState() => _BatchDefaultsDialogState();
}

class _BatchDefaultsDialogState extends State<_BatchDefaultsDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _quantity;
  late final TextEditingController _threshold;
  late bool _available;
  late bool _priceVisible;

  @override
  void initState() {
    super.initState();
    _quantity = TextEditingController(text: '${widget.initial.quantity}');
    _threshold = TextEditingController(text: '${widget.initial.threshold}');
    _available = widget.initial.available;
    _priceVisible = widget.initial.priceVisible;
  }

  @override
  void dispose() {
    _quantity.dispose();
    _threshold.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('إعدادات مشتركة'),
    content: Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'ستُطبق هذه القيم على جميع الأدوية، بينما يبقى السعر مستقلًا لكل دواء.',
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _quantity,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(labelText: 'الكمية'),
              validator: _nonNegativeInteger,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _threshold,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'حد المخزون المنخفض',
              ),
              validator: _nonNegativeInteger,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _available,
              onChanged: (value) => setState(() => _available = value),
              title: const Text('متاح للطلب'),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _priceVisible,
              onChanged: (value) => setState(() => _priceVisible = value),
              title: const Text('إظهار السعر للمستخدم'),
            ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('إلغاء'),
      ),
      FilledButton(
        onPressed: () {
          if (!(_formKey.currentState?.validate() ?? false)) return;
          Navigator.pop(
            context,
            _BatchDefaults(
              quantity: int.parse(_quantity.text),
              threshold: int.parse(_threshold.text),
              available: _available,
              priceVisible: _priceVisible,
            ),
          );
        },
        child: const Text('تطبيق على الجميع'),
      ),
    ],
  );
}

class _BatchEntry {
  _BatchEntry(this.medicine)
    : price = TextEditingController(),
      quantity = TextEditingController(text: '1'),
      threshold = TextEditingController(text: '5');

  final PharmacyCatalogMedicine medicine;
  final TextEditingController price;
  final TextEditingController quantity;
  final TextEditingController threshold;
  bool available = true;
  bool priceVisible = true;
  DateTime? expiryDate;

  void dispose() {
    price.dispose();
    quantity.dispose();
    threshold.dispose();
  }
}

class _BatchDefaults {
  const _BatchDefaults({
    required this.quantity,
    required this.threshold,
    required this.available,
    required this.priceVisible,
  });

  final int quantity;
  final int threshold;
  final bool available;
  final bool priceVisible;
}

final _decimalFormatter = FilteringTextInputFormatter.allow(
  RegExp(r'^\d{0,12}([.]\d{0,2})?'),
);

String? _nonNegativeInteger(String? value) {
  final parsed = int.tryParse(value?.trim() ?? '');
  return parsed == null || parsed < 0 ? 'أدخل رقمًا صحيحًا.' : null;
}

String _dateLabel(DateTime date) =>
    '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
