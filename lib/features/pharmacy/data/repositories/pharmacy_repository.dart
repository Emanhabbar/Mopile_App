import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_selector/file_selector.dart';

import '../../../../core/network/api_client.dart';
import '../data_sources/pharmacy_remote_data_source.dart';
import '../models/pharmacy_models.dart';

final pharmacyRepositoryProvider = Provider<PharmacyRepository>(
  (ref) => PharmacyRepository(PharmacyRemoteDataSource(ref.watch(dioProvider))),
);

class PharmacyRepository {
  PharmacyRepository(this.remote);
  final PharmacyRemoteDataSource remote;
  final Map<String, ({DateTime storedAt, PharmacyCatalogPage page})>
  _catalogCache = {};
  static const _catalogCacheDuration = Duration(minutes: 5);

  Future<PharmacyDashboard> getDashboard() => remote.getDashboard();
  Future<PharmacyDashboard> getProfile() => remote.getProfile();
  Future<PharmacyOpenStatus> getOpenStatus() => remote.getOpenStatus();
  Future<PharmacyLicenseVerification?> getLicenseVerification() =>
      remote.getLicenseVerification();
  Future<PharmacyLicenseVerification> submitLicenseVerification(XFile file) =>
      remote.submitLicenseVerification(file);
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
  Future<PharmacyCatalogPage> searchCatalog(
    String query, {
    int pageNumber = 1,
    int pageSize = 30,
  }) async {
    final normalized = query.trim().toLowerCase();
    final key = '$normalized|$pageNumber|$pageSize';
    final cached = _catalogCache[key];
    if (cached != null &&
        DateTime.now().difference(cached.storedAt) < _catalogCacheDuration) {
      return cached.page;
    }
    final page = await remote.searchCatalog(
      query,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
    if (_catalogCache.length >= 80) {
      final oldestKey = _catalogCache.entries
          .reduce((a, b) => a.value.storedAt.isBefore(b.value.storedAt) ? a : b)
          .key;
      _catalogCache.remove(oldestKey);
    }
    _catalogCache[key] = (storedAt: DateTime.now(), page: page);
    return page;
  }

  void clearCatalogCache() => _catalogCache.clear();
  Future<List<PharmacyRequest>> getRequests({
    String? status,
    String? searchTerm,
  }) => remote.getRequests(status: status, searchTerm: searchTerm);
  Future<PharmacyRequestDetails> getRequest(String id) => remote.getRequest(id);
  Future<PharmacyRequestDetails> confirmRequestPickup(String id) =>
      remote.confirmRequestPickup(id);
}
