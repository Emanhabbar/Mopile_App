import 'package:flutter_test/flutter_test.dart';
import 'package:pharmacy_app/features/prescriptions/data/models/prescription_models.dart';

void main() {
  group('Prescription API models', () {
    test('parses a complete prescription response', () {
      final order = PrescriptionOrder.fromJson({
        'id': 'order-1',
        'status': 'Reserved',
        'originalFileName': 'prescription.pdf',
        'pharmacyId': 'pharmacy-1',
        'pharmacyName': 'صيدلية الشفاء',
        'matchPercentage': 100,
        'reservedUntilUtc': '2026-08-01T10:00:00Z',
        'qrPayload': 'pharmacy://prescriptions/order-1/pickup?code=12345678',
        'warnings': ['تنبيه تجريبي'],
        'items': [
          {
            'id': 'item-1',
            'medicineId': 'medicine-1',
            'extractedName': 'Paracetamol',
            'matchedMedicineName': 'باراسيتامول',
            'scientificName': 'Paracetamol',
            'strength': '500 mg',
            'dosageInstructions': 'مرة يوميًا',
            'requestedQuantity': 2,
            'reservedQuantity': 2,
            'extractionConfidence': 0.98,
          },
        ],
        'pharmacyMatches': [
          {
            'pharmacyId': 'pharmacy-1',
            'pharmacyName': 'صيدلية الشفاء',
            'address': 'دمشق',
            'distanceMeters': 850.5,
            'availableItems': 1,
            'totalItems': 1,
            'matchPercentage': 100,
            'hasCompletePrescription': true,
          },
        ],
        'doseRemindersEnabled': false,
        'refillReminderEnabled': false,
        'createdAtUtc': '2026-07-31T10:00:00Z',
      });

      expect(order.id, 'order-1');
      expect(order.isReserved, isTrue);
      expect(order.pickupCode, '12345678');
      expect(order.items.single.displayName, 'باراسيتامول');
      expect(order.items.single.requestedQuantity, 2);
      expect(order.pharmacyMatches.single.distanceMeters, 850.5);
      expect(order.pharmacyMatches.single.hasCompletePrescription, isTrue);
    });

    test('serializes reminder settings using backend field names', () {
      const request = PrescriptionReminderRequest(
        doseRemindersEnabled: true,
        refillReminderEnabled: true,
        reminderTime: '09:30:00',
        durationDays: 30,
        refillAfterDays: 25,
      );

      expect(request.toJson(), {
        'doseRemindersEnabled': true,
        'refillReminderEnabled': true,
        'reminderTime': '09:30:00',
        'durationDays': 30,
        'refillAfterDays': 25,
      });
    });
  });
}
