import 'package:dio/dio.dart';

import '../../../../core/errors/api_exception.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/chat_models.dart';

class ChatRemoteDataSource {
  const ChatRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<ChatSessionSummary>> getSessions({int take = 50}) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        ApiEndpoints.chatSessions,
        queryParameters: {'take': take},
      );
      return (response.data ?? const [])
          .whereType<Map>()
          .map(
            (item) =>
                ChatSessionSummary.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList(growable: false);
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<ChatSession> startSession({String? title}) async =>
      ChatSession.fromJson(
        await _post(ApiEndpoints.chatSessions, {
          if (title?.trim().isNotEmpty == true) 'title': title!.trim(),
        }),
      );

  Future<ChatSession> getSession(String sessionId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.chatSession(sessionId),
      );
      return ChatSession.fromJson(response.data ?? const {});
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<ChatReply> sendMessage(
    String sessionId, {
    required String message,
    double? latitude,
    double? longitude,
  }) async => ChatReply.fromJson(
    await _post(ApiEndpoints.chatMessages(sessionId), {
      'message': message.trim(),
      'latitude': ?latitude,
      'longitude': ?longitude,
      'radiusInMeters': 5000,
      'take': 5,
      'sortBy': 'BestMatch',
      if (latitude != null) 'source': 'BrowserGps',
    }),
  );

  Future<ChatSession> endSession(String sessionId) async =>
      ChatSession.fromJson(await _post(ApiEndpoints.chatEnd(sessionId), null));

  Future<Map<String, dynamic>> _post(
    String path,
    Map<String, dynamic>? data,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(path, data: data);
      return response.data ?? const {};
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }
}
