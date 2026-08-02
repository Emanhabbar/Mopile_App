import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../data_sources/pharmacy_discovery_remote_data_source.dart';
import '../models/pharmacy_discovery_models.dart';

final pharmacyDiscoveryRepositoryProvider =
    Provider<PharmacyDiscoveryRepository>(
      (ref) => PharmacyDiscoveryRepository(
        PharmacyDiscoveryRemoteDataSource(ref.watch(dioProvider)),
      ),
    );

class PharmacyDiscoveryRepository {
  const PharmacyDiscoveryRepository(this.remote);

  final PharmacyDiscoveryRemoteDataSource remote;

  Future<PharmacyLocatorResult<RegisteredPharmacyLocation>>
  getRegisteredNearby({
    required double latitude,
    required double longitude,
    int radius = 5000,
    int take = 3,
  }) => remote.getRegisteredNearby(
    latitude: latitude,
    longitude: longitude,
    radius: radius,
    take: take,
  );

  Future<Map<String, dynamic>> getRegisteredDetails(
    String pharmacyId, {
    double? latitude,
    double? longitude,
  }) => remote.getRegisteredDetails(
    pharmacyId,
    latitude: latitude,
    longitude: longitude,
  );

  Future<PharmacyLocatorResult<ExternalPharmacy>> getNearby({
    required double latitude,
    required double longitude,
    int radius = 2000,
    bool useCache = true,
  }) => remote.getNearby(
    latitude: latitude,
    longitude: longitude,
    radius: radius,
    useCache: useCache,
  );

  Future<PharmacyLocatorResult<ExternalPharmacy>> search({
    required double latitude,
    required double longitude,
    int radius = 2000,
    String? keyword,
    bool openNow = false,
    int maxResults = 20,
  }) => remote.search(
    latitude: latitude,
    longitude: longitude,
    radius: radius,
    keyword: keyword,
    openNow: openNow,
    maxResults: maxResults,
  );

  Future<PharmacyLocatorResult<RegisteredPharmacyLocation>>
  getClosestRegistered({
    required double latitude,
    required double longitude,
    int take = 3,
  }) => remote.getClosestRegistered(
    latitude: latitude,
    longitude: longitude,
    take: take,
  );

  Future<PharmacyLocatorResult<ExternalClosestPharmacy>> getClosestExternal({
    required double latitude,
    required double longitude,
    int take = 3,
  }) => remote.getClosestExternal(
    latitude: latitude,
    longitude: longitude,
    take: take,
  );

  Future<ExternalPharmacy> getExternalDetails(String placeId) =>
      remote.getExternalDetails(placeId);
  Future<List<int>> getPhoto(String reference) => remote.getPhoto(reference);
  Future<PharmacyLocatorHealth> getHealth() => remote.getHealth();
  Future<String> clearCache({int hours = 24}) =>
      remote.clearCache(hours: hours);
}
