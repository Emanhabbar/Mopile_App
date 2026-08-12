class UserPharmacyDetails {
  const UserPharmacyDetails({
    required this.pharmacy,
    required this.workingHours,
    required this.availableMedicines,
    required this.availableMedicinesCount,
    required this.totalInventoryItems,
    this.currentUserRating,
    this.currentUserComment,
  });

  final UserPharmacyProfile pharmacy;
  final List<PharmacyWorkingHour> workingHours;
  final List<UserPharmacyMedicine> availableMedicines;
  final int availableMedicinesCount;
  final int totalInventoryItems;
  final int? currentUserRating;
  final String? currentUserComment;

  factory UserPharmacyDetails.fromJson(Map<String, dynamic> json) =>
      UserPharmacyDetails(
        pharmacy: UserPharmacyProfile.fromJson(_map(json['pharmacy'])),
        workingHours: _list(json['workingHours'], PharmacyWorkingHour.fromJson),
        availableMedicines: _list(
          json['availableMedicines'],
          UserPharmacyMedicine.fromJson,
        ),
        availableMedicinesCount:
            (json['availableMedicinesCount'] as num?)?.toInt() ?? 0,
        totalInventoryItems:
            (json['totalInventoryItems'] as num?)?.toInt() ?? 0,
        currentUserRating: (json['currentUserRating'] as num?)?.toInt(),
        currentUserComment: _nullable(json['currentUserComment']),
      );
}

class UserPharmacyProfile {
  const UserPharmacyProfile({
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
    this.description,
    this.latitude,
    this.longitude,
    this.locationGoogleMapsUrl,
  });

  final String pharmacyId;
  final String pharmacyName;
  final String city;
  final String area;
  final String address;
  final String? phoneNumber;
  final String? description;
  final double? latitude;
  final double? longitude;
  final String? locationGoogleMapsUrl;
  final double distanceMeters;
  final double averageRating;
  final int ratingsCount;
  final bool hasDeliveryService;
  final bool isOpenNow;
  final String statusText;

  factory UserPharmacyProfile.fromJson(Map<String, dynamic> json) =>
      UserPharmacyProfile(
        pharmacyId: json['pharmacyId']?.toString() ?? '',
        pharmacyName: json['pharmacyName']?.toString() ?? '',
        city: json['city']?.toString() ?? '',
        area: json['area']?.toString() ?? '',
        address: json['address']?.toString() ?? '',
        phoneNumber: _nullable(json['phoneNumber']),
        description: _nullable(json['description']),
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
        locationGoogleMapsUrl: _nullable(json['locationGoogleMapsUrl']),
        distanceMeters: (json['distanceMeters'] as num?)?.toDouble() ?? 0,
        averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0,
        ratingsCount: (json['ratingsCount'] as num?)?.toInt() ?? 0,
        hasDeliveryService: json['hasDeliveryService'] as bool? ?? false,
        isOpenNow: json['isOpenNow'] as bool? ?? false,
        statusText: json['statusText']?.toString() ?? '',
      );
}

class UserPharmacyMedicine {
  const UserPharmacyMedicine({
    required this.medicineId,
    required this.medicineName,
    required this.requiresPrescription,
    this.arabicMedicineName,
    String? medicineDisplayName,
    this.scientificName,
    this.arabicScientificName,
    this.manufacturer,
    this.dosageForm,
    this.capacity,
    this.sellingPrice,
  }) : medicineDisplayName =
           medicineDisplayName ?? arabicMedicineName ?? medicineName;

  final String medicineId;
  final String medicineName;
  final String? arabicMedicineName;
  final String medicineDisplayName;
  final String? scientificName;
  final String? arabicScientificName;
  final String? manufacturer;
  final String? dosageForm;
  final String? capacity;
  final double? sellingPrice;
  final bool requiresPrescription;

  factory UserPharmacyMedicine.fromJson(Map<String, dynamic> json) =>
      UserPharmacyMedicine(
        medicineId: json['medicineId']?.toString() ?? '',
        medicineName: json['medicineName']?.toString() ?? '',
        arabicMedicineName: _nullable(json['arabicMedicineName']),
        medicineDisplayName: _nullable(json['medicineDisplayName']),
        scientificName: _nullable(json['scientificName']),
        arabicScientificName: _nullable(json['arabicScientificName']),
        manufacturer: _nullable(json['manufacturer']),
        dosageForm: _nullable(json['dosageForm']),
        capacity: _nullable(json['capacity']),
        sellingPrice: (json['sellingPrice'] as num?)?.toDouble(),
        requiresPrescription: json['requiresPrescription'] as bool? ?? false,
      );
}

