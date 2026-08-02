class DonationOffer {
  const DonationOffer({
    required this.offerId,
    this.donorFullName = '',
    this.donorPhoneNumber,
    required this.medicineId,
    required this.medicineName,
    required this.packageCount,
    required this.isSealed,
    required this.status,
    required this.createdAtUtc,
    this.scientificName,
    this.targetOrganizationId,
    this.targetOrganizationName,
    this.campaignId,
    this.campaignTitle,
    this.reviewingPharmacyId,
    this.reviewingPharmacyName = '',
    this.pharmacyReviewStatus = '',
    this.pharmacyReviewNote,
    this.expiryDateUtc,
    this.notes,
    this.reviewNote,
    this.reviewedAtUtc,
    this.receivedAtUtc,
    this.pharmacyReviewedAtUtc,
    this.pharmacyReceivedAtUtc,
  });

  factory DonationOffer.fromJson(Map<String, dynamic> json) => DonationOffer(
    offerId: _text(json['offerId']),
    donorFullName: _text(json['donorFullName']),
    donorPhoneNumber: _optional(json['donorPhoneNumber']),
    medicineId: _text(json['medicineId']),
    medicineName: _text(json['medicineName']),
    scientificName: _optional(json['scientificName']),
    targetOrganizationId: _optional(json['targetOrganizationId']),
    targetOrganizationName: _optional(json['targetOrganizationName']),
    campaignId: _optional(json['campaignId']),
    campaignTitle: _optional(json['campaignTitle']),
    reviewingPharmacyId: _optional(json['reviewingPharmacyId']),
    reviewingPharmacyName: _text(json['reviewingPharmacyName']),
    pharmacyReviewStatus: _text(json['pharmacyReviewStatus']),
    pharmacyReviewNote: _optional(json['pharmacyReviewNote']),
    packageCount: _integer(json['packageCount']),
    expiryDateUtc: _date(json['expiryDateUtc']),
    isSealed: json['isSealed'] == true,
    status: _text(json['status']),
    notes: _optional(json['notes']),
    reviewNote: _optional(json['reviewNote']),
    createdAtUtc: _date(json['createdAtUtc']) ?? DateTime.now().toUtc(),
    reviewedAtUtc: _date(json['reviewedAtUtc']),
    receivedAtUtc: _date(json['receivedAtUtc']),
    pharmacyReviewedAtUtc: _date(json['pharmacyReviewedAtUtc']),
    pharmacyReceivedAtUtc: _date(json['pharmacyReceivedAtUtc']),
  );

  final String offerId;
  final String donorFullName;
  final String? donorPhoneNumber;
  final String medicineId;
  final String medicineName;
  final String? scientificName;
  final String? targetOrganizationId;
  final String? targetOrganizationName;
  final String? campaignId;
  final String? campaignTitle;
  final String? reviewingPharmacyId;
  final String reviewingPharmacyName;
  final String pharmacyReviewStatus;
  final String? pharmacyReviewNote;
  final int packageCount;
  final DateTime? expiryDateUtc;
  final bool isSealed;
  final String status;
  final String? notes;
  final String? reviewNote;
  final DateTime createdAtUtc;
  final DateTime? reviewedAtUtc;
  final DateTime? receivedAtUtc;
  final DateTime? pharmacyReviewedAtUtc;
  final DateTime? pharmacyReceivedAtUtc;
}

class DonationVerificationPharmacy {
  const DonationVerificationPharmacy({
    required this.pharmacyId,
    required this.pharmacyName,
    required this.city,
    required this.area,
    required this.address,
    this.distanceMeters,
  });

  factory DonationVerificationPharmacy.fromJson(Map<String, dynamic> json) =>
      DonationVerificationPharmacy(
        pharmacyId: _text(json['pharmacyId']),
        pharmacyName: _text(json['pharmacyName']),
        city: _text(json['city']),
        area: _text(json['area']),
        address: _text(json['address']),
        distanceMeters: (json['distanceMeters'] as num?)?.toDouble(),
      );

  final String pharmacyId;
  final String pharmacyName;
  final String city;
  final String area;
  final String address;
  final double? distanceMeters;
}

class AssistanceRequest {
  const AssistanceRequest({
    required this.requestId,
    required this.medicineId,
    required this.medicineName,
    required this.requestedPackageCount,
    required this.status,
    required this.createdAtUtc,
    this.scientificName,
    this.targetOrganizationId,
    this.targetOrganizationName,
    this.campaignId,
    this.campaignTitle,
    this.neededBeforeUtc,
    this.notes,
    this.responseNote,
    this.statusUpdatedAtUtc,
    this.fulfilledAtUtc,
  });

  factory AssistanceRequest.fromJson(Map<String, dynamic> json) =>
      AssistanceRequest(
        requestId: _text(json['requestId']),
        medicineId: _text(json['medicineId']),
        medicineName: _text(json['medicineName']),
        scientificName: _optional(json['scientificName']),
        targetOrganizationId: _optional(json['targetOrganizationId']),
        targetOrganizationName: _optional(json['targetOrganizationName']),
        campaignId: _optional(json['campaignId']),
        campaignTitle: _optional(json['campaignTitle']),
        requestedPackageCount: _integer(json['requestedPackageCount']),
        neededBeforeUtc: _date(json['neededBeforeUtc']),
        status: _text(json['status']),
        notes: _optional(json['notes']),
        responseNote: _optional(json['responseNote']),
        createdAtUtc: _date(json['createdAtUtc']) ?? DateTime.now().toUtc(),
        statusUpdatedAtUtc: _date(json['statusUpdatedAtUtc']),
        fulfilledAtUtc: _date(json['fulfilledAtUtc']),
      );

