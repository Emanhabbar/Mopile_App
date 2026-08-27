import 'package:dio/dio.dart';

import '../../../../core/errors/api_exception.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/notification_models.dart';

class NotificationsRemoteDataSource {
  const NotificationsRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<AppNotification>> getMine({
    int take = 50,
    bool unreadOnly = false,
    String? type,
  }) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        ApiEndpoints.notifications,
        queryParameters: {
          'take': take,
          'unreadOnly': unreadOnly,
          if (type?.trim().isNotEmpty == true) 'type': type!.trim(),
        },
      );
      return (response.data ?? const [])
          .whereType<Map>()
          .map(
            (item) => AppNotification.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList(growable: false);
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<NotificationSummary> getSummary() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.notificationSummary,
      );
      return NotificationSummary.fromJson(response.data ?? const {});
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<NotificationSummary> getUnreadCount() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.notificationUnreadCount,
      );
      return NotificationSummary.fromJson(response.data ?? const {});
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<AppNotification> markRead(String notificationId) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.notificationRead(notificationId),
      );
      return AppNotification.fromJson(response.data ?? const {});
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<int> markAllRead() async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.notificationReadAll,
      );
      final value = response.data?['updatedCount'];
      return value is num ? value.toInt() : int.tryParse('$value') ?? 0;
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }
}
