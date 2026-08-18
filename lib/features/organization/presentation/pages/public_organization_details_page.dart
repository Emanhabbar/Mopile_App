import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/async_states.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../donations/data/models/donation_models.dart';
import '../../../donations/presentation/controllers/donations_providers.dart';

class PublicOrganizationDetailsPage extends ConsumerWidget {
  const PublicOrganizationDetailsPage({
    required this.organizationId,
    super.key,
  });

  final String organizationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(publicOrganizationProvider(organizationId));
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.organizationDetailsTitle)),
      body: state.when(
        loading: () => AppLoadingState(label: l10n.organizationLoading),
        error: (error, _) => AppErrorState(
          error: error,
          onRetry: () =>
              ref.invalidate(publicOrganizationProvider(organizationId)),
        ),
        data: (organization) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
          children: [
            _OrganizationHeader(organization: organization),
            const SizedBox(height: 20),
            Text(
              l10n.activeCampaignsTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            if (organization.activeCampaigns.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Center(child: Text(l10n.noActiveCampaigns)),
                ),
              )
            else
              ...organization.activeCampaigns.map(
                (campaign) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _CampaignDetailsCard(campaign: campaign),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _OrganizationHeader extends StatelessWidget {
  const _OrganizationHeader({required this.organization});
  final PublicOrganizationDetails organization;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: context.appColors.surfaceSoft,
                child: Icon(Icons.apartment_rounded, color: context.appColors.primary),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      organization.organizationName,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(
                          Icons.verified_rounded,
                          size: 17,
                          color: context.appColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(l10n.approvedOrganizationLabel),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (organization.description != null) ...[
            const SizedBox(height: 16),
            Text(organization.description!),
          ],
          const Divider(height: 28),
          _InfoLine(
            icon: Icons.location_on_outlined,
            text:
                '${organization.city}، ${organization.area} — ${organization.address}',
          ),
          if (organization.phoneNumber != null) ...[
            const SizedBox(height: 9),
            _InfoLine(
              icon: Icons.phone_outlined,
              text: organization.phoneNumber!,
            ),
          ],
          const SizedBox(height: 9),
          _InfoLine(
            icon: Icons.badge_outlined,
            text: l10n.registrationNumber(organization.registrationNumber),
          ),
        ],
      ),
    ),
    );
  }
}

class _CampaignDetailsCard extends StatelessWidget {
  const _CampaignDetailsCard({required this.campaign});
  final DonationCampaign campaign;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(campaign.title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(campaign.description),
          if (campaign.requestedMedicinesSummary != null) ...[
            const SizedBox(height: 9),
            Text(
              AppLocalizations.of(context).requestedMedicinesLabel(
                campaign.requestedMedicinesSummary!,
              ),
            ),
          ],
          if (campaign.acceptsPublicDonations) ...[
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: () => context.push('/user/donations/create-offer'),
              icon: const Icon(Icons.volunteer_activism_outlined),
              label: Text(AppLocalizations.of(context).donateOffer),
            ),
          ],
        ],
      ),
    ),
  );
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: 20, color: context.appColors.primary),
      const SizedBox(width: 8),
      Expanded(child: Text(text)),
    ],
  );
}
