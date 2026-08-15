import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../../core/widgets/app_reveal.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/async_states.dart';
import '../../data/models/user_discovery_models.dart';
import '../controllers/user_providers.dart';

class MedicineSearchPage extends ConsumerStatefulWidget {
  const MedicineSearchPage({super.key, this.initialQuery});

  final String? initialQuery;

  @override
  ConsumerState<MedicineSearchPage> createState() => _MedicineSearchPageState();
}

class _MedicineSearchPageState extends ConsumerState<MedicineSearchPage> {
  final _queryController = TextEditingController();
  int _radius = 5000;
  String _sortBy = 'BestMatch';
  bool _hasSearched = false;

  static const _sortOptions = {
    'BestMatch': 'الأفضل تطابقًا',
    'Distance': 'الأقرب',
    'OpenNow': 'المفتوحة الآن',
    'Rating': 'الأعلى تقييمًا',
    'PriceLowToHigh': 'السعر الأقل',
  };

  @override
  void initState() {
    super.initState();
    _queryController.text = widget.initialQuery ?? '';
    if (_queryController.text.trim().isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _search();
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('البحث عن دواء'),
        actions: [
          IconButton(
            onPressed: () => context.go('/user/nearby-pharmacies'),
            tooltip: 'الصيدليات القريبة',
            icon: const Icon(Icons.map_outlined),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
            sliver: SliverToBoxAdapter(
              child: AppReveal(
                child: _SearchHero(
                  onLocation: () => context.go('/user/nearby-pharmacies'),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  AppReveal(
                    delay: const Duration(milliseconds: 90),
                    child: _SearchControls(
                      controller: _queryController,
                      radius: _radius,
                      sortBy: _sortBy,
                      sortOptions: _sortOptions,
                      searching: search.isLoading,
                      onRadiusChanged: (value) =>
                          setState(() => _radius = value),
                      onSortChanged: (value) => setState(() => _sortBy = value),
                      onSearch: _search,
                    ),
                  ),
                  const SizedBox(height: 21),
                ],
              ),
            ),
          ),
          _medicineResults(context, search),
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }

  Widget _medicineResults(
    BuildContext context,
    AsyncValue<List<NearbyMedicineResult>> search,
  ) {
    if (!_hasSearched) {
      return const SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        sliver: SliverToBoxAdapter(
          child: _DiscoveryEmpty(
            icon: Icons.medication_liquid_outlined,
            title: 'ابدأ بكتابة اسم الدواء',
            message:
                'ستظهر الصيدليات التي يتوفر لديها الدواء مع السعر والمسافة.',
          ),
        ),
      );
    }
    return search.when(
      loading: () => const SliverFillRemaining(
        hasScrollBody: false,
        child: AppLoadingState(label: 'نبحث في الصيدليات القريبة...'),
      ),
      error: (error, _) => SliverFillRemaining(
        hasScrollBody: false,
        child: _isMissingLocation(error)
            ? _LocationRequiredState(
                onSetLocation: () => context.go('/user/nearby-pharmacies'),
              )
            : AppErrorState(error: error, onRetry: _search),
      ),
      data: (results) {
        if (results.isEmpty) {
          return const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: _DiscoveryEmpty(
                icon: Icons.search_off_rounded,
                title: 'لم نجد نتائج مطابقة',
                message:
                    'جرّب الاسم العلمي أو وسّع نطاق البحث وتحقق من كتابة الاسم.',
              ),
            ),
          );
        }
        final pharmaciesCount = results
            .map((result) => result.pharmacy.pharmacyId)
            .toSet()
            .length;
        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _ResultsTitle(
                title: 'نتائج البحث',
                subtitle:
                    '${results.length} نتيجة لدى $pharmaciesCount صيدليات',
              ),
              const SizedBox(height: 12),
              ...results.map((result) {
                final index = results.indexOf(result);
                return AppReveal(
                  delay: Duration(milliseconds: 60 + (index.clamp(0, 5) * 45)),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _MedicineResultCard(result: result),
                  ),
                );
              }),
            ]),
          ),
        );
      },
    );
  }

  Future<void> _search() async {
    final query = _queryController.text.trim();
    if (query.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('اكتب اسم الدواء للبحث.')));
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _hasSearched = true);
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

class _LocationRequiredState extends StatelessWidget {
  const _LocationRequiredState({required this.onSetLocation});

