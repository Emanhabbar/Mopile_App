class AdminDashboard {
  const AdminDashboard({
    required this.totalUsers,
    required this.activeUsers,
    required this.totalPharmacies,
    required this.pendingPharmacies,
    required this.totalOrganizations,
    required this.pendingOrganizations,
    required this.totalWarehouses,
    required this.approvedWarehouses,
    required this.pendingWarehouses,
    required this.pendingOrganizationVerifications,
    required this.totalMedicineRequests,
    required this.pendingMedicineRequests,
    required this.totalDonationOffers,
    required this.openAssistanceRequests,
  });

  factory AdminDashboard.fromJson(Map<String, dynamic> json) => AdminDashboard(
    totalUsers: _int(json['totalUsers']),
    activeUsers: _int(json['activeUsers']),
    totalPharmacies: _int(json['totalPharmacies']),
    pendingPharmacies: _int(json['pendingPharmacies']),
    totalOrganizations: _int(json['totalOrganizations']),
    pendingOrganizations: _int(json['pendingOrganizations']),
    totalWarehouses: _int(json['totalWarehouses']),
    approvedWarehouses: _int(json['approvedWarehouses']),
    pendingWarehouses: _int(json['pendingWarehouses']),
    pendingOrganizationVerifications: _int(
      json['pendingOrganizationVerifications'],
    ),
    totalMedicineRequests: _int(json['totalMedicineRequests']),
    pendingMedicineRequests: _int(json['pendingMedicineRequests']),
    totalDonationOffers: _int(json['totalDonationOffers']),
    openAssistanceRequests: _int(json['openAssistanceRequests']),
  );

  final int totalUsers;
  final int activeUsers;
  final int totalPharmacies;
  final int pendingPharmacies;
  final int totalOrganizations;
  final int pendingOrganizations;
  final int totalWarehouses;
  final int approvedWarehouses;
  final int pendingWarehouses;
  final int pendingOrganizationVerifications;
  final int totalMedicineRequests;
  final int pendingMedicineRequests;
  final int totalDonationOffers;
  final int openAssistanceRequests;
}

class AdminWarehouse {
  const AdminWarehouse({
    required this.warehouseId,
    required this.warehouseName,
    required this.ownerFullName,
    required this.ownerEmail,
    required this.licenseNumber,
    required this.city,
    required this.area,
    required this.address,
    required this.minimumOrderAmount,
    required this.deliveryFee,
    required this.medicineBatchesCount,
    required this.representativesCount,
    required this.isApproved,
    required this.isAccountActive,
  });

  factory AdminWarehouse.fromJson(Map<String, dynamic> json) => AdminWarehouse(
    warehouseId: _text(json['warehouseId']),
    warehouseName: _text(json['warehouseName']),
    ownerFullName: _text(json['ownerFullName']),
    ownerEmail: _text(json['ownerEmail']),
    licenseNumber: _text(json['licenseNumber']),
    city: _text(json['city']),
    area: _text(json['area']),
    address: _text(json['address']),
    minimumOrderAmount: _double(json['minimumOrderAmount']),
    deliveryFee: _double(json['deliveryFee']),
    medicineBatchesCount: _int(json['medicineBatchesCount']),
    representativesCount: _int(json['representativesCount']),
    isApproved: json['isApproved'] == true,
    isAccountActive: json['isAccountActive'] == true,
  );

  final String warehouseId;
  final String warehouseName;
  final String ownerFullName;
  final String ownerEmail;
  final String licenseNumber;
  final String city;
  final String area;
  final String address;
  final double minimumOrderAmount;
  final double deliveryFee;
  final int medicineBatchesCount;
  final int representativesCount;
  final bool isApproved;
  final bool isAccountActive;
}

class AdminPharmacy {
  const AdminPharmacy({
    required this.pharmacyId,
    required this.pharmacyName,
    required this.ownerFullName,
    required this.ownerEmail,
    required this.licenseNumber,
    required this.city,
    required this.area,
    required this.address,
    required this.isApproved,
  });

