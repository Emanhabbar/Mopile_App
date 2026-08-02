import 'package:flutter_test/flutter_test.dart';
import 'package:pharmacy_app/features/admin/data/models/admin_models.dart';

void main() {
  group('Admin API models', () {
    test('parses dashboard counters', () {
      final dashboard = AdminDashboard.fromJson({
        'totalUsers': 100,
        'activeUsers': 90,
        'totalPharmacies': 20,
        'pendingPharmacies': 3,
        'totalOrganizations': 8,
        'pendingOrganizations': 2,
        'totalWarehouses': 6,
        'approvedWarehouses': 4,
        'pendingWarehouses': 2,
        'pendingOrganizationVerifications': 1,
        'totalMedicineRequests': 50,
        'pendingMedicineRequests': 5,
        'totalDonationOffers': 12,
        'openAssistanceRequests': 4,
      });

      expect(dashboard.totalUsers, 100);
      expect(dashboard.pendingPharmacies, 3);
      expect(dashboard.pendingOrganizationVerifications, 1);
      expect(dashboard.pendingWarehouses, 2);
    });

    test('parses accounts and ticker items', () {
      final account = AdminAccount.fromJson({
        'userId': 'user-1',
        'fullName': 'مستخدم',
        'email': 'user@example.com',
        'role': 'User',
        'isActive': true,
        'createdAtUtc': '2026-07-31T10:00:00Z',
      });
      final ticker = HomeTickerItem.fromJson({
        'id': 'ticker-1',
        'type': 'Announcement',
        'title': 'إعلان',
        'message': 'نص الإعلان',
        'isActive': true,
        'sortOrder': 0,
      });

      expect(account.isActive, isTrue);
      expect(account.role, 'User');
      expect(ticker.title, 'إعلان');
      expect(ticker.isActive, isTrue);
    });
  });
}
