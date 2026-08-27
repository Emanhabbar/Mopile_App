import 'package:dio/dio.dart';

import '../../../../core/errors/api_exception.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/auth_session.dart';
import '../models/password_reset_result.dart';
import '../models/registration_request.dart';

class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._dio);

  final Dio _dio;

  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.authLogin,
        data: {'email': email.trim(), 'password': password},
      );
      final data = response.data;
      if (data == null) {
        throw const ApiException(
          '',
          kind: ApiErrorKind.loginResponseIncomplete,
        );
      }
      final session = AuthSession.fromJson(data);
      if (session.accessToken.isEmpty || session.user.userId.isEmpty) {
        throw const ApiException('', kind: ApiErrorKind.sessionReadFailed);
      }
      return session;
    } on DioException catch (exception) {
      throw ApiException.fromDio(exception);
    }
  }

  Future<AuthSession> register(RegistrationRequest request) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        request.type.endpoint,
        data: request.toJson(),
      );
      final data = response.data;
      if (data == null) {
        throw const ApiException(
          '',
          kind: ApiErrorKind.registerResponseIncomplete,
        );
      }
      final session = AuthSession.fromJson(data);
      if (session.accessToken.isEmpty || session.user.userId.isEmpty) {
        throw const ApiException('', kind: ApiErrorKind.newAccountReadFailed);
      }
      return session;
    } on DioException catch (exception) {
      throw ApiException.fromDio(exception);
    }
  }

  Future<PasswordResetResult> requestPasswordReset(String email) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.authForgotPassword,
        data: {'email': email.trim()},
      );
      return PasswordResetResult.fromJson(response.data ?? const {});
    } on DioException catch (exception) {
      throw ApiException.fromDio(exception);
    }
  }

  Future<void> resetPassword({
    required String email,
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      await _dio.post<void>(
        ApiEndpoints.authResetPassword,
        data: {
          'email': email.trim(),
          'token': token.trim(),
          'newPassword': newPassword,
          'confirmNewPassword': confirmPassword,
        },
      );
    } on DioException catch (exception) {
      throw ApiException.fromDio(exception);
    }
  }
}
