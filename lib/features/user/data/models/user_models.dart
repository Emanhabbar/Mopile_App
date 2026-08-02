class UserProfile {
  const UserProfile({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.isActive,
    required this.hasSavedLocation,
    required this.hasMedicalProfile,
    required this.hasEmergencyContact,
    required this.searchHistoryCount,
    required this.ratingsCount,
    this.phoneNumber,
    this.currentLatitude,
    this.currentLongitude,
    this.currentLocationAccuracyMeters,
    this.currentLocationSource = '',
    this.lastLocationUpdatedAtUtc,
  });

  final String userId;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final bool isActive;
  final bool hasSavedLocation;
  final double? currentLatitude;
  final double? currentLongitude;
  final double? currentLocationAccuracyMeters;
  final String currentLocationSource;
  final DateTime? lastLocationUpdatedAtUtc;
  final bool hasMedicalProfile;
  final bool hasEmergencyContact;
  final int searchHistoryCount;
  final int ratingsCount;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: _text(json['userId']),
      fullName: _text(json['fullName']),
      email: _text(json['email']),
      phoneNumber: _nullableText(json['phoneNumber']),
      isActive: _boolean(json['isActive']),
      hasSavedLocation: _boolean(json['hasSavedLocation']),
      currentLatitude: _number(json['currentLatitude']),
      currentLongitude: _number(json['currentLongitude']),
      currentLocationAccuracyMeters: _number(
        json['currentLocationAccuracyMeters'],
      ),
      currentLocationSource: _text(json['currentLocationSource']),
      lastLocationUpdatedAtUtc: _dateTime(json['lastLocationUpdatedAtUtc']),
      hasMedicalProfile: _boolean(json['hasMedicalProfile']),
      hasEmergencyContact: _boolean(json['hasEmergencyContact']),
      searchHistoryCount: _integer(json['searchHistoryCount']),
      ratingsCount: _integer(json['ratingsCount']),
    );
  }
}

class UserDashboard {
  const UserDashboard({
    required this.profile,
    required this.activeRequestsCount,
    required this.pendingRequestsCount,
    required this.completedRequestsCount,
    required this.recentSearchesCount,
    required this.openNearbyPharmaciesCount,
    required this.recentRequests,
    required this.recentSearches,
    this.locationContext,
  });

  final UserProfile profile;
  final UserLocationContext? locationContext;
  final int activeRequestsCount;
  final int pendingRequestsCount;
  final int completedRequestsCount;
  final int recentSearchesCount;
  final int openNearbyPharmaciesCount;
  final List<UserMedicineRequestSummary> recentRequests;
  final List<UserSearchHistory> recentSearches;

  factory UserDashboard.fromJson(Map<String, dynamic> json) {
    return UserDashboard(
      profile: UserProfile.fromJson(_map(json['profile'])),
      locationContext: json['locationContext'] is Map
          ? UserLocationContext.fromJson(_map(json['locationContext']))
          : null,
      activeRequestsCount: _integer(json['activeRequestsCount']),
      pendingRequestsCount: _integer(json['pendingRequestsCount']),
      completedRequestsCount: _integer(json['completedRequestsCount']),
      recentSearchesCount: _integer(json['recentSearchesCount']),
      openNearbyPharmaciesCount: _integer(json['openNearbyPharmaciesCount']),
      recentRequests: _mapList(
        json['recentRequests'],
        UserMedicineRequestSummary.fromJson,
      ),
      recentSearches: _mapList(
        json['recentSearches'],
        UserSearchHistory.fromJson,
      ),
    );
  }
}

class UserLocationContext {
  const UserLocationContext({
    required this.hasSavedLocation,
    required this.latitude,
    required this.longitude,
    required this.radiusInMeters,
    required this.registeredCount,
    required this.externalCount,
    required this.usedExternalFallback,
    required this.registeredNearbyPharmacies,
    this.accuracyMeters,
    this.locationSource = '',
    this.lastLocationUpdatedAtUtc,
  });

  final bool hasSavedLocation;
  final double latitude;
  final double longitude;
  final double? accuracyMeters;
  final String locationSource;
  final DateTime? lastLocationUpdatedAtUtc;
  final int radiusInMeters;
  final int registeredCount;
  final int externalCount;
  final bool usedExternalFallback;
  final List<UserPharmacySummary> registeredNearbyPharmacies;

  factory UserLocationContext.fromJson(Map<String, dynamic> json) {
    return UserLocationContext(
      hasSavedLocation: _boolean(json['hasSavedLocation']),
      latitude: _number(json['latitude']) ?? 0,
      longitude: _number(json['longitude']) ?? 0,
      accuracyMeters: _number(json['accuracyMeters']),
      locationSource: _text(json['locationSource']),
      lastLocationUpdatedAtUtc: _dateTime(json['lastLocationUpdatedAtUtc']),
      radiusInMeters: _integer(json['radiusInMeters']),
      registeredCount: _integer(json['registeredCount']),
      externalCount: _integer(json['externalCount']),
      usedExternalFallback: _boolean(json['usedExternalFallback']),
      registeredNearbyPharmacies: _mapList(
        json['registeredNearbyPharmacies'],
        UserPharmacySummary.fromJson,
      ),
    );
  }
}

