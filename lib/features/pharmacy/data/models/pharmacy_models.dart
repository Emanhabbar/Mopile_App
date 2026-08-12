class PharmacyDashboard {
  const PharmacyDashboard({
    required this.pharmacyId,
    required this.pharmacyName,
    required this.licenseNumber,
    required this.city,
    required this.area,
    required this.address,
    required this.hasLocation,
    required this.locationSource,
    required this.isLocationVerified,
    required this.timeZoneId,
    required this.hasDeliveryService,
    required this.isApproved,
    required this.isOpenNow,
    required this.statusText,
    required this.averageRating,
    required this.ratingsCount,
    required this.inventoryItemsCount,
    required this.availableMedicinesCount,
    required this.inStockCount,
    required this.lowStockCount,
    required this.outOfStockCount,
    required this.expiringSoonCount,
    required this.pendingRequestsCount,
    required this.activeRequestsCount,
    required this.hasWorkingHoursConfigured,
    required this.profileCompletionPercentage,
    required this.expiringSoonItems,
    required this.lowStockItems,
    this.description,
    this.phoneNumber,
    this.latitude,
    this.longitude,
    this.externalPlaceId,
    this.locationGoogleMapsUrl,
    this.locationAccuracyMeters,
  });

  final String pharmacyId;
  final String pharmacyName;
  final String licenseNumber;
  final String city;
  final String area;
  final String address;
  final String? description;
  final String? phoneNumber;
  final double? latitude;
  final double? longitude;
  final bool hasLocation;
  final String? externalPlaceId;
  final String locationSource;
  final bool isLocationVerified;
  final double? locationAccuracyMeters;
  final String? locationGoogleMapsUrl;
  final String timeZoneId;
  final bool hasDeliveryService;
  final bool isApproved;
  final bool isOpenNow;
  final String statusText;
  final double averageRating;
  final int ratingsCount;
  final int inventoryItemsCount;
  final int availableMedicinesCount;
  final int inStockCount;
  final int lowStockCount;
  final int outOfStockCount;
  final int expiringSoonCount;
  final int pendingRequestsCount;
  final int activeRequestsCount;
  final bool hasWorkingHoursConfigured;
  final int profileCompletionPercentage;
  final List<PharmacyInventoryAlert> expiringSoonItems;
  final List<PharmacyInventoryAlert> lowStockItems;

  factory PharmacyDashboard.fromJson(Map<String, dynamic> json) =>
      PharmacyDashboard(
        pharmacyId: _text(json['pharmacyId']),
        pharmacyName: _text(json['pharmacyName']),
        licenseNumber: _text(json['licenseNumber']),
        city: _text(json['city']),
        area: _text(json['area']),
        address: _text(json['address']),
        description: _nullable(json['description']),
        phoneNumber: _nullable(json['phoneNumber']),
        latitude: _double(json['latitude']),
        longitude: _double(json['longitude']),
        hasLocation: _bool(json['hasLocation']),
        externalPlaceId: _nullable(json['externalPlaceId']),
        locationSource: _text(json['locationSource']),
        isLocationVerified: _bool(json['isLocationVerified']),
        locationAccuracyMeters: _double(json['locationAccuracyMeters']),
        locationGoogleMapsUrl: _nullable(json['locationGoogleMapsUrl']),
        timeZoneId: _text(json['timeZoneId']),
        hasDeliveryService: _bool(json['hasDeliveryService']),
        isApproved: _bool(json['isApproved']),
        isOpenNow: _bool(json['isOpenNow']),
        statusText: _text(json['statusText']),
        averageRating: _double(json['averageRating']) ?? 0,
        ratingsCount: _int(json['ratingsCount']),
        inventoryItemsCount: _int(json['inventoryItemsCount']),
        availableMedicinesCount: _int(json['availableMedicinesCount']),
        inStockCount: _int(json['inStockCount']),
        lowStockCount: _int(json['lowStockCount']),
        outOfStockCount: _int(json['outOfStockCount']),
        expiringSoonCount: _int(json['expiringSoonCount']),
        pendingRequestsCount: _int(json['pendingRequestsCount']),
        activeRequestsCount: _int(json['activeRequestsCount']),
        hasWorkingHoursConfigured: _bool(json['hasWorkingHoursConfigured']),
        profileCompletionPercentage: _int(json['profileCompletionPercentage']),
        expiringSoonItems: _list(
          json['expiringSoonItems'],
          PharmacyInventoryAlert.fromJson,
        ),
        lowStockItems: _list(
          json['lowStockItems'],
          PharmacyInventoryAlert.fromJson,
        ),
      );
}

