import 'package:dio/dio.dart';

import '../../../../core/errors/api_exception.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/admin_models.dart';

class AdminRemoteDataSource {
  const AdminRemoteDataSource(this._dio);
  final Dio _dio;

  Future<AdminDashboard> getDashboard() async =>
      AdminDashboard.fromJson(await _get(ApiEndpoints.adminDashboard));
  Future<List<AdminPharmacy>> getPendingPharmacies() async =>
      _getList(ApiEndpoints.adminPendingPharmacies, AdminPharmacy.fromJson);
  Future<List<AdminOrganization>> getPendingOrganizations() async => _getList(
    ApiEndpoints.adminPendingOrganizations,
    AdminOrganization.fromJson,
  );
  Future<List<AdminWarehouse>> getPendingWarehouses() async =>
      _getList(ApiEndpoints.adminPendingWarehouses, AdminWarehouse.fromJson);
  Future<void> approvePharmacy(String id, bool approved) async =>
      _put(ApiEndpoints.adminPharmacyApproval(id), {'isApproved': approved});
  Future<void> approveOrganization(String id, bool approved) async => _put(
    ApiEndpoints.adminOrganizationApproval(id),
    {'isApproved': approved},
  );
  Future<void> approveWarehouse(String id, bool approved) async =>
      _put(ApiEndpoints.adminWarehouseApproval(id), {'isApproved': approved});
  Future<void> reviewOrganization(
    String id, {
    required String status,
    String? notes,
  }) async => _put(ApiEndpoints.adminOrganizationVerification(id), {
    'verificationStatus': status,
    'verificationNotes': notes,
  });

  Future<Map<String, dynamic>> getOrganizationVerification(String id) =>
      _get(ApiEndpoints.adminOrganizationVerification(id));

  Future<AdminDownloadedDocument> getOrganizationDocument(
    String organizationId,
    String documentId,
  ) async {
    try {
      final response = await _dio.get<List<int>>(
        ApiEndpoints.adminOrganizationVerificationDocument(
          organizationId,
          documentId,
        ),
        options: Options(responseType: ResponseType.bytes),
      );
      return (
        bytes: response.data ?? const [],
        fileName: response.headers.value('content-disposition'),
        contentType: response.headers.value('content-type'),
      );
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<List<AdminAccount>> getAccounts({
    String? search,
    String? role,
    String? status,
  }) async => _getList(
    ApiEndpoints.adminAccounts,
    AdminAccount.fromJson,
    query: {
      if (search?.trim().isNotEmpty == true) 'search': search!.trim(),
      if (role?.isNotEmpty == true) 'role': role,
      if (status?.isNotEmpty == true) 'status': status,
    },
  );
  Future<void> updateAccountStatus(
    String id,
    bool active, {
    String? reason,
  }) async {
    try {
      await _dio.put<void>(
        ApiEndpoints.adminAccountStatus(id),
        data: {'isActive': active, 'reason': reason},
      );
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<Map<String, dynamic>> getAccountDetails(String id) =>
      _get(ApiEndpoints.adminAccount(id));

  Future<List<HomeTickerItem>> getTicker() async =>
      _getList(ApiEndpoints.adminHomeTicker, HomeTickerItem.fromJson);
  Future<List<HomeTickerPharmacy>> getTickerPharmacies() async => _getList(
    ApiEndpoints.adminHomeTickerPharmacies,
    HomeTickerPharmacy.fromJson,
  );
  Future<HomeTickerItem> saveTicker({
    String? id,
    String type = 'Announcement',
    required String title,
    required String message,
    required bool active,
    String? pharmacyProfileId,
  }) async {
    final data = {
      'type': type,
      'title': title,
      'message': message,
      'pharmacyProfileId': type == 'DutyPharmacy' ? pharmacyProfileId : null,
      'isActive': active,
      'sortOrder': 0,
    };
    final json = id == null
        ? await _post(ApiEndpoints.adminHomeTicker, data)
        : await _put(ApiEndpoints.adminHomeTickerItem(id), data);
    return HomeTickerItem.fromJson(json);
  }

  Future<void> deleteTicker(String id) async {
    try {
      await _dio.delete<void>(ApiEndpoints.adminHomeTickerItem(id));
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<Map<String, dynamic>> _get(String path) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(path);
      return response.data ?? const {};
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<List<T>> _getList<T>(
    String path,
    T Function(Map<String, dynamic>) parser, {
    Map<String, dynamic>? query,
  }) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        path,
        queryParameters: query,
      );
      return (response.data ?? const [])
          .whereType<Map>()
          .map((item) => parser(Map<String, dynamic>.from(item)))
          .toList(growable: false);
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
}