class UserPharmacySummary {
  const UserPharmacySummary({
    required this.pharmacyId,
    required this.pharmacyName,
    required this.city,
    required this.area,
    required this.address,
    required this.distanceMeters,
    required this.averageRating,
    required this.ratingsCount,
    required this.hasDeliveryService,
    required this.isOpenNow,
    required this.statusText,
    this.phoneNumber,
  });

  final String pharmacyId;
  final String pharmacyName;
  final String city;
  final String area;
  final String address;
  final String? phoneNumber;
  final double distanceMeters;
  final double averageRating;
  final int ratingsCount;
  final bool hasDeliveryService;
  final bool isOpenNow;
  final String statusText;

  factory UserPharmacySummary.fromJson(Map<String, dynamic> json) {
    return UserPharmacySummary(
      pharmacyId: _text(json['pharmacyId']),
      pharmacyName: _text(json['pharmacyName']),
      city: _text(json['city']),
      area: _text(json['area']),
      address: _text(json['address']),
      phoneNumber: _nullableText(json['phoneNumber']),
      distanceMeters: _number(json['distanceMeters']) ?? 0,
      averageRating: _number(json['averageRating']) ?? 0,
      ratingsCount: _integer(json['ratingsCount']),
      hasDeliveryService: _boolean(json['hasDeliveryService']),
      isOpenNow: _boolean(json['isOpenNow']),
      statusText: _text(json['statusText']),
    );
  }
}

class UserMedicineRequestSummary {
  const UserMedicineRequestSummary({
    required this.requestId,
    required this.requestCode,
    required this.pharmacyName,
    required this.medicineName,
    required this.requestedQuantity,
    required this.status,
    required this.statusDisplayText,
    required this.canCancel,
    required this.createdAtUtc,
  });

  final String requestId;
  final String requestCode;
  final String pharmacyName;
  final String medicineName;
  final int requestedQuantity;
  final String status;
  final String statusDisplayText;
  final bool canCancel;
  final DateTime? createdAtUtc;

  factory UserMedicineRequestSummary.fromJson(Map<String, dynamic> json) {
    return UserMedicineRequestSummary(
      requestId: _text(json['requestId']),
      requestCode: _text(json['requestCode']),
      pharmacyName: _text(json['pharmacyName']),
      medicineName: _text(json['medicineName']),
      requestedQuantity: _integer(json['requestedQuantity']),
      status: _text(json['status']),
      statusDisplayText: _text(json['statusDisplayText']),
      canCancel: _boolean(json['canCancel']),
      createdAtUtc: _dateTime(json['createdAtUtc']),
    );
  }
}

class UserSearchHistory {
  const UserSearchHistory({
    required this.id,
    required this.searchType,
    required this.query,
    required this.resultCount,
    this.searchedAtUtc,
  });

  final String id;
  final String searchType;
  final String query;
  final int resultCount;
  final DateTime? searchedAtUtc;

  factory UserSearchHistory.fromJson(Map<String, dynamic> json) {
    return UserSearchHistory(
      id: _text(json['id']),
      searchType: _text(json['searchType']),
      query: _text(json['query']),
      resultCount: _integer(json['resultCount']),
      searchedAtUtc: _dateTime(json['searchedAtUtc']),
    );
  }
}

class UserMedicalProfile {
  const UserMedicalProfile({
    required this.userId,
    required this.hasMedicalProfile,
    required this.hasEmergencyContact,
    required this.allergies,
    required this.chronicConditions,
    required this.currentMedications,
    this.dateOfBirth,
    this.bloodType,
    this.emergencyContactName,
    this.emergencyContactPhoneNumber,
    this.emergencyNotes,
    this.lastUpdatedAtUtc,
  });

  final String userId;
  final bool hasMedicalProfile;
  final bool hasEmergencyContact;
  final DateTime? dateOfBirth;
  final String? bloodType;
  final List<String> allergies;
  final List<String> chronicConditions;
  final List<String> currentMedications;
  final String? emergencyContactName;
  final String? emergencyContactPhoneNumber;
  final String? emergencyNotes;
  final DateTime? lastUpdatedAtUtc;

