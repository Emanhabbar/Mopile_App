import 'package:flutter_test/flutter_test.dart';
import 'package:pharmacy_app/features/user/data/models/user_discovery_models.dart';
import 'package:pharmacy_app/features/user/data/models/user_models.dart';
import 'package:pharmacy_app/features/user/data/models/user_request_models.dart';

void main() {
  group('User API models', () {
    test('parses dashboard values and nested pharmacy data', () {
      final dashboard = UserDashboard.fromJson({
        'profile': {
          'userId': 'user-1',
          'fullName': 'مستخدم تجريبي',
          'email': 'user@example.com',
          'isActive': true,
          'hasSavedLocation': true,
          'hasMedicalProfile': true,
          'hasEmergencyContact': false,
          'searchHistoryCount': 4,
          'ratingsCount': 2,
        },
        'locationContext': {
          'hasSavedLocation': true,
          'latitude': 33.51,
          'longitude': 36.29,
          'radiusInMeters': 5000,
          'registeredCount': 1,
          'externalCount': 0,
          'usedExternalFallback': false,
          'registeredNearbyPharmacies': [
            {
              'pharmacyId': 'pharmacy-1',
              'pharmacyName': 'صيدلية الحياة',
              'city': 'دمشق',
              'area': 'المزة',
              'address': 'شارع رئيسي',
              'distanceMeters': 750.5,
              'averageRating': 4.5,
              'ratingsCount': 10,
              'hasDeliveryService': false,
              'isOpenNow': true,
              'statusText': 'مفتوحة الآن',
            },
          ],
        },
        'activeRequestsCount': 2,
        'pendingRequestsCount': 1,
        'completedRequestsCount': 3,
        'recentSearchesCount': 4,
        'openNearbyPharmaciesCount': 1,
        'recentRequests': [],
        'recentSearches': [],
      });

      expect(dashboard.profile.fullName, 'مستخدم تجريبي');
      expect(dashboard.activeRequestsCount, 2);
      expect(dashboard.locationContext?.registeredCount, 1);
      expect(
        dashboard.locationContext?.registeredNearbyPharmacies.single.isOpenNow,
        isTrue,
      );
    });

    test('serializes medical profile update using API field names', () {
      final request = UpdateMedicalProfileRequest(
        dateOfBirth: DateTime(2000, 2, 3),
        bloodType: 'O+',
        allergies: const ['البنسلين'],
        chronicConditions: const ['السكري'],
        currentMedications: const ['دواء 1'],
        emergencyContactName: 'جهة اتصال',
        emergencyContactPhoneNumber: '0999999999',
        emergencyNotes: 'ملاحظة',
      );

      expect(request.toJson(), {
        'dateOfBirth': '2000-02-03',
        'bloodType': 'O+',
        'allergies': ['البنسلين'],
        'chronicConditions': ['السكري'],
        'currentMedications': ['دواء 1'],
        'emergencyContactName': 'جهة اتصال',
        'emergencyContactPhoneNumber': '0999999999',
        'emergencyNotes': 'ملاحظة',
      });
    });

    test('serializes medicine search filters for the backend contract', () {
      const request = UserMedicineSearch(
        query: '  Paracetamol  ',
        radiusInMeters: 10000,
        maxResults: 50,
        sortBy: 'PriceLowToHigh',
      );

      expect(request.toJson(), {
        'query': 'Paracetamol',
        'radiusInMeters': 10000,
        'maxResults': 50,
        'sortBy': 'PriceLowToHigh',
      });
    });

    test('parses location markers and nearest route path', () {
      final context = UserLocationDiscovery.fromJson({
        'userId': 'user-1',
        'hasSavedLocation': true,
        'latitude': 33.5,
        'longitude': 36.2,
        'locationSource': 'Manual',
        'radiusInMeters': 5000,
        'registeredCount': 1,
        'externalCount': 0,
        'usedExternalFallback': false,
        'registeredNearbyPharmacies': [],
        'externalNearbyPharmacies': [],
        'mapMarkers': [
          {
            'markerId': 'pharmacy-1',
            'source': 'Registered',
            'pharmacyId': 'pharmacy-1',
            'name': 'صيدلية الحياة',
            'address': 'دمشق',
            'latitude': 33.51,
            'longitude': 36.21,
            'distanceMeters': 800,
            'isOpenNow': true,
            'statusText': 'مفتوحة',
            'averageRating': 4.2,
            'ratingsCount': 5,
            'hasDeliveryService': false,
            'isLocationVerified': true,
          },
        ],
      });
      final route = UserNearestRoute.fromJson({
        'originLatitude': 33.5,
        'originLongitude': 36.2,
        'pharmacy': {
          'markerId': 'pharmacy-1',
          'source': 'Registered',
          'name': 'صيدلية الحياة',
          'address': 'دمشق',
          'latitude': 33.51,
          'longitude': 36.21,
          'distanceMeters': 800,
          'isOpenNow': true,
          'statusText': 'مفتوحة',
          'averageRating': 4.2,
          'ratingsCount': 5,
          'hasDeliveryService': false,
          'isLocationVerified': true,
        },
        'routeAvailable': true,
        'distanceMeters': 900,
        'durationSeconds': 420,
        'path': [
          {'latitude': 33.5, 'longitude': 36.2},
          {'latitude': 33.51, 'longitude': 36.21},
        ],
        'directionsUrl': 'https://maps.example/route',
      });

      expect(context.mapMarkers.single.name, 'صيدلية الحياة');
      expect(route.path, hasLength(2));
      expect(route.routeAvailable, isTrue);
    });

    test('serializes medicine request using backend limits and names', () {
      const request = CreateMedicineRequest(
        medicineId: 'medicine-1',
        requestedQuantity: 2,
        note: 'عبوتان من فضلك',
      );

      expect(request.toJson(), {
        'medicineId': 'medicine-1',
        'requestedQuantity': 2,
        'note': 'عبوتان من فضلك',
      });
    });

    test('parses pharmacy details and overnight working hours', () {
      final details = UserPharmacyDetails.fromJson({
        'pharmacy': {
          'pharmacyId': 'pharmacy-1',
          'pharmacyName': 'صيدلية الحياة',
          'city': 'دمشق',
          'area': 'المزة',
          'address': 'شارع رئيسي',
          'distanceMeters': 900,
          'averageRating': 4.8,
          'ratingsCount': 20,
          'hasDeliveryService': true,
          'isOpenNow': true,
          'statusText': 'مفتوحة',
        },
        'workingHours': [
          {
            'dayOfWeek': 'Saturday',
            'openTime': '20:00:00',
            'closeTime': '02:00:00',
            'isClosed': false,
          },
        ],
        'availableMedicines': [
          {
            'medicineId': 'medicine-1',
            'medicineName': 'دواء',
            'sellingPrice': 15000,
            'requiresPrescription': false,
          },
        ],
        'availableMedicinesCount': 1,
        'totalInventoryItems': 1,
      });

      expect(details.pharmacy.hasDeliveryService, isTrue);
      expect(details.workingHours.single.dayOfWeek, 6);
      expect(details.workingHours.single.closeTime, '02:00:00');
      expect(details.availableMedicines.single.sellingPrice, 15000);
    });
  });

  test('parses the dedicated create medicine request response', () {
    final result = UserMedicineRequestResult.fromJson({
      'requestId': 'request-1',
      'requestCode': 'REQ-2026-1',
      'pharmacyId': 'pharmacy-1',
      'medicineId': 'medicine-1',
      'pharmacyName': 'صيدلية الحياة',
      'medicineName': 'Paracetamol',
      'requestedQuantity': 2,
      'status': 'Pending',
      'statusDisplayText': 'قيد الانتظار',
      'canCancel': true,
      'createdAtUtc': '2026-07-30T12:00:00Z',
    });

    expect(result.requestId, 'request-1');
    expect(result.requestCode, 'REQ-2026-1');
    expect(result.requestedQuantity, 2);
    expect(result.canCancel, isTrue);
    expect(result.createdAtUtc, isNotNull);
  });
}
