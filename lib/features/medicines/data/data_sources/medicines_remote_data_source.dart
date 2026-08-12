import 'package:dio/dio.dart';

import '../../../../core/errors/api_exception.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/medicine_models.dart';

class MedicinesRemoteDataSource {
  const MedicinesRemoteDataSource(this._dio);

  final Dio _dio;

  Future<MedicinePage> getMedicines({
    String? searchTerm,
    int pageNumber = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.medicines,
        queryParameters: {
          if (searchTerm?.trim().isNotEmpty == true)
            'searchTerm': searchTerm!.trim(),
          'pageNumber': pageNumber,
          'pageSize': pageSize,
        },
      );
      return MedicinePage.fromJson(response.data ?? const {});
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<Medicine> getMedicine(String id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.medicine(id),
      );
      return Medicine.fromJson(response.data ?? const {});
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<Medicine> createMedicine(CreateMedicine request) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.medicines,
        data: request.toJson(),
      );
      return Medicine.fromJson(response.data ?? const {});
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<Medicine> updateLocalization(
    String id,
    UpdateMedicineLocalization request,
  ) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        ApiEndpoints.medicineLocalization(id),
        data: request.toJson(),
      );
      return Medicine.fromJson(response.data ?? const {});
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }
}
