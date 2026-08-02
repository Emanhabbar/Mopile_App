import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/storage/secure_session_storage.dart';
import '../data_sources/auth_remote_data_source.dart';
import '../models/auth_session.dart';
import '../models/password_reset_result.dart';
import '../models/registration_request.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    remoteDataSource: AuthRemoteDataSource(ref.watch(dioProvider)),
    sessionStorage: ref.watch(sessionStorageProvider),
  );
});

class AuthRepository {
  const AuthRepository({
    required this._remoteDataSource,
    required this._sessionStorage,
  });

  final AuthRemoteDataSource _remoteDataSource;
  final SessionStorage _sessionStorage;

  Future<AuthSession?> restoreSession() async {
    final session = await _sessionStorage.read();
    if (session == null) return null;
    if (session.isExpired) {
      await _sessionStorage.clear();
      return null;
    }
    return session;
  }

  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    final session = await _remoteDataSource.login(
      email: email,
      password: password,
    );
    await _sessionStorage.write(session);
    return session;
  }

  Future<AuthSession> register(RegistrationRequest request) async {
    final session = await _remoteDataSource.register(request);
    await _sessionStorage.write(session);
    return session;
  }

  Future<void> saveSession(AuthSession session) =>
      _sessionStorage.write(session);

  Future<void> logout() => _sessionStorage.clear();

  Future<PasswordResetResult> requestPasswordReset(String email) =>
      _remoteDataSource.requestPasswordReset(email);

  Future<void> resetPassword({
    required String email,
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) => _remoteDataSource.resetPassword(
    email: email,
    token: token,
    newPassword: newPassword,
    confirmPassword: confirmPassword,
  );
}
