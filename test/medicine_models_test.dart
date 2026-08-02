import 'package:flutter_test/flutter_test.dart';
import 'package:pharmacy_app/features/medicines/data/models/medicine_models.dart';
import 'package:pharmacy_app/features/pharmacy/data/models/pharmacy_models.dart';

void main() {
  group('Medicines API models', () {
    test('parses a paged medicine response', () {
      final page = MedicinePage.fromJson({
        'items': [
          {
            'id': 'medicine-1',
            'name': 'Paracetamol',
            'scientificName': 'Acetaminophen',
            'purchasePrice': 1200,
            'sellingPrice': 1500.5,
            'quantityInStock': 40,
            'requiresPrescription': false,
          },
        ],
        'pageNumber': 2,
        'pageSize': 20,
        'totalCount': 45,
        'totalPages': 3,
      });

      expect(page.items, hasLength(1));
      expect(page.items.single.sellingPrice, 1500.5);
      expect(page.pageNumber, 2);
      expect(page.hasPreviousPage, isTrue);
      expect(page.hasNextPage, isTrue);
    });

    test('serializes the create medicine contract', () {
      const request = CreateMedicine(
        name: ' Paracetamol ',
        purchasePrice: 1000,
        sellingPrice: 1300,
        quantityInStock: 20,
        requiresPrescription: false,
        scientificName: ' ',
        dosageForm: 'Tablet',
      );

      expect(request.toJson(), {
        'name': 'Paracetamol',
        'scientificName': null,
        'purchasePrice': 1000,
        'sellingPrice': 1300,
        'quantityInStock': 20,
        'manufacturer': null,
        'dosageForm': 'Tablet',
        'packageSize': null,
        'capacity': null,
        'composition': null,
        'description': null,
        'requiresPrescription': false,
      });
    });

    test('parses the pharmacy live open-status response', () {
      final status = PharmacyOpenStatus.fromJson({
        'pharmacyId': 'pharmacy-1',
        'isOpenNow': true,
        'statusText': 'مفتوحة الآن',
        'localDateTime': '2026-07-30T18:30:00',
        'timeZoneId': 'Asia/Damascus',
      });

      expect(status.pharmacyId, 'pharmacy-1');
      expect(status.isOpenNow, isTrue);
      expect(status.localDateTime, isNotNull);
      expect(status.timeZoneId, 'Asia/Damascus');
    });
  });
}
