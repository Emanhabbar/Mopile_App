import 'package:dio/dio.dart';

import '../../../../core/errors/api_exception.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../donations/data/models/donation_models.dart';
import '../models/organization_models.dart';

class OrganizationRemoteDataSource {
  const OrganizationRemoteDataSource(this._dio);

  final Dio _dio;

  Future<OrganizationDashboard> getDashboard() async =>
      OrganizationDashboard.fromJson(
        await _get(ApiEndpoints.organizationDashboard),
      );

  Future<OrganizationDashboard> getMe() async =>
      OrganizationDashboard.fromJson(await _get(ApiEndpoints.organizationMe));

  Future<OrganizationVerification> getVerification() async =>
      OrganizationVerification.fromJson(
        await _get(ApiEndpoints.organizationVerification),
      );

  Future<OrganizationDashboard> updateProfile(
    OrganizationDashboard current, {
    required String organizationName,
    required String registrationNumber,
    required String phoneNumber,
    required String city,
    required String area,
    required String address,
    String? description,
  }) async => OrganizationDashboard.fromJson(
    await _put(ApiEndpoints.organizationProfile, {
      'organizationName': organizationName,
      'registrationNumber': registrationNumber,
      'phoneNumber': phoneNumber,
      'city': city,
      'area': area,
      'address': address,
      'description': description,
    }),
  );

  Future<OrganizationVerification> uploadDocument({
    required String documentType,
    required String filePath,
    required String fileName,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.organizationVerificationDocuments,
        data: FormData.fromMap({
          'documentType': documentType,
          'file': await MultipartFile.fromFile(filePath, filename: fileName),
        }),
        options: Options(contentType: 'multipart/form-data'),
      );
      return OrganizationVerification.fromJson(response.data ?? const {});
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<OrganizationDocumentFile> getDocument(String documentId) async {
    try {
      final response = await _dio.get<List<int>>(
        ApiEndpoints.organizationVerificationDocument(documentId),
        options: Options(responseType: ResponseType.bytes),
      );
      final disposition = response.headers.value('content-disposition');
      final match = RegExp(
        r'''filename\*?=(?:UTF-8''|")?([^";]+)''',
        caseSensitive: false,
      ).firstMatch(disposition ?? '');
      return (
        bytes: response.data ?? const [],
        fileName: match?.group(1)?.replaceAll('"', ''),
        contentType: response.headers.value('content-type'),
      );
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<List<DonationCampaign>> getCampaigns({String? status}) async =>
      _getList(
        ApiEndpoints.organizationCampaigns,
        DonationCampaign.fromJson,
        query: {if (status?.isNotEmpty == true) 'status': status, 'take': 100},
      );

  Future<DonationCampaign> createCampaign({
    required String title,
    required String description,
    String? requestedMedicinesSummary,
    String? city,
    String? area,
    required bool isUrgent,
    required bool acceptsPublicDonations,
    DateTime? startsAtUtc,
    DateTime? endsAtUtc,
  }) async => DonationCampaign.fromJson(
    await _post(ApiEndpoints.organizationCampaigns, {
      'title': title,
      'description': description,
      'requestedMedicinesSummary': requestedMedicinesSummary,
      'city': city,
      'area': area,
      'isUrgent': isUrgent,
      'acceptsPublicDonations': acceptsPublicDonations,
      'startsAtUtc': startsAtUtc?.toUtc().toIso8601String(),
      'endsAtUtc': endsAtUtc?.toUtc().toIso8601String(),
    }),
  );

  Future<DonationCampaign> updateCampaignStatus(
    String campaignId,
    String status,
  ) async => DonationCampaign.fromJson(
    await _put(ApiEndpoints.organizationCampaignStatus(campaignId), {
      'status': status,
    }),
  );

  Future<List<OrganizationDonationOffer>> getDonationOffers({
    String? status,
  }) async => _getList(
    ApiEndpoints.organizationDonationOffers,
    OrganizationDonationOffer.fromJson,
    query: {if (status?.isNotEmpty == true) 'status': status, 'take': 100},
  );

  Future<OrganizationDonationOffer> reviewOffer(
    String offerId, {
    required String status,
    String? note,
  }) async => OrganizationDonationOffer.fromJson(
    await _put(ApiEndpoints.organizationDonationReview(offerId), {
      'status': status,
      'reviewNote': note,
    }),
  );

  Future<List<OrganizationAssistanceRequest>> getAssistanceRequests({
    String? status,
  }) async => _getList(
    ApiEndpoints.organizationAssistanceRequests,
    OrganizationAssistanceRequest.fromJson,
    query: {if (status?.isNotEmpty == true) 'status': status, 'take': 100},
  );

  Future<OrganizationAssistanceRequest> updateAssistanceStatus(
    String requestId, {
    required String status,
    String? note,
  }) async => OrganizationAssistanceRequest.fromJson(
    await _put(ApiEndpoints.organizationAssistanceStatus(requestId), {
      'status': status,
      'responseNote': note,
    }),
  );

  Future<Map<String, dynamic>> _get(String path) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(path);
      return response.data ?? const {};
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<List<T>> _getList<T>(
    String path,
    T Function(Map<String, dynamic>) parser, {
    Map<String, dynamic>? query,
  }) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        path,
        queryParameters: query,
      );
      return (response.data ?? const [])
          .whereType<Map>()
          .map((item) => parser(Map<String, dynamic>.from(item)))
          .toList(growable: false);
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<Map<String, dynamic>> _post(
    String path,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(path, data: data);
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
