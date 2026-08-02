import 'package:dio/dio.dart';

class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  bool get isLocationRequired {
    final normalized = message.toLowerCase();
    return normalized.contains('user location is required') ||
        normalized.contains('update the saved location first') ||
        normalized.contains('latitude and longitude') ||
        normalized.contains('saved location') ||
        normalized.contains('حدد موقعك أولًا') ||
        normalized.contains('خط العرض وخط الطول');
  }

  factory ApiException.fromDio(DioException exception) {
    final response = exception.response;
    final data = response?.data;

    String? message;
    if (data is Map<String, dynamic>) {
      message =
          _readText(data['detail']) ??
          _readText(data['error']) ??
          _readText(data['message']) ??
          _firstValidationError(data['errors']) ??
          _readText(data['title']);
    } else if (data is String && data.trim().isNotEmpty) {
      message = data.trim();
    }

    message ??= switch (exception.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => 'انتهت مهلة الاتصال، حاول مجددًا.',
      DioExceptionType.connectionError =>
        'تعذر الاتصال بالخادم. تحقق من الشبكة وتشغيل الخدمة.',
      _ => 'تعذر إكمال العملية حاليًا.',
    };
    message = _localizeKnownMessage(message);

    return ApiException(message, statusCode: response?.statusCode);
  }

  static String _localizeKnownMessage(String message) {
    final normalized = message.toLowerCase();
    if (normalized.contains('user location is required') ||
        normalized.contains('update the saved location first')) {
      return 'حدد موقعك أولًا لعرض الصيدليات القريبة.';
    }
    if (normalized.contains('latitude and longitude must be provided')) {
      return 'يجب إدخال خط العرض وخط الطول معًا.';
    }
    return message;
  }

  static String? _readText(Object? value) {
    if (value is String && value.trim().isNotEmpty) return value.trim();
    return null;
  }

  static String? _firstValidationError(Object? value) {
    if (value is! Map) return null;
    for (final entry in value.values) {
      if (entry is List && entry.isNotEmpty) {
        return _readText(entry.first);
      }
      final text = _readText(entry);
      if (text != null) return text;
    }
    return null;
  }

  @override
  String toString() => message;
}
