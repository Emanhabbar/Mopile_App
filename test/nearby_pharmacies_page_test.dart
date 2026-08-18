import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pharmacy_app/features/user/data/models/user_discovery_models.dart';
import 'package:pharmacy_app/features/user/presentation/controllers/user_providers.dart';
import 'package:pharmacy_app/features/user/presentation/pages/nearby_pharmacies_page.dart';

import 'helpers.dart';

void main() {
  testWidgets('nearby map stays renderable while semantics are enabled', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();

    const parameters = (radiusInMeters: 5000, sortBy: 'Distance');
    const nearestPharmacy = UserMapPharmacy(
      markerId: 'pharmacy-1',
      source: 'Registered',
      pharmacyId: 'pharmacy-1',
      name: 'صيدلية الشفاء',
      address: 'وسط المدينة',
      latitude: 36.205,
      longitude: 36.164,
      distanceMeters: 620,
      isOpenNow: true,
      statusText: 'مفتوحة الآن',
      averageRating: 4.7,
      ratingsCount: 18,
      hasDeliveryService: true,
      isLocationVerified: true,
      googleMapsUrl: 'https://maps.google.com',
    );
    const discovery = UserLocationDiscovery(
      userId: 'user-1',
      hasSavedLocation: true,
      latitude: 36.2021,
      longitude: 36.1606,
      locationSource: 'Manual',
      radiusInMeters: 5000,
      registeredCount: 1,
      externalCount: 0,
      usedExternalFallback: false,
      registeredPharmacies: [],
      externalPharmacies: [],
      mapMarkers: [nearestPharmacy],
    );
    const route = UserNearestRoute(
      originLatitude: 36.2021,
      originLongitude: 36.1606,
      pharmacy: nearestPharmacy,
      routeAvailable: true,
      distanceMeters: 710,
      durationSeconds: 480,
      path: [
        RouteCoordinate(latitude: 36.2021, longitude: 36.1606),
        RouteCoordinate(latitude: 36.2035, longitude: 36.162),
        RouteCoordinate(latitude: 36.205, longitude: 36.164),
      ],
      directionsUrl: 'https://maps.google.com',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userLocationDiscoveryProvider(
            parameters,
          ).overrideWith((ref) async => discovery),
          userNearestRouteProvider(5000).overrideWith((ref) async => route),
        ],
        child: appUnderTest(const NearbyPharmaciesPage()),
      ),
    );
    await tester.pumpAndSettle(const Duration(milliseconds: 700));

    expect(find.byType(FlutterMap), findsOneWidget);
    expect(find.text('صيدلية الشفاء'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('pharmacy-map-marker-pharmacy-1')),
      findsOneWidget,
    );
    await tester.ensureVisible(find.byType(FlutterMap));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(FlutterMap), const Offset(30, 20));
    await tester.pump();
    expect(tester.takeException(), isNull);
    semantics.dispose();
  });
}