class PharmacyOpenStatus {
  const PharmacyOpenStatus({
    required this.pharmacyId,
    required this.isOpenNow,
    required this.statusText,
    required this.timeZoneId,
    this.localDateTime,
  });

  final String pharmacyId;
  final bool isOpenNow;
  final String statusText;
  final DateTime? localDateTime;
  final String timeZoneId;

  factory PharmacyOpenStatus.fromJson(Map<String, dynamic> json) =>
      PharmacyOpenStatus(
        pharmacyId: _text(json['pharmacyId']),
        isOpenNow: _bool(json['isOpenNow']),
        statusText: _text(json['statusText']),
        localDateTime: _date(json['localDateTime']),
        timeZoneId: _text(json['timeZoneId']),
      );
}

class PharmacyInventoryAlert {
  const PharmacyInventoryAlert({
    required this.inventoryItemId,
    required this.medicineId,
    required this.medicineName,
    required this.quantity,
    required this.lowStockThreshold,
    required this.alertType,
    this.expiryDateUtc,
    this.daysUntilExpiry,
  });

  final String inventoryItemId;
  final String medicineId;
  final String medicineName;
  final int quantity;
  final int lowStockThreshold;
  final DateTime? expiryDateUtc;
  final int? daysUntilExpiry;
  final String alertType;

  factory PharmacyInventoryAlert.fromJson(Map<String, dynamic> json) =>
      PharmacyInventoryAlert(
        inventoryItemId: _text(json['inventoryItemId']),
        medicineId: _text(json['medicineId']),
        medicineName: _text(json['medicineName']),
        quantity: _int(json['quantity']),
        lowStockThreshold: _int(json['lowStockThreshold']),
        expiryDateUtc: _date(json['expiryDateUtc']),
        daysUntilExpiry: (json['daysUntilExpiry'] as num?)?.toInt(),
        alertType: _text(json['alertType']),
      );
}

class PharmacyInventoryItem {
  const PharmacyInventoryItem({
    required this.inventoryItemId,
    required this.medicineId,
    required this.medicineName,
    required this.sellingPrice,
    required this.isPriceVisibleToUsers,
    required this.quantity,
    required this.isAvailable,
    required this.lowStockThreshold,
    required this.stockStatus,
    required this.requiresPrescription,
    this.arabicMedicineName,
    String? medicineDisplayName,
    this.scientificName,
    this.arabicScientificName,
    this.manufacturer,
    this.dosageForm,
    this.packageSize,
    this.capacity,
    this.expiryDateUtc,
    this.daysUntilExpiry,
  }) : medicineDisplayName =
           medicineDisplayName ?? arabicMedicineName ?? medicineName;

  final String inventoryItemId;
  final String medicineId;
  final String medicineName;
  final String? arabicMedicineName;
  final String medicineDisplayName;
  final String? scientificName;
  final String? arabicScientificName;
  final String? manufacturer;
  final String? dosageForm;
  final String? packageSize;
  final String? capacity;
  final double sellingPrice;
  final bool isPriceVisibleToUsers;
  final int quantity;
  final bool isAvailable;
  final DateTime? expiryDateUtc;
  final int lowStockThreshold;
  final String stockStatus;
  final int? daysUntilExpiry;
  final bool requiresPrescription;

