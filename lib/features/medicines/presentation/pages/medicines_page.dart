import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_roles.dart';
import '../../../../core/widgets/async_states.dart';
import '../../../../l10n/generated/app_localizations.dart';
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
        title: Text(AppLocalizations.of(context).medicinesCatalogTitle),
        actions: [
          if (isAdmin)
            TextButton.icon(
              onPressed: () => context.push('/medicines/create'),
              icon: const Icon(Icons.add_circle_outline_rounded, size: 20),
              label: Text(AppLocalizations.of(context).addMedicine),
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
                ? AppLoadingState(
                    label: AppLocalizations.of(context).catalogLoading,
                  )
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
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: BoxDecoration(
        color: colors.background,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.medicinesCatalogTitle,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: colors.text,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.catalogSubtitle,
            style: TextStyle(
              fontSize: 14,
              color: colors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.searchLabel,
                style: TextStyle(
                  color: colors.text,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: widget.controller,
                maxLength: 200,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => widget.onSearch(),
                cursorColor: colors.primary,
                cursorWidth: 1.4,
                style: TextStyle(
                  color: colors.text,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: l10n.catalogSearchHint,
                  hintStyle: TextStyle(
                    color: colors.textMuted.withValues(alpha: 0.6),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  filled: true,
                  fillColor: colors.surfaceSoft,
                  prefixIcon: const Padding(
                    padding: EdgeInsetsDirectional.only(
                      start: 14,
                      end: 10,
                    ),
                    child: Icon(
                      Icons.search_rounded,
                      size: 21,
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(minWidth: 46, minHeight: 52),
                  suffixIcon: _hasText
                      ? IconButton(
                          onPressed: widget.onClear,
                          icon: const Icon(Icons.close_rounded),
                        )
                      : null,
                  suffixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 52),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 15,
                  ),
                  counterText: '',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: colors.primary.withValues(alpha: 0.4),
                      width: 1.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
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
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.border),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colors.primary.withValues(alpha: .15),
                      colors.primary.withValues(alpha: .05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  Icons.medication_liquid_rounded,
                  color: colors.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medicine.displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: colors.text,
                      ),
                    ),
                    if (medicine.arabicName != null &&
                        medicine.name.trim().isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        medicine.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: colors.textMuted,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    if ((medicine.arabicScientificName ??
                            medicine.scientificName)
                        case final name?) ...[
                      const SizedBox(height: 4),
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: colors.textMuted,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        _ModernTag(
                          icon: Icons.payments_outlined,
                          text: _currency(l10n, medicine.sellingPrice),
                          color: colors.primary,
                        ),
                        if (medicine.dosageForm case final form?)
                          _ModernTag(
                            icon: Icons.category_outlined,
                            text: form,
                            color: colors.primaryDark,
                          ),
                        if (medicine.requiresPrescription)
                          _ModernTag(
                            icon: Icons.receipt_long_outlined,
                            text: l10n.byPrescriptionTag,
                            color: colors.warning,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                color: colors.textMuted,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModernTag extends StatelessWidget {
  const _ModernTag({
    required this.icon,
    required this.text,
    this.color = const Color(0xFF216474),
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 12,
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
              AppLocalizations.of(context).loadingMore,
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
    final l10n = AppLocalizations.of(context);
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(34),
      children: [
        const SizedBox(height: 120),
        Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: .08),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              hasSearch ? Icons.search_off_rounded : Icons.medication_outlined,
              size: 40,
              color: colors.primary,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          hasSearch ? l10n.noSearchResultsTitle : l10n.emptyCatalogTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: colors.text,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          hasSearch ? l10n.noSearchResultsHint : l10n.emptyCatalogNoSearch,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: colors.textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

String _currency(AppLocalizations l10n, double value) {
  final digits = value == value.roundToDouble() ? 0 : 2;
  return l10n.currencySYP(value.toStringAsFixed(digits));
}
