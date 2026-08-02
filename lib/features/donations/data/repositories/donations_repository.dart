import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../data_sources/donations_remote_data_source.dart';
import '../models/donation_models.dart';

final donationsRepositoryProvider = Provider<DonationsRepository>(
  (ref) =>
      DonationsRepository(DonationsRemoteDataSource(ref.watch(dioProvider))),
);

class DonationsRepository {
  const DonationsRepository(this.remote);

  final DonationsRemoteDataSource remote;

  Future<List<DonationVerificationPharmacy>> getVerificationPharmacies({
    double? latitude,
    double? longitude,
  }) => remote.getVerificationPharmacies(
    latitude: latitude,
    longitude: longitude,
  );

  Future<List<DonationOffer>> getMyOffers({String? status}) =>
      remote.getMyOffers(status: status);
  Future<DonationOffer> createOffer(CreateDonationOffer request) =>
      remote.createOffer(request);
  Future<List<DonationOffer>> getPharmacyDonationOffers({String? status}) =>
      remote.getPharmacyDonationOffers(status: status);
  Future<DonationOffer> reviewPharmacyDonationOffer(
    String offerId, {
    required String status,
    String? note,
  }) => remote.reviewPharmacyDonationOffer(offerId, status: status, note: note);
  Future<List<AssistanceRequest>> getMyAssistanceRequests({String? status}) =>
      remote.getMyAssistanceRequests(status: status);
  Future<AssistanceRequest> createAssistanceRequest(
    CreateAssistanceRequest request,
  ) => remote.createAssistanceRequest(request);
  Future<List<PublicOrganization>> getOrganizations() =>
      remote.getOrganizations();
  Future<PublicOrganizationDetails> getOrganization(String id) =>
      remote.getOrganization(id);
  Future<List<DonationCampaign>> getActiveCampaigns({String? organizationId}) =>
      remote.getActiveCampaigns(organizationId: organizationId);
}