  factory PharmacyInventoryItem.fromJson(Map<String, dynamic> json) =>
      PharmacyInventoryItem(
        inventoryItemId: _text(json['inventoryItemId']),
        medicineId: _text(json['medicineId']),
        medicineName: _text(json['medicineName']),
        arabicMedicineName: _nullable(json['arabicMedicineName']),
        medicineDisplayName: _nullable(json['medicineDisplayName']),
        scientificName: _nullable(json['scientificName']),
        arabicScientificName: _nullable(json['arabicScientificName']),
        manufacturer: _nullable(json['manufacturer']),
        dosageForm: _nullable(json['dosageForm']),
        packageSize: _nullable(json['packageSize']),
        capacity: _nullable(json['capacity']),
        sellingPrice: _double(json['sellingPrice']) ?? 0,
        isPriceVisibleToUsers: _bool(json['isPriceVisibleToUsers']),
        quantity: _int(json['quantity']),
        isAvailable: _bool(json['isAvailable']),
        expiryDateUtc: _date(json['expiryDateUtc']),
        lowStockThreshold: _int(json['lowStockThreshold']),
        stockStatus: _text(json['stockStatus']),
        daysUntilExpiry: (json['daysUntilExpiry'] as num?)?.toInt(),
        requiresPrescription: _bool(json['requiresPrescription']),
      );
}

class PharmacyWorkingPeriod {
  const PharmacyWorkingPeriod({
    required this.dayOfWeek,
    required this.isClosed,
    this.id,
    this.openTime,
    this.closeTime,
  });

  final String? id;
  final int dayOfWeek;
  final String? openTime;
  final String? closeTime;
  final bool isClosed;

  factory PharmacyWorkingPeriod.fromJson(Map<String, dynamic> json) =>
      PharmacyWorkingPeriod(
        id: _nullable(json['id']),
        dayOfWeek: _day(json['dayOfWeek']),
        openTime: _nullable(json['openTime']),
        closeTime: _nullable(json['closeTime']),
        isClosed: _bool(json['isClosed']),
      );

  Map<String, dynamic> toJson() => {
    'dayOfWeek': dayOfWeek,
    'openTime': isClosed ? null : openTime,
    'closeTime': isClosed ? null : closeTime,
    'isClosed': isClosed,
  };
}

class PharmacyCatalogMedicine {
  const PharmacyCatalogMedicine({
    required this.id,
    required this.name,
    required this.requiresPrescription,
    this.barcode,
    this.arabicName,
    String? displayName,
    this.scientificName,
    this.arabicScientificName,
    this.manufacturer,
    this.dosageForm,
    this.packageSize,
    this.capacity,
  }) : displayName = displayName ?? arabicName ?? name;
  final String id;
  final String name;
  final String? barcode;
  final String? arabicName;
  final String displayName;
  final String? scientificName;
  final String? arabicScientificName;
  final String? manufacturer;
  final String? dosageForm;
  final String? packageSize;
  final String? capacity;
  final bool requiresPrescription;

  factory PharmacyCatalogMedicine.fromJson(Map<String, dynamic> json) =>
      PharmacyCatalogMedicine(
        id: _text(json['id']),
        name: _text(json['name']),
        barcode: _nullable(json['barcode']),
        arabicName: _nullable(json['arabicName']),
        displayName: _nullable(json['displayName']),
        scientificName: _nullable(json['scientificName']),
        arabicScientificName: _nullable(json['arabicScientificName']),
        manufacturer: _nullable(json['manufacturer']),
        dosageForm: _nullable(json['dosageForm']),
        packageSize: _nullable(json['packageSize']),
        capacity: _nullable(json['capacity']),
        requiresPrescription: _bool(json['requiresPrescription']),
      );
}

