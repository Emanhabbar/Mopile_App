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
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _search.dispose();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(medicinesListProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(medicinesListProvider);
    final isAdmin =
        ref.watch(authControllerProvider).valueOrNull?.user.primaryRole ==
        AppRole.admin;

    return Scaffold(
      appBar: AppBar(
        title: const Text('دليل الأدوية'),
        actions: [
          if (isAdmin)
            TextButton.icon(
              onPressed: () => context.push('/medicines/create'),
              icon: const Icon(Icons.add_circle_outline_rounded, size: 20),
              label: const Text('إضافة دواء'),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          _CatalogHeader(
            controller: _search,
            onSearch: _applySearch,
            onClear: _clearSearch,
          ),
          Expanded(
            child: state.isLoading
                ? const AppLoadingState(label: 'جاري تحميل دليل الأدوية...')
                : state.error != null && state.items.isEmpty
                    ? AppErrorState(
                        error: state.error!,
                        onRetry: () =>
                            ref.read(medicinesListProvider.notifier).refresh(),
                      )
                    : state.items.isEmpty
                        ? _EmptyCatalog(
                            hasSearch: _search.text.trim().isNotEmpty,
                          )
                        : RefreshIndicator(
                        onRefresh: () =>
                            ref.read(medicinesListProvider.notifier).refresh(),
                        child: ListView.builder(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(20, 14, 20, 100),
                          itemCount: state.items.length +
                              (state.isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == state.items.length) {
                              return const _LoadingMoreIndicator();
                            }
                            final medicine = state.items[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 11),
                              child: _MedicineCard(
                                medicine: medicine,
                                onTap: () =>
                                    context.push('/medicines/${medicine.id}'),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  void _applySearch() {
    FocusManager.instance.primaryFocus?.unfocus();
    final term = _search.text.trim();
    ref.read(medicinesListProvider.notifier).loadInitial(term);
    _scrollController.jumpTo(0);
  }

  void _clearSearch() {
    _search.clear();
    ref.read(medicinesListProvider.notifier).loadInitial('');
    _scrollController.jumpTo(0);
  }
}

class _CatalogHeader extends StatefulWidget {
  const _CatalogHeader({
    required this.controller,
    required this.onSearch,
    required this.onClear,
  });

  final TextEditingController controller;
  final VoidCallback onSearch;
  final VoidCallback onClear;

  @override
  State<_CatalogHeader> createState() => _CatalogHeaderState();
}

class _CatalogHeaderState extends State<_CatalogHeader> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.isNotEmpty;
    if (hasText != _hasText) setState(() => _hasText = hasText);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(bottom: BorderSide(color: colors.border)),
      ),
      child: TextField(
        controller: widget.controller,
        maxLength: 200,
        textInputAction: TextInputAction.search,
        onSubmitted: (_) => widget.onSearch(),
        decoration: InputDecoration(
          hintText: 'اسم الدواء، الاسم العلمي أو الشركة',
          prefixIcon: const Icon(Icons.search_rounded),
          counterText: '',
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_hasText)
                IconButton(
                  onPressed: widget.onClear,
                  tooltip: 'مسح',
                  icon: const Icon(Icons.close_rounded),
                ),
              if (_hasText)
                IconButton.filled(
                  onPressed: widget.onSearch,
                  tooltip: 'بحث',
                  style: IconButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: Colors.white,
                  ),
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

class _MedicineCard extends StatelessWidget {
  const _MedicineCard({required this.medicine, required this.onTap});

  final Medicine medicine;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.medication_liquid_rounded,
                  color: colors.primary,
                ),
              ),
              const SizedBox(width: 12),
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
                      const SizedBox(height: 2),
                      Text(
                        medicine.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: colors.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                    if ((medicine.arabicScientificName ??
                            medicine.scientificName)
                        case final name?) ...[
                      const SizedBox(height: 2),
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: colors.textMuted,
                            ),
                      ),
                    ],
                    const SizedBox(height: 7),
                    Wrap(
                      spacing: 6,
                      runSpacing: 5,
                      children: [
                        _Tag(
                          icon: Icons.payments_outlined,
                          text: _currency(medicine.sellingPrice),
                          color: colors.primary,
                        ),
                        if (medicine.dosageForm case final form?)
                          _Tag(
                            icon: Icons.category_outlined,
                            text: form,
                            color: colors.primaryDark,
                          ),
                        if (medicine.requiresPrescription)
                          _Tag(
                            icon: Icons.receipt_long_outlined,
                            text: 'بوصفة طبية',
                            color: colors.warning,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.chevron_left_rounded, color: colors.textMuted),
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
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 3),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}

class _LoadingMoreIndicator extends StatelessWidget {
  const _LoadingMoreIndicator();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Column(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: colors.primary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'جاري تحميل المزيد...',
              style: TextStyle(
                color: colors.textMuted,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyCatalog extends StatelessWidget {
  const _EmptyCatalog({required this.hasSearch});

  final bool hasSearch;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(34),
      children: [
        const SizedBox(height: 90),
        Icon(
          Icons.medication_outlined,
          size: 52,
          color: colors.textMuted,
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
}

String _currency(double value) {
  final digits = value == value.roundToDouble() ? 0 : 2;
  return '${value.toStringAsFixed(digits)} ل.س';
}