  factory AdminPharmacy.fromJson(Map<String, dynamic> json) => AdminPharmacy(
    pharmacyId: _text(json['pharmacyId']),
    pharmacyName: _text(json['pharmacyName']),
    ownerFullName: _text(json['ownerFullName']),
    ownerEmail: _text(json['ownerEmail']),
    licenseNumber: _text(json['licenseNumber']),
    city: _text(json['city']),
    area: _text(json['area']),
    address: _text(json['address']),
    isApproved: json['isApproved'] == true,
  );

  final String pharmacyId;
  final String pharmacyName;
  final String ownerFullName;
  final String ownerEmail;
  final String licenseNumber;
  final String city;
  final String area;
  final String address;
  final bool isApproved;
}

class AdminPharmacyLicenseVerification {
  const AdminPharmacyLicenseVerification({
    required this.verificationId,
    required this.status,
    required this.registeredName,
    required this.originalFileName,
    this.extractedName,
    this.registryNumber,
    this.ocrConfidence,
    this.matchScore,
    this.isNameMatch,
    this.rejectionReason,
    this.failureReason,
    this.manualReviewNote,
  });

  factory AdminPharmacyLicenseVerification.fromJson(
    Map<String, dynamic> json,
  ) => AdminPharmacyLicenseVerification(
    verificationId: _text(json['verificationId']),
    status: _text(json['status']),
    registeredName: _text(json['registeredName']),
    originalFileName: _text(json['originalFileName']),
    extractedName: _optional(json['extractedName']),
    registryNumber: _optional(json['registryNumber']),
    ocrConfidence: _optionalDouble(json['ocrConfidence']),
    matchScore: _optionalDouble(json['matchScore']),
    isNameMatch: json['isNameMatch'] as bool?,
    rejectionReason: _optional(json['rejectionReason']),
    failureReason: _optional(json['failureReason']),
    manualReviewNote: _optional(json['manualReviewNote']),
  );

  final String verificationId;
  final String status;
  final String registeredName;
  final String originalFileName;
  final String? extractedName;
  final String? registryNumber;
  final double? ocrConfidence;
  final double? matchScore;
  final bool? isNameMatch;
  final String? rejectionReason;
  final String? failureReason;
  final String? manualReviewNote;
}

class AdminOrganization {
  const AdminOrganization({
    required this.organizationId,
    required this.organizationName,
    required this.ownerFullName,
    required this.ownerEmail,
    required this.registrationNumber,
    required this.city,
    required this.area,
    required this.isApproved,
    required this.verificationStatus,
    required this.verificationDocumentsCount,
  });

  factory AdminOrganization.fromJson(Map<String, dynamic> json) =>
      AdminOrganization(
        organizationId: _text(json['organizationId']),
        organizationName: _text(json['organizationName']),
        ownerFullName: _text(json['ownerFullName']),
        ownerEmail: _text(json['ownerEmail']),
        registrationNumber: _text(json['registrationNumber']),
        city: _text(json['city']),
        area: _text(json['area']),
        isApproved: json['isApproved'] == true,
        verificationStatus: _text(json['verificationStatus']),
        verificationDocumentsCount: _int(json['verificationDocumentsCount']),
      );

  final String organizationId;
  final String organizationName;
  final String ownerFullName;
  final String ownerEmail;
  final String registrationNumber;
  final String city;
  final String area;
  final bool isApproved;
  final String verificationStatus;
  final int verificationDocumentsCount;
}

class AdminAccount {
  const AdminAccount({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.role,
    required this.isActive,
    required this.createdAtUtc,
    this.phoneNumber,
    this.profileName,
    this.city,
    this.isApproved,
  });

  factory AdminAccount.fromJson(Map<String, dynamic> json) => AdminAccount(
    userId: _text(json['userId']),
    fullName: _text(json['fullName']),
    email: _text(json['email']),
    phoneNumber: _optional(json['phoneNumber']),
    role: _text(json['role']),
    profileName: _optional(json['profileName']),
    city: _optional(json['city']),
    isActive: json['isActive'] == true,
    isApproved: json['isApproved'] as bool?,
    createdAtUtc: _date(json['createdAtUtc']),
  );

