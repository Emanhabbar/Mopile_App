import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/notification_models.dart';
import '../../data/repositories/notifications_repository.dart';

typedef NotificationFilter = ({bool unreadOnly, String? type});

final notificationsProvider = FutureProvider.autoDispose
    .family<List<AppNotification>, NotificationFilter>(
      (ref, filter) => ref
          .watch(notificationsRepositoryProvider)
          .getMine(unreadOnly: filter.unreadOnly, type: filter.type),
    );

final notificationSummaryProvider =
    FutureProvider.autoDispose<NotificationSummary>(
      (ref) => ref.watch(notificationsRepositoryProvider).getSummary(),
    );

final notificationUnreadCountProvider =
    FutureProvider.autoDispose<NotificationSummary>(
      (ref) => ref.watch(notificationsRepositoryProvider).getUnreadCount(),
    );
