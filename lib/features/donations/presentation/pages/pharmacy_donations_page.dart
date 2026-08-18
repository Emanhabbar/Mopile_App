import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../../core/widgets/app_reveal.dart';
import '../../../../core/widgets/async_states.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/models/donation_models.dart';
import '../../data/repositories/donations_repository.dart';
import '../controllers/donations_providers.dart';

class PharmacyDonationsPage extends ConsumerWidget {
  const PharmacyDonationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offers = ref.watch(pharmacyDonationOffersProvider(null));
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.verifyDonationsTitle),
            Text(
              l10n.verifyDonationsSubtitle,
              style: TextStyle(
                color: context.appColors.textMuted,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      body: offers.when(
        loading: () => AppLoadingState(label: l10n.donationOffersLoading),
        error: (error, _) => AppErrorState(
          error: error,
          onRetry: () => ref.invalidate(pharmacyDonationOffersProvider),
        ),
        data: (items) => RefreshIndicator(
          onRefresh: () =>
              ref.refresh(pharmacyDonationOffersProvider(null).future),
          child: items.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    const SizedBox(height: 120),
                    Icon(
                      Icons.verified_outlined,
                      size: 54,
                      color: context.appColors.textMuted,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.noDonationsToVerify,
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: items.length + 1,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) => index == 0
                      ? _PharmacyDonationHero(count: items.length)
                      : AppReveal(
                          delay: Duration(
                            milliseconds: ((index - 1).clamp(0, 5)) * 45,
                          ),
                          child: _DonationReviewCard(
                            offer: items[index - 1],
                            onReview: (status) =>
                                _review(context, ref, items[index - 1], status),
                          ),
                        ),
                ),
        ),
      ),
    );
  }

  Future<void> _review(
    BuildContext context,
    WidgetRef ref,
    DonationOffer offer,
    String status,
  ) async {
    final l10n = AppLocalizations.of(context);
    final note = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(_actionLabel(status, l10n)),
        content: AppTextField(
          controller: note,
          label: l10n.reviewNoteLabel,
          hint: l10n.reviewNoteHint,
          maxLines: 4,
          minLines: 2,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
    final reviewNote = note.text;
    note.dispose();
    if (confirmed != true || !context.mounted) return;
    try {
      await ref
          .read(donationsRepositoryProvider)
          .reviewPharmacyDonationOffer(
            offer.offerId,
            status: status,
            note: reviewNote,
          );
      ref.invalidate(pharmacyDonationOffersProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.donationStatusUpdated)));
      }
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error is ApiException ? error.localize(l10n) : l10n.donationUpdateFailed,
          ),
          backgroundColor: context.appColors.danger,
        ),
      );
    }
  }
}

class _PharmacyDonationHero extends StatelessWidget {
  const _PharmacyDonationHero({required this.count});
  final int count;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [context.appColors.primaryDeep, context.appColors.primary],
      ),
      borderRadius: BorderRadius.circular(25),
    ),
    child: Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .12),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            Icons.verified_outlined,
            color: context.appColors.secondary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.pharmacyReviewTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                l10n.pharmacyReviewSubtitle,
                style: const TextStyle(color: Colors.white70, fontSize: 10.5),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            color: context.appColors.secondary,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            '$count',
            style: TextStyle(
              color: context.appColors.primaryDeep,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    ),
    );
  }
}

class _DonationReviewCard extends StatelessWidget {
  const _DonationReviewCard({required this.offer, required this.onReview});

  final DonationOffer offer;
  final ValueChanged<String> onReview;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pending = offer.pharmacyReviewStatus == 'PendingPharmacyReview';
    final approved = offer.pharmacyReviewStatus == 'PharmacyApproved';
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: context.appColors.surfaceSoft,
                  child: Icon(
                    Icons.volunteer_activism_outlined,
                    color: context.appColors.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        offer.medicineName,
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                      Text(l10n.packagesCount(offer.packageCount)),
                    ],
                  ),
                ),
                _StatusChip(offer.pharmacyReviewStatus),
              ],
            ),
            const Divider(height: 24),
            Text(l10n.donorLabel(offer.donorFullName)),
            if (offer.targetOrganizationName != null)
              Text(l10n.beneficiaryLabel(offer.targetOrganizationName!)),
            if (offer.expiryDateUtc != null)
              Text(
                l10n.expiryLabel(
                  '${offer.expiryDateUtc!.year}/'
                  '${offer.expiryDateUtc!.month}/${offer.expiryDateUtc!.day}',
                ),
              ),
            if (pending) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => onReview('PharmacyApproved'),
                      icon: const Icon(Icons.check_circle_outline),
                      label: Text(l10n.acceptAfterInspection),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: () => onReview('PharmacyRejected'),
                    child: Text(l10n.reject),
                  ),
                ],
              ),
            ] else if (approved) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => onReview('ReceivedByPharmacy'),
                  icon: const Icon(Icons.inventory_2_outlined),
                  label: Text(l10n.confirmReceivePackages),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip(this.status);
  final String status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      'PharmacyApproved' || 'ReceivedByPharmacy' => context.appColors.success,
      'PharmacyRejected' => context.appColors.danger,
      _ => context.appColors.warning,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _statusLabel(status, AppLocalizations.of(context)),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

String _statusLabel(String status, AppLocalizations l10n) => switch (status) {
  'PharmacyApproved' => l10n.donationStatusApproved,
  'PharmacyRejected' => l10n.donationStatusRejected,
  'ReceivedByPharmacy' => l10n.donationStatusReceived,
  _ => l10n.statusPendingInspection,
};

String _actionLabel(String status, AppLocalizations l10n) => switch (status) {
  'PharmacyApproved' => l10n.actionApproveDonation,
  'PharmacyRejected' => l10n.actionRejectDonation,
  'ReceivedByPharmacy' => l10n.actionConfirmReceipt,
  _ => l10n.actionUpdateDonation,
};
