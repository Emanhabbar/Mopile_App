import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/async_states.dart';
import '../../../donations/data/models/donation_models.dart';
import '../../../donations/presentation/controllers/donations_providers.dart';

class PublicOrganizationsPage extends ConsumerWidget {
  const PublicOrganizationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final organizations = ref.watch(publicOrganizationsProvider);
    final campaigns = ref.watch(activeCampaignsProvider(null));

    return Scaffold(
      appBar: AppBar(title: const Text('المنظمات والحملات')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(publicOrganizationsProvider);
          ref.invalidate(activeCampaignsProvider(null));
          await Future.wait([
            ref.read(publicOrganizationsProvider.future),
            ref.read(activeCampaignsProvider(null).future),
          ]);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
          children: [
            _IntroCard(
              organizationsCount: organizations.valueOrNull?.length,
              campaignsCount: campaigns.valueOrNull?.length,
            ),
            const SizedBox(height: 24),
            _SectionTitle(
              title: 'الحملات النشطة',
              subtitle: 'مبادرات دوائية متاحة للمساهمة',
            ),
            const SizedBox(height: 12),
            campaigns.when(
              loading: () =>
                  const AppLoadingState(label: 'جاري تحميل الحملات...'),
              error: (error, _) => AppErrorState(
                error: error,
                onRetry: () => ref.invalidate(activeCampaignsProvider(null)),
              ),
              data: (items) => items.isEmpty
                  ? const _EmptyCard(text: 'لا توجد حملات نشطة حاليًا.')
                  : Column(
                      children: items
                          .map(
                            (campaign) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _CampaignCard(campaign: campaign),
                            ),
                          )
                          .toList(growable: false),
                    ),
            ),
            const SizedBox(height: 24),
            _SectionTitle(
              title: 'المنظمات المعتمدة',
              subtitle: 'استعرض الجهات وحملاتها الحالية',
            ),
            const SizedBox(height: 12),
            organizations.when(
              loading: () =>
                  const AppLoadingState(label: 'جاري تحميل المنظمات...'),
              error: (error, _) => AppErrorState(
                error: error,
                onRetry: () => ref.invalidate(publicOrganizationsProvider),
              ),
              data: (items) => items.isEmpty
                  ? const _EmptyCard(text: 'لا توجد منظمات معتمدة حاليًا.')
                  : Column(
                      children: items
                          .map(
                            (organization) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _OrganizationCard(
                                organization: organization,
                                onTap: () => context.push(
                                  '/organizations/${organization.organizationId}',
                                ),
                              ),
                            ),
                          )
                          .toList(growable: false),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard({this.organizationsCount, this.campaignsCount});

  final int? organizationsCount;
  final int? campaignsCount;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: context.appColors.primary,
      borderRadius: BorderRadius.circular(24),
    ),
    child: Row(
      children: [
        const Icon(
          Icons.volunteer_activism_rounded,
          color: Colors.white,
          size: 38,
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'دواء يصل لمن يحتاجه',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 5),
              Text(
                '${organizationsCount ?? '—'} منظمة • ${campaignsCount ?? '—'} حملة نشطة',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _OrganizationCard extends StatelessWidget {
  const _OrganizationCard({required this.organization, required this.onTap});

  final PublicOrganization organization;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.all(14),
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: context.appColors.surfaceSoft,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.apartment_rounded, color: context.appColors.primary),
      ),
      title: Text(
        organization.organizationName,
        style: const TextStyle(fontWeight: FontWeight.w800),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Text(
          '${organization.city}، ${organization.area}\n${organization.activeCampaignsCount} حملة نشطة',
        ),
      ),
      trailing: const Icon(Icons.chevron_left_rounded),
    ),
  );
}

class _CampaignCard extends StatelessWidget {
  const _CampaignCard({required this.campaign});

  final DonationCampaign campaign;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  campaign.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              if (campaign.isUrgent)
                const Chip(
                  avatar: Icon(Icons.priority_high_rounded, size: 16),
                  label: Text('عاجلة'),
                ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            campaign.organizationName,
            style: TextStyle(
              color: context.appColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            campaign.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          if (campaign.requestedMedicinesSummary != null) ...[
            const SizedBox(height: 9),
            Text(
              'الاحتياج: ${campaign.requestedMedicinesSummary}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 3),
      Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
    ],
  );
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Center(child: Text(text)),
    ),
  );
}
