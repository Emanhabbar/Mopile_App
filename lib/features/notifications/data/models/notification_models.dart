class AppNotification {
  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAtUtc,
    this.relatedEntityId,
    this.relatedEntityType,
    this.readAtUtc,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      AppNotification(
        id: json['id']?.toString() ?? '',
        type: json['type']?.toString() ?? '',
        title: json['title']?.toString() ?? '',
        message: json['message']?.toString() ?? '',
        relatedEntityId: _optional(json['relatedEntityId']),
        relatedEntityType: _optional(json['relatedEntityType']),
        isRead: json['isRead'] == true,
        createdAtUtc:
            DateTime.tryParse(json['createdAtUtc']?.toString() ?? '') ??
            DateTime.now().toUtc(),
        readAtUtc: DateTime.tryParse(json['readAtUtc']?.toString() ?? ''),
      );

  final String id;
  final String type;
  final String title;
  final String message;
  final String? relatedEntityId;
  final String? relatedEntityType;
  final bool isRead;
  final DateTime createdAtUtc;
  final DateTime? readAtUtc;
}

class NotificationSummary {
  const NotificationSummary({
    required this.totalCount,
    required this.unreadCount,
    required this.readCount,
    required this.unreadByType,
    this.latestCreatedAtUtc,
  });

  factory NotificationSummary.fromJson(Map<String, dynamic> json) {
    final rawTypes = json['unreadByType'];
    return NotificationSummary(
      totalCount: _integer(json['totalCount']),
      unreadCount: _integer(json['unreadCount']),
      readCount: _integer(json['readCount']),
      latestCreatedAtUtc: DateTime.tryParse(
        json['latestCreatedAtUtc']?.toString() ?? '',
      ),
      unreadByType: rawTypes is List
          ? rawTypes
                .whereType<Map>()
                .map(
                  (item) => NotificationTypeCount.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList(growable: false)
          : const [],
    );
  }

  final int totalCount;
  final int unreadCount;
  final int readCount;
  final DateTime? latestCreatedAtUtc;
  final List<NotificationTypeCount> unreadByType;
}

class NotificationTypeCount {
  const NotificationTypeCount({required this.type, required this.count});

  factory NotificationTypeCount.fromJson(Map<String, dynamic> json) =>
      NotificationTypeCount(
        type: json['type']?.toString() ?? '',
        count: _integer(json['count']),
      );

  final String type;
  final int count;
}

String? _optional(Object? value) {
  final text = value?.toString().trim();
  return text == null || text.isEmpty ? null : text;
}

int _integer(Object? value) =>
    value is num ? value.toInt() : int.tryParse('$value') ?? 0;