  factory UserMedicalProfile.fromJson(Map<String, dynamic> json) {
    return UserMedicalProfile(
      userId: _text(json['userId']),
      hasMedicalProfile: _boolean(json['hasMedicalProfile']),
      hasEmergencyContact: _boolean(json['hasEmergencyContact']),
      dateOfBirth: _dateTime(json['dateOfBirth']),
      bloodType: _nullableText(json['bloodType']),
      allergies: _stringList(json['allergies']),
      chronicConditions: _stringList(json['chronicConditions']),
      currentMedications: _stringList(json['currentMedications']),
      emergencyContactName: _nullableText(json['emergencyContactName']),
      emergencyContactPhoneNumber: _nullableText(
        json['emergencyContactPhoneNumber'],
      ),
      emergencyNotes: _nullableText(json['emergencyNotes']),
      lastUpdatedAtUtc: _dateTime(json['lastUpdatedAtUtc']),
    );
  }
}

class UpdateMedicalProfileRequest {
  const UpdateMedicalProfileRequest({
    required this.allergies,
    required this.chronicConditions,
    required this.currentMedications,
    this.dateOfBirth,
    this.bloodType,
    this.emergencyContactName,
    this.emergencyContactPhoneNumber,
    this.emergencyNotes,
  });

  final DateTime? dateOfBirth;
  final String? bloodType;
  final List<String> allergies;
  final List<String> chronicConditions;
  final List<String> currentMedications;
  final String? emergencyContactName;
  final String? emergencyContactPhoneNumber;
  final String? emergencyNotes;

  Map<String, dynamic> toJson() => {
    'dateOfBirth': dateOfBirth == null
        ? null
        : '${dateOfBirth!.year.toString().padLeft(4, '0')}-'
              '${dateOfBirth!.month.toString().padLeft(2, '0')}-'
              '${dateOfBirth!.day.toString().padLeft(2, '0')}',
    'bloodType': _emptyToNull(bloodType),
    'allergies': allergies,
    'chronicConditions': chronicConditions,
    'currentMedications': currentMedications,
    'emergencyContactName': _emptyToNull(emergencyContactName),
    'emergencyContactPhoneNumber': _emptyToNull(emergencyContactPhoneNumber),
    'emergencyNotes': _emptyToNull(emergencyNotes),
  };
}

class UserHealthCard {
  const UserHealthCard({
    required this.userId,
    required this.fullName,
    required this.allergies,
    required this.chronicConditions,
    required this.currentMedications,
    this.phoneNumber,
    this.dateOfBirth,
    this.bloodType,
    this.emergencyContactName,
    this.emergencyContactPhoneNumber,
    this.emergencyNotes,
    this.lastUpdatedAtUtc,
  });

  final String userId;
  final String fullName;
  final String? phoneNumber;
  final DateTime? dateOfBirth;
  final String? bloodType;
  final List<String> allergies;
  final List<String> chronicConditions;
  final List<String> currentMedications;
  final String? emergencyContactName;
  final String? emergencyContactPhoneNumber;
  final String? emergencyNotes;
  final DateTime? lastUpdatedAtUtc;

  factory UserHealthCard.fromJson(Map<String, dynamic> json) {
    return UserHealthCard(
      userId: _text(json['userId']),
      fullName: _text(json['fullName']),
      phoneNumber: _nullableText(json['phoneNumber']),
      dateOfBirth: _dateTime(json['dateOfBirth']),
      bloodType: _nullableText(json['bloodType']),
      allergies: _stringList(json['allergies']),
      chronicConditions: _stringList(json['chronicConditions']),
      currentMedications: _stringList(json['currentMedications']),
      emergencyContactName: _nullableText(json['emergencyContactName']),
      emergencyContactPhoneNumber: _nullableText(
        json['emergencyContactPhoneNumber'],
      ),
      emergencyNotes: _nullableText(json['emergencyNotes']),
      lastUpdatedAtUtc: _dateTime(json['lastUpdatedAtUtc']),
    );
  }
}

Map<String, dynamic> _map(Object? value) =>
    value is Map<String, dynamic> ? value : const {};

List<T> _mapList<T>(Object? value, T Function(Map<String, dynamic>) converter) {
  return value is List
      ? value
            .whereType<Map>()
            .map((item) => converter(Map<String, dynamic>.from(item)))
            .toList(growable: false)
      : const [];
}

List<String> _stringList(Object? value) => value is List
    ? value.map((item) => item.toString()).toList(growable: false)
    : const [];

String _text(Object? value) => value?.toString() ?? '';

String? _nullableText(Object? value) {
  final text = value?.toString().trim();
  return text == null || text.isEmpty ? null : text;
}

bool _boolean(Object? value) => value is bool ? value : false;

int _integer(Object? value) => value is num ? value.toInt() : 0;

double? _number(Object? value) =>
    value is num ? value.toDouble() : double.tryParse(value?.toString() ?? '');

DateTime? _dateTime(Object? value) =>
    DateTime.tryParse(value?.toString() ?? '')?.toLocal();

String? _emptyToNull(String? value) {
  final trimmed = value?.trim();
  return trimmed == null || trimmed.isEmpty ? null : trimmed;
}