class PharmacyCatalogPage {
  const PharmacyCatalogPage({
    required this.items,
    required this.pageNumber,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
  });

  factory PharmacyCatalogPage.fromJson(Map<String, dynamic> json) =>
      PharmacyCatalogPage(
        items: _list(json['items'], PharmacyCatalogMedicine.fromJson),
        pageNumber: _int(json['pageNumber']),
        pageSize: _int(json['pageSize']),
        totalCount: _int(json['totalCount']),
        totalPages: _int(json['totalPages']),
      );

  final List<PharmacyCatalogMedicine> items;
  final int pageNumber;
  final int pageSize;
  final int totalCount;
  final int totalPages;

  bool get hasNextPage => pageNumber < totalPages;
}

class PharmacyInventoryBatchItemInput {
  const PharmacyInventoryBatchItemInput({
    required this.medicineId,
    required this.quantity,
    required this.unitPrice,
    required this.isPriceVisibleToUsers,
    required this.isAvailable,
    required this.lowStockThreshold,
    this.expiryDate,
  });

  final String medicineId;
  final int quantity;
  final double unitPrice;
  final bool isPriceVisibleToUsers;
  final bool isAvailable;
  final int lowStockThreshold;
  final DateTime? expiryDate;

  Map<String, dynamic> toJson() => {
    'medicineId': medicineId,
    'quantity': quantity,
    'unitPrice': unitPrice,
    'isPriceVisibleToUsers': isPriceVisibleToUsers,
    'isAvailable': isAvailable,
    'expiryDateUtc': expiryDate?.toUtc().toIso8601String(),
    'lowStockThreshold': lowStockThreshold,
  };
}

class PharmacyLocationCandidate {
  const PharmacyLocationCandidate({
    required this.placeId,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.distanceMeters,
    required this.rating,
    required this.totalRatings,
    required this.isOpenNow,
    required this.googleMapsUrl,
    required this.isBestMatch,
  });
  final String placeId;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double distanceMeters;
  final double rating;
  final int totalRatings;
  final bool isOpenNow;
  final String googleMapsUrl;
  final bool isBestMatch;

  factory PharmacyLocationCandidate.fromJson(Map<String, dynamic> json) =>
      PharmacyLocationCandidate(
        placeId: _text(json['placeId']),
        name: _text(json['name']),
        address: _text(json['address']),
        latitude: _double(json['latitude']) ?? 0,
        longitude: _double(json['longitude']) ?? 0,
        distanceMeters: _double(json['distanceMeters']) ?? 0,
        rating: _double(json['rating']) ?? 0,
        totalRatings: _int(json['totalRatings']),
        isOpenNow: _bool(json['isOpenNow']),
        googleMapsUrl: _text(json['googleMapsUrl']),
        isBestMatch: _bool(json['isBestMatch']),
      );
}

class PharmacyRequest {
  const PharmacyRequest({
    required this.requestId,
    required this.requestCode,
    required this.medicineId,
    required this.medicineName,
    required this.userFullName,
    required this.requestedQuantity,
    required this.status,
    required this.statusDisplayText,
    required this.canRespond,
    required this.hasPharmacyResponse,
    required this.isFinalStatus,
    this.arabicMedicineName,
    String? medicineDisplayName,
    this.userPhoneNumber,
    this.note,
    this.pharmacyResponseNote,
    this.suggestedAlternative,
    this.createdAtUtc,
  }) : medicineDisplayName =
           medicineDisplayName ?? arabicMedicineName ?? medicineName;

  final String requestId;
  final String requestCode;
  final String medicineId;
  final String medicineName;
  final String? arabicMedicineName;
  final String medicineDisplayName;
  final String userFullName;
  final String? userPhoneNumber;
  final int requestedQuantity;
  final String status;
  final String statusDisplayText;
  final String? note;
  final String? pharmacyResponseNote;
  final PharmacyCatalogMedicine? suggestedAlternative;
  final bool canRespond;
  final bool hasPharmacyResponse;
  final bool isFinalStatus;
  final DateTime? createdAtUtc;

