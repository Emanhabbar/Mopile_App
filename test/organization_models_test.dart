import 'package:flutter_test/flutter_test.dart';
import 'package:pharmacy_app/features/organization/data/models/organization_models.dart';

void main() {
  group('Organization API models', () {
    test('parses organization dashboard counters', () {
      final dashboard = OrganizationDashboard.fromJson({
        'organizationId': 'organization-1',
        'organizationName': 'منظمة الخير',
        'registrationNumber': 'ORG-100',
        'city': 'دمشق',
        'area': 'المزة',
        'address': 'الشارع الرئيسي',
        'isApproved': true,
        'verificationStatus': 'Approved',
        'verificationDocumentsCount': 3,
        'totalCampaignsCount': 8,
        'activeCampaignsCount': 2,
        'pendingDonationOffersCount': 4,
        'openAssistanceRequestsCount': 5,
        'recentCampaigns': const [],
      });

      expect(dashboard.organizationName, 'منظمة الخير');
      expect(dashboard.activeCampaignsCount, 2);
      expect(dashboard.pendingDonationOffersCount, 4);
    });

    test('parses pharmacy-supervised donation offer', () {
      final offer = OrganizationDonationOffer.fromJson({
        'offerId': 'offer-1',
        'donorFullName': 'متبرع',
        'medicineName': 'باراسيتامول',
        'packageCount': 3,
        'isSealed': true,
        'status': 'PendingReview',
        'reviewingPharmacyName': 'صيدلية الشفاء',
        'pharmacyReviewStatus': 'ReceivedByPharmacy',
      });

      expect(offer.reviewingPharmacyName, 'صيدلية الشفاء');
      expect(offer.pharmacyReviewStatus, 'ReceivedByPharmacy');
    });
  });
}
