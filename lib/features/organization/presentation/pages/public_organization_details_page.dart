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
    final state = ref.watch(
      publicOrganizationProvider(organizationId),
    );

    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: context.appColors.background,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        title: Text(
          l10n.organizationDetailsTitle,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: state.when(
        loading: () => AppLoadingState(
          label: l10n.organizationLoading,
        ),
        error: (error, _) => AppErrorState(
          error: error,
          onRetry: () => ref.invalidate(
            publicOrganizationProvider(organizationId),
          ),
        ),
        data: (organization) => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            20,
            8,
            20,
            40,
          ),
          children: [
            // =============================================================
            // ORGANIZATION HERO
            // =============================================================

            _OrganizationHero(
              organization: organization,
            ),

            const SizedBox(height: 24),

            // =============================================================
            // ORGANIZATION INFORMATION
            // =============================================================

            const _SectionTitle(
              title: 'معلومات المنظمة',
              subtitle: 'معلومات التواصل والتسجيل',
            ),

            const SizedBox(height: 11),

            _OrganizationInfoCard(
              organization: organization,
            ),

            const SizedBox(height: 28),

            // =============================================================
            // ACTIVE CAMPAIGNS
            // =============================================================

            _SectionTitle(
              title: l10n.activeCampaignsTitle,
              subtitle: 'الحملات المتاحة للتبرع',
            ),

            const SizedBox(height: 11),

            if (organization.activeCampaigns.isEmpty)
              _EmptyCampaignsCard(
                message: l10n.noActiveCampaigns,
              )
            else
              ...organization.activeCampaigns.map(
                (campaign) => Padding(
                  padding: const EdgeInsets.only(
                    bottom: 12,
                  ),
                  child: _CampaignDetailsCard(
                    campaign: campaign,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// ORGANIZATION HERO
// ============================================================================

class _OrganizationHero extends StatelessWidget {
  const _OrganizationHero({
    required this.organization,
  });

  final PublicOrganizationDetails organization;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: context.appColors.primary,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: context.appColors.primaryLight.withValues(
            alpha: 0.25,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =============================================================
          // TOP ROW
          // =============================================================

          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(
                    alpha: 0.10,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  Icons.apartment_rounded,
                  color: context.appColors.primaryLight,
                  size: 29,
                ),
              ),

              const Spacer(),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: context.appColors.primaryLight.withValues(
                    alpha: 0.12,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: context.appColors.primaryLight.withValues(
                      alpha: 0.18,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.verified_rounded,
                      size: 12,
                      color: context.appColors.primaryLight,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      l10n.approvedOrganizationLabel,
                      style: TextStyle(
                        color: context.appColors.primaryLight,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 17),

          // =============================================================
          // ORGANIZATION NAME
          // =============================================================

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  organization.organizationName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        height: 1.2,
                      ),
                ),
              ),

              const SizedBox(width: 10),

              Icon(
                Icons.verified_rounded,
                color: context.appColors.primaryLight,
                size: 25,
              ),
            ],
          ),

          // =============================================================
          // DESCRIPTION
          // =============================================================

          if (organization.description != null &&
              organization.description!.trim().isNotEmpty) ...[
            const SizedBox(height: 9),
            Text(
              organization.description!,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white.withValues(
                  alpha: 0.76,
                ),
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                height: 1.45,
              ),
            ),
          ],

          const SizedBox(height: 17),

          // =============================================================
          // LOCATION
          // =============================================================

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(
                alpha: 0.08,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: Colors.white.withValues(
                    alpha: 0.82,
                  ),
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${organization.city}، '
                    '${organization.area}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withValues(
                        alpha: 0.82,
                      ),
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                    ),
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

// ============================================================================
// SECTION TITLE
// ============================================================================

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 21,
          decoration: BoxDecoration(
            color: context.appColors.primary,
            borderRadius: BorderRadius.circular(4),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(
                      color: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.color
                          ?.withValues(alpha: 0.70),
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// ORGANIZATION INFO CARD
// ============================================================================

class _OrganizationInfoCard extends StatelessWidget {
  const _OrganizationInfoCard({
    required this.organization,
  });

  final PublicOrganizationDetails organization;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: context.appColors.border,
        ),
      ),
      child: Column(
        children: [
          _InfoTile(
            icon: Icons.location_on_outlined,
            title: 'الموقع',
            value:
                '${organization.city}، '
                '${organization.area} — '
                '${organization.address}',
          ),

          if (organization.phoneNumber != null) ...[
            const SizedBox(height: 10),
            _InfoTile(
              icon: Icons.phone_outlined,
              title: 'رقم الهاتف',
              value: organization.phoneNumber!,
            ),
          ],

          const SizedBox(height: 10),

          _InfoTile(
            icon: Icons.badge_outlined,
            title: 'رقم التسجيل',
            value: l10n.registrationNumber(
              organization.registrationNumber,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// INFO TILE
// ============================================================================

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.appColors.surfaceSoft,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: context.appColors.primary.withValues(
                alpha: 0.10,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: context.appColors.primary,
              size: 20,
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.color
                        ?.withValues(alpha: 0.70),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  value,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.35,
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

// ============================================================================
// EMPTY CAMPAIGNS
// ============================================================================

class _EmptyCampaignsCard extends StatelessWidget {
  const _EmptyCampaignsCard({
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 28,
      ),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: context.appColors.border,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: context.appColors.primary.withValues(
                alpha: 0.08,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.campaign_outlined,
              color: context.appColors.primary,
              size: 25,
            ),
          ),

          const SizedBox(height: 11),

          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// CAMPAIGN CARD
// ============================================================================

class _CampaignDetailsCard extends StatelessWidget {
  const _CampaignDetailsCard({
    required this.campaign,
  });

  final DonationCampaign campaign;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: context.appColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =============================================================
          // TITLE
          // =============================================================

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: context.appColors.primary.withValues(
                    alpha: 0.10,
                  ),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  Icons.campaign_outlined,
                  color: context.appColors.primary,
                  size: 22,
                ),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      campaign.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                    ),

                    const SizedBox(height: 5),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: context.appColors.primary.withValues(
                          alpha: 0.08,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        l10n.campaignActive,
                        style: TextStyle(
                          color: context.appColors.primary,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // =============================================================
          // DESCRIPTION
          // =============================================================

          const SizedBox(height: 13),

          Text(
            campaign.description,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(
                  height: 1.5,
                ),
          ),

          // =============================================================
          // REQUESTED MEDICINES
          // =============================================================

          if (campaign.requestedMedicinesSummary != null &&
              campaign.requestedMedicinesSummary!
                  .trim()
                  .isNotEmpty) ...[
            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.appColors.surfaceSoft,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.medication_outlined,
                    color: context.appColors.primary,
                    size: 19,
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      l10n.requestedMedicinesLabel(
                        campaign.requestedMedicinesSummary!,
                      ),
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                            fontWeight: FontWeight.w700,
                            height: 1.4,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // =============================================================
          // DONATION BUTTON
          // =============================================================

          if (campaign.acceptsPublicDonations) ...[
            const SizedBox(height: 14),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton.icon(
                onPressed: () => context.push(
                  '/user/donations/create-offer',
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: context.appColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(
                  Icons.volunteer_activism_outlined,
                  size: 19,
                ),
                label: Text(
                  l10n.donateOffer,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}