  factory PharmacyRequest.fromJson(Map<String, dynamic> json) =>
      PharmacyRequest(
        requestId: _text(json['requestId']),
        requestCode: _text(json['requestCode']),
        medicineId: _text(json['medicineId']),
        medicineName: _text(json['medicineName']),
        arabicMedicineName: _nullable(json['arabicMedicineName']),
        medicineDisplayName: _nullable(json['medicineDisplayName']),
        userFullName: _text(json['userFullName']),
        userPhoneNumber: _nullable(json['userPhoneNumber']),
        requestedQuantity: _int(json['requestedQuantity']),
        status: _text(json['status']),
        statusDisplayText: _text(json['statusDisplayText']),
        note: _nullable(json['note']),
        pharmacyResponseNote: _nullable(json['pharmacyResponseNote']),
        suggestedAlternative: json['suggestedAlternative'] is Map
            ? PharmacyCatalogMedicine.fromJson(
                _map(json['suggestedAlternative']),
              )
            : null,
        canRespond: _bool(json['canRespond']),
        hasPharmacyResponse: _bool(json['hasPharmacyResponse']),
        isFinalStatus: _bool(json['isFinalStatus']),
        createdAtUtc: _date(json['createdAtUtc']),
      );
}

class PharmacyRequestDetails {
  const PharmacyRequestDetails({
    required this.request,
    required this.pharmacyName,
    required this.userEmail,
    required this.isRequestedMedicineCurrentlyAvailable,
    required this.alternativeCandidates,
    this.requestedMedicineScientificName,
    this.requestedMedicineArabicScientificName,
    this.requestedMedicineComposition,
    this.requestedMedicineDosageForm,
    this.requestedMedicineCapacity,
  });
  final PharmacyRequest request;
  final String pharmacyName;
  final String userEmail;
  final String? requestedMedicineScientificName;
  final String? requestedMedicineArabicScientificName;
  final String? requestedMedicineComposition;
  final String? requestedMedicineDosageForm;
  final String? requestedMedicineCapacity;
  final bool isRequestedMedicineCurrentlyAvailable;
  final List<PharmacyCatalogMedicine> alternativeCandidates;

  factory PharmacyRequestDetails.fromJson(Map<String, dynamic> json) =>
      PharmacyRequestDetails(
        request: PharmacyRequest.fromJson(json),
        pharmacyName: _text(json['pharmacyName']),
        userEmail: _text(json['userEmail']),
        requestedMedicineScientificName: _nullable(
          json['requestedMedicineScientificName'],
        ),
        requestedMedicineArabicScientificName: _nullable(
          json['requestedMedicineArabicScientificName'],
        ),
        requestedMedicineComposition: _nullable(
          json['requestedMedicineComposition'],
        ),
        requestedMedicineDosageForm: _nullable(
          json['requestedMedicineDosageForm'],
        ),
        requestedMedicineCapacity: _nullable(json['requestedMedicineCapacity']),
        isRequestedMedicineCurrentlyAvailable: _bool(
          json['isRequestedMedicineCurrentlyAvailable'],
        ),
        alternativeCandidates: _list(
          json['alternativeCandidates'],
          PharmacyCatalogMedicine.fromJson,
        ),
      );
}

class PharmacyLicenseVerification {
  const PharmacyLicenseVerification({
    required this.verificationId,
    required this.pharmacyId,
    required this.status,
    required this.registeredName,
    required this.originalFileName,
    required this.contentType,
    required this.fileSizeBytes,
    required this.attemptCount,
    required this.submittedAtUtc,
    this.isReadable,
    this.extractedName,
    this.parentName,
    this.birthPlace,
    this.birthYear,
    this.registryNumber,
    this.registryDate,
    this.decreeNumber,
    this.decreeDate,
    this.documentSerialNumber,
    this.ocrConfidence,
    this.matchScore,
    this.matchThreshold,
    this.isNameMatch,
    this.rejectionReason,
    this.failureReason,
    this.manualReviewNote,
    this.manuallyReviewedAtUtc,
    this.processedAtUtc,
  });