class PharmacyWorkingHour {
  const PharmacyWorkingHour({
    required this.dayOfWeek,
    required this.isClosed,
    this.openTime,
    this.closeTime,
  });

  final int dayOfWeek;
  final String? openTime;
  final String? closeTime;
  final bool isClosed;

  factory PharmacyWorkingHour.fromJson(Map<String, dynamic> json) =>
      PharmacyWorkingHour(
        dayOfWeek: _day(json['dayOfWeek']),
        openTime: _nullable(json['openTime']),
        closeTime: _nullable(json['closeTime']),
        isClosed: json['isClosed'] as bool? ?? false,
      );
}

class CreateMedicineRequest {
  const CreateMedicineRequest({
    required this.medicineId,
    required this.requestedQuantity,
    this.note,
  });

  final String medicineId;
  final int requestedQuantity;
  final String? note;

  Map<String, dynamic> toJson() => {
    'medicineId': medicineId,
    'requestedQuantity': requestedQuantity,
    'note': _emptyToNull(note),
  };
}

class MedicineAlternative {
  const MedicineAlternative({
    required this.medicineId,
    required this.medicineName,
    this.arabicMedicineName,
    String? medicineDisplayName,
    this.scientificName,
    this.arabicScientificName,
    this.composition,
    this.dosageForm,
    this.manufacturer,
    this.capacity,
  }) : medicineDisplayName =
           medicineDisplayName ?? arabicMedicineName ?? medicineName;

  final String medicineId;
  final String medicineName;
  final String? arabicMedicineName;
  final String medicineDisplayName;
  final String? scientificName;
  final String? arabicScientificName;
  final String? composition;
  final String? dosageForm;
  final String? manufacturer;
  final String? capacity;

  factory MedicineAlternative.fromJson(Map<String, dynamic> json) =>
      MedicineAlternative(
        medicineId: json['medicineId']?.toString() ?? '',
        medicineName: json['medicineName']?.toString() ?? '',
        arabicMedicineName: _nullable(json['arabicMedicineName']),
        medicineDisplayName: _nullable(json['medicineDisplayName']),
        scientificName: _nullable(json['scientificName']),
        arabicScientificName: _nullable(json['arabicScientificName']),
        composition: _nullable(json['composition']),
        dosageForm: _nullable(json['dosageForm']),
        manufacturer: _nullable(json['manufacturer']),
        capacity: _nullable(json['capacity']),
      );
}

class UserMedicineRequestResult {
  const UserMedicineRequestResult({
    required this.requestId,
    required this.requestCode,
    required this.pharmacyId,
    required this.medicineId,
    required this.pharmacyName,
    required this.medicineName,
    required this.requestedQuantity,
    required this.status,
    required this.statusDisplayText,
    required this.canCancel,
    this.arabicMedicineName,
    String? medicineDisplayName,
    this.note,
    this.suggestedAlternative,
    this.createdAtUtc,
  }) : medicineDisplayName =
           medicineDisplayName ?? arabicMedicineName ?? medicineName;

  final String requestId;
  final String requestCode;
  final String pharmacyId;
  final String medicineId;
  final String pharmacyName;
  final String medicineName;
  final String? arabicMedicineName;
  final String medicineDisplayName;
  final int requestedQuantity;
  final String status;
  final String statusDisplayText;
  final String? note;
  final MedicineAlternative? suggestedAlternative;
  final bool canCancel;
  final DateTime? createdAtUtc;

