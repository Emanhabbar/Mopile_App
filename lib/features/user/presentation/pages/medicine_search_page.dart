import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../../core/widgets/app_reveal.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/async_states.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/models/user_discovery_models.dart';
import '../controllers/user_providers.dart';

class MedicineSearchPage extends ConsumerStatefulWidget {
  const MedicineSearchPage({
    super.key,
    this.initialQuery,
  });

  final String? initialQuery;

  @override
  ConsumerState<MedicineSearchPage> createState() =>
      _MedicineSearchPageState();
}

class _MedicineSearchPageState
    extends ConsumerState<MedicineSearchPage> {
  final _queryController = TextEditingController();

  int _radius = 5000;
  String _sortBy = 'BestMatch';
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();

    _queryController.text = widget.initialQuery ?? '';

    if (_queryController.text.trim().isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _search();
        }
      });
    }
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final search = ref.watch(userMedicineSearchProvider);
    final l10n = AppLocalizations.of(context);

    final sortOptions = <String, String>{
      'BestMatch': l10n.sortBestMatch,
      'Distance': l10n.sortDistance,
      'OpenNow': l10n.sortOpenNow,
      'Rating': l10n.sortRating,
      'PriceLowToHigh': l10n.sortPriceLowToHigh,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.medicineSearchTitle),
        actions: [
          IconButton(
            onPressed: () =>
                context.go('/user/nearby-pharmacies'),
            tooltip: l10n.nearbyPharmacies,
            icon: const Icon(Icons.map_outlined),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // ==========================================================
          // HERO
          // ==========================================================

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              20,
              16,
              20,
              0,
            ),
            sliver: SliverToBoxAdapter(
              child: AppReveal(
                child: _SearchHero(),
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 18),
          ),

          // ==========================================================
          // SEARCH CONTROLS
          // ==========================================================

          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            sliver: SliverToBoxAdapter(
              child: AppReveal(
                delay: const Duration(
                  milliseconds: 90,
                ),
                child: _SearchControls(
                  controller: _queryController,
                  radius: _radius,
                  sortBy: _sortBy,
                  sortOptions: sortOptions,
                  searching: search.isLoading,
                  onRadiusChanged: (value) {
                    setState(() {
                      _radius = value;
                    });
                  },
                  onSortChanged: (value) {
                    setState(() {
                      _sortBy = value;
                    });
                  },
                  onSearch: _search,
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),

          // ==========================================================
          // RESULTS
          // ==========================================================

          _medicineResults(
            context,
            search,
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 36),
          ),
        ],
      ),
    );
  }

  // ==================================================================
  // MEDICINE RESULTS
  // ==================================================================

  Widget _medicineResults(
    BuildContext context,
    AsyncValue<List<NearbyMedicineResult>> search,
  ) {
    final l10n = AppLocalizations.of(context);

    if (!_hasSearched) {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        sliver: SliverToBoxAdapter(
          child: _DiscoveryEmpty(
            icon: Icons.medication_liquid_outlined,
            title: l10n.searchStartTitle,
            message: l10n.searchStartMessage,
          ),
        ),
      );
    }

    return search.when(
      // --------------------------------------------------------------
      // LOADING
      // --------------------------------------------------------------

      loading: () => SliverFillRemaining(
        hasScrollBody: false,
        child: AppLoadingState(
          label: l10n.searchLoadingNearby,
        ),
      ),

      // --------------------------------------------------------------
      // ERROR
      // --------------------------------------------------------------

      error: (error, _) => SliverFillRemaining(
        hasScrollBody: false,
        child: _isMissingLocation(error)
            ? _LocationRequiredState(
                onSetLocation: () => context.go(
                  '/user/nearby-pharmacies',
                ),
              )
            : AppErrorState(
                error: error,
                onRetry: _search,
              ),
      ),

      // --------------------------------------------------------------
      // DATA
      // --------------------------------------------------------------

      data: (results) {
        if (results.isEmpty) {
          return SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            sliver: SliverToBoxAdapter(
              child: _DiscoveryEmpty(
                icon: Icons.search_off_rounded,
                title: l10n.searchNoResultsTitle,
                message: l10n.searchNoResultsMessage,
              ),
            ),
          );
        }

        final pharmaciesCount = results
            .map(
              (result) => result.pharmacy.pharmacyId,
            )
            .toSet()
            .length;

        return SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                _ResultsTitle(
                  title: l10n.searchResultsTitle,
                  subtitle: l10n.searchResultsSubtitle(
                    results.length,
                    pharmaciesCount,
                  ),
                ),

                const SizedBox(height: 16),

                ...results.asMap().entries.map(
                  (entry) {
                    final index = entry.key;
                    final result = entry.value;

                    return AppReveal(
                      delay: Duration(
                        milliseconds:
                            60 +
                            (index.clamp(0, 5) * 45),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 14,
                        ),
                        child: _MedicineResultCard(
                          result: result,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==================================================================
  // SEARCH
  // ==================================================================

  Future<void> _search() async {
    final query = _queryController.text.trim();

    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)
                .searchEmptyQuery,
          ),
        ),
      );
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    setState(() {
      _hasSearched = true;
    });

    await ref
        .read(userMedicineSearchProvider.notifier)
        .search(
          UserMedicineSearch(
            query: query,
            radiusInMeters: _radius,
            sortBy: _sortBy,
          ),
        );
  }
}

