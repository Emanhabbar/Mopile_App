import 'package:dio/dio.dart';

import '../../../../core/errors/api_exception.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/pharmacy_discovery_models.dart';

class PharmacyDiscoveryRemoteDataSource {
  const PharmacyDiscoveryRemoteDataSource(this._dio);

  final Dio _dio;

  Future<PharmacyLocatorResult<RegisteredPharmacyLocation>>
  getRegisteredNearby({
    required double latitude,
    required double longitude,
    int radius = 5000,
    int take = 3,
  }) async {
    final json = await _get(
      ApiEndpoints.pharmaciesRegisteredNearby,
      query: {
        'lat': latitude,
        'lng': longitude,
        'radius': radius,
        'take': take,
      },
    );
    return _result(
      json,
      dataKey: 'data',
      parser: RegisteredPharmacyLocation.fromJson,
    );
  }

  Future<Map<String, dynamic>> getRegisteredDetails(
    String pharmacyId, {
    double? latitude,
    double? longitude,
  }) {
    final query = <String, dynamic>{};
    if (latitude != null) query['lat'] = latitude;
    if (longitude != null) query['lng'] = longitude;
    return _get(ApiEndpoints.registeredPharmacy(pharmacyId), query: query);
  }

  Future<PharmacyLocatorResult<ExternalPharmacy>> getNearby({
    required double latitude,
    required double longitude,
    int radius = 2000,
    bool useCache = true,
  }) async {
    final json = await _get(
      ApiEndpoints.pharmaciesNearby,
      query: {
        'lat': latitude,
        'lng': longitude,
        'radius': radius,
        'useCache': useCache,
      },
    );
    return _result(json, dataKey: 'data', parser: ExternalPharmacy.fromJson);
  }

  Future<PharmacyLocatorResult<ExternalPharmacy>> search({
    required double latitude,
    required double longitude,
    int radius = 2000,
    String? keyword,
    bool openNow = false,
    int maxResults = 20,
  }) async {
    final json = await _post(ApiEndpoints.pharmaciesSearch, {
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
      'type': 'pharmacy',
      'keyword': _optional(keyword),
      'openNow': openNow,
      'maxResults': maxResults,
    });
    return _result(json, dataKey: 'data', parser: ExternalPharmacy.fromJson);
  }

  Future<PharmacyLocatorResult<RegisteredPharmacyLocation>>
  getClosestRegistered({
    required double latitude,
    required double longitude,
    int take = 3,
  }) async {
    final json = await _get(
      ApiEndpoints.pharmaciesClosest,
      query: {'lat': latitude, 'lng': longitude, 'take': take},
    );
    return _result(
      json,
      dataKey: 'pharmacies',
      parser: RegisteredPharmacyLocation.fromJson,
    );
  }

  Future<PharmacyLocatorResult<ExternalClosestPharmacy>> getClosestExternal({
    required double latitude,
    required double longitude,
    int take = 3,
  }) async {
    final json = await _get(
      ApiEndpoints.pharmaciesExternalClosest,
      query: {'lat': latitude, 'lng': longitude, 'take': take},
    );
    return _result(
      json,
      dataKey: 'pharmacies',
      parser: ExternalClosestPharmacy.fromJson,
    );
  }

  Future<ExternalPharmacy> getExternalDetails(String placeId) async =>
      ExternalPharmacy.fromJson(
        await _get(ApiEndpoints.externalPharmacyDetails(placeId)),
      );

  Future<List<int>> getPhoto(String reference) async {
    try {
      final response = await _dio.get<List<int>>(
        ApiEndpoints.pharmaciesPhoto,
        queryParameters: {'reference': reference},
        options: Options(responseType: ResponseType.bytes),
      );
      return response.data ?? const [];
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<PharmacyLocatorHealth> getHealth() async =>
      PharmacyLocatorHealth.fromJson(await _get(ApiEndpoints.pharmaciesHealth));

  Future<String?> clearCache({int hours = 24}) async {
    final json = await _post(
      ApiEndpoints.pharmaciesCacheClear,
      null,
      query: {'hours': hours},
    );
    final message = json['message']?.toString();
    return message == null || message.trim().isEmpty ? null : message;
  }

  Future<Map<String, dynamic>> _get(
    String path, {
    Map<String, dynamic>? query,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: query,
      );
      return response.data ?? const {};
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<Map<String, dynamic>> _post(
    String path,
    Object? data, {
    Map<String, dynamic>? query,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        path,
        data: data,
        queryParameters: query,
      );
      return response.data ?? const {};
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }
}

PharmacyLocatorResult<T> _result<T>(
  Map<String, dynamic> json, {
  required String dataKey,
  required T Function(Map<String, dynamic>) parser,
}) {
  final items =
      (json[dataKey] as List?)
          ?.whereType<Map>()
          .map((item) => parser(Map<String, dynamic>.from(item)))
          .toList(growable: false) ??
      const [];
  final countValue = json['count'];
  return PharmacyLocatorResult(
    source: _optional(json['source']),
    count: countValue is num ? countValue.toInt() : items.length,
    items: items,
  );
}

String? _optional(Object? value) {
  final text = value?.toString().trim();
  return text == null || text.isEmpty ? null : text;
}
