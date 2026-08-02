import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pharmacy_app/features/admin/data/models/admin_models.dart';
import 'package:pharmacy_app/features/admin/presentation/controllers/admin_providers.dart';
import 'package:pharmacy_app/features/admin/presentation/pages/admin_home_page.dart';
import 'package:pharmacy_app/features/organization/data/models/organization_models.dart';
import 'package:pharmacy_app/features/organization/presentation/controllers/organization_providers.dart';
import 'package:pharmacy_app/features/organization/presentation/pages/organization_home_page.dart';
import 'package:pharmacy_app/features/supply_chain/data/models/supply_chain_models.dart';
import 'package:pharmacy_app/features/supply_chain/presentation/controllers/supply_chain_providers.dart';
import 'package:pharmacy_app/features/supply_chain/presentation/pages/representative_home_page.dart';
import 'package:pharmacy_app/features/supply_chain/presentation/pages/warehouse_home_page.dart';

void main() {
  testWidgets('admin home renders live platform indicators', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          adminDashboardProvider.overrideWith(
            (ref) async => const AdminDashboard(
              totalUsers: 20,
              activeUsers: 18,
              totalPharmacies: 7,
              pendingPharmacies: 2,
              totalOrganizations: 3,
              pendingOrganizations: 1,
              totalWarehouses: 2,
              approvedWarehouses: 1,
              pendingWarehouses: 1,
              pendingOrganizationVerifications: 1,
              totalMedicineRequests: 9,
              pendingMedicineRequests: 2,
              totalDonationOffers: 4,
              openAssistanceRequests: 1,
            ),
          ),
        ],
        child: const MaterialApp(home: Scaffold(body: AdminHomePage())),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('منصة واضحة تحت إدارتك'), findsOneWidget);
    expect(find.text('5 عناصر بانتظار المراجعة'), findsOneWidget);
  });

  testWidgets('organization home renders campaign and verification data', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          organizationDashboardProvider.overrideWith(
            (ref) async => const OrganizationDashboard(
              organizationId: 'org-1',
              organizationName: 'منظمة دوائي',
              registrationNumber: 'REG-1',
              city: 'دمشق',
              area: 'المزة',
              address: 'العنوان',
              isApproved: true,
              verificationStatus: 'Approved',
              verificationDocumentsCount: 2,
              totalCampaignsCount: 4,
              activeCampaignsCount: 2,
              pendingDonationOffersCount: 3,
              openAssistanceRequestsCount: 1,
              recentCampaigns: [],
            ),
          ),
        ],
        child: const MaterialApp(home: Scaffold(body: OrganizationHomePage())),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('منظمة دوائي'), findsOneWidget);
    expect(find.text('منظمة معتمدة · موثقة'), findsOneWidget);
  });

  testWidgets('warehouse home renders stock and order indicators', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          supplyDashboardProvider.overrideWith(
            (ref) async => const SupplyDashboard(
              activeBatches: 12,
              lowStockBatches: 2,
              expiringBatches: 1,
              pendingOrders: 3,
              activeDeliveries: 2,
              inventoryValue: 450000,
              recentOrders: [],
              alerts: [],
            ),
          ),
        ],
        child: const MaterialApp(home: Scaffold(body: WarehouseHomePage())),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('توريد منظم من المخزون للتسليم'), findsOneWidget);
    expect(find.text('3 طلبات توريد بانتظارك'), findsOneWidget);
  });

  testWidgets('representative home renders the assigned delivery', (
    tester,
  ) async {
    final order = SupplyOrder(
      id: 'order-1',
      orderCode: 'SO-1',
      status: 'ReadyForDispatch',
      pharmacyName: 'صيدلية الشفاء',
      warehouseName: 'مستودع دوائي',
      pharmacyCity: 'دمشق',
      pharmacyArea: 'المزة',
      pharmacyAddress: 'العنوان',
      subtotal: 100,
      deliveryFee: 10,
      totalAmount: 110,
      createdAtUtc: DateTime.utc(2026, 8, 2),
      items: const [],
      shipment: const Shipment(
        id: 'shipment-1',
        shipmentCode: 'SH-1',
        status: 'Assigned',
        pickupQrToken: 'token',
      ),
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          supplyOrdersProvider.overrideWith((ref) async => [order]),
        ],
        child: const MaterialApp(
          home: Scaffold(body: RepresentativeHomePage()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('مهمتك الحالية إلى صيدلية الشفاء'), findsOneWidget);
    expect(find.text('1 مهام نشطة'), findsOneWidget);
  });
}
