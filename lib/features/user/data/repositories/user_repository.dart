import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../data_sources/user_remote_data_source.dart';
import '../models/user_discovery_models.dart';
import '../models/user_models.dart';
import '../models/user_request_models.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(UserRemoteDataSource(ref.watch(dioProvider)));
});

class UserRepository {
  const UserRepository(this._remoteDataSource);

  final UserRemoteDataSource _remoteDataSource;

  Future<UserDashboard> getDashboard() => _remoteDataSource.getDashboard();
  Future<UserProfile> getProfile() => _remoteDataSource.getProfile();
  Future<UserMedicalProfile> getMedicalProfile() =>
      _remoteDataSource.getMedicalProfile();
  Future<UserHealthCard> getHealthCard() => _remoteDataSource.getHealthCard();
  Future<UserMedicalProfile> updateMedicalProfile(
    UpdateMedicalProfileRequest request,
  ) => _remoteDataSource.updateMedicalProfile(request);

  Future<UserProfile> updateLocation(UserLocationUpdate request) =>
      _remoteDataSource.updateLocation(request);
  Future<UserLocationDiscovery> getLocationContext(UserNearbyQuery request) =>
      _remoteDataSource.getLocationContext(request);
  Future<UserNearestRoute> getNearestRoute(
    UserNearbyQuery request, {
    String? pharmacyId,
  }) => _remoteDataSource.getNearestRoute(request, pharmacyId: pharmacyId);
  Future<List<UserPharmacySummary>> getNearestPharmacies(
    UserNearbyQuery request,
  ) => _remoteDataSource.getNearestPharmacies(request);
  Future<List<NearbyMedicineResult>> searchMedicines(
    UserMedicineSearch request,
  ) => _remoteDataSource.searchMedicines(request);
  Future<UserPharmacyDetails> getPharmacyDetails(String pharmacyId) =>
      _remoteDataSource.getPharmacyDetails(pharmacyId);
  Future<UserMedicineRequestResult> createMedicineRequest(
    String pharmacyId,
    CreateMedicineRequest request,
  ) => _remoteDataSource.createMedicineRequest(pharmacyId, request);
  Future<PharmacyRating> ratePharmacy(
    String pharmacyId, {
    required int score,
    String? comment,
  }) => _remoteDataSource.ratePharmacy(
    pharmacyId,
    score: score,
    comment: comment,
  );
  Future<List<UserMedicineRequest>> getMedicineRequests({
    String? status,
    int take = 50,
  }) => _remoteDataSource.getMedicineRequests(status: status, take: take);
  Future<UserMedicineRequestDetails> getMedicineRequest(String requestId) =>
      _remoteDataSource.getMedicineRequest(requestId);
  Future<UserMedicineRequestDetails> cancelMedicineRequest(String requestId) =>
      _remoteDataSource.cancelMedicineRequest(requestId);
  Future<List<UserSearchRecord>> getSearchHistory({int take = 50}) =>
      _remoteDataSource.getSearchHistory(take: take);
  Future<void> deleteSearchHistoryItem(String historyId) =>
      _remoteDataSource.deleteSearchHistoryItem(historyId);
  Future<void> clearSearchHistory() => _remoteDataSource.clearSearchHistory();
}
