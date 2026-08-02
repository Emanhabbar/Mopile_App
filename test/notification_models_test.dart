import 'package:flutter_test/flutter_test.dart';
import 'package:pharmacy_app/features/notifications/data/models/notification_models.dart';

void main() {
  group('Notification API models', () {
    test('parses notification and related entity data', () {
      final notification = AppNotification.fromJson({
        'id': 'notification-1',
        'type': 'PrescriptionStatusUpdated',
        'title': 'تحديث حالة الوصفة',
        'message': 'أصبحت وصفتك جاهزة للاستلام.',
        'relatedEntityId': 'order-1',
        'relatedEntityType': 'PrescriptionOrder',
        'isRead': false,
        'createdAtUtc': '2026-07-31T12:00:00Z',
        'readAtUtc': null,
      });

      expect(notification.id, 'notification-1');
      expect(notification.relatedEntityId, 'order-1');
      expect(notification.relatedEntityType, 'PrescriptionOrder');
      expect(notification.isRead, isFalse);
    });

    test('parses notification summary counts', () {
      final summary = NotificationSummary.fromJson({
        'totalCount': 12,
        'unreadCount': 3,
        'readCount': 9,
        'latestCreatedAtUtc': '2026-07-31T12:00:00Z',
        'unreadByType': [
          {'type': 'PrescriptionStatusUpdated', 'count': 2},
          {'type': 'MedicineRequestUpdated', 'count': 1},
        ],
      });

      expect(summary.totalCount, 12);
      expect(summary.unreadCount, 3);
      expect(summary.unreadByType.length, 2);
      expect(summary.unreadByType.first.count, 2);
    });
  });
}
