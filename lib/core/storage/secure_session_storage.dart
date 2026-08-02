import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../features/auth/data/models/auth_session.dart';

abstract interface class SessionStorage {
  Future<AuthSession?> read();
  Future<void> write(AuthSession session);
  Future<void> clear();
}

final sessionStorageProvider = Provider<SessionStorage>(
  (ref) => SecureSessionStorage(),
);

class SecureSessionStorage implements SessionStorage {
  SecureSessionStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const _sessionKey = 'hayat_dawaiya_session_v1';
  final FlutterSecureStorage _storage;

  @override
  Future<AuthSession?> read() async {
    final rawValue = await _storage.read(key: _sessionKey);
    if (rawValue == null || rawValue.isEmpty) return null;

    try {
      final json = jsonDecode(rawValue);
      return json is Map<String, dynamic> ? AuthSession.fromJson(json) : null;
    } on FormatException {
      await clear();
      return null;
    }
  }

  @override
  Future<void> write(AuthSession session) {
    return _storage.write(
      key: _sessionKey,
      value: jsonEncode(session.toJson()),
    );
  }

  @override
  Future<void> clear() => _storage.delete(key: _sessionKey);
}
