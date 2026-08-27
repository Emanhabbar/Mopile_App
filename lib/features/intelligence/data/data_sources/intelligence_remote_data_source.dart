import 'package:dio/dio.dart';

import '../../../../core/errors/api_exception.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/intelligence_models.dart';

class IntelligenceRemoteDataSource {
  const IntelligenceRemoteDataSource(this._dio);
  final Dio _dio;

  Future<IntelligenceHealth> getHealth() async =>
      IntelligenceHealth.fromJson(await _get(ApiEndpoints.intelligenceHealth));

  Future<AlternativeMedicineResult> getAlternatives(
    String medicineName, {
    int topN = 5,
  }) async => AlternativeMedicineResult.fromJson(
    await _post(ApiEndpoints.intelligenceAlternatives, {
      'medicineName': medicineName,
      'topN': topN,
    }),
  );

  Future<StockoutPrediction> predictStockout({
    required int stockQuantity,
    required int quantitySold,
    required double averageDailyConsumption,
    required int last7DaysSales,
    required int last30DaysSales,
    required int month,
  }) async => StockoutPrediction.fromJson(
    await _post(ApiEndpoints.intelligenceStockout, {
      'stockQuantity': stockQuantity,
      'quantitySold': quantitySold,
      'avgDailyConsumption': averageDailyConsumption,
      'last7DaysSales': last7DaysSales,
      'last30DaysSales': last30DaysSales,
      'month': month,
    }),
  );

  Future<Map<String, dynamic>> _get(String path) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(path);
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
}
