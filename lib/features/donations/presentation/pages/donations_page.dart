import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/app_reveal.dart';
import '../../../../core/widgets/async_states.dart';
import '../../data/models/donation_models.dart';
import '../controllers/donations_providers.dart';

class DonationsPage extends ConsumerStatefulWidget {
  const DonationsPage({super.key});

  @override
  ConsumerState<DonationsPage> createState() => _DonationsPageState();
}

class _DonationsPageState extends ConsumerState<DonationsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  String? _offerStatus;
  String? _requestStatus;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this)..addListener(_tabChanged);
  }

  @override
  void dispose() {
    _tabs
      ..removeListener(_tabChanged)
      ..dispose();
    super.dispose();
  }

  void _tabChanged() {
    if (!_tabs.indexIsChanging) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('التبرعات والمساعدة'),
            Text(
              'دواء يصل إلى من يحتاجه',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 8, 20, 6),
            child: AppReveal(child: _DonationHero()),
          ),
          _DonationSegment(selected: _tabs.index, onSelected: _tabs.animateTo),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                _OffersTab(
                  status: _offerStatus,
                  onStatusChanged: (value) =>
                      setState(() => _offerStatus = value),
                ),
                _RequestsTab(
                  status: _requestStatus,
                  onStatusChanged: (value) =>
                      setState(() => _requestStatus = value),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(
          _tabs.index == 0
              ? '/user/donations/create-offer'
              : '/user/donations/create-request',
        ),
        icon: const Icon(Icons.add_rounded),
        label: Text(_tabs.index == 0 ? 'عرض تبرع' : 'طلب مساعدة'),
      ),
    );
  }
}

class _DonationHero extends StatelessWidget {
  const _DonationHero();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [AppColors.primaryDeep, AppColors.primary],
      ),
      borderRadius: BorderRadius.circular(25),
    ),
    child: const Row(
      children: [
        _DonationHeroIcon(),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'العطاء يبدأ بخطوة',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                'قدّم دواءً صالحًا أو اطلب المساعدة عبر الجهات المشاركة.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 10.5,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _DonationHeroIcon extends StatelessWidget {
  const _DonationHeroIcon();
  @override
  Widget build(BuildContext context) => Container(
    width: 52,
    height: 52,
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: .12),
      borderRadius: BorderRadius.circular(17),
    ),
    child: const Icon(
      Icons.volunteer_activism_rounded,
      color: AppColors.secondary,
      size: 27,
    ),
  );
}

