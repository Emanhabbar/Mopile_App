import 'package:flutter_test/flutter_test.dart';
import 'package:pharmacy_app/features/chat/data/models/chat_models.dart';

void main() {
  group('Chat API models', () {
    test('parses session details and messages', () {
      final session = ChatSession.fromJson({
        'sessionId': 'session-1',
        'title': 'استفسار دوائي',
        'startedAtUtc': '2026-07-31T10:00:00Z',
        'lastActivityAtUtc': '2026-07-31T10:01:00Z',
        'isEnded': false,
        'messages': [
          {
            'messageId': 'message-1',
            'senderType': 'User',
            'content': 'أين أجد الدواء؟',
            'sentAtUtc': '2026-07-31T10:00:00Z',
          },
          {
            'messageId': 'message-2',
            'senderType': 'Bot',
            'content': 'يمكنني مساعدتك.',
            'sentAtUtc': '2026-07-31T10:01:00Z',
          },
        ],
      });

      expect(session.sessionId, 'session-1');
      expect(session.messages.length, 2);
      expect(session.messages.first.isUser, isTrue);
      expect(session.messages.last.isUser, isFalse);
    });

    test('parses reply actions and session state', () {
      final reply = ChatReply.fromJson({
        'sessionId': 'session-1',
        'detectedIntent': 'FindMedicine',
        'replyMessage': 'هذه النتائج القريبة.',
        'requiresLocation': true,
        'sessionEnded': false,
        'newMessages': [],
        'suggestedActions': [
          {
            'actionType': 'OpenNearbyPharmacies',
            'label': 'عرض الصيدليات',
            'endpoint': '/api/Users/me/nearest-pharmacies',
          },
        ],
        'requiresPharmacist': false,
      });

      expect(reply.detectedIntent, 'FindMedicine');
      expect(reply.requiresLocation, isTrue);
      expect(reply.suggestedActions.single.label, 'عرض الصيدليات');
    });
  });
}
