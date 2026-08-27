import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import '../../../../core/errors/api_exception.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/account_profile.dart';

class AccountRemoteDataSource {
  const AccountRemoteDataSource(this._dio);

  final Dio _dio;

  Future<AccountProfile> getProfile() async =>
      AccountProfile.fromJson(await _get(ApiEndpoints.accountMe));

  Future<AccountProfile> updateProfile({
    required String fullName,
    String? phoneNumber,
  }) async => AccountProfile.fromJson(
    await _put(ApiEndpoints.accountProfile, {
      'fullName': fullName,
      'phoneNumber': _optional(phoneNumber),
    }),
  );

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    try {
      await _dio.put<void>(
        ApiEndpoints.accountPassword,
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
          'confirmNewPassword': confirmNewPassword,
        },
      );
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<AccountProfile> updateAvatar({
    required String filePath,
    required String fileName,
  }) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        ApiEndpoints.accountAvatar,
        data: FormData.fromMap({
          'image': await MultipartFile.fromFile(
            filePath,
            filename: fileName,
            contentType: _imageType(fileName),
          ),
        }),
        options: Options(contentType: 'multipart/form-data'),
      );
      return AccountProfile.fromJson(response.data ?? const {});
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<AccountProfile> deleteAvatar() async {
    try {
      final response = await _dio.delete<Map<String, dynamic>>(
        ApiEndpoints.accountAvatar,
      );
      return AccountProfile.fromJson(response.data ?? const {});
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<Map<String, dynamic>> _get(String path) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(path);
      return response.data ?? const {};
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<Map<String, dynamic>> _put(
    String path,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(path, data: data);
      return response.data ?? const {};
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }
}

String? _optional(String? value) {
  final text = value?.trim();
  return text == null || text.isEmpty ? null : text;
}

MediaType _imageType(String fileName) {
  final extension = fileName.split('.').last.toLowerCase();
  return switch (extension) {
    'png' => MediaType('image', 'png'),
    'webp' => MediaType('image', 'webp'),
    _ => MediaType('image', 'jpeg'),
  };
}
