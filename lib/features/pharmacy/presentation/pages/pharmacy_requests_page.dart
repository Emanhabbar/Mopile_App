import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/async_states.dart';
import '../../data/models/pharmacy_models.dart';
import '../controllers/pharmacy_providers.dart';

class PharmacyRequestsPage extends ConsumerStatefulWidget {
  const PharmacyRequestsPage({super.key});

  @override
  ConsumerState<PharmacyRequestsPage> createState() =>
      _PharmacyRequestsPageState();
}

class _PharmacyRequestsPageState extends ConsumerState<PharmacyRequestsPage> {
  final _search = TextEditingController();
  String _query = '';
  String? _status;

  PharmacyRequestFilter get _filter => (search: _query, status: _status);

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pharmacyRequestsProvider(_filter));
    final snapshot = state.valueOrNull ?? const <PharmacyRequest>[];
    return Scaffold(
      appBar: AppBar(
        title: const Text('طلبات الأدوية'),
        actions: [
          IconButton(
            onPressed: () => ref.invalidate(pharmacyRequestsProvider(_filter)),
            tooltip: 'تحديث الطلبات',
            icon: const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
            child: Column(
              children: [
                _RequestsOverview(items: snapshot),
                const SizedBox(height: 13),
                TextField(
                  controller: _search,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) => setState(() => _query = value.trim()),
                  decoration: InputDecoration(
                    hintText: 'ابحث بالدواء أو اسم المستخدم أو الهاتف',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _search.text.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'مسح البحث',
                            onPressed: () {
                              _search.clear();
                              setState(() => _query = '');
                            },
                            icon: const Icon(Icons.close_rounded),
                          ),
                  ),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'All', label: Text('الكل')),
                      ButtonSegment(value: 'Pending', label: Text('بانتظارك')),
                      ButtonSegment(value: 'Available', label: Text('متوفر')),
                      ButtonSegment(
                        value: 'Unavailable',
                        label: Text('غير متوفر'),
                      ),
                    ],
                    selected: {_status ?? 'All'},
                    onSelectionChanged: (values) => setState(
                      () =>
                          _status = values.first == 'All' ? null : values.first,
                    ),
                    showSelectedIcon: false,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: state.when(
              loading: () =>
                  const AppLoadingState(label: 'جاري تحميل الطلبات...'),
              error: (error, _) => AppErrorState(
                error: error,
                onRetry: () =>
                    ref.invalidate(pharmacyRequestsProvider(_filter)),
              ),
              data: (items) => RefreshIndicator(
                onRefresh: () =>
                    ref.refresh(pharmacyRequestsProvider(_filter).future),
                child: items.isEmpty
                    ? const _RequestsEmpty()
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                        itemCount: items.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 11),
                        itemBuilder: (_, index) => _RequestCard(
                          request: items[index],
                          onTap: () => context.push(
                            '/pharmacy/requests/${items[index].requestId}',
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RequestsOverview extends StatelessWidget {
  const _RequestsOverview({required this.items});

  final List<PharmacyRequest> items;

  @override
  Widget build(BuildContext context) {
    final pending = items.where((item) => item.canRespond).length;
    final available = items
        .where((item) => item.status.toLowerCase() == 'available')
        .length;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [context.appColors.primaryDeep, context.appColors.primary],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: context.appColors.primaryDeep.withValues(alpha: .14),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Icon(
              Icons.assignment_turned_in_outlined,
              color: context.appColors.secondary,
              size: 28,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'متابعة الطلبات',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  pending > 0
                      ? '$pending طلب يحتاج إلى ردك الآن'
                      : 'لا توجد طلبات معلّقة ضمن هذه القائمة',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          _OverviewNumber(label: 'متوفر', value: available),
          const SizedBox(width: 8),
          _OverviewNumber(label: 'الطلبات', value: items.length),
        ],
      ),
    );
  }
}

class _OverviewNumber extends StatelessWidget {
  const _OverviewNumber({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        '$value',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 19,
          fontWeight: FontWeight.w900,
        ),
      ),
      Text(label, style: const TextStyle(color: Colors.white60, fontSize: 10)),
    ],
  );
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({required this.request, required this.onTap});

  final PharmacyRequest request;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(context.appColors, request.status);
    final label = request.statusDisplayText.trim().isNotEmpty
        ? request.statusDisplayText
        : _statusLabel(request.status);
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(width: 5, color: color),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 43,
                            height: 43,
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: .09),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(Icons.medication_rounded, color: color),
                          ),
                          const SizedBox(width: 11),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  request.medicineName,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  request.userFullName,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          _StatusBadge(text: label, color: color),
                        ],
                      ),
                      const SizedBox(height: 13),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: context.appColors.surfaceSoft,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            _RequestFact(
                              icon: Icons.numbers_rounded,
                              text: 'الكمية ${request.requestedQuantity}',
                            ),
                            const _FactDivider(),
                            _RequestFact(
                              icon: Icons.tag_rounded,
                              text: request.requestCode,
                            ),
                            const Spacer(),
                            if (request.canRespond)
                              Row(
                                children: [
                                  Text(
                                    'الرد الآن',
                                    style: TextStyle(
                                      color: context.appColors.primary,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  SizedBox(width: 3),
                                  Icon(
                                    Icons.arrow_back_rounded,
                                    size: 16,
                                    color: context.appColors.primary,
                                  ),
                                ],
                              )
                            else
                              Icon(
                                Icons.chevron_left_rounded,
                                color: context.appColors.textMuted,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(maxWidth: 88),
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
    decoration: BoxDecoration(
      color: color.withValues(alpha: .09),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w800),
    ),
  );
}

class _RequestFact extends StatelessWidget {
  const _RequestFact({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 15, color: context.appColors.textMuted),
      const SizedBox(width: 4),
      Text(
        text,
        style: TextStyle(fontSize: 11, color: context.appColors.textMuted),
      ),
    ],
  );
}

class _FactDivider extends StatelessWidget {
  const _FactDivider();

  @override
  Widget build(BuildContext context) => Container(
    width: 1,
    height: 15,
    margin: const EdgeInsets.symmetric(horizontal: 9),
    color: context.appColors.border,
  );
}

class _RequestsEmpty extends StatelessWidget {
  const _RequestsEmpty();

  @override
  Widget build(BuildContext context) => ListView(
    physics: const AlwaysScrollableScrollPhysics(),
    padding: const EdgeInsets.symmetric(horizontal: 30),
    children: [
      const SizedBox(height: 80),
      Container(
        width: 72,
        height: 72,
        margin: const EdgeInsets.symmetric(horizontal: 100),
        decoration: BoxDecoration(
          color: context.appColors.surfaceSoft,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.assignment_turned_in_outlined,
          color: context.appColors.primary,
          size: 34,
        ),
      ),
      const SizedBox(height: 16),
      Text(
        'لا توجد طلبات مطابقة',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      const SizedBox(height: 5),
      Text(
        'ستظهر هنا طلبات الأدوية الجديدة الواردة من المستخدمين.',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    ],
  );
}

String _statusLabel(String value) => switch (value.toLowerCase()) {
  'available' => 'متوفر',
  'unavailable' => 'غير متوفر',
  'cancelled' => 'ملغى',
  _ => 'بانتظار الرد',
};

Color _statusColor(AppColors colors, String value) => switch (value
    .toLowerCase()) {
  'available' => colors.success,
  'unavailable' => colors.danger,
  'cancelled' => colors.textMuted,
  _ => colors.warning,
};
