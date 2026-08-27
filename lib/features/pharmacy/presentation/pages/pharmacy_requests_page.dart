import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/layout.dart';
import '../../../../core/constants/demo_flags.dart';
import '../../../../core/widgets/app_reveal.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/async_states.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/models/pharmacy_models.dart';
import '../controllers/pharmacy_providers.dart';
import '../widgets/pharmacy_requests_demo.dart';

class PharmacyRequestsPage extends ConsumerStatefulWidget {
  const PharmacyRequestsPage({super.key});

  @override
  ConsumerState<PharmacyRequestsPage> createState() =>
      _PharmacyRequestsPageState();
}

class _PharmacyRequestsPageState
    extends ConsumerState<PharmacyRequestsPage> {
  final TextEditingController _search = TextEditingController();

  String _query = '';
  String? _status;

  PharmacyRequestFilter get _filter => (
        search: _query,
        status: _status,
      );

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _submitSearch(String value) {
    setState(() {
      _query = value.trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (kScreenshotDemo) {
      return const PharmacyRequestsDemo();
    }

    final state = ref.watch(
      pharmacyRequestsProvider(_filter),
    );

    final snapshot =
        state.valueOrNull ?? const <PharmacyRequest>[];

    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.medicineRequestsTitle,
        ),
        actions: [
          IconButton(
            onPressed: () {
              ref.invalidate(
                pharmacyRequestsProvider(_filter),
              );
            },
            tooltip: l10n.refreshOrders,
            icon: const Icon(
              Icons.refresh_rounded,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              14,
              20,
              8,
            ),
            child: Column(
              children: [
                // ==========================================================
                // HERO
                // ==========================================================

                AppReveal(
                  child: _RequestsHero(
                    items: snapshot,
                  ),
                ),

                const SizedBox(height: 26),

                // ==========================================================
                // SEARCH
                // ==========================================================

                AppReveal(
                  delay: const Duration(
                    milliseconds: 60,
                  ),
                  child: AppTextField(
                    label: l10n.searchRequestField,
                    controller: _search,
                    icon: Icons.search_rounded,
                    textInputAction: TextInputAction.search,
                    onSubmitted: _submitSearch,
                  ),
                ),

                const SizedBox(height: 12),

                // ==========================================================
                // STATUS FILTERS
                // ==========================================================

                AppReveal(
                  delay: const Duration(
                    milliseconds: 90,
                  ),
                  child: _RequestStatusSelector(
                    selectedStatus: _status,
                    onStatusSelected: (status) {
                      setState(() {
                        _status =
                            status == 'All' ? null : status;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          // ================================================================
          // REQUESTS
          // ================================================================

          Expanded(
            child: state.when(
              loading: () => AppLoadingState(
                label: l10n.ordersLoading,
              ),
              error: (error, _) => AppErrorState(
                error: error,
                onRetry: () {
                  ref.invalidate(
                    pharmacyRequestsProvider(_filter),
                  );
                },
              ),
              data: (items) => RefreshIndicator(
                onRefresh: () => ref.refresh(
                  pharmacyRequestsProvider(_filter).future,
                ),
                child: items.isEmpty
                    ? const _RequestsEmpty()
                    : ListView.separated(
                        physics:
                            const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.fromLTRB(
                          20,
                          10,
                          20,
                          kBottomNavReserved + 12,
                        ),
                        itemCount: items.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(
                          height: 11,
                        ),
                        itemBuilder: (_, index) {
                          return AppReveal(
                            delay: Duration(
                              milliseconds:
                                  110 + (index * 35),
                            ),
                            child: _RequestCard(
                              request: items[index],
                              onTap: () {
                                context.push(
                                  '/pharmacy/requests/${items[index].requestId}',
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// REQUESTS HERO
// ============================================================================

class _RequestsHero extends StatelessWidget {
  const _RequestsHero({
    required this.items,
  });

  final List<PharmacyRequest> items;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final waiting = items
        .where(
          (item) => item.canRespond,
        )
        .length;

    final available = items
        .where(
          (item) =>
              item.status.toLowerCase() == 'available',
        )
        .length;

    final unavailable = items
        .where(
          (item) =>
              item.status.toLowerCase() == 'unavailable',
        )
        .length;

    final hasWaiting = waiting > 0;

    return Container(
      decoration: BoxDecoration(
        color: context.appColors.primary,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: context.appColors.primaryLight.withValues(
            alpha: 0.25,
          ),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(21),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // ==============================================================
            // TOP ROW
            // ==============================================================

            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(
                      alpha: 0.10,
                    ),
                    borderRadius:
                        BorderRadius.circular(18),
                  ),
                  child: Icon(
                    Icons.assignment_turned_in_rounded,
                    color:
                        context.appColors.primaryLight,
                    size: 28,
                  ),
                ),

                const Spacer(),

                _RequestsStatusPill(
                  text: hasWaiting
                      ? l10n.pendingNeedReply(waiting)
                      : l10n.noPendingRequests,
                  icon: hasWaiting
                      ? Icons.hourglass_top_rounded
                      : Icons.check_circle_rounded,
                  color: hasWaiting
                      ? context.appColors.primaryLight
                      : Colors.white70,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ==============================================================
            // TITLE
            // ==============================================================

            Text(
              l10n.medicineRequestsTitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
            ),

            const SizedBox(height: 8),

            // ==============================================================
            // DESCRIPTION
            // ==============================================================

            Row(
              children: [
                Icon(
                  hasWaiting
                      ? Icons.notifications_active_rounded
                      : Icons.task_alt_rounded,
                  color: Colors.white.withValues(
                    alpha: 0.70,
                  ),
                  size: 19,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    hasWaiting
                        ? l10n.pendingNeedReply(waiting)
                        : l10n.noPendingRequests,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withValues(
                        alpha: 0.80,
                      ),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // ==============================================================
            // HERO METRICS
            // ==============================================================

            Row(
              children: [
                _RequestsHeroMetric(
                  icon: Icons.assignment_rounded,
                  label: l10n.overviewOrders,
                  value: '${items.length}',
                ),

                const SizedBox(width: 10),

                _RequestsHeroMetric(
                  icon: Icons.check_circle_rounded,
                  label: l10n.overviewAvailable,
                  value: '$available',
                ),

                const SizedBox(width: 10),

                _RequestsHeroMetric(
                  icon: Icons.cancel_rounded,
                  label: l10n.statusUnavailable,
                  value: '$unavailable',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// REQUESTS STATUS PILL
// ============================================================================

class _RequestsStatusPill extends StatelessWidget {
  const _RequestsStatusPill({
    required this.text,
    required this.icon,
    required this.color,
  });

  final String text;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 150,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: 0.12,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(
            alpha: 0.16,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 12,
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// REQUESTS HERO METRIC
// ============================================================================

class _RequestsHeroMetric extends StatelessWidget {
  const _RequestsHeroMetric({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 11,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(
            alpha: 0.075,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(
              alpha: 0.08,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color:
                  context.appColors.primaryLight,
              size: 18,
            ),

            const SizedBox(width: 7),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withValues(
                        alpha: 0.55,
                      ),
                      fontSize: 9.5,
                    ),
                  ),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// REQUEST CARD
// ============================================================================

class _RequestCard extends StatelessWidget {
  const _RequestCard({
    required this.request,
    required this.onTap,
  });

  final PharmacyRequest request;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final color = _statusColor(
      context.appColors,
      request.status,
    );

    final label =
        request.statusDisplayText.trim().isNotEmpty
            ? request.statusDisplayText
            : _statusLabel(
                l10n,
                request.status,
              );

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 5,
                color: color,
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      // ====================================================
                      // HEADER
                      // ====================================================

                      Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 43,
                            height: 43,
                            decoration: BoxDecoration(
                              color:
                                  color.withValues(
                                alpha: .09,
                              ),
                              borderRadius:
                                  BorderRadius.circular(
                                14,
                              ),
                            ),
                            child: Icon(
                              Icons.medication_rounded,
                              color: color,
                            ),
                          ),

                          const SizedBox(width: 11),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  request.medicineName,
                                  maxLines: 2,
                                  overflow:
                                      TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium,
                                ),

                                const SizedBox(height: 3),

                                Text(
                                  request.userFullName,
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

                          _StatusBadge(
                            text: label,
                            color: color,
                          ),
                        ],
                      ),

                      const SizedBox(height: 13),

                      // ====================================================
                      // REQUEST FACTS
                      // ====================================================

                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: context
                              .appColors
                              .surfaceSoft,
                          borderRadius:
                              BorderRadius.circular(
                            14,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _RequestFact(
                                icon:
                                    Icons.numbers_rounded,
                                text: l10n
                                    .quantityRequestedValue(
                                  request
                                      .requestedQuantity,
                                ),
                              ),
                            ),

                            const _FactDivider(),

                            Expanded(
                              child: _RequestFact(
                                icon: Icons.tag_rounded,
                                text:
                                    request.requestCode,
                              ),
                            ),

                            const SizedBox(width: 8),

                            if (request.canRespond)
                              _ReplyAction(
                                onTap: onTap,
                              )
                            else
                              Icon(
                                Icons
                                    .chevron_left_rounded,
                                color: context
                                    .appColors
                                    .textMuted,
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

// ============================================================================
// REPLY ACTION
// ============================================================================

class _ReplyAction extends StatelessWidget {
  const _ReplyAction({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 4,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.replyNow,
                style: TextStyle(
                  color:
                      context.appColors.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(width: 3),

              Icon(
                Icons.arrow_back_rounded,
                size: 16,
                color:
                    context.appColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// STATUS BADGE
// ============================================================================

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.text,
    required this.color,
  });

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 88,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: .09,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

// ============================================================================
// REQUEST FACT
// ============================================================================

class _RequestFact extends StatelessWidget {
  const _RequestFact({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 15,
          color: context.appColors.textMuted,
        ),

        const SizedBox(width: 4),

        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              color:
                  context.appColors.textMuted,
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// FACT DIVIDER
// ============================================================================

class _FactDivider extends StatelessWidget {
  const _FactDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 15,
      margin: const EdgeInsets.symmetric(
        horizontal: 9,
      ),
      color: context.appColors.border,
    );
  }
}

// ============================================================================
// EMPTY STATE
// ============================================================================

class _RequestsEmpty extends StatelessWidget {
  const _RequestsEmpty();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ListView(
      physics:
          const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
      ),
      children: [
        const SizedBox(height: 80),

        Container(
          width: 72,
          height: 72,
          margin: const EdgeInsets.symmetric(
            horizontal: 100,
          ),
          decoration: BoxDecoration(
            color:
                context.appColors.surfaceSoft,
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
          l10n.noMatchingRequests,
          textAlign: TextAlign.center,
          style:
              Theme.of(context).textTheme.titleMedium,
        ),

        const SizedBox(height: 5),

        Text(
          l10n.noMatchingRequestsSubtitle,
          textAlign: TextAlign.center,
          style:
              Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

// ============================================================================
// STATUS LABEL
// ============================================================================

String _statusLabel(
  AppLocalizations l10n,
  String value,
) =>
    switch (value.toLowerCase()) {
      'available' => l10n.statusAvailable,
      'unavailable' => l10n.statusUnavailable,
      'cancelled' => l10n.statusCancelled,
      _ => l10n.requestStatusWaitingReply,
    };

// ============================================================================
// STATUS COLOR
// ============================================================================

Color _statusColor(
  AppColors colors,
  String value,
) =>
    switch (value.toLowerCase()) {
      'available' => colors.primary,
      'unavailable' => colors.danger,
      'cancelled' => colors.textMuted,
      _ => colors.primary,
    };

// ============================================================================
// STATUS SELECTOR
// ============================================================================

class _RequestStatusSelector extends StatelessWidget {
  const _RequestStatusSelector({
    required this.selectedStatus,
    required this.onStatusSelected,
  });

  final String? selectedStatus;
  final Function(String) onStatusSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = AppLocalizations.of(context);

    return Row(
      children: [
        Expanded(
          child: _RequestStatusButton(
            label: l10n.statusAll,
            icon: Icons.apps_rounded,
            color: colors.primary,
            isSelected: selectedStatus == null,
            onTap: () {
              onStatusSelected('All');
            },
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: _RequestStatusButton(
            label: l10n.statusWaitingYou,
            icon: Icons.hourglass_top_rounded,
            color: colors.primary,
            isSelected:
                selectedStatus == 'Pending',
            onTap: () {
              onStatusSelected('Pending');
            },
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: _RequestStatusButton(
            label: l10n.statusAvailable,
            icon: Icons.check_circle_rounded,
            color: colors.primary,
            isSelected:
                selectedStatus == 'Available',
            onTap: () {
              onStatusSelected('Available');
            },
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: _RequestStatusButton(
            label: l10n.statusUnavailable,
            icon: Icons.cancel_rounded,
            color: colors.primary,
            isSelected:
                selectedStatus == 'Unavailable',
            onTap: () {
              onStatusSelected('Unavailable');
            },
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// STATUS BUTTON
// ============================================================================

class _RequestStatusButton extends StatelessWidget {
  const _RequestStatusButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 200,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? color
              : colors.surface,
          borderRadius:
              BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? color
                : colors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Colors.white
                  : color,
              size: 22,
            ),

            const SizedBox(height: 6),

            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : color,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}