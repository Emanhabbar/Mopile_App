import 'package:dio/dio.dart';

import '../../l10n/generated/app_localizations.dart';

enum ApiErrorKind {
  timeout,
  connection,
  generic,
  locationRequired,
  locationCoordinatesRequired,
  awaitingApproval,
  alreadyApproved,
  alreadyRejected,
  notFound,
  alreadyTaken,
  locationServiceDisabled,
  locationPermissionDenied,
  locationPermissionDeniedForever,
  loginResponseIncomplete,
  sessionReadFailed,
  registerResponseIncomplete,
  newAccountReadFailed,
  invalidListResponse,
}

class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode, this.kind});

  final String message;
  final int? statusCode;
  final ApiErrorKind? kind;

  bool get isLocationRequired =>
      kind == ApiErrorKind.locationRequired ||
      kind == ApiErrorKind.locationCoordinatesRequired ||
      message.toLowerCase().contains('user location is required') ||
      message.toLowerCase().contains('update the saved location first') ||
      message.toLowerCase().contains('latitude and longitude') ||
      message.toLowerCase().contains('saved location') ||
      message.contains('حدد موقعك أولًا') ||
      message.contains('خط العرض وخط الطول');

  String localize(AppLocalizations l10n) => switch (kind) {
    ApiErrorKind.timeout => l10n.errorTimeout,
    ApiErrorKind.connection => l10n.errorConnection,
    ApiErrorKind.generic => l10n.errorGeneric,
    ApiErrorKind.locationRequired => l10n.errorLocationRequired,
    ApiErrorKind.locationCoordinatesRequired => l10n.errorLocationCoordinates,
    ApiErrorKind.awaitingApproval => l10n.errorAwaitingApproval,
    ApiErrorKind.alreadyApproved => l10n.errorAlreadyApproved,
    ApiErrorKind.alreadyRejected => l10n.errorAlreadyRejected,
    ApiErrorKind.notFound => l10n.errorNotFound,
    ApiErrorKind.alreadyTaken => l10n.errorAlreadyTaken,
    ApiErrorKind.locationServiceDisabled => l10n.errorLocationServiceDisabled,
    ApiErrorKind.locationPermissionDenied =>
      l10n.errorLocationPermissionDenied,
    ApiErrorKind.locationPermissionDeniedForever =>
      l10n.errorLocationPermissionForever,
    ApiErrorKind.loginResponseIncomplete => l10n.errorLoginResponseIncomplete,
    ApiErrorKind.sessionReadFailed => l10n.errorSessionReadFailed,
    ApiErrorKind.registerResponseIncomplete =>
      l10n.errorRegisterResponseIncomplete,
    ApiErrorKind.newAccountReadFailed => l10n.errorNewAccountReadFailed,
    ApiErrorKind.invalidListResponse => l10n.errorInvalidListResponse,
    null => message,
  };

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

    final kind = message == null
        ? _fallbackKind(exception.type)
        : _knownKind(message);

    return ApiException(
      message ?? '',
      statusCode: response?.statusCode,
      kind: kind,
    );
  }

  static ApiErrorKind _fallbackKind(DioExceptionType type) => switch (type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout => ApiErrorKind.timeout,
    DioExceptionType.connectionError => ApiErrorKind.connection,
    _ => ApiErrorKind.generic,
  };

  static ApiErrorKind? _knownKind(String message) {
    final normalized = message.toLowerCase();
    if (normalized.contains('user location is required') ||
        normalized.contains('update the saved location first')) {
      return ApiErrorKind.locationRequired;
    }
    if (normalized.contains('latitude and longitude must be provided')) {
      return ApiErrorKind.locationCoordinatesRequired;
    }
    if (normalized.contains('awaiting administration approval')) {
      return ApiErrorKind.awaitingApproval;
    }
    if (normalized.contains('already approved') ||
        normalized.contains('has already been approved')) {
      return ApiErrorKind.alreadyApproved;
    }
    if (normalized.contains('already rejected') ||
        normalized.contains('has already been rejected')) {
      return ApiErrorKind.alreadyRejected;
    }
    if (normalized.contains('not found') ||
        normalized.contains('does not exist')) {
      return ApiErrorKind.notFound;
    }
    if (normalized.contains('already taken') ||
        normalized.contains('already in use')) {
      return ApiErrorKind.alreadyTaken;
    }
    return null;
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
