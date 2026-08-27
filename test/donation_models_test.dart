import 'package:flutter_test/flutter_test.dart';
import 'package:pharmacy_app/features/donations/data/models/donation_models.dart';

void main() {
  group('Donation API models', () {
    test('parses donation offer and assistance request responses', () {
      final offer = DonationOffer.fromJson({
        'offerId': 'offer-1',
        'medicineId': 'medicine-1',
        'medicineName': 'باراسيتامول',
        'reviewingPharmacyId': 'pharmacy-1',
        'reviewingPharmacyName': 'صيدلية الشفاء',
        'pharmacyReviewStatus': 'PendingPharmacyReview',
        'targetOrganizationId': 'organization-1',
        'targetOrganizationName': 'منظمة الشفاء',
        'packageCount': 3,
        'isSealed': true,
        'status': 'PendingReview',
        'createdAtUtc': '2026-07-31T10:00:00Z',
      });
      final request = AssistanceRequest.fromJson({
        'requestId': 'request-1',
        'medicineId': 'medicine-2',
        'medicineName': 'دواء مزمن',
        'targetOrganizationId': 'organization-1',
        'requestedPackageCount': 2,
        'status': 'Open',
        'createdAtUtc': '2026-07-31T10:00:00Z',
      });

      expect(offer.offerId, 'offer-1');
      expect(offer.packageCount, 3);
      expect(offer.isSealed, isTrue);
      expect(offer.reviewingPharmacyName, 'صيدلية الشفاء');
      expect(request.requestId, 'request-1');
      expect(request.requestedPackageCount, 2);
    });

    test('serializes creation requests with backend field names', () {
      const offer = CreateDonationOffer(
        medicineId: 'medicine-1',
        reviewingPharmacyId: 'pharmacy-1',
        targetOrganizationId: 'organization-1',
        campaignId: 'campaign-1',
        packageCount: 4,
        isSealed: true,
        notes: 'عبوات سليمة',
      );
      const assistance = CreateAssistanceRequest(
        medicineId: 'medicine-2',
        targetOrganizationId: 'organization-1',
        requestedPackageCount: 2,
      );

      expect(offer.toJson()['packageCount'], 4);
      expect(offer.toJson()['targetOrganizationId'], 'organization-1');
      expect(offer.toJson()['reviewingPharmacyId'], 'pharmacy-1');
      expect(assistance.toJson()['requestedPackageCount'], 2);
      expect(assistance.toJson()['medicineId'], 'medicine-2');
    });
  });
}
