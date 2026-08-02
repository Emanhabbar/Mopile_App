import 'package:dio/dio.dart';

import '../../../../core/errors/api_exception.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/prescription_models.dart';

class PrescriptionsRemoteDataSource {
  const PrescriptionsRemoteDataSource(this._dio);

  final Dio _dio;

  Future<PrescriptionOrder> analyze({
    required String filePath,
    required String fileName,
  }) async {
    try {
      final file = await MultipartFile.fromFile(filePath, filename: fileName);
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.prescriptionAnalyze,
        data: FormData.fromMap({'file': file}),
        options: Options(contentType: 'multipart/form-data'),
      );
      return PrescriptionOrder.fromJson(response.data ?? const {});
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<List<PrescriptionOrder>> getMine() async =>
      _getList(ApiEndpoints.myPrescriptions);

  Future<PrescriptionOrder> getById(String orderId) async =>
      _get(ApiEndpoints.prescription(orderId));

  Future<PrescriptionOrder> reserve(String orderId, String pharmacyId) async =>
      _post(ApiEndpoints.prescriptionReserve(orderId), {
        'pharmacyId': pharmacyId,
      });

  Future<PrescriptionOrder> cancel(String orderId) async =>
      _post(ApiEndpoints.prescriptionCancel(orderId), null);

  Future<PrescriptionOrder> activateReminders(
    String orderId,
    PrescriptionReminderRequest request,
  ) async =>
      _post(ApiEndpoints.prescriptionReminders(orderId), request.toJson());

  Future<List<PrescriptionOrder>> getPharmacyOrders() async =>
      _getList(ApiEndpoints.pharmacyPrescriptionOrders);

  Future<PrescriptionOrder> updatePharmacyStatus(
    String orderId, {
    required String status,
    String? pickupCode,
  }) async => _post(ApiEndpoints.pharmacyPrescriptionStatus(orderId), {
    'status': status,
    if (pickupCode?.trim().isNotEmpty == true) 'pickupCode': pickupCode!.trim(),
  });

  Future<PrescriptionOrder> _get(String path) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(path);
      return PrescriptionOrder.fromJson(response.data ?? const {});
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<List<PrescriptionOrder>> _getList(String path) async {
    try {
      final response = await _dio.get<List<dynamic>>(path);
      return (response.data ?? const [])
          .whereType<Map>()
          .map(
            (item) =>
                PrescriptionOrder.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList(growable: false);
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<PrescriptionOrder> _post(
    String path,
    Map<String, dynamic>? data,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(path, data: data);
      return PrescriptionOrder.fromJson(response.data ?? const {});
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }
}