class _DonationSegment extends StatelessWidget {
  const _DonationSegment({required this.selected, required this.onSelected});
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    child: Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          _item(0, Icons.redeem_outlined, 'عروض التبرع'),
          _item(1, Icons.health_and_safety_outlined, 'طلبات المساعدة'),
        ],
      ),
    ),
  );

  Widget _item(int index, IconData icon, String label) {
    final active = selected == index;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => onSelected(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: AppColors.shadow.withValues(alpha: .08),
                      blurRadius: 10,
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.primary, size: 18),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: active ? FontWeight.w900 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OffersTab extends ConsumerWidget {
  const _OffersTab({required this.status, required this.onStatusChanged});

  final String? status;
  final ValueChanged<String?> onStatusChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myDonationOffersProvider(status));
    return Column(
      children: [
        _StatusFilter(
          selected: status,
          values: const {
            null: 'الكل',
            'PendingReview': 'قيد المراجعة',
            'Approved': 'مقبول',
            'Received': 'تم الاستلام',
            'Rejected': 'مرفوض',
          },
          onChanged: onStatusChanged,
        ),
        Expanded(
          child: state.when(
            loading: () => const AppLoadingState(label: 'جاري تحميل عروضك...'),
            error: (error, _) => AppErrorState(
              error: error,
              onRetry: () => ref.invalidate(myDonationOffersProvider(status)),
            ),
            data: (items) => RefreshIndicator(
              onRefresh: () =>
                  ref.refresh(myDonationOffersProvider(status).future),
              child: items.isEmpty
                  ? const _EmptyList(
                      icon: Icons.volunteer_activism_outlined,
                      text: 'لا توجد عروض تبرع ضمن هذا التصنيف.',
                    )
                  : ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 90),
                      itemCount: items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) => AppReveal(
                        delay: Duration(milliseconds: index.clamp(0, 5) * 45),
                        child: _OfferCard(offer: items[index]),
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RequestsTab extends ConsumerWidget {
  const _RequestsTab({required this.status, required this.onStatusChanged});

  final String? status;
  final ValueChanged<String?> onStatusChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myAssistanceRequestsProvider(status));
    return Column(
      children: [
        _StatusFilter(
          selected: status,
          values: const {
            null: 'الكل',
            'Open': 'مفتوح',
            'UnderReview': 'قيد المراجعة',
            'Fulfilled': 'تمت المساعدة',
            'Rejected': 'مرفوض',
          },
          onChanged: onStatusChanged,
        ),
        Expanded(
          child: state.when(
            loading: () => const AppLoadingState(label: 'جاري تحميل طلباتك...'),
            error: (error, _) => AppErrorState(
              error: error,
              onRetry: () =>
                  ref.invalidate(myAssistanceRequestsProvider(status)),
            ),
            data: (items) => RefreshIndicator(
              onRefresh: () =>
                  ref.refresh(myAssistanceRequestsProvider(status).future),
              child: items.isEmpty
                  ? const _EmptyList(
                      icon: Icons.support_agent_rounded,
                      text: 'لا توجد طلبات مساعدة ضمن هذا التصنيف.',
                    )
                  : ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 90),
                      itemCount: items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) => AppReveal(
                        delay: Duration(milliseconds: index.clamp(0, 5) * 45),
                        child: _RequestCard(request: items[index]),
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusFilter extends StatelessWidget {
  const _StatusFilter({
    required this.selected,
    required this.values,
    required this.onChanged,
  });

  final String? selected;
  final Map<String?, String> values;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 60,
    child: ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
      scrollDirection: Axis.horizontal,
      children: values.entries
          .map(
            (entry) => Padding(
              padding: const EdgeInsetsDirectional.only(end: 7),
              child: ChoiceChip(
                label: Text(entry.value),
                selected: selected == entry.key,
                onSelected: (_) => onChanged(entry.key),
                showCheckmark: false,
              ),
            ),
          )
          .toList(growable: false),
    ),
  );
}

class _OfferCard extends StatelessWidget {
  const _OfferCard({required this.offer});

  final DonationOffer offer;

  @override
  Widget build(BuildContext context) {
    final status = donationStatus(offer.status);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CardHeader(
              icon: Icons.medication_rounded,
              title: offer.medicineName,
              status: status,
            ),
            const SizedBox(height: 9),
            Text(
              '${offer.packageCount} عبوات · ${offer.targetOrganizationName ?? 'منظمة'}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (offer.campaignTitle != null)
              Text(
                'الحملة: ${offer.campaignTitle}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            if (offer.reviewNote != null) ...[
              const Divider(height: 22),
              Text('ملاحظة المنظمة: ${offer.reviewNote}'),
            ],
          ],
        ),
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({required this.request});

  final AssistanceRequest request;

  @override
  Widget build(BuildContext context) {
    final status = donationStatus(request.status);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CardHeader(
              icon: Icons.health_and_safety_outlined,
              title: request.medicineName,
              status: status,
            ),
            const SizedBox(height: 9),
            Text(
              '${request.requestedPackageCount} عبوات · ${request.targetOrganizationName ?? 'منظمة'}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (request.neededBeforeUtc != null)
              Text(
                'مطلوب قبل ${_date(request.neededBeforeUtc!)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            if (request.responseNote != null) ...[
              const Divider(height: 22),
              Text('رد المنظمة: ${request.responseNote}'),
            ],
          ],
        ),
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  const _CardHeader({
    required this.icon,
    required this.title,
    required this.status,
  });

  final IconData icon;
  final String title;
  final ({String label, Color color}) status;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, color: AppColors.primary),
      const SizedBox(width: 9),
      Expanded(
        child: Text(title, style: Theme.of(context).textTheme.titleMedium),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
          color: status.color.withValues(alpha: 0.09),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          status.label,
          style: TextStyle(
            color: status.color,
            fontWeight: FontWeight.w800,
            fontSize: 10.5,
          ),
        ),
      ),
    ],
  );
}

class _EmptyList extends StatelessWidget {
  const _EmptyList({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => ListView(
    physics: const AlwaysScrollableScrollPhysics(),
    padding: const EdgeInsets.all(32),
    children: [
      const SizedBox(height: 70),
      Icon(icon, color: AppColors.textMuted, size: 42),
      const SizedBox(height: 12),
      Text(text, textAlign: TextAlign.center),
    ],
  );
}

({String label, Color color}) donationStatus(String value) => switch (value
    .toLowerCase()) {
  'approved' => (label: 'مقبول', color: AppColors.success),
  'received' || 'fulfilled' => (
    label: value.toLowerCase() == 'received' ? 'تم الاستلام' : 'تمت المساعدة',
    color: AppColors.success,
  ),
  'rejected' => (label: 'مرفوض', color: AppColors.danger),
  'cancelled' => (label: 'ملغى', color: AppColors.textMuted),
  'underreview' ||
  'pendingreview' => (label: 'قيد المراجعة', color: const Color(0xFFB47618)),
  _ => (label: 'مفتوح', color: AppColors.primary),
};

String _date(DateTime value) => '${value.year}/${value.month}/${value.day}';
