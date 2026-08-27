import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../data_sources/notifications_remote_data_source.dart';
import '../models/notification_models.dart';

final notificationsRepositoryProvider = Provider<NotificationsRepository>(
  (ref) => NotificationsRepository(
    NotificationsRemoteDataSource(ref.watch(dioProvider)),
  ),
);

class NotificationsRepository {
  const NotificationsRepository(this.remote);

  final NotificationsRemoteDataSource remote;

  Future<List<AppNotification>> getMine({
    int take = 50,
    bool unreadOnly = false,
    String? type,
  }) => remote.getMine(take: take, unreadOnly: unreadOnly, type: type);
  Future<NotificationSummary> getSummary() => remote.getSummary();
  Future<NotificationSummary> getUnreadCount() => remote.getUnreadCount();
  Future<AppNotification> markRead(String id) => remote.markRead(id);
  Future<int> markAllRead() => remote.markAllRead();
}
