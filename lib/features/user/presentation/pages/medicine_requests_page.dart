import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/app_reveal.dart';
import '../../../../core/widgets/async_states.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/models/user_request_models.dart';
import '../controllers/user_providers.dart';

class MedicineRequestsPage extends ConsumerStatefulWidget {
  const MedicineRequestsPage({super.key});

  @override
  ConsumerState<MedicineRequestsPage> createState() =>
      _MedicineRequestsPageState();
}

class _MedicineRequestsPageState extends ConsumerState<MedicineRequestsPage> {
  String? _status;

  @override
  Widget build(BuildContext context) {
    final requests = ref.watch(userMedicineRequestsProvider(_status));
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.requestsTitle),
        actions: [
          IconButton(
            onPressed: () => context.push('/user/search-history'),
            tooltip: l10n.searchHistoryTitle,
            icon: const Icon(Icons.history_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 2),
            child: AppReveal(
              child: _RequestsIntro(
                onNewRequest: () => context.go('/user/search'),
              ),
            ),
          ),
          AppReveal(
            delay: const Duration(milliseconds: 70),
            child: _StatusFilters(
              value: _status,
              onChanged: (value) => setState(() => _status = value),
            ),
          ),
          Expanded(
            child: requests.when(
              loading: () => AppLoadingState(label: l10n.requestsLoading),
              error: (error, _) => AppErrorState(
                error: error,
                onRetry: () =>
                    ref.invalidate(userMedicineRequestsProvider(_status)),
              ),
              data: (items) => RefreshIndicator(
                onRefresh: () =>
                    ref.refresh(userMedicineRequestsProvider(_status).future),
                child: items.isEmpty
                    ? const _EmptyRequests()
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
                        itemCount: items.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 11),
                        itemBuilder: (context, index) => AppReveal(
                          delay: Duration(
                            milliseconds: (index.clamp(0, 5) * 45),
                          ),
                          child: _RequestCard(
                            request: items[index],
                            onTap: () => context.push(
                              '/user/requests/${items[index].requestId}',
                            ),
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

class _RequestsIntro extends StatelessWidget {
  const _RequestsIntro({required this.onNewRequest});

  final VoidCallback onNewRequest;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.appColors.primary,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: context.appColors.primaryDark.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              color: context.appColors.secondary,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.requestsIntroTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 3),
                Text(
                  l10n.requestsIntroSubtitle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onNewRequest,
            tooltip: l10n.newRequest,
            style: IconButton.styleFrom(
              backgroundColor: context.appColors.secondary,
              foregroundColor: context.appColors.primaryDark,
            ),
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
    );
  }
}

class _StatusFilters extends StatelessWidget {
  const _StatusFilters({required this.value, required this.onChanged});

  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final filters = <String?, String>{
      null: l10n.statusAll,
      'Pending': l10n.statusPending,
      'Available': l10n.statusAvailable,
      'Unavailable': l10n.statusUnavailable,
      'Cancelled': l10n.statusCancelled,
    };
    return SizedBox(
      height: 65,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        scrollDirection: Axis.horizontal,
        children: filters.entries
            .map(
              (entry) => Padding(
                padding: const EdgeInsetsDirectional.only(end: 8),
                child: ChoiceChip(
                  label: Text(entry.value),
                  selected: value == entry.key,
                  onSelected: (_) => onChanged(entry.key),
                  showCheckmark: false,
                  avatar: Icon(
                    _filterIcon(entry.key),
                    size: 16,
                    color: value == entry.key
                        ? context.appColors.primary
                        : context.appColors.textMuted,
                  ),
                ),
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}

IconData _filterIcon(String? status) => switch (status) {
  'Pending' => Icons.schedule_rounded,
  'Available' => Icons.check_circle_outline_rounded,
  'Unavailable' => Icons.cancel_outlined,
  'Cancelled' => Icons.block_rounded,
  _ => Icons.grid_view_rounded,
};

class _RequestCard extends StatelessWidget {
  const _RequestCard({required this.request, required this.onTap});

  final UserMedicineRequest request;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final status = _statusStyle(request.status);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: status.color.withValues(alpha: 0.09),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(status.icon, color: status.color),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.medicineDisplayName,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          request.pharmacyName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  _StatusBadge(text: _statusText(l10n, request), color: status.color),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.appColors.background,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    _Fact(label: l10n.requestNumber, value: request.requestCode),
                    _Fact(
                      label: l10n.requestQuantity,
                      value: '${request.requestedQuantity}',
                    ),
                    _Fact(label: l10n.requestDate, value: _date(request.createdAtUtc)),
                  ],
                ),
              ),
              if (request.hasPharmacyResponse &&
                  request.pharmacyResponseNote != null) ...[
                const SizedBox(height: 11),
                Text(
                  request.pharmacyResponseNote!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyRequests extends StatelessWidget {
  const _EmptyRequests();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(32),
      children: [
        const SizedBox(height: 80),
        Icon(
          Icons.inventory_2_outlined,
          color: context.appColors.textMuted,
          size: 48,
        ),
        const SizedBox(height: 14),
        Text(
          l10n.requestsEmptyTitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 6),
        Text(
          l10n.requestsEmptySubtitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Expanded(
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

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.text, required this.color});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.09),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      text,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.w800,
        fontSize: 10.5,
      ),
    ),
  );
}

({Color color, IconData icon}) _statusStyle(String status) => switch (status
    .toLowerCase()) {
  'available' => (color: Color(0xFF167D5A), icon: Icons.check_circle_rounded),
  'unavailable' => (color: Color(0xFFB33A3A), icon: Icons.cancel_rounded),
  'cancelled' => (color: Color(0xFF668087), icon: Icons.block_rounded),
  _ => (color: const Color(0xFFB47618), icon: Icons.schedule_rounded),
};

String _statusText(AppLocalizations l10n, UserMedicineRequest request) {
  if (request.statusDisplayText.trim().isNotEmpty &&
      !request.statusDisplayText.toLowerCase().contains('waiting')) {
    return request.statusDisplayText;
  }
  return switch (request.status.toLowerCase()) {
    'available' => l10n.medicineAvailable,
    'unavailable' => l10n.statusUnavailable,
    'cancelled' => l10n.statusCancelled,
    _ => l10n.statusPending,
  };
}

String _date(DateTime? value) =>
    value == null ? '—' : '${value.year}/${value.month}/${value.day}';
