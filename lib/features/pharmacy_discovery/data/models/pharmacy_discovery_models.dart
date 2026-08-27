class PharmacyLocatorResult<T> {
  const PharmacyLocatorResult({
    required this.count,
    required this.items,
    this.source,
  });

  final String? source;
  final int count;
  final List<T> items;
}

class ExternalPharmacy {
  const ExternalPharmacy({
    required this.placeId,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.totalRatings,
    required this.isOpenNow,
    required this.distanceMeters,
    required this.googleMapsUrl,
    required this.types,
    this.photoUrl,
    this.lastUpdated,
  });

  factory ExternalPharmacy.fromJson(Map<String, dynamic> json) =>
      ExternalPharmacy(
        placeId: _text(json['placeId']),
        name: _text(json['name']),
        address: _text(json['address']),
        latitude: _number(json['latitude']),
        longitude: _number(json['longitude']),
        rating: _number(json['rating']),
        totalRatings: _integer(json['totalRatings']),
        isOpenNow: json['isOpenNow'] == true,
        distanceMeters: _number(json['distance']),
        types:
            (json['types'] as List?)
                ?.map((item) => item.toString())
                .toList(growable: false) ??
            const [],
        photoUrl: _optional(json['photoUrl']),
        googleMapsUrl: _text(json['googleMapsUrl']),
        lastUpdated: DateTime.tryParse(json['lastUpdated']?.toString() ?? ''),
      );

  final String placeId;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double rating;
  final int totalRatings;
  final bool isOpenNow;
  final double distanceMeters;
  final List<String> types;
  final String? photoUrl;
  final String googleMapsUrl;
  final DateTime? lastUpdated;
}

class RegisteredPharmacyLocation {
  const RegisteredPharmacyLocation({
    required this.pharmacyId,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.distanceMeters,
    required this.rating,
    required this.ratingsCount,
    required this.isOpenNow,
    this.city,
    this.area,
    this.statusText,
    this.phoneNumber,
  });

  factory RegisteredPharmacyLocation.fromJson(Map<String, dynamic> json) =>
      RegisteredPharmacyLocation(
        pharmacyId: _text(json['pharmacyId']),
        name: _firstText(json, ['pharmacyName', 'name']),
        address: _text(json['address']),
        city: _optional(json['city']),
        area: _optional(json['area']),
        phoneNumber: _optional(json['phoneNumber']),
        latitude: _number(json['latitude']),
        longitude: _number(json['longitude']),
        distanceMeters: _number(json['distanceMeters'] ?? json['distance']),
        rating: _number(json['averageRating'] ?? json['rating']),
        ratingsCount: _integer(json['ratingsCount'] ?? json['totalRatings']),
        isOpenNow: json['isOpenNow'] == true,
        statusText: _optional(json['statusText']),
      );

  final String pharmacyId;
  final String name;
  final String address;
  final String? city;
  final String? area;
  final String? phoneNumber;
  final double latitude;
  final double longitude;
  final double distanceMeters;
  final double rating;
  final int ratingsCount;
  final bool isOpenNow;
  final String? statusText;
}

class ExternalClosestPharmacy {
  const ExternalClosestPharmacy({
    required this.pharmacy,
    required this.distanceKm,
  });

  factory ExternalClosestPharmacy.fromJson(Map<String, dynamic> json) =>
      ExternalClosestPharmacy(
        pharmacy: ExternalPharmacy.fromJson(
          json['pharmacy'] is Map
              ? Map<String, dynamic>.from(json['pharmacy'] as Map)
              : const {},
        ),
        distanceKm: _number(json['distanceKm']),
      );

  final ExternalPharmacy pharmacy;
  final double distanceKm;
}

class PharmacyLocatorHealth {
  const PharmacyLocatorHealth({
    required this.status,
    required this.service,
    this.timestamp,
  });

  factory PharmacyLocatorHealth.fromJson(Map<String, dynamic> json) =>
      PharmacyLocatorHealth(
        status: _text(json['status']),
        service: _text(json['service']),
        timestamp: DateTime.tryParse(json['timestamp']?.toString() ?? ''),
      );

  final String status;
  final String service;
  final DateTime? timestamp;

  bool get isHealthy => status.toLowerCase() == 'ok';
}

String _text(Object? value) => value?.toString() ?? '';

String _firstText(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = _optional(json[key]);
    if (value != null) return value;
  }
  return '';
}

String? _optional(Object? value) {
  final text = value?.toString().trim();
  return text == null || text.isEmpty ? null : text;
}

double _number(Object? value) =>
    value is num ? value.toDouble() : double.tryParse('$value') ?? 0;

int _integer(Object? value) =>
    value is num ? value.toInt() : int.tryParse('$value') ?? 0;
