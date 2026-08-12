import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../../core/widgets/app_reveal.dart';
import '../../../../core/widgets/async_states.dart';
import '../../data/models/donation_models.dart';
import '../../data/repositories/donations_repository.dart';
import '../controllers/donations_providers.dart';

class PharmacyDonationsPage extends ConsumerWidget {
  const PharmacyDonationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offers = ref.watch(pharmacyDonationOffersProvider(null));
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('التحقق من التبرعات'),
            Text(
              'سلامة الدواء قبل وصوله للمستفيد',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      body: offers.when(
        loading: () =>
            const AppLoadingState(label: 'جاري تحميل عروض التبرع...'),
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
                  children: const [
                    SizedBox(height: 120),
                    Icon(
                      Icons.verified_outlined,
                      size: 54,
                      color: AppColors.textMuted,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'لا توجد تبرعات بانتظار التحقق.',
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
    final note = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(_actionLabel(status)),
        content: TextField(
          controller: note,
          minLines: 2,
          maxLines: 4,
          maxLength: 1000,
          decoration: const InputDecoration(
            labelText: 'ملاحظة الفحص (اختياري)',
            alignLabelWithHint: true,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('تأكيد'),
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تحديث حالة التبرع بنجاح.')),
        );
      }
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error is ApiException ? error.message : 'تعذر تحديث التبرع.',
          ),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }
}

class _PharmacyDonationHero extends StatelessWidget {
  const _PharmacyDonationHero({required this.count});
  final int count;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [AppColors.primaryDeep, AppColors.primary],
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
          child: const Icon(
            Icons.verified_outlined,
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'مراجعة دقيقة وآمنة',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                'افحص العبوات ثم حدّث حالتها حسب نتيجة التحقق.',
                style: TextStyle(color: Colors.white70, fontSize: 10.5),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            '$count',
            style: const TextStyle(
              color: AppColors.primaryDeep,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    ),
  );
}

class _DonationReviewCard extends StatelessWidget {
  const _DonationReviewCard({required this.offer, required this.onReview});

  final DonationOffer offer;
  final ValueChanged<String> onReview;

  @override
  Widget build(BuildContext context) {
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
                const CircleAvatar(
                  backgroundColor: AppColors.surfaceSoft,
                  child: Icon(
                    Icons.volunteer_activism_outlined,
                    color: AppColors.primary,
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
                      Text('${offer.packageCount} عبوات'),
                    ],
                  ),
                ),
                _StatusChip(offer.pharmacyReviewStatus),
              ],
            ),
            const Divider(height: 24),
            Text('المتبرع: ${offer.donorFullName}'),
            if (offer.targetOrganizationName != null)
              Text('الجهة المستفيدة: ${offer.targetOrganizationName}'),
            if (offer.expiryDateUtc != null)
              Text(
                'الانتهاء: ${offer.expiryDateUtc!.year}/'
                '${offer.expiryDateUtc!.month}/${offer.expiryDateUtc!.day}',
              ),
            if (pending) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => onReview('PharmacyApproved'),
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('قبول بعد الفحص'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: () => onReview('PharmacyRejected'),
                    child: const Text('رفض'),
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
                  label: const Text('تأكيد استلام العبوات'),
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
      'PharmacyApproved' || 'ReceivedByPharmacy' => AppColors.success,
      'PharmacyRejected' => AppColors.danger,
      _ => AppColors.warning,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _statusLabel(status),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

String _statusLabel(String status) => switch (status) {
  'PharmacyApproved' => 'مقبول',
  'PharmacyRejected' => 'مرفوض',
  'ReceivedByPharmacy' => 'تم الاستلام',
  _ => 'بانتظار الفحص',
};

String _actionLabel(String status) => switch (status) {
  'PharmacyApproved' => 'اعتماد التبرع',
  'PharmacyRejected' => 'رفض التبرع',
  'ReceivedByPharmacy' => 'تأكيد الاستلام',
  _ => 'تحديث التبرع',
};
