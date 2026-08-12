import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_roles.dart';
import '../../../../core/widgets/async_states.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../data/models/medicine_models.dart';
import '../controllers/medicines_providers.dart';

class MedicinesPage extends ConsumerStatefulWidget {
  const MedicinesPage({super.key});

  @override
  ConsumerState<MedicinesPage> createState() => _MedicinesPageState();
}

class _MedicinesPageState extends ConsumerState<MedicinesPage> {
  final _search = TextEditingController();
  String _searchTerm = '';
  int _pageNumber = 1;
  static const _pageSize = 20;

  MedicinesQuery get _query =>
      (searchTerm: _searchTerm, pageNumber: _pageNumber, pageSize: _pageSize);

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final medicines = ref.watch(medicinesProvider(_query));
    final isAdmin =
        ref.watch(authControllerProvider).valueOrNull?.user.primaryRole ==
        AppRole.admin;

    return Scaffold(
      appBar: AppBar(
        title: const Text('دليل الأدوية'),
        actions: [
          if (isAdmin)
            IconButton(
              onPressed: () => context.push('/medicines/create'),
              tooltip: 'إضافة دواء',
              icon: const Icon(Icons.add_circle_outline_rounded),
            ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/medicines/create'),
              icon: const Icon(Icons.add_rounded),
              label: const Text('دواء جديد'),
            )
          : null,
      body: Column(
        children: [
          _CatalogHeader(
            controller: _search,
            onSearch: _applySearch,
            onClear: _clearSearch,
          ),
          Expanded(
            child: medicines.when(
              loading: () =>
                  const AppLoadingState(label: 'جاري تحميل دليل الأدوية...'),
              error: (error, _) => AppErrorState(
                error: error,
                onRetry: () => ref.invalidate(medicinesProvider(_query)),
              ),
              data: (page) => RefreshIndicator(
                onRefresh: () => ref.refresh(medicinesProvider(_query).future),
                child: page.items.isEmpty
                    ? _EmptyCatalog(hasSearch: _searchTerm.isNotEmpty)
                    : ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(20, 14, 20, 100),
                        children: [
                          _ResultSummary(page: page),
                          const SizedBox(height: 12),
                          ...page.items.map(
                            (medicine) => Padding(
                              padding: const EdgeInsets.only(bottom: 11),
                              child: _MedicineCard(
                                medicine: medicine,
                                onTap: () =>
                                    context.push('/medicines/${medicine.id}'),
                              ),
                            ),
                          ),
                          if (page.totalPages > 1) ...[
                            const SizedBox(height: 8),
                            _Pagination(
                              page: page,
                              onPrevious: page.hasPreviousPage
                                  ? () => _changePage(_pageNumber - 1)
                                  : null,
                              onNext: page.hasNextPage
                                  ? () => _changePage(_pageNumber + 1)
                                  : null,
                            ),
                          ],
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _applySearch() {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _searchTerm = _search.text.trim();
      _pageNumber = 1;
    });
  }

  void _clearSearch() {
    _search.clear();
    if (_searchTerm.isEmpty) return;
    setState(() {
      _searchTerm = '';
      _pageNumber = 1;
    });
  }

  void _changePage(int value) {
    setState(() => _pageNumber = value);
    PrimaryScrollController.maybeOf(context)?.animateTo(
      0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }
}

class _CatalogHeader extends StatelessWidget {
  const _CatalogHeader({
    required this.controller,
    required this.onSearch,
    required this.onClear,
  });

  final TextEditingController controller;
  final VoidCallback onSearch;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
      decoration: const BoxDecoration(
        color: Color(0xFFFFFFFF),
        border: Border(bottom: BorderSide(color: Color(0xFFD9E4E5))),
      ),
      child: TextField(
        controller: controller,
        maxLength: 200,
        textInputAction: TextInputAction.search,
        onSubmitted: (_) => onSearch(),
        decoration: InputDecoration(
          hintText: 'اسم الدواء، الاسم العلمي أو الشركة',
          prefixIcon: const Icon(Icons.search_rounded),
          counterText: '',
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: onClear,
                tooltip: 'مسح',
                icon: const Icon(Icons.close_rounded),
              ),
              IconButton.filled(
                onPressed: onSearch,
                tooltip: 'بحث',
                icon: const Icon(Icons.arrow_back_rounded),
              ),
              const SizedBox(width: 7),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultSummary extends StatelessWidget {
  const _ResultSummary({required this.page});

  final MedicinePage page;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'الأدوية المسجلة',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 3),
              Text(
                '${page.totalCount} دواء في الدليل',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
          decoration: BoxDecoration(
            color: context.appColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(
            '${page.pageNumber}/${page.totalPages}',
            style: const TextStyle(
              color: Color(0xFF216474),
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _MedicineCard extends StatelessWidget {
  const _MedicineCard({required this.medicine, required this.onTap});

  final Medicine medicine;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: context.appColors.primary.withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.medication_liquid_rounded,
                  color: Color(0xFF216474),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medicine.displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (medicine.arabicName != null &&
                        medicine.name.trim().isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        medicine.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF668087),
                          fontSize: 11,
                        ),
                      ),
                    ],
                    if ((medicine.arabicScientificName ??
                            medicine.scientificName)
                        case final name?) ...[
                      const SizedBox(height: 3),
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 7,
                      runSpacing: 6,
                      children: [
                        _Tag(
                          icon: Icons.payments_outlined,
                          text: _currency(medicine.sellingPrice),
                        ),
                        if (medicine.dosageForm case final form?)
                          _Tag(icon: Icons.category_outlined, text: form),
                        if (medicine.requiresPrescription)
                          const _Tag(
                            icon: Icons.receipt_long_outlined,
                            text: 'بوصفة طبية',
                            color: Color(0xFFB47618),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_left_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({
    required this.icon,
    required this.text,
    this.color = const Color(0xFF216474),
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}

class _Pagination extends StatelessWidget {
  const _Pagination({
    required this.page,
    required this.onPrevious,
    required this.onNext,
  });

  final MedicinePage page;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: OutlinedButton.icon(
          onPressed: onPrevious,
          icon: const Icon(Icons.chevron_right_rounded),
          label: const Text('السابق'),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Text(
          '${page.pageNumber} من ${page.totalPages}',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      Expanded(
        child: FilledButton.icon(
          onPressed: onNext,
          icon: const Icon(Icons.chevron_left_rounded),
          label: const Text('التالي'),
        ),
      ),
    ],
  );
}

class _EmptyCatalog extends StatelessWidget {
  const _EmptyCatalog({required this.hasSearch});

  final bool hasSearch;

  @override
  Widget build(BuildContext context) => ListView(
    physics: const AlwaysScrollableScrollPhysics(),
    padding: const EdgeInsets.all(34),
    children: [
      const SizedBox(height: 90),
      const Icon(
        Icons.medication_outlined,
        size: 52,
        color: Color(0xFF668087),
      ),
      const SizedBox(height: 14),
      Text(
        hasSearch ? 'لا توجد نتائج مطابقة' : 'دليل الأدوية فارغ',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      const SizedBox(height: 7),
      Text(
        hasSearch
            ? 'جرّب اسمًا آخر أو جزءًا من الاسم العلمي.'
            : 'ستظهر الأدوية المسجلة هنا.',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    ],
  );
}

String _currency(double value) {
  final digits = value == value.roundToDouble() ? 0 : 2;
  return '${value.toStringAsFixed(digits)} ل.س';
}
