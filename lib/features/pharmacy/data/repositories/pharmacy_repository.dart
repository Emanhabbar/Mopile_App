import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../data_sources/pharmacy_remote_data_source.dart';
import '../models/pharmacy_models.dart';

final pharmacyRepositoryProvider = Provider<PharmacyRepository>(
  (ref) => PharmacyRepository(PharmacyRemoteDataSource(ref.watch(dioProvider))),
);

class PharmacyRepository {
  const PharmacyRepository(this.remote);
  final PharmacyRemoteDataSource remote;

  Future<PharmacyDashboard> getDashboard() => remote.getDashboard();
  Future<PharmacyDashboard> getProfile() => remote.getProfile();
  Future<PharmacyOpenStatus> getOpenStatus() => remote.getOpenStatus();
  Future<List<PharmacyWorkingPeriod>> getWorkingHours() =>
      remote.getWorkingHours();
  Future<List<PharmacyInventoryItem>> getInventory({
    String? searchTerm,
    bool availableOnly = false,
    String? stockStatus,
    int? expiringWithinDays,
  }) => remote.getInventory(
    searchTerm: searchTerm,
    availableOnly: availableOnly,
    stockStatus: stockStatus,
    expiringWithinDays: expiringWithinDays,
  );
  Future<List<PharmacyCatalogMedicine>> searchCatalog(String query) =>
      remote.searchCatalog(query);
  Future<List<PharmacyRequest>> getRequests({
    String? status,
    String? searchTerm,
  }) => remote.getRequests(status: status, searchTerm: searchTerm);
  Future<PharmacyRequestDetails> getRequest(String id) => remote.getRequest(id);
}
