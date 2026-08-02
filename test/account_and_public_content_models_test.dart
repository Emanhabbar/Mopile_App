import 'package:flutter_test/flutter_test.dart';
import 'package:pharmacy_app/features/account/data/models/account_profile.dart';
import 'package:pharmacy_app/features/auth/data/models/auth_session.dart';
import 'package:pharmacy_app/features/dashboard/data/models/home_ticker_item.dart';
import 'package:pharmacy_app/features/donations/data/models/donation_models.dart';

void main() {
  group('Account and public content API models', () {
    test(
      'parses account profile and merges mutable values into the session',
      () {
        final profile = AccountProfile.fromJson({
          'userId': 'user-1',
          'fullName': 'الاسم المحدّث',
          'email': 'user@example.com',
          'phoneNumber': '0999999999',
          'roles': ['User'],
          'isActive': true,
          'createdAtUtc': '2026-07-31T10:00:00Z',
          'hasProfileImage': true,
          'profileImageUpdatedAtUtc': '2026-07-31T11:00:00Z',
        });
        const current = AuthUser(
          userId: 'user-1',
          email: 'user@example.com',
          fullName: 'الاسم القديم',
          roles: ['User'],
        );

        final merged = profile.mergeInto(current);

        expect(profile.phoneNumber, '0999999999');
        expect(merged.fullName, 'الاسم المحدّث');
        expect(merged.hasProfileImage, isTrue);
        expect(merged.profileImageUpdatedAtUtc, isNotNull);
      },
    );

    test('parses organization details and nested active campaigns', () {
      final organization = PublicOrganizationDetails.fromJson({
        'organizationId': 'organization-1',
        'organizationName': 'منظمة الدواء',
        'registrationNumber': 'REG-1',
        'city': 'دمشق',
        'area': 'المزة',
        'address': 'عنوان المنظمة',
        'isApproved': true,
        'activeCampaigns': [
          {
            'campaignId': 'campaign-1',
            'organizationId': 'organization-1',
            'organizationName': 'منظمة الدواء',
            'title': 'حملة علاج',
            'description': 'تأمين أدوية مزمنة',
            'isUrgent': true,
            'acceptsPublicDonations': true,
            'status': 'Active',
          },
        ],
      });

      expect(organization.isApproved, isTrue);
      expect(organization.activeCampaigns, hasLength(1));
      expect(organization.activeCampaigns.single.isUrgent, isTrue);
    });

    test('identifies a duty pharmacy ticker item', () {
      final item = HomeTickerItem.fromJson({
        'id': 'ticker-1',
        'type': 'DutyPharmacy',
        'title': 'صيدلية مناوبة',
        'message': 'متاحة الآن',
        'pharmacyProfileId': 'pharmacy-1',
        'pharmacyName': 'صيدلية الشفاء',
        'isActive': true,
        'sortOrder': 1,
      });

      expect(item.isDutyPharmacy, isTrue);
      expect(item.pharmacyProfileId, 'pharmacy-1');
    });
  });
}
