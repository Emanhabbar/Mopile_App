import 'user_models.dart';

class UserLocationUpdate {
  const UserLocationUpdate({
    required this.latitude,
    required this.longitude,
    this.accuracyMeters,
    this.source = 'Manual',
  });

  final double latitude;
  final double longitude;
  final double? accuracyMeters;
  final String source;

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
    'accuracyMeters': accuracyMeters,
    'source': source,
  };
}

class UserNearbyQuery {
  const UserNearbyQuery({
    this.latitude,
    this.longitude,
    this.radiusInMeters = 5000,
    this.take = 20,
    this.externalTake = 4,
    this.includeExternalFallback = true,
    this.sortBy = 'Distance',
  });

  final double? latitude;
  final double? longitude;
  final int radiusInMeters;
  final int take;
  final int externalTake;
  final bool includeExternalFallback;
  final String sortBy;

  Map<String, dynamic> toQuery() => {
    if (latitude != null) 'latitude': latitude,
    if (longitude != null) 'longitude': longitude,
    'radiusInMeters': radiusInMeters,
    'take': take,
    'externalTake': externalTake,
    'includeExternalFallback': includeExternalFallback,
    'sortBy': sortBy,
  };
}

class UserMedicineSearch {
  const UserMedicineSearch({
    required this.query,
    this.latitude,
    this.longitude,
    this.radiusInMeters = 5000,
    this.maxResults = 50,
    this.sortBy = 'BestMatch',
  });

  final String query;
  final double? latitude;
  final double? longitude;
  final int radiusInMeters;
  final int maxResults;
  final String sortBy;

  Map<String, dynamic> toJson() => {
    'query': query.trim(),
    if (latitude != null) 'latitude': latitude,
    if (longitude != null) 'longitude': longitude,
    'radiusInMeters': radiusInMeters,
    'maxResults': maxResults,
    'sortBy': sortBy,
  };
}

