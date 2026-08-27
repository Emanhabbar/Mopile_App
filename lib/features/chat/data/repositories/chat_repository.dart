import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../data_sources/chat_remote_data_source.dart';
import '../models/chat_models.dart';

final chatRepositoryProvider = Provider<ChatRepository>(
  (ref) => ChatRepository(ChatRemoteDataSource(ref.watch(dioProvider))),
);

class ChatRepository {
  const ChatRepository(this.remote);
  final ChatRemoteDataSource remote;

  Future<List<ChatSessionSummary>> getSessions() => remote.getSessions();
  Future<ChatSession> startSession({String? title}) =>
      remote.startSession(title: title);
  Future<ChatSession> getSession(String id) => remote.getSession(id);
  Future<ChatReply> sendMessage(
    String id, {
    required String message,
    double? latitude,
    double? longitude,
  }) => remote.sendMessage(
    id,
    message: message,
    latitude: latitude,
    longitude: longitude,
  );
  Future<ChatSession> endSession(String id) => remote.endSession(id);
}