  factory PharmacyLicenseVerification.fromJson(Map<String, dynamic> json) =>
      PharmacyLicenseVerification(
        verificationId: _text(json['verificationId']),
        pharmacyId: _text(json['pharmacyId']),
        status: _text(json['status']),
        registeredName: _text(json['registeredName']),
        originalFileName: _text(json['originalFileName']),
        contentType: _text(json['contentType']),
        fileSizeBytes: _int(json['fileSizeBytes']),
        isReadable: json['isReadable'] as bool?,
        extractedName: _nullable(json['extractedName']),
        parentName: _nullable(json['parentName']),
        birthPlace: _nullable(json['birthPlace']),
        birthYear: _nullable(json['birthYear']),
        registryNumber: _nullable(json['registryNumber']),
        registryDate: _nullable(json['registryDate']),
        decreeNumber: _nullable(json['decreeNumber']),
        decreeDate: _nullable(json['decreeDate']),
        documentSerialNumber: _nullable(json['documentSerialNumber']),
        ocrConfidence: _double(json['ocrConfidence']),
        matchScore: _double(json['matchScore']),
        matchThreshold: _double(json['matchThreshold']),
        isNameMatch: json['isNameMatch'] as bool?,
        rejectionReason: _nullable(json['rejectionReason']),
        failureReason: _nullable(json['failureReason']),
        manualReviewNote: _nullable(json['manualReviewNote']),
        manuallyReviewedAtUtc: _date(json['manuallyReviewedAtUtc']),
        attemptCount: _int(json['attemptCount']),
        submittedAtUtc: _date(json['submittedAtUtc']) ?? DateTime.now(),
        processedAtUtc: _date(json['processedAtUtc']),
      );

  final String verificationId;
  final String pharmacyId;
  final String status;
  final String registeredName;
  final String originalFileName;
  final String contentType;
  final int fileSizeBytes;
  final bool? isReadable;
  final String? extractedName;
  final String? parentName;
  final String? birthPlace;
  final String? birthYear;
  final String? registryNumber;
  final String? registryDate;
  final String? decreeNumber;
  final String? decreeDate;
  final String? documentSerialNumber;
  final double? ocrConfidence;
  final double? matchScore;
  final double? matchThreshold;
  final bool? isNameMatch;
  final String? rejectionReason;
  final String? failureReason;
  final String? manualReviewNote;
  final DateTime? manuallyReviewedAtUtc;
  final int attemptCount;
  final DateTime submittedAtUtc;
  final DateTime? processedAtUtc;

  bool get isPending =>
      status.toLowerCase() == 'pending' || status.toLowerCase() == 'processing';
}

Map<String, dynamic> _map(Object? value) =>
    value is Map ? Map<String, dynamic>.from(value) : const {};
List<T> _list<T>(Object? value, T Function(Map<String, dynamic>) parser) =>
    value is List
    ? value
          .whereType<Map>()
          .map((item) => parser(Map<String, dynamic>.from(item)))
          .toList(growable: false)
    : const [];
String _text(Object? value) => value?.toString() ?? '';
String? _nullable(Object? value) {
  final text = value?.toString().trim();
  return text == null || text.isEmpty ? null : text;
}

int _int(Object? value) => (value as num?)?.toInt() ?? 0;
double? _double(Object? value) => (value as num?)?.toDouble();
bool _bool(Object? value) => value as bool? ?? false;
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
  return days.indexWhere(
    (day) => day.toLowerCase() == value?.toString().toLowerCase(),
  );
}
