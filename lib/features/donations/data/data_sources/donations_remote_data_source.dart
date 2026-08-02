import 'package:dio/dio.dart';

import '../../../../core/errors/api_exception.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/donation_models.dart';

class DonationsRemoteDataSource {
  const DonationsRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<DonationVerificationPharmacy>> getVerificationPharmacies({
    double? latitude,
    double? longitude,
  }) => _getList(
    ApiEndpoints.donationVerificationPharmacies,
    DonationVerificationPharmacy.fromJson,
    query: {'latitude': latitude, 'longitude': longitude},
  );

  Future<List<DonationOffer>> getMyOffers({String? status}) async => _getList(
    ApiEndpoints.myDonationOffers,
    (json) => DonationOffer.fromJson(json),
    query: {if (status?.isNotEmpty == true) 'status': status, 'take': 100},
  );

  Future<DonationOffer> createOffer(CreateDonationOffer request) async {
    final json = await _post(ApiEndpoints.donationOffers, request.toJson());
    return DonationOffer.fromJson(json);
  }

  Future<List<DonationOffer>> getPharmacyDonationOffers({String? status}) =>
      _getList(
        ApiEndpoints.pharmacyDonationOffers,
        DonationOffer.fromJson,
        query: {if (status?.isNotEmpty == true) 'status': status},
      );

  Future<DonationOffer> reviewPharmacyDonationOffer(
    String offerId, {
    required String status,
    String? note,
  }) async {
    final json = await _put(ApiEndpoints.pharmacyDonationReview(offerId), {
      'status': status,
      'reviewNote': _nullableText(note),
    });
    return DonationOffer.fromJson(json);
  }

  Future<List<AssistanceRequest>> getMyAssistanceRequests({
    String? status,
  }) async => _getList(
    ApiEndpoints.myAssistanceRequests,
    (json) => AssistanceRequest.fromJson(json),
    query: {if (status?.isNotEmpty == true) 'status': status, 'take': 100},
  );

  Future<AssistanceRequest> createAssistanceRequest(
    CreateAssistanceRequest request,
  ) async {
    final json = await _post(ApiEndpoints.assistanceRequests, request.toJson());
    return AssistanceRequest.fromJson(json);
  }

  Future<List<PublicOrganization>> getOrganizations() async => _getList(
    ApiEndpoints.organizations,
    (json) => PublicOrganization.fromJson(json),
  );

  Future<PublicOrganizationDetails> getOrganization(String id) async =>
      PublicOrganizationDetails.fromJson(
        await _get(ApiEndpoints.organization(id)),
      );

  Future<List<DonationCampaign>> getActiveCampaigns({
    String? organizationId,
  }) async => _getList(
    ApiEndpoints.activeCampaigns,
    (json) => DonationCampaign.fromJson(json),
    query: {
      if (organizationId?.isNotEmpty == true) 'organizationId': organizationId,
      'take': 100,
    },
  );

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

String? _nullableText(String? value) {
  final text = value?.trim();
  return text == null || text.isEmpty ? null : text;
}
