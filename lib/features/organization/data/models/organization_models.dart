import '../../../donations/data/models/donation_models.dart';

class OrganizationDashboard {
  const OrganizationDashboard({
    required this.organizationId,
    required this.organizationName,
    required this.registrationNumber,
    required this.city,
    required this.area,
    required this.address,
    required this.isApproved,
    required this.verificationStatus,
    required this.verificationDocumentsCount,
    required this.totalCampaignsCount,
    required this.activeCampaignsCount,
    required this.pendingDonationOffersCount,
    required this.openAssistanceRequestsCount,
    required this.recentCampaigns,
    this.phoneNumber,
    this.description,
    this.verificationNotes,
  });

  factory OrganizationDashboard.fromJson(
    Map<String, dynamic> json,
  ) => OrganizationDashboard(
    organizationId: _text(json['organizationId']),
    organizationName: _text(json['organizationName']),
    registrationNumber: _text(json['registrationNumber']),
    phoneNumber: _optional(json['phoneNumber']),
    city: _text(json['city']),
    area: _text(json['area']),
    address: _text(json['address']),
    description: _optional(json['description']),
    isApproved: json['isApproved'] == true,
    verificationStatus: _text(json['verificationStatus']),
    verificationNotes: _optional(json['verificationNotes']),
    verificationDocumentsCount: _integer(json['verificationDocumentsCount']),
    totalCampaignsCount: _integer(json['totalCampaignsCount']),
    activeCampaignsCount: _integer(json['activeCampaignsCount']),
    pendingDonationOffersCount: _integer(json['pendingDonationOffersCount']),
    openAssistanceRequestsCount: _integer(json['openAssistanceRequestsCount']),
    recentCampaigns: _list(json['recentCampaigns'], DonationCampaign.fromJson),
  );

  final String organizationId;
  final String organizationName;
  final String registrationNumber;
  final String? phoneNumber;
  final String city;
  final String area;
  final String address;
  final String? description;
  final bool isApproved;
  final String verificationStatus;
  final String? verificationNotes;
  final int verificationDocumentsCount;
  final int totalCampaignsCount;
  final int activeCampaignsCount;
  final int pendingDonationOffersCount;
  final int openAssistanceRequestsCount;
  final List<DonationCampaign> recentCampaigns;
}

class OrganizationDonationOffer {
  const OrganizationDonationOffer({
    required this.offerId,
    required this.donorFullName,
    required this.medicineName,
    required this.packageCount,
    required this.isSealed,
    required this.status,
    this.donorPhoneNumber,
    this.campaignTitle,
    this.reviewingPharmacyName,
    this.pharmacyReviewStatus,
    this.pharmacyReviewNote,
    this.expiryDateUtc,
    this.notes,
    this.reviewNote,
  });

  factory OrganizationDonationOffer.fromJson(Map<String, dynamic> json) =>
      OrganizationDonationOffer(
        offerId: _text(json['offerId']),
        donorFullName: _text(json['donorFullName']),
        donorPhoneNumber: _optional(json['donorPhoneNumber']),
        medicineName: _text(json['medicineName']),
        campaignTitle: _optional(json['campaignTitle']),
        reviewingPharmacyName: _optional(json['reviewingPharmacyName']),
        pharmacyReviewStatus: _optional(json['pharmacyReviewStatus']),
        pharmacyReviewNote: _optional(json['pharmacyReviewNote']),
        packageCount: _integer(json['packageCount']),
        expiryDateUtc: _date(json['expiryDateUtc']),
        isSealed: json['isSealed'] == true,
        status: _text(json['status']),
        notes: _optional(json['notes']),
        reviewNote: _optional(json['reviewNote']),
      );

  final String offerId;
  final String donorFullName;
  final String? donorPhoneNumber;
  final String medicineName;
  final String? campaignTitle;
  final String? reviewingPharmacyName;
  final String? pharmacyReviewStatus;
  final String? pharmacyReviewNote;
  final int packageCount;
  final DateTime? expiryDateUtc;
  final bool isSealed;
  final String status;
  final String? notes;
  final String? reviewNote;
}

class OrganizationAssistanceRequest {
  const OrganizationAssistanceRequest({
    required this.requestId,
    required this.requesterFullName,
    required this.medicineName,
    required this.requestedPackageCount,
    required this.status,
    this.requesterPhoneNumber,
    this.campaignTitle,
    this.neededBeforeUtc,
    this.notes,
    this.responseNote,
  });

  factory OrganizationAssistanceRequest.fromJson(Map<String, dynamic> json) =>
      OrganizationAssistanceRequest(
        requestId: _text(json['requestId']),
        requesterFullName: _text(json['requesterFullName']),
        requesterPhoneNumber: _optional(json['requesterPhoneNumber']),
        medicineName: _text(json['medicineName']),
        campaignTitle: _optional(json['campaignTitle']),
        requestedPackageCount: _integer(json['requestedPackageCount']),
        neededBeforeUtc: _date(json['neededBeforeUtc']),
        status: _text(json['status']),
        notes: _optional(json['notes']),
        responseNote: _optional(json['responseNote']),
      );

  final String requestId;
  final String requesterFullName;
  final String? requesterPhoneNumber;
  final String medicineName;
  final String? campaignTitle;
  final int requestedPackageCount;
  final DateTime? neededBeforeUtc;
  final String status;
  final String? notes;
  final String? responseNote;
}

class OrganizationVerification {
  const OrganizationVerification({
    required this.organizationId,
    required this.organizationName,
    required this.isApproved,
    required this.verificationStatus,
    required this.documents,
    this.verificationNotes,
  });

  factory OrganizationVerification.fromJson(Map<String, dynamic> json) =>
      OrganizationVerification(
        organizationId: _text(json['organizationId']),
        organizationName: _text(json['organizationName']),
        isApproved: json['isApproved'] == true,
        verificationStatus: _text(json['verificationStatus']),
        verificationNotes: _optional(json['verificationNotes']),
        documents: _list(json['documents'], OrganizationDocument.fromJson),
      );

  final String organizationId;
  final String organizationName;
  final bool isApproved;
  final String verificationStatus;
  final String? verificationNotes;
  final List<OrganizationDocument> documents;
}

class OrganizationDocument {
  const OrganizationDocument({
    required this.documentId,
    required this.documentType,
    required this.originalFileName,
    required this.contentType,
    required this.fileSizeBytes,
    required this.uploadedAtUtc,
  });

  factory OrganizationDocument.fromJson(Map<String, dynamic> json) =>
      OrganizationDocument(
        documentId: _text(json['documentId']),
        documentType: _text(json['documentType']),
        originalFileName: _text(json['originalFileName']),
        contentType: _text(json['contentType']),
        fileSizeBytes: _integer(json['fileSizeBytes']),
        uploadedAtUtc: _date(json['uploadedAtUtc']) ?? DateTime.now().toUtc(),
      );

  final String documentId;
  final String documentType;
  final String originalFileName;
  final String contentType;
  final int fileSizeBytes;
  final DateTime uploadedAtUtc;
}

typedef OrganizationDocumentFile = ({
  List<int> bytes,
  String? fileName,
  String? contentType,
});

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
DateTime? _date(Object? value) =>
    value == null ? null : DateTime.tryParse(value.toString());