  final String userId;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String role;
  final String? profileName;
  final String? city;
  final bool isActive;
  final bool? isApproved;
  final DateTime createdAtUtc;
}

class HomeTickerItem {
  const HomeTickerItem({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.isActive,
    required this.sortOrder,
    this.pharmacyProfileId,
    this.pharmacyName,
    this.startsAtUtc,
    this.endsAtUtc,
  });

  factory HomeTickerItem.fromJson(Map<String, dynamic> json) => HomeTickerItem(
    id: _text(json['id']),
    type: _text(json['type']),
    title: _text(json['title']),
    message: _text(json['message']),
    pharmacyProfileId: _optional(json['pharmacyProfileId']),
    pharmacyName: _optional(json['pharmacyName']),
    isActive: json['isActive'] == true,
    sortOrder: _int(json['sortOrder']),
    startsAtUtc: _optionalDate(json['startsAtUtc']),
    endsAtUtc: _optionalDate(json['endsAtUtc']),
  );

  final String id;
  final String type;
  final String title;
  final String message;
  final String? pharmacyProfileId;
  final String? pharmacyName;
  final bool isActive;
  final int sortOrder;
  final DateTime? startsAtUtc;
  final DateTime? endsAtUtc;
}

class HomeTickerPharmacy {
  const HomeTickerPharmacy({required this.id, required this.name});

  factory HomeTickerPharmacy.fromJson(Map<String, dynamic> json) =>
      HomeTickerPharmacy(id: _text(json['id']), name: _text(json['name']));

  final String id;
  final String name;
}

class AdminAiServicesHealth {
  const AdminAiServicesHealth({
    required this.licenseVerification,
    required this.drugSearch,
    required this.smartPharmacyBot,
  });

  factory AdminAiServicesHealth.fromJson(Map<String, dynamic> json) =>
      AdminAiServicesHealth(
        licenseVerification: AdminAiServiceStatus.fromJson(
          _map(json['licenseVerification']),
        ),
        drugSearch: AdminAiServiceStatus.fromJson(_map(json['drugSearch'])),
        smartPharmacyBot: AdminAiServiceStatus.fromJson(
          _map(json['smartPharmacyBot']),
        ),
      );

  final AdminAiServiceStatus licenseVerification;
  final AdminAiServiceStatus drugSearch;
  final AdminAiServiceStatus smartPharmacyBot;
}

class AdminAiServiceStatus {
  const AdminAiServiceStatus({
    required this.available,
    required this.status,
    this.itemsLoaded,
    this.model,
  });

  factory AdminAiServiceStatus.fromJson(Map<String, dynamic> json) =>
      AdminAiServiceStatus(
        available: json['available'] == true,
        status: _text(json['status']),
        itemsLoaded: json['drugsLoaded'] is num
            ? (json['drugsLoaded'] as num).toInt()
            : json['medicinesLoaded'] is num
            ? (json['medicinesLoaded'] as num).toInt()
            : null,
        model: _optional(json['model']),
      );

  final bool available;
  final String status;
  final int? itemsLoaded;
  final String? model;
}

typedef AdminDownloadedDocument = ({
  List<int> bytes,
  String? fileName,
  String? contentType,
});

Map<String, dynamic> _map(Object? value) =>
    value is Map ? Map<String, dynamic>.from(value) : const {};

String _text(Object? value) => value?.toString() ?? '';
String? _optional(Object? value) {
  final text = value?.toString().trim();
  return text == null || text.isEmpty ? null : text;
}

int _int(Object? value) =>
    value is num ? value.toInt() : int.tryParse('$value') ?? 0;
double _double(Object? value) =>
    value is num ? value.toDouble() : double.tryParse('$value') ?? 0;
double? _optionalDouble(Object? value) =>
    value is num ? value.toDouble() : double.tryParse('$value');
DateTime _date(Object? value) =>
    DateTime.tryParse(value?.toString() ?? '') ?? DateTime.now().toUtc();
DateTime? _optionalDate(Object? value) =>
    value == null ? null : DateTime.tryParse(value.toString());
