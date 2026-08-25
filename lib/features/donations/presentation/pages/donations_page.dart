import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/demo_flags.dart';
import '../../../../core/widgets/app_reveal.dart';
import '../../../../core/widgets/async_states.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/models/donation_models.dart';
import '../controllers/donations_providers.dart';
import '../widgets/donations_demo.dart';

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
    if (kScreenshotDemo) {
      return const DonationsDemo();
    }
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.donationsTitle),
            Text(
              l10n.donationsSubtitle,
              style: TextStyle(
                color: context.appColors.textMuted,
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
        backgroundColor: context.appColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: Text(
          _tabs.index == 0 ? l10n.donationOfferAction : l10n.assistanceRequestAction,
        ),
      ),
    );
  }
}

class _DonationHero extends StatelessWidget {
  const _DonationHero();
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: context.appColors.primary,
      borderRadius: BorderRadius.circular(25),
    ),
    child: Row(
      children: [
        const _DonationHeroIcon(),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.givingStartsWithStep,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                l10n.donationHeroSubtitle,
                style: const TextStyle(
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
    child: Icon(
      Icons.volunteer_activism_rounded,
      color: context.appColors.secondary,
      size: 27,
    ),
  );
}

class _DonationSegment extends StatelessWidget {
  const _DonationSegment({required this.selected, required this.onSelected});
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    child: Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: context.appColors.surfaceSoft,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          _item(context, 0, Icons.redeem_outlined, l10n.donationOffersTab),
          _item(context, 1, Icons.health_and_safety_outlined, l10n.assistanceRequestsTab),
        ],
      ),
    ),
    );
  }

  Widget _item(BuildContext context, int index, IconData icon, String label) {
    final colors = context.appColors;
    final active = selected == index;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => onSelected(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: active ? colors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: colors.primary.withValues(alpha: .18),
                      blurRadius: 10,
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: active ? Colors.white : colors.primary,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: active ? Colors.white : colors.text,
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
    final l10n = AppLocalizations.of(context);
    final values = <String?, String>{
      null: l10n.statusAll,
      'PendingReview': l10n.donationStatusUnderReview,
      'Approved': l10n.donationStatusApproved,
      'Received': l10n.donationStatusReceived,
      'Rejected': l10n.donationStatusRejected,
    };
    return Column(
      children: [
        _StatusFilter(
          selected: status,
          values: values,
          onChanged: onStatusChanged,
        ),
        Expanded(
          child: state.when(
            loading: () => AppLoadingState(label: l10n.offersLoading),
            error: (error, _) => AppErrorState(
              error: error,
              onRetry: () => ref.invalidate(myDonationOffersProvider(status)),
            ),
            data: (items) => RefreshIndicator(
              onRefresh: () =>
                  ref.refresh(myDonationOffersProvider(status).future),
              child: items.isEmpty
                  ? _EmptyList(
                      icon: Icons.volunteer_activism_outlined,
                      text: l10n.noDonationOffers,
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
    final l10n = AppLocalizations.of(context);
    final values = <String?, String>{
      null: l10n.statusAll,
      'Open': l10n.statusOpen,
      'UnderReview': l10n.donationStatusUnderReview,
      'Fulfilled': l10n.donationStatusFulfilled,
      'Rejected': l10n.donationStatusRejected,
    };
    return Column(
      children: [
        _StatusFilter(
          selected: status,
          values: values,
          onChanged: onStatusChanged,
        ),
        Expanded(
          child: state.when(
            loading: () => AppLoadingState(label: l10n.requestsLoading),
            error: (error, _) => AppErrorState(
              error: error,
              onRetry: () =>
                  ref.invalidate(myAssistanceRequestsProvider(status)),
            ),
            data: (items) => RefreshIndicator(
              onRefresh: () =>
                  ref.refresh(myAssistanceRequestsProvider(status).future),
              child: items.isEmpty
                  ? _EmptyList(
                      icon: Icons.support_agent_rounded,
                      text: l10n.noAssistanceRequests,
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
                backgroundColor: context.appColors.surfaceSoft,
                selectedColor: context.appColors.primary,
                side: BorderSide.none,
                labelStyle: TextStyle(
                  color: selected == entry.key
                      ? Colors.white
                      : context.appColors.text,
                  fontWeight: FontWeight.w800,
                ),
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
    final l10n = AppLocalizations.of(context);
    final status = donationStatus(context.appColors, offer.status, l10n);
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
              '${l10n.packagesCount(offer.packageCount)} · ${offer.targetOrganizationName ?? l10n.targetOrganization}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (offer.campaignTitle != null)
              Text(
                l10n.campaignLabel(offer.campaignTitle!),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            if (offer.reviewNote != null) ...[
              const Divider(height: 22),
              Text(l10n.organizationNoteLabel(offer.reviewNote!)),
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
    final l10n = AppLocalizations.of(context);
    final status = donationStatus(context.appColors, request.status, l10n);
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
              '${l10n.packagesCount(request.requestedPackageCount)} · ${request.targetOrganizationName ?? l10n.targetOrganization}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (request.neededBeforeUtc != null)
              Text(
                l10n.neededBeforeLabel(_date(request.neededBeforeUtc!)),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            if (request.responseNote != null) ...[
              const Divider(height: 22),
              Text(l10n.organizationResponseLabel(request.responseNote!)),
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
      Icon(icon, color: context.appColors.primary),
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
      Icon(icon, color: context.appColors.textMuted, size: 42),
      const SizedBox(height: 12),
      Text(text, textAlign: TextAlign.center),
    ],
  );
}

({String label, Color color}) donationStatus(
  AppColors colors,
  String value,
  AppLocalizations l10n,
) => switch (value.toLowerCase()) {
  'approved' => (label: l10n.donationStatusApproved, color: colors.success),
  'received' || 'fulfilled' => (
    label: value.toLowerCase() == 'received'
        ? l10n.donationStatusReceived
        : l10n.donationStatusFulfilled,
    color: colors.success,
  ),
  'rejected' => (label: l10n.donationStatusRejected, color: colors.danger),
  'cancelled' => (label: l10n.donationStatusCancelled, color: colors.textMuted),
  'underreview' || 'pendingreview' => (
    label: l10n.donationStatusUnderReview,
    color: const Color(0xFFB47618),
  ),
  _ => (label: l10n.donationStatusOpen, color: colors.primary),
};

String _date(DateTime value) => '${value.year}/${value.month}/${value.day}';