// ======================================================================
// LOCATION REQUIRED
// ======================================================================

class _LocationRequiredState extends StatelessWidget {
  const _LocationRequiredState({
    required this.onSetLocation,
  });

  final VoidCallback onSetLocation;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 380,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(
                    alpha: 0.09,
                  ),
                  borderRadius:
                      BorderRadius.circular(21),
                ),
                child: Icon(
                  Icons.add_location_alt_rounded,
                  color: colors.primary,
                  size: 31,
                ),
              ),

              const SizedBox(height: 18),

              Text(
                l10n.setLocationFirst,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                l10n.setLocationDesc,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 22),

              FilledButton.icon(
                onPressed: onSetLocation,
                icon: const Icon(
                  Icons.my_location_rounded,
                ),
                label: Text(
                  l10n.setLocationAction,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ======================================================================
// SEARCH HERO
// ======================================================================

class _SearchHero extends StatelessWidget {
  const _SearchHero();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: colors.primaryDark.withValues(
            alpha: 0.35,
          ),
        ),
      ),
      child: Row(
        children: [
          // ============================================================
          // HERO ICON
          // ============================================================

          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: Colors.white.withValues(
                alpha: 0.10,
              ),
              borderRadius:
                  BorderRadius.circular(17),
            ),
            child: Icon(
              Icons.manage_search_rounded,
              color: colors.secondary,
              size: 29,
            ),
          ),

          const SizedBox(width: 13),

          // ============================================================
          // HERO TEXT
          // ============================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.searchHeroTitle,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),

                const SizedBox(height: 3),

                Text(
                  l10n.searchHeroSubtitle,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                        color: Colors.white70,
                        height: 1.4,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================================
// SEARCH CONTROLS
// ======================================================================

class _SearchControls extends StatelessWidget {
  const _SearchControls({
    required this.controller,
    required this.radius,
    required this.sortBy,
    required this.sortOptions,
    required this.searching,
    required this.onRadiusChanged,
    required this.onSortChanged,
    required this.onSearch,
  });

  final TextEditingController controller;
  final int radius;
  final String sortBy;
  final Map<String, String> sortOptions;
  final bool searching;

  final ValueChanged<int> onRadiusChanged;
  final ValueChanged<String> onSortChanged;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.border,
        ),
      ),
      child: Column(
        children: [
          // ------------------------------------------------------------
          // MEDICINE NAME
          // ------------------------------------------------------------

          AppTextField(
            label: l10n.medicineNameLabel,
            hint: l10n.medicineNameHint,
            controller: controller,
            icon: Icons.medication_outlined,
            textInputAction:
                TextInputAction.search,
            onSubmitted: (_) => onSearch(),
          ),

          const SizedBox(height: 16),

          // ------------------------------------------------------------
          // FILTERS
          // ------------------------------------------------------------

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _CleanDropdown<int>(
                  label: l10n.radiusLabel,
                  icon: Icons.radar_rounded,
                  value: radius,
                  items: [
                    DropdownMenuItem(
                      value: 1000,
                      child: Text(
                        l10n.distanceKm('1'),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 3000,
                      child: Text(
                        l10n.distanceKm('3'),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 5000,
                      child: Text(
                        l10n.distanceKm('5'),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 10000,
                      child: Text(
                        l10n.distanceKm('10'),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 25000,
                      child: Text(
                        l10n.distanceKm('25'),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      onRadiusChanged(value);
                    }
                  },
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _CleanDropdown<String>(
                  label: l10n.sortLabel,
                  icon: Icons.tune_rounded,
                  value: sortBy,
                  isExpanded: true,
                  items: sortOptions.entries
                      .map(
                        (entry) =>
                            DropdownMenuItem<String>(
                          value: entry.key,
                          child: Text(
                            entry.value,
                            overflow:
                                TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(
                        growable: false,
                      ),
                  onChanged: (value) {
                    if (value != null) {
                      onSortChanged(value);
                    }
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // ------------------------------------------------------------
          // SEARCH BUTTON
          // ------------------------------------------------------------

          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton.icon(
              onPressed:
                  searching ? null : onSearch,
              icon: searching
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child:
                          CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(
                      Icons.search_rounded,
                      size: 22,
                    ),
              label: Text(
                searching
                    ? l10n.searchingProgress
                    : l10n.searchAction,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================================
// CLEAN DROPDOWN
// ======================================================================

class _CleanDropdown<T> extends StatelessWidget {
  const _CleanDropdown({
    required this.label,
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
    this.isExpanded = false,
  });

  final String label;
  final IconData icon;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    // ================================================================
    // DROPDOWN COLORS
    // ================================================================

    // Dark Mode:
    // No white background.
    // Transparent background with a very thin silver border.

    final dropdownSurface = isDark
        ? Colors.transparent
        : colors.surfaceSoft;

    final dropdownMenuSurface = isDark
        ? colors.surface
        : colors.surface;

    final dropdownText = isDark
        ? Colors.white
        : colors.text;

    final dropdownIcon = isDark
        ? const Color(0xFFD1D5DB)
        : colors.textMuted;

    // Very light silver border.
    final dropdownBorder = isDark
        ? const Color(0xFFD1D5DB).withValues(
            alpha: 0.32,
          )
        : Colors.transparent;

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        // --------------------------------------------------------------
        // LABEL
        // --------------------------------------------------------------

        Text(
          label,
          style: TextStyle(
            color: colors.text,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 1.3,
          ),
        ),

        const SizedBox(height: 8),

        // --------------------------------------------------------------
        // DROPDOWN
        // --------------------------------------------------------------

        Container(
          decoration: BoxDecoration(
            color: dropdownSurface,
            borderRadius:
                BorderRadius.circular(14),

            // Very thin silver border.
            border: Border.all(
              color: dropdownBorder,
              width: isDark ? 0.7 : 0,
            ),
          ),
          child: DropdownButtonFormField<T>(
            initialValue: value,
            isExpanded: isExpanded,

            // Selected value text
            style: TextStyle(
              color: dropdownText,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),

            // Arrow
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: dropdownIcon,
              size: 22,
            ),

            // Opened menu
            dropdownColor: dropdownMenuSurface,

            decoration: InputDecoration(
              prefixIcon: Padding(
                padding:
                    const EdgeInsetsDirectional.only(
                  start: 14,
                  end: 10,
                ),
                child: Icon(
                  icon,
                  size: 21,
                  color: colors.primary,
                ),
              ),

              prefixIconConstraints:
                  const BoxConstraints(
                minWidth: 46,
                minHeight: 52,
              ),

              contentPadding:
                  const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 15,
              ),

              filled: true,

              fillColor: dropdownSurface,

              // Normal border
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: dropdownBorder,
                  width: isDark ? 0.7 : 0,
                ),
              ),

              // Enabled border
              enabledBorder:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: dropdownBorder,
                  width: isDark ? 0.7 : 0,
                ),
              ),

              // Focused border
              focusedBorder:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: isDark
                      ? const Color(0xFFD1D5DB)
                          .withValues(alpha: 0.45)
                      : colors.primary.withValues(
                          alpha: 0.40,
                        ),
                  width: isDark ? 0.8 : 1.2,
                ),
              ),
            ),

            // ----------------------------------------------------------
            // OPTIONS
            // ----------------------------------------------------------

            items: items.map(
              (item) {
                return DropdownMenuItem<T>(
                  value: item.value,
                  child: DefaultTextStyle(
                    style: TextStyle(
                      color: dropdownText,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    child: item.child,
                  ),
                );
              },
            ).toList(growable: false),

            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

// ======================================================================
// MEDICINE RESULT CARD
// ======================================================================

class _MedicineResultCard extends StatelessWidget {
  const _MedicineResultCard({
    required this.result,
  });

  final NearbyMedicineResult result;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;

    final details = [
      if (result.arabicMedicineName != null)
        result.medicineName,
      result.arabicScientificName ??
          result.scientificName,
      result.dosageForm,
      result.capacity,
    ]
        .whereType<String>()
        .where(
          (item) => item.isNotEmpty,
        )
        .join(' · ');

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // ==========================================================
            // MEDICINE HEADER
            // ==========================================================

            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.medicineDisplayName,
                        maxLines: 2,
                        overflow:
                            TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.w700,
                            ),
                      ),

                      if (details.isNotEmpty) ...[
                        const SizedBox(height: 5),

                        Text(
                          details,
                          maxLines: 2,
                          overflow:
                              TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium,
                        ),
                      ],
                    ],
                  ),
                ),

                if (result.requiresPrescription) ...[
                  const SizedBox(width: 10),

                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: colors.surfaceWarm,
                      borderRadius:
                          BorderRadius.circular(20),
                    ),
                    child: Text(
                      l10n.requiresPrescription,
                      style: TextStyle(
                        color: colors.warning,
                        fontSize: 11,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 16),

            // ==========================================================
            // FACTS
            // ==========================================================

            Container(
              padding:
                  const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: colors.background,
                borderRadius:
                    BorderRadius.circular(17),
              ),
              child: Row(
                children: [
                  _Fact(
                    label: l10n.priceLabel,
                    value: _price(
                      l10n,
                      result.sellingPrice,
                    ),
                  ),

                  _Fact(
                    label: l10n.requestQuantity,
                    value:
                        '${result.quantityAvailable}',
                  ),

                  _Fact(
                    label: l10n.distanceLabel,
                    value: _distance(
                      l10n,
                      result.pharmacy
                          .distanceMeters,
                    ),
                  ),

                  _Fact(
                    label: l10n.ratingLabel,
                    value:
                        '${result.pharmacy.averageRating.toStringAsFixed(1)} ★',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // ==========================================================
            // PHARMACY
            // ==========================================================

            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: colors.primary
                        .withValues(alpha: 0.08),
                    borderRadius:
                        BorderRadius.circular(11),
                  ),
                  child: Icon(
                    Icons.local_pharmacy_rounded,
                    color: colors.primary,
                    size: 20,
                  ),
                ),

                const SizedBox(width: 9),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.pharmacy.pharmacyName,
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              fontSize: 14,
                              fontWeight:
                                  FontWeight.w700,
                            ),
                      ),

                      const SizedBox(height: 2),

                      Text(
                        result.pharmacy.statusText,
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                Icon(
                  result.pharmacy.isOpenNow
                      ? Icons.check_circle_rounded
                      : Icons.schedule_rounded,
                  color: result.pharmacy.isOpenNow
                      ? colors.success
                      : colors.textMuted,
                ),
              ],
            ),

            const SizedBox(height: 14),

            // ==========================================================
            // ACTION
            // ==========================================================

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => context.push(
                  '/user/pharmacies/'
                  '${result.pharmacy.pharmacyId}'
                  '?medicine=${result.medicineId}',
                ),
                icon: const Icon(
                  Icons.inventory_2_outlined,
                ),
                label: Text(
                  l10n.viewPharmacyAndRequest,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================================
// FACT
// ======================================================================

class _Fact extends StatelessWidget {
  const _Fact({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Expanded(
      child: Padding(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 3,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              label,
              maxLines: 1,
              overflow:
                  TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall,
            ),

            const SizedBox(height: 4),

            Text(
              value,
              maxLines: 1,
              overflow:
                  TextOverflow.ellipsis,
              style: TextStyle(
                color: colors.text,
                fontWeight:
                    FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================================
// RESULTS TITLE
// ======================================================================

class _ResultsTitle extends StatelessWidget {
  const _ResultsTitle({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),

        const SizedBox(height: 4),

        Text(
          subtitle,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(
                color: colors.textMuted,
              ),
        ),
      ],
    );
  }
}

// ======================================================================
// EMPTY / DISCOVERY
// ======================================================================

class _DiscoveryEmpty extends StatelessWidget {
  const _DiscoveryEmpty({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 32,
        ),
        child: Column(
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: colors.surfaceSoft,
                borderRadius:
                    BorderRadius.circular(20),
              ),
              child: Icon(
                icon,
                color: colors.textMuted,
                size: 30,
              ),
            ),

            const SizedBox(height: 14),

            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                    fontWeight:
                        FontWeight.w700,
                  ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 6),

            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                    height: 1.5,
                    color: colors.textMuted,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================================
// HELPERS
// ======================================================================

bool _isMissingLocation(Object error) =>
    error is ApiException &&
    error.isLocationRequired;

String _distance(
  AppLocalizations l10n,
  double meters,
) {
  if (meters < 1000) {
    return l10n.distanceMeters(
      '${meters.round()}',
    );
  }

  return l10n.distanceKm(
    (meters / 1000).toStringAsFixed(1),
  );
}

String _price(
  AppLocalizations l10n,
  double? value,
) {
  return value == null
      ? l10n.priceUnannounced
      : l10n.currencySYP(
          value.toStringAsFixed(0),
        );
}