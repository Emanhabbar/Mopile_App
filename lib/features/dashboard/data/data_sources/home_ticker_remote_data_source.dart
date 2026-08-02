import 'package:dio/dio.dart';

import '../../../../core/errors/api_exception.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/home_ticker_item.dart';

class HomeTickerRemoteDataSource {
  const HomeTickerRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<HomeTickerItem>> getPublished() async {
    try {
      final response = await _dio.get<List<dynamic>>(ApiEndpoints.homeTicker);
      return (response.data ?? const [])
          .whereType<Map>()
          .map(
            (item) => HomeTickerItem.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList(growable: false);
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }
}
