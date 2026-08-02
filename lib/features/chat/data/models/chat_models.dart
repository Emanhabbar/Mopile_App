class ChatSessionSummary {
  const ChatSessionSummary({
    required this.sessionId,
    required this.title,
    required this.startedAtUtc,
    required this.lastActivityAtUtc,
    required this.isEnded,
    required this.messagesCount,
    this.endedAtUtc,
    this.lastMessagePreview,
  });

  factory ChatSessionSummary.fromJson(Map<String, dynamic> json) =>
      ChatSessionSummary(
        sessionId: _text(json['sessionId']),
        title: _text(json['title']),
        startedAtUtc: _date(json['startedAtUtc']),
        lastActivityAtUtc: _date(json['lastActivityAtUtc']),
        endedAtUtc: _optionalDate(json['endedAtUtc']),
        isEnded: json['isEnded'] == true,
        messagesCount: _integer(json['messagesCount']),
        lastMessagePreview: _optional(json['lastMessagePreview']),
      );

  final String sessionId;
  final String title;
  final DateTime startedAtUtc;
  final DateTime lastActivityAtUtc;
  final DateTime? endedAtUtc;
  final bool isEnded;
  final int messagesCount;
  final String? lastMessagePreview;
}

class ChatSession {
  const ChatSession({
    required this.sessionId,
    required this.title,
    required this.startedAtUtc,
    required this.lastActivityAtUtc,
    required this.isEnded,
    required this.messages,
    this.endedAtUtc,
  });

  factory ChatSession.fromJson(Map<String, dynamic> json) => ChatSession(
    sessionId: _text(json['sessionId']),
    title: _text(json['title']),
    startedAtUtc: _date(json['startedAtUtc']),
    lastActivityAtUtc: _date(json['lastActivityAtUtc']),
    endedAtUtc: _optionalDate(json['endedAtUtc']),
    isEnded: json['isEnded'] == true,
    messages: _list(json['messages'], ChatMessage.fromJson),
  );

  final String sessionId;
  final String title;
  final DateTime startedAtUtc;
  final DateTime lastActivityAtUtc;
  final DateTime? endedAtUtc;
  final bool isEnded;
  final List<ChatMessage> messages;
}

class ChatMessage {
  const ChatMessage({
    required this.messageId,
    required this.senderType,
    required this.content,
    required this.sentAtUtc,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    messageId: _text(json['messageId']),
    senderType: _text(json['senderType']),
    content: _text(json['content']),
    sentAtUtc: _date(json['sentAtUtc']),
  );

  final String messageId;
  final String senderType;
  final String content;
  final DateTime sentAtUtc;

  bool get isUser => senderType.toLowerCase() == 'user';
}

class ChatReply {
  const ChatReply({
    required this.sessionId,
    required this.detectedIntent,
    required this.replyMessage,
    required this.requiresLocation,
    required this.sessionEnded,
    required this.newMessages,
    required this.suggestedActions,
    required this.requiresPharmacist,
    this.aiEngine,
    this.aiRetrievalConfidence,
  });

  factory ChatReply.fromJson(Map<String, dynamic> json) => ChatReply(
    sessionId: _text(json['sessionId']),
    detectedIntent: _text(json['detectedIntent']),
    replyMessage: _text(json['replyMessage']),
    requiresLocation: json['requiresLocation'] == true,
    sessionEnded: json['sessionEnded'] == true,
    newMessages: _list(json['newMessages'], ChatMessage.fromJson),
    suggestedActions: _list(json['suggestedActions'], ChatAction.fromJson),
    aiEngine: _optional(json['aiEngine']),
    aiRetrievalConfidence: _optional(json['aiRetrievalConfidence']),
    requiresPharmacist: json['requiresPharmacist'] == true,
  );

  final String sessionId;
  final String detectedIntent;
  final String replyMessage;
  final bool requiresLocation;
  final bool sessionEnded;
  final List<ChatMessage> newMessages;
  final List<ChatAction> suggestedActions;
  final String? aiEngine;
  final String? aiRetrievalConfidence;
  final bool requiresPharmacist;
}

class ChatAction {
  const ChatAction({
    required this.actionType,
    required this.label,
    this.endpoint,
    this.httpMethod,
    this.notes,
    this.url,
    this.relatedEntityId,
  });

  factory ChatAction.fromJson(Map<String, dynamic> json) => ChatAction(
    actionType: _text(json['actionType']),
    label: _text(json['label']),
    endpoint: _optional(json['endpoint']),
    httpMethod: _optional(json['httpMethod']),
    notes: _optional(json['notes']),
    url: _optional(json['url']),
    relatedEntityId: _optional(json['relatedEntityId']),
  );

  final String actionType;
  final String label;
  final String? endpoint;
  final String? httpMethod;
  final String? notes;
  final String? url;
  final String? relatedEntityId;
}

List<T> _list<T>(Object? value, T Function(Map<String, dynamic>) parser) {
  if (value is! List) return const [];
  return value
      .whereType<Map>()
      .map((item) => parser(Map<String, dynamic>.from(item)))
      .toList(growable: false);
}

String _text(Object? value) => value?.toString() ?? '';
String? _optional(Object? value) {
  final text = value?.toString().trim();
  return text == null || text.isEmpty ? null : text;
}

int _integer(Object? value) =>
    value is num ? value.toInt() : int.tryParse('$value') ?? 0;
DateTime _date(Object? value) =>
    DateTime.tryParse(value?.toString() ?? '') ?? DateTime.now().toUtc();
DateTime? _optionalDate(Object? value) =>
    value == null ? null : DateTime.tryParse(value.toString());
