import 'package:dio/dio.dart';
import 'package:file_selector/file_selector.dart';
import 'package:http_parser/http_parser.dart';

import '../../../../core/errors/api_exception.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/pharmacy_models.dart';

class PharmacyRemoteDataSource {
  const PharmacyRemoteDataSource(this._dio);
  final Dio _dio;

  Future<PharmacyDashboard> getDashboard() async =>
      PharmacyDashboard.fromJson(await _get(ApiEndpoints.pharmacyDashboard));
  Future<PharmacyDashboard> getProfile() async =>
      PharmacyDashboard.fromJson(await _get(ApiEndpoints.pharmacyMe));
  Future<PharmacyOpenStatus> getOpenStatus() async =>
      PharmacyOpenStatus.fromJson(await _get(ApiEndpoints.pharmacyOpenStatus));

  Future<PharmacyLicenseVerification?> getLicenseVerification() async {
    try {
      final response = await _dio.get<Object?>(
        ApiEndpoints.pharmacyLicenseVerification,
      );
      return response.data is Map
          ? PharmacyLicenseVerification.fromJson(
              Map<String, dynamic>.from(response.data! as Map),
            )
          : null;
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<PharmacyLicenseVerification> submitLicenseVerification(
    XFile file,
  ) async {
    final bytes = await file.readAsBytes();
    final contentType = _licenseMediaType(file.name);
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.pharmacyLicenseVerification,
        data: FormData.fromMap({
          'File': MultipartFile.fromBytes(
            bytes,
            filename: file.name,
            contentType: contentType,
          ),
        }),
      );
      return PharmacyLicenseVerification.fromJson(response.data ?? const {});
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<PharmacyDashboard> updateProfile({
    required String pharmacyName,
    required String city,
    required String area,
    required String address,
    required bool hasDeliveryService,
    String? description,
    String? timeZoneId,
  }) async => PharmacyDashboard.fromJson(
    await _put(ApiEndpoints.pharmacyProfile, {
      'pharmacyName': pharmacyName,
      'description': description,
      'city': city,
      'area': area,
      'address': address,
      'timeZoneId': timeZoneId,
      'hasDeliveryService': hasDeliveryService,
    }),
  );

  Future<PharmacyDashboard> updateLocation({
    required double latitude,
    required double longitude,
    double? accuracyMeters,
    String? city,
    String? area,
    String? address,
    String? timeZoneId,
  }) async => PharmacyDashboard.fromJson(
    await _put(ApiEndpoints.pharmacyLocation, {
      'latitude': latitude,
      'longitude': longitude,
      'accuracyMeters': accuracyMeters,
      'city': city,
      'area': area,
      'address': address,
      'timeZoneId': timeZoneId,
      'tryVerifyWithGoogle': true,
      'overwriteNameFromGoogle': false,
      'overwriteAddressFromGoogle': true,
    }),
  );

  Future<List<PharmacyWorkingPeriod>> getWorkingHours() async {
    final response = await _getList(ApiEndpoints.pharmacyWorkingHours);
    return _parseList(response, PharmacyWorkingPeriod.fromJson);
  }

  Future<List<PharmacyLocationCandidate>> getLocationCandidates({
    double? latitude,
    double? longitude,
  }) async {
    final response = await _getList(
      ApiEndpoints.pharmacyLocationCandidates,
      query: {
        'latitude': ?latitude,
        'longitude': ?longitude,
        'radiusInMeters': 500,
        'take': 5,
      },
    );
    return _parseList(response, PharmacyLocationCandidate.fromJson);
  }

  Future<PharmacyDashboard> linkLocation(String placeId) async =>
      PharmacyDashboard.fromJson(
        await _post(ApiEndpoints.pharmacyLocationLink, {
          'placeId': placeId,
          'overwriteName': false,
          'overwriteAddress': true,
        }),
      );

  Future<List<PharmacyWorkingPeriod>> updateWorkingHours(
    List<PharmacyWorkingPeriod> periods,
  ) async {
    try {
      final response = await _dio.put<List<dynamic>>(
        ApiEndpoints.pharmacyWorkingHours,
        data: {'periods': periods.map((item) => item.toJson()).toList()},
      );
      return _parseList(
        response.data ?? const [],
        PharmacyWorkingPeriod.fromJson,
      );
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<List<PharmacyInventoryItem>> getInventory({
    String? searchTerm,
    bool availableOnly = false,
    String? stockStatus,
    int? expiringWithinDays,
  }) async {
    final response = await _getList(
      ApiEndpoints.pharmacyMedicines,
      query: {
        if (searchTerm?.trim().isNotEmpty == true)
          'searchTerm': searchTerm!.trim(),
        'availableOnly': availableOnly,
        if (stockStatus?.isNotEmpty == true) 'stockStatus': stockStatus,
        'expiringWithinDays': ?expiringWithinDays,
      },
    );
    return _parseList(response, PharmacyInventoryItem.fromJson);
  }

  Future<PharmacyInventoryItem> addInventory({
    required String medicineId,
    required int quantity,
    required double unitPrice,
    required bool isPriceVisibleToUsers,
    required bool isAvailable,
    required int lowStockThreshold,
    DateTime? expiryDate,
  }) async => PharmacyInventoryItem.fromJson(
    await _post(ApiEndpoints.pharmacyMedicines, {
      'medicineId': medicineId,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'isPriceVisibleToUsers': isPriceVisibleToUsers,
      'isAvailable': isAvailable,
      'expiryDateUtc': expiryDate?.toUtc().toIso8601String(),
      'lowStockThreshold': lowStockThreshold,
    }),
  );

  Future<PharmacyInventoryItem> addManualInventory({
    required String name,
    required int quantity,
    required double unitPrice,
    required bool isPriceVisibleToUsers,
    required bool isAvailable,
    required int lowStockThreshold,
    required bool requiresPrescription,
    String? barcode,
    String? arabicName,
    String? scientificName,
    String? arabicScientificName,
    String? manufacturer,
    String? dosageForm,
    String? packageSize,
    String? capacity,
    String? composition,
    String? description,
    DateTime? expiryDate,
  }) async => PharmacyInventoryItem.fromJson(
    await _post(ApiEndpoints.pharmacyMedicinesManual, {
      'name': name,
      'barcode': barcode,
      'arabicName': arabicName,
      'scientificName': scientificName,
      'arabicScientificName': arabicScientificName,
      'manufacturer': manufacturer,
      'dosageForm': dosageForm,
      'packageSize': packageSize,
      'capacity': capacity,
      'composition': composition,
      'description': description,
      'requiresPrescription': requiresPrescription,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'isPriceVisibleToUsers': isPriceVisibleToUsers,
      'isAvailable': isAvailable,
      'expiryDateUtc': expiryDate?.toUtc().toIso8601String(),
      'lowStockThreshold': lowStockThreshold,
    }),
  );

  Future<List<PharmacyInventoryItem>> addInventoryBatch({
    required List<PharmacyInventoryBatchItemInput> items,
  }) async {
    final response = await _postList(ApiEndpoints.pharmacyMedicinesBatch, {
      'items': items.map((item) => item.toJson()).toList(growable: false),
    });
    return _parseList(response, PharmacyInventoryItem.fromJson);
  }

  Future<PharmacyInventoryItem> updateInventory(
    String inventoryItemId, {
    required int quantity,
    required double unitPrice,
    required bool isPriceVisibleToUsers,
    required bool isAvailable,
    required int lowStockThreshold,
    DateTime? expiryDate,
  }) async => PharmacyInventoryItem.fromJson(
    await _put(ApiEndpoints.pharmacyMedicine(inventoryItemId), {
      'quantity': quantity,
      'unitPrice': unitPrice,
      'isPriceVisibleToUsers': isPriceVisibleToUsers,
      'isAvailable': isAvailable,
      'expiryDateUtc': expiryDate?.toUtc().toIso8601String(),
      'lowStockThreshold': lowStockThreshold,
    }),
  );

  Future<void> deleteInventory(String inventoryItemId) async {
    try {
      await _dio.delete<void>(ApiEndpoints.pharmacyMedicine(inventoryItemId));
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<PharmacyCatalogPage> searchCatalog(
    String searchTerm, {
    int pageNumber = 1,
    int pageSize = 30,
  }) async {
    final response = await _get(
      ApiEndpoints.pharmacyMedicineCatalog,
      query: {
        'searchTerm': searchTerm.trim(),
        'pageNumber': pageNumber,
        'pageSize': pageSize,
      },
    );
    return PharmacyCatalogPage.fromJson(response);
  }

  Future<List<PharmacyRequest>> getRequests({
    String? status,
    String? searchTerm,
  }) async {
    final response = await _getList(
      ApiEndpoints.pharmacyRequests,
      query: {
        if (status?.isNotEmpty == true) 'status': status,
        if (searchTerm?.trim().isNotEmpty == true)
          'searchTerm': searchTerm!.trim(),
        'take': 50,
      },
    );
    return _parseList(response, PharmacyRequest.fromJson);
  }

  Future<PharmacyRequestDetails> getRequest(String requestId) async =>
      PharmacyRequestDetails.fromJson(
        await _get(ApiEndpoints.pharmacyRequest(requestId)),
      );

  Future<PharmacyRequestDetails> respondToRequest(
    String requestId, {
    required String status,
    String? responseNote,
    String? alternativeMedicineId,
  }) async => PharmacyRequestDetails.fromJson(
    await _put(ApiEndpoints.pharmacyRequestResponse(requestId), {
      'status': status,
      'pharmacyResponseNote': responseNote,
      'suggestedAlternativeMedicineId': status == 'Unavailable'
          ? alternativeMedicineId
          : null,
    }),
  );

  Future<PharmacyRequestDetails> confirmRequestPickup(String requestId) async =>
      PharmacyRequestDetails.fromJson(
        await _post(ApiEndpoints.pharmacyConfirmRequestPickup(requestId), {}),
      );

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

  Future<List<dynamic>> _getList(
    String path, {
    Map<String, dynamic>? query,
  }) async {
    try {
      final response = await _dio.get<Object?>(path, queryParameters: query);
      final data = response.data;
      if (data is List) return List<dynamic>.from(data);

      // Catalog endpoints return a paged object, while the remaining pharmacy
      // collections return a JSON array directly.
      if (data is Map && data['items'] is List) {
        return List<dynamic>.from(data['items'] as List);
      }

      throw const ApiException('استجابة القائمة من الخادم غير صالحة.');
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<Map<String, dynamic>> _put(
    String path,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(path, data: data);
      return response.data ?? const {};
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<Map<String, dynamic>> _post(
    String path,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(path, data: data);
      return response.data ?? const {};
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<List<dynamic>> _postList(
    String path,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.post<List<dynamic>>(path, data: data);
      return response.data ?? const [];
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }
}

MediaType _licenseMediaType(String fileName) {
  final extension = fileName.split('.').last.toLowerCase();
  return switch (extension) {
    'png' => MediaType('image', 'png'),
    'webp' => MediaType('image', 'webp'),
    _ => MediaType('image', 'jpeg'),
  };
}

List<T> _parseList<T>(
  List<dynamic> value,
  T Function(Map<String, dynamic>) parser,
) => value
    .whereType<Map>()
    .map((item) => parser(Map<String, dynamic>.from(item)))
    .toList(growable: false);
