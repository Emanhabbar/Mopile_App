import 'package:dio/dio.dart';

import '../../../../core/errors/api_exception.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/user_discovery_models.dart';
import '../models/user_models.dart';
import '../models/user_request_models.dart';

class UserRemoteDataSource {
  const UserRemoteDataSource(this._dio);

  final Dio _dio;

  Future<UserDashboard> getDashboard() async {
    final data = await _get(
      ApiEndpoints.userDashboard,
      queryParameters: const {
        'take': 3,
        'externalTake': 3,
        'includeExternalFallback': true,
      },
    );
    return UserDashboard.fromJson(data);
  }

  Future<UserProfile> getProfile() async {
    return UserProfile.fromJson(await _get(ApiEndpoints.userMe));
  }

  Future<UserMedicalProfile> getMedicalProfile() async {
    return UserMedicalProfile.fromJson(
      await _get(ApiEndpoints.userMedicalProfile),
    );
  }

  Future<UserHealthCard> getHealthCard() async {
    return UserHealthCard.fromJson(await _get(ApiEndpoints.userHealthCard));
  }

  Future<UserMedicalProfile> updateMedicalProfile(
    UpdateMedicalProfileRequest request,
  ) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        ApiEndpoints.userMedicalProfile,
        data: request.toJson(),
      );
      return UserMedicalProfile.fromJson(response.data ?? const {});
    } on DioException catch (exception) {
      throw ApiException.fromDio(exception);
    }
  }

  Future<UserProfile> updateLocation(UserLocationUpdate request) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        ApiEndpoints.userLocation,
        data: request.toJson(),
      );
      return UserProfile.fromJson(response.data ?? const {});
    } on DioException catch (exception) {
      throw ApiException.fromDio(exception);
    }
  }

  Future<UserLocationDiscovery> getLocationContext(
    UserNearbyQuery request,
  ) async {
    return UserLocationDiscovery.fromJson(
      await _get(
        ApiEndpoints.userLocationContext,
        queryParameters: request.toQuery(),
      ),
    );
  }

  Future<UserNearestRoute> getNearestRoute(
    UserNearbyQuery request, {
    String? pharmacyId,
  }) async {
    return UserNearestRoute.fromJson(
      await _get(
        ApiEndpoints.userNearestPharmacyRoute,
        queryParameters: {
          if (pharmacyId?.isNotEmpty == true) 'pharmacyId': pharmacyId,
          if (request.latitude != null) 'latitude': request.latitude,
          if (request.longitude != null) 'longitude': request.longitude,
          'radiusInMeters': request.radiusInMeters,
        },
      ),
    );
  }

  Future<List<UserPharmacySummary>> getNearestPharmacies(
    UserNearbyQuery request,
  ) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        ApiEndpoints.userNearestPharmacies,
        queryParameters: request.toQuery(),
      );
      return (response.data ?? const [])
          .whereType<Map>()
          .map(
            (item) =>
                UserPharmacySummary.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList(growable: false);
    } on DioException catch (exception) {
      throw ApiException.fromDio(exception);
    }
  }

  Future<List<NearbyMedicineResult>> searchMedicines(
    UserMedicineSearch request,
  ) async {
    try {
      final response = await _dio.post<List<dynamic>>(
        ApiEndpoints.userMedicineSearch,
        data: request.toJson(),
      );
      return (response.data ?? const [])
          .whereType<Map>()
          .map(
            (item) =>
                NearbyMedicineResult.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList(growable: false);
    } on DioException catch (exception) {
      throw ApiException.fromDio(exception);
    }
  }

  Future<UserPharmacyDetails> getPharmacyDetails(String pharmacyId) async {
    return UserPharmacyDetails.fromJson(
      await _get(ApiEndpoints.userPharmacy(pharmacyId)),
    );
  }

  Future<UserMedicineRequestResult> createMedicineRequest(
    String pharmacyId,
    CreateMedicineRequest request,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.userPharmacyRequest(pharmacyId),
        data: request.toJson(),
      );
      return UserMedicineRequestResult.fromJson(response.data ?? const {});
    } on DioException catch (exception) {
      throw ApiException.fromDio(exception);
    }
  }

  Future<PharmacyRating> ratePharmacy(
    String pharmacyId, {
    required int score,
    String? comment,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.userRatePharmacy(pharmacyId),
        data: {'score': score, 'comment': comment},
      );
      return PharmacyRating.fromJson(response.data ?? const {});
    } on DioException catch (exception) {
      throw ApiException.fromDio(exception);
    }
  }

  Future<List<UserMedicineRequest>> getMedicineRequests({
    String? status,
    int take = 50,
  }) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        ApiEndpoints.userMedicineRequests,
        queryParameters: {
          if (status != null && status.isNotEmpty) 'status': status,
          'take': take,
        },
      );
      return _objectList(response.data, UserMedicineRequest.fromJson);
    } on DioException catch (exception) {
      throw ApiException.fromDio(exception);
    }
  }

  Future<UserMedicineRequestDetails> getMedicineRequest(
    String requestId,
  ) async {
    return UserMedicineRequestDetails.fromJson(
      await _get(ApiEndpoints.userMedicineRequest(requestId)),
    );
  }

  Future<UserMedicineRequestDetails> cancelMedicineRequest(
    String requestId,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.userCancelMedicineRequest(requestId),
      );
      return UserMedicineRequestDetails.fromJson(response.data ?? const {});
    } on DioException catch (exception) {
      throw ApiException.fromDio(exception);
    }
  }

  Future<List<UserSearchRecord>> getSearchHistory({int take = 50}) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        ApiEndpoints.userSearchHistory,
        queryParameters: {'take': take},
      );
      return _objectList(response.data, UserSearchRecord.fromJson);
    } on DioException catch (exception) {
      throw ApiException.fromDio(exception);
    }
  }

  Future<void> deleteSearchHistoryItem(String historyId) async {
    try {
      await _dio.delete<void>(ApiEndpoints.userSearchHistoryItem(historyId));
    } on DioException catch (exception) {
      throw ApiException.fromDio(exception);
    }
  }

  Future<void> clearSearchHistory() async {
    try {
      await _dio.delete<void>(ApiEndpoints.userSearchHistory);
    } on DioException catch (exception) {
      throw ApiException.fromDio(exception);
    }
  }

  Future<Map<String, dynamic>> _get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
      );
      return response.data ?? const {};
    } on DioException catch (exception) {
      throw ApiException.fromDio(exception);
    }
  }
}

List<T> _objectList<T>(
  Object? value,
  T Function(Map<String, dynamic>) converter,
) => value is List
    ? value
          .whereType<Map>()
          .map((item) => converter(Map<String, dynamic>.from(item)))
          .toList(growable: false)
    : const [];
