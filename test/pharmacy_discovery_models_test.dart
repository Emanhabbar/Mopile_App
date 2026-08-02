import 'package:flutter_test/flutter_test.dart';
import 'package:pharmacy_app/features/pharmacy_discovery/data/models/pharmacy_discovery_models.dart';

void main() {
  group('Public pharmacy discovery API models', () {
    test('parses an external Google Places pharmacy', () {
      final pharmacy = ExternalPharmacy.fromJson({
        'placeId': 'place-1',
        'name': 'صيدلية قريبة',
        'address': 'دمشق',
        'latitude': 33.5,
        'longitude': 36.3,
        'rating': 4.6,
        'totalRatings': 18,
        'isOpenNow': true,
        'distance': 725.5,
        'types': ['pharmacy', 'health'],
        'photoUrl': '/api/pharmacies/photo?reference=photo-1',
        'googleMapsUrl': 'https://maps.google.com/?q=33.5,36.3',
      });

      expect(pharmacy.placeId, 'place-1');
      expect(pharmacy.distanceMeters, 725.5);
      expect(pharmacy.isOpenNow, isTrue);
      expect(pharmacy.types, contains('pharmacy'));
    });

    test('parses registered pharmacies with backend naming variants', () {
      final pharmacy = RegisteredPharmacyLocation.fromJson({
        'pharmacyId': 'pharmacy-1',
        'pharmacyName': 'صيدلية مسجلة',
        'address': 'شارع رئيسي',
        'latitude': 33.51,
        'longitude': 36.31,
        'distanceMeters': 1200,
        'averageRating': 4.2,
        'ratingsCount': 9,
        'isOpenNow': false,
        'statusText': 'مغلقة الآن',
      });

      expect(pharmacy.name, 'صيدلية مسجلة');
      expect(pharmacy.rating, 4.2);
      expect(pharmacy.distanceMeters, 1200);
    });

    test('parses locator health status', () {
      final health = PharmacyLocatorHealth.fromJson({
        'status': 'ok',
        'service': 'Pharmacy Locator',
        'timestamp': '2026-07-31T10:00:00Z',
      });

      expect(health.isHealthy, isTrue);
      expect(health.service, 'Pharmacy Locator');
    });
  });
}
