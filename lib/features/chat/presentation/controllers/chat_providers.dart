import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/chat_models.dart';
import '../../data/repositories/chat_repository.dart';

final chatSessionsProvider =
    FutureProvider.autoDispose<List<ChatSessionSummary>>(
      (ref) => ref.watch(chatRepositoryProvider).getSessions(),
    );
final chatSessionProvider = FutureProvider.autoDispose
    .family<ChatSession, String>(
      (ref, id) => ref.watch(chatRepositoryProvider).getSession(id),
    );
