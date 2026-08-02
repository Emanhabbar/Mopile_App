import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/donation_models.dart';
import '../../data/repositories/donations_repository.dart';

final donationVerificationPharmaciesProvider =
    FutureProvider.autoDispose<List<DonationVerificationPharmacy>>(
      (ref) =>
          ref.watch(donationsRepositoryProvider).getVerificationPharmacies(),
    );

final pharmacyDonationOffersProvider = FutureProvider.autoDispose
    .family<List<DonationOffer>, String?>(
      (ref, status) => ref
          .watch(donationsRepositoryProvider)
          .getPharmacyDonationOffers(status: status),
    );

final myDonationOffersProvider = FutureProvider.autoDispose
    .family<List<DonationOffer>, String?>(
      (ref, status) =>
          ref.watch(donationsRepositoryProvider).getMyOffers(status: status),
    );

final myAssistanceRequestsProvider = FutureProvider.autoDispose
    .family<List<AssistanceRequest>, String?>(
      (ref, status) => ref
          .watch(donationsRepositoryProvider)
          .getMyAssistanceRequests(status: status),
    );

final publicOrganizationsProvider =
    FutureProvider.autoDispose<List<PublicOrganization>>(
      (ref) => ref.watch(donationsRepositoryProvider).getOrganizations(),
    );

final publicOrganizationProvider = FutureProvider.autoDispose
    .family<PublicOrganizationDetails, String>(
      (ref, organizationId) => ref
          .watch(donationsRepositoryProvider)
          .getOrganization(organizationId),
    );

final activeCampaignsProvider = FutureProvider.autoDispose
    .family<List<DonationCampaign>, String?>(
      (ref, organizationId) => ref
          .watch(donationsRepositoryProvider)
          .getActiveCampaigns(organizationId: organizationId),
    );