  final String requestId;
  final String medicineId;
  final String medicineName;
  final String? scientificName;
  final String? targetOrganizationId;
  final String? targetOrganizationName;
  final String? campaignId;
  final String? campaignTitle;
  final int requestedPackageCount;
  final DateTime? neededBeforeUtc;
  final String status;
  final String? notes;
  final String? responseNote;
  final DateTime createdAtUtc;
  final DateTime? statusUpdatedAtUtc;
  final DateTime? fulfilledAtUtc;
}

class PublicOrganization {
  const PublicOrganization({
    required this.organizationId,
    required this.organizationName,
    required this.city,
    required this.area,
    required this.address,
    required this.activeCampaignsCount,
    this.description,
    this.phoneNumber,
  });

  factory PublicOrganization.fromJson(Map<String, dynamic> json) =>
      PublicOrganization(
        organizationId: _text(json['organizationId']),
        organizationName: _text(json['organizationName']),
        city: _text(json['city']),
        area: _text(json['area']),
        address: _text(json['address']),
        description: _optional(json['description']),
        phoneNumber: _optional(json['phoneNumber']),
        activeCampaignsCount: _integer(json['activeCampaignsCount']),
      );

  final String organizationId;
  final String organizationName;
  final String city;
  final String area;
  final String address;
  final String? description;
  final String? phoneNumber;
  final int activeCampaignsCount;
}

class PublicOrganizationDetails {
  const PublicOrganizationDetails({
    required this.organizationId,
    required this.organizationName,
    required this.registrationNumber,
    required this.city,
    required this.area,
    required this.address,
    required this.isApproved,
    required this.activeCampaigns,
    this.description,
    this.phoneNumber,
  });

  factory PublicOrganizationDetails.fromJson(Map<String, dynamic> json) =>
      PublicOrganizationDetails(
        organizationId: _text(json['organizationId']),
        organizationName: _text(json['organizationName']),
        registrationNumber: _text(json['registrationNumber']),
        city: _text(json['city']),
        area: _text(json['area']),
        address: _text(json['address']),
        description: _optional(json['description']),
        phoneNumber: _optional(json['phoneNumber']),
        isApproved: json['isApproved'] == true,
        activeCampaigns:
            (json['activeCampaigns'] as List?)
                ?.whereType<Map>()
                .map(
                  (item) => DonationCampaign.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList(growable: false) ??
            const [],
      );

  final String organizationId;
  final String organizationName;
  final String registrationNumber;
  final String city;
  final String area;
  final String address;
  final String? description;
  final String? phoneNumber;
  final bool isApproved;
  final List<DonationCampaign> activeCampaigns;
}

class DonationCampaign {
  const DonationCampaign({
    required this.campaignId,
    required this.organizationId,
    required this.organizationName,
    required this.title,
    required this.description,
    required this.isUrgent,
    required this.acceptsPublicDonations,
    required this.status,
    this.requestedMedicinesSummary,
    this.city,
    this.area,
    this.startsAtUtc,
    this.endsAtUtc,
  });

  factory DonationCampaign.fromJson(Map<String, dynamic> json) =>
      DonationCampaign(
        campaignId: _text(json['campaignId']),
        organizationId: _text(json['organizationId']),
        organizationName: _text(json['organizationName']),
        title: _text(json['title']),
        description: _text(json['description']),
        requestedMedicinesSummary: _optional(json['requestedMedicinesSummary']),
        city: _optional(json['city']),
        area: _optional(json['area']),
        isUrgent: json['isUrgent'] == true,
        acceptsPublicDonations: json['acceptsPublicDonations'] == true,
        status: _text(json['status']),
        startsAtUtc: _date(json['startsAtUtc']),
        endsAtUtc: _date(json['endsAtUtc']),
      );

  final String campaignId;
  final String organizationId;
  final String organizationName;
  final String title;
  final String description;
  final String? requestedMedicinesSummary;
  final String? city;
  final String? area;
  final bool isUrgent;
  final bool acceptsPublicDonations;
  final String status;
  final DateTime? startsAtUtc;
  final DateTime? endsAtUtc;
}

class CreateDonationOffer {
  const CreateDonationOffer({
    required this.medicineId,
    required this.reviewingPharmacyId,
    required this.packageCount,
    required this.isSealed,
    this.targetOrganizationId,
    this.campaignId,
    this.expiryDateUtc,
    this.notes,
  });

  final String medicineId;
  final String reviewingPharmacyId;
  final String? targetOrganizationId;
  final String? campaignId;
  final int packageCount;
  final DateTime? expiryDateUtc;
  final bool isSealed;
  final String? notes;

  Map<String, dynamic> toJson() => {
    'medicineId': medicineId,
    'reviewingPharmacyId': reviewingPharmacyId,
    'targetOrganizationId': targetOrganizationId,
    'campaignId': campaignId,
    'packageCount': packageCount,
    'expiryDateUtc': expiryDateUtc?.toUtc().toIso8601String(),
    'isSealed': isSealed,
    'notes': _optional(notes),
  };
}

class CreateAssistanceRequest {
  const CreateAssistanceRequest({
    required this.medicineId,
    required this.targetOrganizationId,
    required this.requestedPackageCount,
    this.campaignId,
    this.neededBeforeUtc,
    this.notes,
  });

  final String medicineId;
  final String targetOrganizationId;
  final String? campaignId;
  final int requestedPackageCount;
  final DateTime? neededBeforeUtc;
  final String? notes;

  Map<String, dynamic> toJson() => {
    'medicineId': medicineId,
    'targetOrganizationId': targetOrganizationId,
    'campaignId': campaignId,
    'requestedPackageCount': requestedPackageCount,
    'neededBeforeUtc': neededBeforeUtc?.toUtc().toIso8601String(),
    'notes': _optional(notes),
  };
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