  final VoidCallback onSetLocation;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: context.appColors.primary.withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(21),
                ),
                child: Icon(
                  Icons.add_location_alt_rounded,
                  color: context.appColors.primary,
                  size: 31,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'حدد موقعك أولًا',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'نستخدم موقعك لعرض الدواء والصيدليات الأقرب إليك.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 22),
              FilledButton.icon(
                onPressed: onSetLocation,
                icon: const Icon(Icons.my_location_rounded),
                label: const Text('تحديد الموقع'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchHero extends StatelessWidget {
  const _SearchHero({required this.onLocation});

  final VoidCallback onLocation;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.appColors.primaryDeep,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: context.appColors.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Icon(
              Icons.manage_search_rounded,
              color: context.appColors.secondary,
              size: 29,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ابحث عن دوائك بسهولة',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 3),
                Text(
                  'قارن التوفر والسعر والمسافة.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
          IconButton.filledTonal(
            onPressed: onLocation,
            tooltip: 'الصيدليات القريبة',
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.12),
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.map_outlined),
          ),
        ],
      ),
    );
  }
}

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
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        children: [
          AppTextField(
            label: 'اسم الدواء',
            hint: 'اسم الدواء أو الاسم العلمي',
            controller: controller,
            icon: Icons.medication_outlined,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => onSearch(),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _CleanDropdown<int>(
                  label: 'النطاق',
                  icon: Icons.radar_rounded,
                  value: radius,
                  items: const [
                    DropdownMenuItem(value: 1000, child: Text('1 كم')),
                    DropdownMenuItem(value: 3000, child: Text('3 كم')),
                    DropdownMenuItem(value: 5000, child: Text('5 كم')),
                    DropdownMenuItem(value: 10000, child: Text('10 كم')),
                    DropdownMenuItem(value: 25000, child: Text('25 كم')),
                  ],
                  onChanged: (v) { if (v != null) onRadiusChanged(v); },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _CleanDropdown<String>(
                  label: 'الترتيب',
                  icon: Icons.tune_rounded,
                  value: sortBy,
                  isExpanded: true,
                  items: sortOptions.entries
                      .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
                      .toList(growable: false),
                  onChanged: (v) { if (v != null) onSortChanged(v); },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton.icon(
              onPressed: searching ? null : onSearch,
              icon: searching
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.search_rounded, size: 22),
              label: Text(
                searching ? 'جاري البحث...' : 'عرض أماكن توفر الدواء',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        Container(
          decoration: BoxDecoration(
            color: colors.surfaceSoft,
            borderRadius: BorderRadius.circular(14),
          ),
          child: DropdownButtonFormField<T>(
            initialValue: value,
            isExpanded: isExpanded,
            icon: Icon(Icons.keyboard_arrow_down_rounded, color: colors.textMuted, size: 22),
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: const EdgeInsetsDirectional.only(start: 14, end: 10),
                child: Icon(icon, size: 21, color: colors.primary),
              ),
              prefixIconConstraints: const BoxConstraints(minWidth: 46, minHeight: 52),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
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
            items: items,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class _MedicineResultCard extends StatelessWidget {
  const _MedicineResultCard({required this.result});

  final NearbyMedicineResult result;

  @override
  Widget build(BuildContext context) {
    final details = [
      if (result.arabicMedicineName != null) result.medicineName,
      result.arabicScientificName ?? result.scientificName,
      result.dosageForm,
      result.capacity,
    ].whereType<String>().where((item) => item.isNotEmpty).join(' · ');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.medicineDisplayName,
                        style: Theme.of(
                          context,
                        ).textTheme.titleLarge?.copyWith(fontSize: 18),
                      ),
                      if (details.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          details,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ],
                  ),
                ),
                if (result.requiresPrescription)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: context.appColors.surfaceWarm,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'يتطلب وصفة',
                      style: TextStyle(
                        color: context.appColors.warning,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: context.appColors.background,
                borderRadius: BorderRadius.circular(17),
              ),
              child: Row(
                children: [
                  _Fact(label: 'السعر', value: _price(result.sellingPrice)),
                  _Fact(label: 'الكمية', value: '${result.quantityAvailable}'),
                  _Fact(
                    label: 'المسافة',
                    value: _distance(result.pharmacy.distanceMeters),
                  ),
                  _Fact(
                    label: 'التقييم',
                    value:
                        '${result.pharmacy.averageRating.toStringAsFixed(1)} ★',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Icon(
                  Icons.local_pharmacy_rounded,
                  color: context.appColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.pharmacy.pharmacyName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(fontSize: 14),
                      ),
                      Text(
                        result.pharmacy.statusText,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Icon(
                  result.pharmacy.isOpenNow
                      ? Icons.check_circle_rounded
                      : Icons.schedule_rounded,
                  color: result.pharmacy.isOpenNow
                      ? context.appColors.success
                      : context.appColors.textMuted,
                ),
              ],
            ),
            const SizedBox(height: 13),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => context.push(
                  '/user/pharmacies/${result.pharmacy.pharmacyId}'
                  '?medicine=${result.medicineId}',
                ),
                icon: const Icon(Icons.inventory_2_outlined),
                label: const Text('عرض الصيدلية وطلب الدواء'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 3),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: context.appColors.text,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultsTitle extends StatelessWidget {
  const _ResultsTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 3),
        Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            Icon(icon, color: context.appColors.textMuted, size: 37),
            const SizedBox(height: 12),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 5),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

bool _isMissingLocation(Object error) =>
    error is ApiException && error.isLocationRequired;

String _distance(double meters) => meters < 1000
    ? '${meters.round()} م'
    : '${(meters / 1000).toStringAsFixed(1)} كم';

String _price(double? value) =>
    value == null ? 'غير معلن' : '${value.toStringAsFixed(0)} ل.س';
