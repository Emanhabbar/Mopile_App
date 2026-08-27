import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../config/app_config.dart';
import '../storage/secure_session_storage.dart';

final dioProvider = Provider<Dio>((ref) {
  final sessionStorage = ref.watch(sessionStorageProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: const {'Accept': 'application/json'},
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final session = await sessionStorage.read();
        if (session != null && !session.isExpired) {
          options.headers['Authorization'] = 'Bearer ${session.accessToken}';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          // مسار الطلب النسبي بدون شرطة مائلة بادئة، عشان الفحص يشتغل
          // سواء كان dio ضمّ baseUrl ولا لأ.
          final path = error.requestOptions.path;
          final isAuthEndpoint =
              path.contains('Auth/login') ||
              path.contains('Auth/register') ||
              path.contains('Auth/password/forgot') ||
              path.contains('Auth/password/reset');
          if (!isAuthEndpoint) {
            await sessionStorage.clear();
            ref.read(authControllerProvider.notifier).logout();
            ref.read(sessionExpiredProvider.notifier).state = true;
          }
        }
        handler.next(error);
      },
    ),
  );

  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(
        requestBody: false,
        responseBody: false,
        requestHeader: false,
        responseHeader: false,
      ),
    );
  }

  return dio;
});