class NearbyMedicineResult {
  const NearbyMedicineResult({
    required this.medicineId,
    required this.medicineName,
    required this.requiresPrescription,
    required this.quantityAvailable,
    required this.isAvailable,
    required this.availabilityStatus,
    required this.rankingScore,
    required this.pharmacy,
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
  final bool requiresPrescription;
  final int quantityAvailable;
  final bool isAvailable;
  final String availabilityStatus;
  final double? sellingPrice;
  final double rankingScore;
  final UserPharmacySummary pharmacy;

  factory NearbyMedicineResult.fromJson(Map<String, dynamic> json) {
    return NearbyMedicineResult(
      medicineId: json['medicineId']?.toString() ?? '',
      medicineName: json['medicineName']?.toString() ?? '',
      arabicMedicineName: _nullable(json['arabicMedicineName']),
      medicineDisplayName: _nullable(json['medicineDisplayName']),
      scientificName: _nullable(json['scientificName']),
      arabicScientificName: _nullable(json['arabicScientificName']),
      manufacturer: _nullable(json['manufacturer']),
      dosageForm: _nullable(json['dosageForm']),
      capacity: _nullable(json['capacity']),
      requiresPrescription: json['requiresPrescription'] as bool? ?? false,
      quantityAvailable: (json['quantityAvailable'] as num?)?.toInt() ?? 0,
      isAvailable:
          json['isAvailable'] as bool? ??
          ((json['quantityAvailable'] as num?)?.toInt() ?? 0) > 0,
      availabilityStatus: json['availabilityStatus']?.toString() ?? '',
      sellingPrice: (json['sellingPrice'] as num?)?.toDouble(),
      rankingScore: (json['rankingScore'] as num?)?.toDouble() ?? 0,
      pharmacy: UserPharmacySummary.fromJson(
        json['pharmacy'] is Map
            ? Map<String, dynamic>.from(json['pharmacy'] as Map)
            : const {},
      ),
    );
  }
}

class UserMapPharmacy {
  const UserMapPharmacy({
    required this.markerId,
    required this.source,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.distanceMeters,
    required this.isOpenNow,
    required this.statusText,
    required this.averageRating,
    required this.ratingsCount,
    required this.hasDeliveryService,
    required this.isLocationVerified,
    this.pharmacyId,
    this.externalPlaceId,
    this.phoneNumber,
    this.googleMapsUrl,
  });

  final String markerId;
  final String source;
  final String? pharmacyId;
  final String? externalPlaceId;
  final String name;
  final String address;
  final String? phoneNumber;
  final double latitude;
  final double longitude;
  final double distanceMeters;
  final bool isOpenNow;
  final String statusText;
  final double averageRating;
  final int ratingsCount;
  final bool hasDeliveryService;
  final bool isLocationVerified;
  final String? googleMapsUrl;

  factory UserMapPharmacy.fromJson(Map<String, dynamic> json) {
    return UserMapPharmacy(
      markerId: json['markerId']?.toString() ?? '',
      source: json['source']?.toString() ?? '',
      pharmacyId: _nullable(json['pharmacyId']),
      externalPlaceId: _nullable(json['externalPlaceId']),
      name: json['name']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      phoneNumber: _nullable(json['phoneNumber']),
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
      distanceMeters: (json['distanceMeters'] as num?)?.toDouble() ?? 0,
      isOpenNow: json['isOpenNow'] as bool? ?? false,
      statusText: json['statusText']?.toString() ?? '',
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0,
      ratingsCount: (json['ratingsCount'] as num?)?.toInt() ?? 0,
      hasDeliveryService: json['hasDeliveryService'] as bool? ?? false,
      isLocationVerified: json['isLocationVerified'] as bool? ?? false,
      googleMapsUrl: _nullable(json['googleMapsUrl']),
    );
  }
}

class UserLocationDiscovery {
  const UserLocationDiscovery({
    required this.userId,
    required this.hasSavedLocation,
    required this.latitude,
    required this.longitude,
    required this.locationSource,
    required this.radiusInMeters,
    required this.registeredCount,
    required this.externalCount,
    required this.usedExternalFallback,
    required this.registeredPharmacies,
    required this.externalPharmacies,
    required this.mapMarkers,
    this.accuracyMeters,
    this.lastLocationUpdatedAtUtc,
  });

  final String userId;
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
  final List<UserPharmacySummary> registeredPharmacies;
  final List<UserMapPharmacy> externalPharmacies;
  final List<UserMapPharmacy> mapMarkers;

  factory UserLocationDiscovery.fromJson(Map<String, dynamic> json) {
    return UserLocationDiscovery(
      userId: json['userId']?.toString() ?? '',
      hasSavedLocation: json['hasSavedLocation'] as bool? ?? false,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
      accuracyMeters: (json['accuracyMeters'] as num?)?.toDouble(),
      locationSource: json['locationSource']?.toString() ?? '',
      lastLocationUpdatedAtUtc: DateTime.tryParse(
        json['lastLocationUpdatedAtUtc']?.toString() ?? '',
      )?.toLocal(),
      radiusInMeters: (json['radiusInMeters'] as num?)?.toInt() ?? 0,
      registeredCount: (json['registeredCount'] as num?)?.toInt() ?? 0,
      externalCount: (json['externalCount'] as num?)?.toInt() ?? 0,
      usedExternalFallback: json['usedExternalFallback'] as bool? ?? false,
      registeredPharmacies: _objects(
        json['registeredNearbyPharmacies'],
        UserPharmacySummary.fromJson,
      ),
      externalPharmacies: _objects(
        json['externalNearbyPharmacies'],
        UserMapPharmacy.fromJson,
      ),
      mapMarkers: _objects(json['mapMarkers'], UserMapPharmacy.fromJson),
    );
  }
}

class RouteCoordinate {
  const RouteCoordinate({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;

  factory RouteCoordinate.fromJson(Map<String, dynamic> json) =>
      RouteCoordinate(
        latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
        longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
      );
}

class UserNearestRoute {
  const UserNearestRoute({
    required this.originLatitude,
    required this.originLongitude,
    required this.pharmacy,
    required this.routeAvailable,
    required this.distanceMeters,
    required this.path,
    required this.directionsUrl,
    this.durationSeconds,
  });

  final double originLatitude;
  final double originLongitude;
  final UserMapPharmacy pharmacy;
  final bool routeAvailable;
  final double distanceMeters;
  final double? durationSeconds;
  final List<RouteCoordinate> path;
  final String directionsUrl;

  factory UserNearestRoute.fromJson(Map<String, dynamic> json) {
    return UserNearestRoute(
      originLatitude: (json['originLatitude'] as num?)?.toDouble() ?? 0,
      originLongitude: (json['originLongitude'] as num?)?.toDouble() ?? 0,
      pharmacy: UserMapPharmacy.fromJson(
        json['pharmacy'] is Map
            ? Map<String, dynamic>.from(json['pharmacy'] as Map)
            : const {},
      ),
      routeAvailable: json['routeAvailable'] as bool? ?? false,
      distanceMeters: (json['distanceMeters'] as num?)?.toDouble() ?? 0,
      durationSeconds: (json['durationSeconds'] as num?)?.toDouble(),
      path: _objects(json['path'], RouteCoordinate.fromJson),
      directionsUrl: json['directionsUrl']?.toString() ?? '',
    );
  }
}

List<T> _objects<T>(
  Object? value,
  T Function(Map<String, dynamic>) converter,
) => value is List
    ? value
          .whereType<Map>()
          .map((item) => converter(Map<String, dynamic>.from(item)))
          .toList(growable: false)
    : const [];

String? _nullable(Object? value) {
  final result = value?.toString().trim();
  return result == null || result.isEmpty ? null : result;
}