  factory UserMedicineRequestResult.fromJson(Map<String, dynamic> json) =>
      UserMedicineRequestResult(
        requestId: json['requestId']?.toString() ?? '',
        requestCode: json['requestCode']?.toString() ?? '',
        pharmacyId: json['pharmacyId']?.toString() ?? '',
        medicineId: json['medicineId']?.toString() ?? '',
        pharmacyName: json['pharmacyName']?.toString() ?? '',
        medicineName: json['medicineName']?.toString() ?? '',
        arabicMedicineName: _nullable(json['arabicMedicineName']),
        medicineDisplayName: _nullable(json['medicineDisplayName']),
        requestedQuantity: (json['requestedQuantity'] as num?)?.toInt() ?? 0,
        status: json['status']?.toString() ?? '',
        statusDisplayText: json['statusDisplayText']?.toString() ?? '',
        note: _nullable(json['note']),
        suggestedAlternative: json['suggestedAlternative'] is Map
            ? MedicineAlternative.fromJson(_map(json['suggestedAlternative']))
            : null,
        canCancel: json['canCancel'] as bool? ?? false,
        createdAtUtc: _date(json['createdAtUtc']),
      );
}

class UserMedicineRequest {
  const UserMedicineRequest({
    required this.requestId,
    required this.requestCode,
    required this.pharmacyId,
    required this.medicineId,
    required this.pharmacyName,
    required this.medicineName,
    required this.requestedQuantity,
    required this.status,
    required this.statusDisplayText,
    required this.canCancel,
    required this.hasPharmacyResponse,
    required this.isFinalStatus,
    required this.createdAtUtc,
    required this.pharmacyIsOpenNow,
    required this.pharmacyStatusText,
    this.arabicMedicineName,
    String? medicineDisplayName,
    this.note,
    this.pharmacyResponseNote,
    this.suggestedAlternative,
    this.statusUpdatedAtUtc,
    this.respondedAtUtc,
    this.cancelledAtUtc,
    this.pharmacyPhoneNumber,
  }) : medicineDisplayName =
           medicineDisplayName ?? arabicMedicineName ?? medicineName;

  final String requestId;
  final String requestCode;
  final String pharmacyId;
  final String medicineId;
  final String pharmacyName;
  final String medicineName;
  final String? arabicMedicineName;
  final String medicineDisplayName;
  final int requestedQuantity;
  final String status;
  final String statusDisplayText;
  final String? note;
  final String? pharmacyResponseNote;
  final MedicineAlternative? suggestedAlternative;
  final bool canCancel;
  final bool hasPharmacyResponse;
  final bool isFinalStatus;
  final DateTime? createdAtUtc;
  final DateTime? statusUpdatedAtUtc;
  final DateTime? respondedAtUtc;
  final DateTime? cancelledAtUtc;
  final String? pharmacyPhoneNumber;
  final bool pharmacyIsOpenNow;
  final String pharmacyStatusText;

  factory UserMedicineRequest.fromJson(Map<String, dynamic> json) =>
      UserMedicineRequest(
        requestId: json['requestId']?.toString() ?? '',
        requestCode: json['requestCode']?.toString() ?? '',
        pharmacyId: json['pharmacyId']?.toString() ?? '',
        medicineId: json['medicineId']?.toString() ?? '',
        pharmacyName: json['pharmacyName']?.toString() ?? '',
        medicineName: json['medicineName']?.toString() ?? '',
        arabicMedicineName: _nullable(json['arabicMedicineName']),
        medicineDisplayName: _nullable(json['medicineDisplayName']),
        requestedQuantity: (json['requestedQuantity'] as num?)?.toInt() ?? 0,
        status: json['status']?.toString() ?? '',
        statusDisplayText: json['statusDisplayText']?.toString() ?? '',
        note: _nullable(json['note']),
        pharmacyResponseNote: _nullable(json['pharmacyResponseNote']),
        suggestedAlternative: json['suggestedAlternative'] is Map
            ? MedicineAlternative.fromJson(_map(json['suggestedAlternative']))
            : null,
        canCancel: json['canCancel'] as bool? ?? false,
        hasPharmacyResponse: json['hasPharmacyResponse'] as bool? ?? false,
        isFinalStatus: json['isFinalStatus'] as bool? ?? false,
        createdAtUtc: _date(json['createdAtUtc']),
        statusUpdatedAtUtc: _date(json['statusUpdatedAtUtc']),
        respondedAtUtc: _date(json['respondedAtUtc']),
        cancelledAtUtc: _date(json['cancelledAtUtc']),
        pharmacyPhoneNumber: _nullable(json['pharmacyPhoneNumber']),
        pharmacyIsOpenNow: json['pharmacyIsOpenNow'] as bool? ?? false,
        pharmacyStatusText: json['pharmacyStatusText']?.toString() ?? '',
      );
}

