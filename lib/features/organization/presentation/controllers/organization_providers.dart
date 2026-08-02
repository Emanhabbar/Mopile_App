import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../donations/data/models/donation_models.dart';
import '../../data/models/organization_models.dart';
import '../../data/repositories/organization_repository.dart';

final organizationDashboardProvider =
    FutureProvider.autoDispose<OrganizationDashboard>(
      (ref) => ref.watch(organizationRepositoryProvider).getDashboard(),
    );
final organizationProfileProvider =
    FutureProvider.autoDispose<OrganizationDashboard>(
      (ref) => ref.watch(organizationRepositoryProvider).getMe(),
    );
final organizationVerificationProvider =
    FutureProvider.autoDispose<OrganizationVerification>(
      (ref) => ref.watch(organizationRepositoryProvider).getVerification(),
    );
final organizationCampaignsProvider =
    FutureProvider.autoDispose<List<DonationCampaign>>(
      (ref) => ref.watch(organizationRepositoryProvider).getCampaigns(),
    );
final organizationOffersProvider =
    FutureProvider.autoDispose<List<OrganizationDonationOffer>>(
      (ref) => ref.watch(organizationRepositoryProvider).getDonationOffers(),
    );
final organizationAssistanceProvider =
    FutureProvider.autoDispose<List<OrganizationAssistanceRequest>>(
      (ref) =>
          ref.watch(organizationRepositoryProvider).getAssistanceRequests(),
    );
