import 'package:flutter_test/flutter_test.dart';
import 'package:pharmacy_app/features/pharmacy/data/models/pharmacy_models.dart';

void main() {
  group('Pharmacy API models', () {
    test('parses dashboard counters and inventory alerts', () {
      final dashboard = PharmacyDashboard.fromJson({
        'pharmacyId': 'pharmacy-1',
        'pharmacyName': 'صيدلية الحياة',
        'licenseNumber': 'LIC-1',
        'city': 'دمشق',
        'area': 'المزة',
        'address': 'شارع رئيسي',
        'hasLocation': true,
        'locationSource': 'Manual',
        'isLocationVerified': true,
        'timeZoneId': 'Asia/Damascus',
        'hasDeliveryService': true,
        'isApproved': true,
        'isOpenNow': true,
        'statusText': 'مفتوحة',
        'averageRating': 4.5,
        'ratingsCount': 10,
        'inventoryItemsCount': 20,
        'availableMedicinesCount': 18,
        'inStockCount': 15,
        'lowStockCount': 3,
        'outOfStockCount': 2,
        'expiringSoonCount': 1,
        'pendingRequestsCount': 4,
        'activeRequestsCount': 4,
        'hasWorkingHoursConfigured': true,
        'profileCompletionPercentage': 100,
        'expiringSoonItems': [],
        'lowStockItems': [
          {
            'inventoryItemId': 'item-1',
            'medicineId': 'medicine-1',
            'medicineName': 'دواء',
            'quantity': 2,
            'lowStockThreshold': 5,
            'alertType': 'LowStock',
          },
        ],
      });

      expect(dashboard.inventoryItemsCount, 20);
      expect(dashboard.lowStockItems.single.quantity, 2);
      expect(dashboard.isOpenNow, isTrue);
    });

    test('serializes an overnight working period correctly', () {
      const period = PharmacyWorkingPeriod(
        dayOfWeek: 6,
        openTime: '20:00:00',
        closeTime: '02:00:00',
        isClosed: false,
      );

      expect(period.toJson(), {
        'dayOfWeek': 6,
        'openTime': '20:00:00',
        'closeTime': '02:00:00',
        'isClosed': false,
      });
    });

    test('parses price visibility from inventory item', () {
      final item = PharmacyInventoryItem.fromJson({
        'inventoryItemId': 'item-1',
        'medicineId': 'medicine-1',
        'medicineName': 'دواء',
        'sellingPrice': 15000,
        'isPriceVisibleToUsers': false,
        'quantity': 8,
        'isAvailable': true,
        'lowStockThreshold': 3,
        'stockStatus': 'InStock',
        'requiresPrescription': false,
      });

      expect(item.isPriceVisibleToUsers, isFalse);
      expect(item.sellingPrice, 15000);
    });

    test('parses pharmacy license verification result', () {
      final verification = PharmacyLicenseVerification.fromJson({
        'verificationId': 'verification-1',
        'pharmacyId': 'pharmacy-1',
        'status': 'Processing',
        'registeredName': 'أحمد',
        'originalFileName': 'license.png',
        'contentType': 'image/png',
        'fileSizeBytes': 500000,
        'attemptCount': 1,
        'submittedAtUtc': '2026-08-09T12:00:00Z',
      });

      expect(verification.isPending, isTrue);
      expect(verification.originalFileName, 'license.png');
    });
  });
}