class UserMedicineRequestDetails {
  const UserMedicineRequestDetails({
    required this.request,
    required this.pharmacyCity,
    required this.pharmacyArea,
    required this.pharmacyAddress,
    required this.isRequestedMedicineCurrentlyAvailable,
    this.pharmacyLatitude,
    this.pharmacyLongitude,
    this.pharmacyGoogleMapsUrl,
  });

  final UserMedicineRequest request;
  final String pharmacyCity;
  final String pharmacyArea;
  final String pharmacyAddress;
  final double? pharmacyLatitude;
  final double? pharmacyLongitude;
  final String? pharmacyGoogleMapsUrl;
  final bool isRequestedMedicineCurrentlyAvailable;

  factory UserMedicineRequestDetails.fromJson(Map<String, dynamic> json) =>
      UserMedicineRequestDetails(
        request: UserMedicineRequest.fromJson(json),
        pharmacyCity: json['pharmacyCity']?.toString() ?? '',
        pharmacyArea: json['pharmacyArea']?.toString() ?? '',
        pharmacyAddress: json['pharmacyAddress']?.toString() ?? '',
        pharmacyLatitude: (json['pharmacyLatitude'] as num?)?.toDouble(),
        pharmacyLongitude: (json['pharmacyLongitude'] as num?)?.toDouble(),
        pharmacyGoogleMapsUrl: _nullable(json['pharmacyGoogleMapsUrl']),
        isRequestedMedicineCurrentlyAvailable:
            json['isRequestedMedicineCurrentlyAvailable'] as bool? ?? false,
      );
}

class PharmacyRating {
  const PharmacyRating({
    required this.pharmacyId,
    required this.userScore,
    required this.averageRating,
    required this.ratingsCount,
    this.userComment,
  });

  final String pharmacyId;
  final int userScore;
  final String? userComment;
  final double averageRating;
  final int ratingsCount;

  factory PharmacyRating.fromJson(Map<String, dynamic> json) => PharmacyRating(
    pharmacyId: json['pharmacyId']?.toString() ?? '',
    userScore: (json['userScore'] as num?)?.toInt() ?? 0,
    userComment: _nullable(json['userComment']),
    averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0,
    ratingsCount: (json['ratingsCount'] as num?)?.toInt() ?? 0,
  );
}

class UserSearchRecord {
  const UserSearchRecord({
    required this.id,
    required this.searchType,
    required this.query,
    required this.resultCount,
    this.latitude,
    this.longitude,
    this.radiusInMeters,
    this.searchedAtUtc,
  });

  final String id;
  final String searchType;
  final String query;
  final double? latitude;
  final double? longitude;
  final int? radiusInMeters;
  final int resultCount;
  final DateTime? searchedAtUtc;

  factory UserSearchRecord.fromJson(Map<String, dynamic> json) =>
      UserSearchRecord(
        id: json['id']?.toString() ?? '',
        searchType: json['searchType']?.toString() ?? '',
        query: json['query']?.toString() ?? '',
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
        radiusInMeters: (json['radiusInMeters'] as num?)?.toInt(),
        resultCount: (json['resultCount'] as num?)?.toInt() ?? 0,
        searchedAtUtc: _date(json['searchedAtUtc']),
      );
}

Map<String, dynamic> _map(Object? value) =>
    value is Map ? Map<String, dynamic>.from(value) : const {};

List<T> _list<T>(Object? value, T Function(Map<String, dynamic>) converter) =>
    value is List
    ? value
          .whereType<Map>()
          .map((item) => converter(Map<String, dynamic>.from(item)))
          .toList(growable: false)
    : const [];

String? _nullable(Object? value) {
  final result = value?.toString().trim();
  return result == null || result.isEmpty ? null : result;
}

String? _emptyToNull(String? value) => _nullable(value);
DateTime? _date(Object? value) =>
    DateTime.tryParse(value?.toString() ?? '')?.toLocal();

int _day(Object? value) {
  if (value is num) return value.toInt();
  const days = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];
  final index = days.indexWhere(
    (day) => day.toLowerCase() == value?.toString().toLowerCase(),
  );
  return index < 0 ? 0 : index;
}
