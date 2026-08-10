import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../../core/widgets/app_reveal.dart';
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
            onPressed: () => context.push('/user/nearby-pharmacies'),
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
                  onLocation: () => context.push('/user/nearby-pharmacies'),
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
                onSetLocation: () => context.push('/user/nearby-pharmacies'),
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
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF174B57), Color(0xFF216474)],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: context.appColors.primaryDark.withValues(alpha: 0.17),
            blurRadius: 26,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(17),
            ),
            child: const Icon(
              Icons.manage_search_rounded,
              color: Color(0xFFF5CB72),
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
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(23),
        side: BorderSide(color: context.appColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              maxLength: 200,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => onSearch(),
              decoration: const InputDecoration(
                hintText: 'اسم الدواء أو الاسم العلمي',
                prefixIcon: Icon(Icons.medication_outlined),
                counterText: '',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _RadiusDropdown(
                    value: radius,
                    onChanged: onRadiusChanged,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _SortDropdown(
                    value: sortBy,
                    options: sortOptions,
                    onChanged: onSortChanged,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 13),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: searching ? null : onSearch,
                icon: searching
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.search_rounded),
                label: Text(
                  searching ? 'جاري البحث...' : 'عرض أماكن توفر الدواء',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RadiusDropdown extends StatelessWidget {
  const _RadiusDropdown({required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      initialValue: value,
      decoration: const InputDecoration(
        labelText: 'النطاق',
        prefixIcon: Icon(Icons.radar_rounded),
      ),
      items: const [
        DropdownMenuItem(value: 1000, child: Text('1 كم')),
        DropdownMenuItem(value: 3000, child: Text('3 كم')),
        DropdownMenuItem(value: 5000, child: Text('5 كم')),
        DropdownMenuItem(value: 10000, child: Text('10 كم')),
        DropdownMenuItem(value: 25000, child: Text('25 كم')),
      ],
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}

class _SortDropdown extends StatelessWidget {
  const _SortDropdown({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String value;
  final Map<String, String> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      decoration: const InputDecoration(
        labelText: 'الترتيب',
        prefixIcon: Icon(Icons.tune_rounded),
      ),
      items: options.entries
          .map(
            (entry) =>
                DropdownMenuItem(value: entry.key, child: Text(entry.value)),
          )
          .toList(growable: false),
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}

class _MedicineResultCard extends StatelessWidget {
  const _MedicineResultCard({required this.result});

  final NearbyMedicineResult result;

  @override
  Widget build(BuildContext context) {
    final details = [
      result.scientificName,
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
                        result.medicineName,
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
                      color: const Color(0xFFFFF5DE),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'يتطلب وصفة',
                      style: TextStyle(
                        color: Color(0xFF996619),
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
