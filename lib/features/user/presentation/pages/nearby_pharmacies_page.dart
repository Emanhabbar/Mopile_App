import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/demo_flags.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../../core/location/device_location_service.dart';
import '../../../../core/widgets/app_reveal.dart';
import '../../../../core/widgets/async_states.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/models/user_discovery_models.dart';
import '../../data/models/user_models.dart';
import '../../data/repositories/user_repository.dart';
import '../controllers/user_providers.dart';


List<LatLng> _decodePolyline(String encoded) {
  final List<LatLng> points = [];
  int index = 0;
  int lat = 0;
  int lng = 0;
  while (index < encoded.length) {
    int b;
    int shift = 0;
    int result = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    lat += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
    shift = 0;
    result = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    lng += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
    points.add(LatLng(lat / 1e5, lng / 1e5));
  }
  return points;
}

Future<List<LatLng>?> _fetchDirectionsRoute({
  required double originLat,
  required double originLng,
  required double destLat,
  required double destLng,
}) async {
  final url = Uri.https('maps.googleapis.com', '/maps/api/directions/json', {
    'origin': '$originLat,$originLng',
    'destination': '$destLat,$destLng',
    'mode': 'walking',
  });
  try {
    final client = HttpClient();
    final request = await client.getUrl(url);
    final response = await request.close();
    final body = await response.transform(utf8.decoder).join();
    client.close(force: false);
    final json = jsonDecode(body) as Map<String, dynamic>;
    final routes = json['routes'] as List<dynamic>?;
    if (routes == null || routes.isEmpty) return null;
    final overviewPolyline =
        routes[0]['overview_polyline'] as Map<String, dynamic>;
    final encoded = overviewPolyline['points'] as String;
    return _decodePolyline(encoded);
  } catch (_) {
    return null;
  }
}

const _mockDiscovery = UserLocationDiscovery(
  userId: 'demo',
  hasSavedLocation: true,
  latitude: 33.5138,
  longitude: 36.2765,
  locationSource: 'Manual',
  radiusInMeters: 3000,
  registeredCount: 3,
  externalCount: 0,
  usedExternalFallback: false,
  registeredPharmacies: [
    UserPharmacySummary(
      pharmacyId: 'p1',
      pharmacyName: 'صيدلية الشفاء',
      city: 'دمشق',
      area: 'المزة',
      address: 'طريق المطار، المزة',
      distanceMeters: 750,
      averageRating: 4.5,
      ratingsCount: 120,
      hasDeliveryService: true,
      isOpenNow: true,
      statusText: 'مفتوحة الآن',
    ),
    UserPharmacySummary(
      pharmacyId: 'p2',
      pharmacyName: 'صيدلية النور',
      city: 'دمشق',
      area: 'المزة',
      address: 'شارع المزة الرئيسي',
      distanceMeters: 1200,
      averageRating: 4.2,
      ratingsCount: 85,
      hasDeliveryService: true,
      isOpenNow: true,
      statusText: 'مفتوحة الآن',
    ),
    UserPharmacySummary(
      pharmacyId: 'p3',
      pharmacyName: 'صيدلية الحياة',
      city: 'دمشق',
      area: 'أبي رمانة',
      address: 'شارع أبي رمانة',
      distanceMeters: 2400,
      averageRating: 4.0,
      ratingsCount: 60,
      hasDeliveryService: false,
      isOpenNow: false,
      statusText: 'مغلقة',
    ),
  ],
  externalPharmacies: [],
  mapMarkers: [
    UserMapPharmacy(
      markerId: 'm1',
      source: 'Registered',
      pharmacyId: 'p1',
      name: 'صيدلية الشفاء',
      address: 'طريق المطار، المزة',
      latitude: 33.5140,
      longitude: 36.2770,
      distanceMeters: 750,
      isOpenNow: true,
      statusText: 'مفتوحة الآن',
      averageRating: 4.5,
      ratingsCount: 120,
      hasDeliveryService: true,
      isLocationVerified: true,
    ),
    UserMapPharmacy(
      markerId: 'm2',
      source: 'Registered',
      pharmacyId: 'p2',
      name: 'صيدلية النور',
      address: 'شارع المزة الرئيسي',
      latitude: 33.5160,
      longitude: 36.2790,
      distanceMeters: 1200,
      isOpenNow: true,
      statusText: 'مفتوحة الآن',
      averageRating: 4.2,
      ratingsCount: 85,
      hasDeliveryService: true,
      isLocationVerified: true,
    ),
    UserMapPharmacy(
      markerId: 'm3',
      source: 'Registered',
      pharmacyId: 'p3',
      name: 'صيدلية الحياة',
      address: 'شارع أبي رمانة',
      latitude: 33.5200,
      longitude: 36.2830,
      distanceMeters: 2400,
      isOpenNow: false,
      statusText: 'مغلقة',
      averageRating: 4.0,
      ratingsCount: 60,
      hasDeliveryService: false,
      isLocationVerified: true,
    ),
  ],
);

const _mockRoute = UserNearestRoute(
  originLatitude: 33.5138,
  originLongitude: 36.2765,
  pharmacy: UserMapPharmacy(
    markerId: 'm1',
    source: 'Registered',
    pharmacyId: 'p1',
    name: 'صيدلية الشفاء',
    address: 'طريق المطار، المزة',
    latitude: 33.5140,
    longitude: 36.2770,
    distanceMeters: 750,
    isOpenNow: true,
    statusText: 'مفتوحة الآن',
    averageRating: 4.5,
    ratingsCount: 120,
    hasDeliveryService: true,
    isLocationVerified: true,
  ),
  routeAvailable: true,
  distanceMeters: 750,
  durationSeconds: 480,
  path: [
    RouteCoordinate(latitude: 33.5138, longitude: 36.2765),
    RouteCoordinate(latitude: 33.5132, longitude: 36.2760),
    RouteCoordinate(latitude: 33.5125, longitude: 36.2755),
    RouteCoordinate(latitude: 33.5120, longitude: 36.2748),
    RouteCoordinate(latitude: 33.5118, longitude: 36.2742),
    RouteCoordinate(latitude: 33.5120, longitude: 36.2735),
    RouteCoordinate(latitude: 33.5125, longitude: 36.2730),
    RouteCoordinate(latitude: 33.5130, longitude: 36.2728),
    RouteCoordinate(latitude: 33.5135, longitude: 36.2730),
    RouteCoordinate(latitude: 33.5138, longitude: 36.2740),
    RouteCoordinate(latitude: 33.5140, longitude: 36.2755),
    RouteCoordinate(latitude: 33.5140, longitude: 36.2770),
  ],
  directionsUrl: '',
);

class NearbyPharmaciesPage extends ConsumerStatefulWidget {
  const NearbyPharmaciesPage({super.key});

  @override
  ConsumerState<NearbyPharmaciesPage> createState() =>
      _NearbyPharmaciesPageState();
}

class _NearbyPharmaciesPageState extends ConsumerState<NearbyPharmaciesPage> {
  int _radius = 5000;
  bool _updatingLocation = false;

  UserDiscoveryParameters get _parameters =>
      (radiusInMeters: _radius, sortBy: 'Distance');

  @override
  Widget build(BuildContext context) {
    final discovery = kScreenshotDemo
        ? const AsyncData(_mockDiscovery)
        : ref.watch(userLocationDiscoveryProvider(_parameters));
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.nearbyPharmacies),
        actions: [
          IconButton(
            onPressed: _updatingLocation ? null : _useDeviceLocation,
            tooltip: l10n.updateMyLocation,
            icon: const Icon(Icons.my_location_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: discovery.when(
        loading: () => AppLoadingState(label: l10n.locatingPharmacies),
        error: (error, _) {
          if (_isMissingLocation(error)) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              children: [
                AppReveal(
                  child: _LocationHeader(
                    hasLocation: false,
                    isUpdating: _updatingLocation,
                    onAutomatic: _useDeviceLocation,
                    onManual: _showManualLocation,
                  ),
                ),
                const SizedBox(height: 18),
                const AppReveal(
                  delay: Duration(milliseconds: 90),
                  child: _NoLocationCard(),
                ),
              ],
            );
          }
          return AppErrorState(
            error: error,
            onRetry: () =>
                ref.invalidate(userLocationDiscoveryProvider(_parameters)),
          );
        },
        data: (data) {
          final AsyncValue<UserNearestRoute?> route = kScreenshotDemo
              ? const AsyncData(_mockRoute)
              : data.hasSavedLocation && data.mapMarkers.isNotEmpty
              ? ref.watch(userNearestRouteProvider(_radius))
              : const AsyncData(null);
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(userLocationDiscoveryProvider(_parameters));
              ref.invalidate(userNearestRouteProvider(_radius));
              await ref.read(userLocationDiscoveryProvider(_parameters).future);
            },
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              children: [
                AppReveal(
                  child: _LocationHeader(
                    hasLocation: data.hasSavedLocation,
                    isUpdating: _updatingLocation,
                    onAutomatic: _useDeviceLocation,
                    onManual: _showManualLocation,
                  ),
                ),
                const SizedBox(height: 16),
                AppReveal(
                  delay: const Duration(milliseconds: 70),
                  child: _RadiusSelector(
                    value: _radius,
                    onChanged: (value) => setState(() => _radius = value),
                  ),
                ),
                const SizedBox(height: 18),
                if (!data.hasSavedLocation)
                  const AppReveal(
                    delay: Duration(milliseconds: 120),
                    child: _NoLocationCard(),
                  )
                else ...[
                  _MapCard(
                    data: data,
                    route: route.valueOrNull,
                    radius: _radius,
                  ),
                  const SizedBox(height: 20),
                  AppReveal(
                    delay: const Duration(milliseconds: 170),
                    child: _ResultsSummary(data: data),
                  ),
                  const SizedBox(height: 12),
                  if (data.mapMarkers.isEmpty)
                    const _EmptyNearby()
                  else
                    ...data.mapMarkers
                        .take(3)
                        .toList()
                        .asMap()
                        .entries
                        .map(
                          (entry) => Padding(
                            padding: const EdgeInsets.only(bottom: 11),
                            child: AppReveal(
                              delay: Duration(
                                milliseconds: 210 + (entry.key * 55),
                              ),
                              child: _NearbyItem(
                                number: entry.key + 1,
                                pharmacy: entry.value,
                                isNearest: entry.key == 0,
                                route: entry.key == 0
                                    ? route.valueOrNull
                                    : null,
                              ),
                            ),
                          ),
                        ),
                  if (route.isLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child: LinearProgressIndicator(),
                    ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _useDeviceLocation() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _updatingLocation = true);
    try {
      final location = await ref
          .read(deviceLocationServiceProvider)
          .determineCurrent();
      await _saveLocation(
        UserLocationUpdate(
          latitude: location.latitude,
          longitude: location.longitude,
          accuracyMeters: location.accuracyMeters,
          source: 'BrowserGps',
        ),
      );
    } catch (error) {
      _showMessage(_messageFor(error, l10n), error: true);
    } finally {
      if (mounted) setState(() => _updatingLocation = false);
    }
  }

  Future<void> _showManualLocation() async {
    final l10n = AppLocalizations.of(context);
    final latitude = TextEditingController();
    final longitude = TextEditingController();
    final request = await showModalBottomSheet<UserLocationUpdate>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) =>
          _ManualLocationSheet(latitude: latitude, longitude: longitude),
    );
    latitude.dispose();
    longitude.dispose();
    if (request == null) return;
    setState(() => _updatingLocation = true);
    try {
      await _saveLocation(request);
    } catch (error) {
      _showMessage(_messageFor(error, l10n), error: true);
    } finally {
      if (mounted) setState(() => _updatingLocation = false);
    }
  }

  Future<void> _saveLocation(UserLocationUpdate request) async {
    final l10n = AppLocalizations.of(context);
    await ref.read(userRepositoryProvider).updateLocation(request);
    ref
      ..invalidate(userLocationDiscoveryProvider)
      ..invalidate(userNearestRouteProvider)
      ..invalidate(userNearestPharmaciesProvider)
      ..invalidate(userDashboardProvider)
      ..invalidate(userProfileProvider);
    _showMessage(l10n.locationUpdated);
  }

  void _showMessage(String message, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: error ? context.appColors.danger : null,
        ),
      );
  }

  String _messageFor(Object error, AppLocalizations l10n) =>
      error is ApiException ? error.localize(l10n) : l10n.locationUpdateFailed;
}

class _LocationHeader extends StatelessWidget {
  const _LocationHeader({
    required this.hasLocation,
    required this.isUpdating,
    required this.onAutomatic,
    required this.onManual,
  });

  final bool hasLocation;
  final bool isUpdating;
  final VoidCallback onAutomatic;
  final VoidCallback onManual;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.appColors.primary,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: context.appColors.primaryDark.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.near_me_rounded,
              color: context.appColors.secondary,
              size: 26,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            hasLocation ? l10n.discoverNearest : l10n.setLocationFirst,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: Colors.white, fontSize: 22),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.nearbyHeaderSubtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 17),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: FilledButton.icon(
                    onPressed: isUpdating ? null : onAutomatic,
                    icon: isUpdating
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.my_location_rounded),
                    label: Text(
                      isUpdating ? l10n.locatingNow : l10n.myCurrentLocation,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: isUpdating ? null : onManual,
                  icon: const Icon(Icons.edit_location_alt_outlined, size: 20),
                  label: Text(
                    l10n.manualLabel,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.25),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RadiusSelector extends StatelessWidget {
  const _RadiusSelector({required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final options = <int, String>{
      1000: l10n.distanceKm('1'),
      3000: l10n.distanceKm('3'),
      5000: l10n.distanceKm('5'),
      10000: l10n.distanceKm('10'),
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              l10n.searchRangeLabel,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Spacer(),
            Text(
              l10n.dragMapHint,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 9),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SegmentedButton<int>(
            segments: options.entries
                .map(
                  (entry) =>
                      ButtonSegment(value: entry.key, label: Text(entry.value)),
                )
                .toList(growable: false),
            selected: {value},
            onSelectionChanged: (selection) => onChanged(selection.first),
            showSelectedIcon: false,
          ),
        ),
      ],
    );
  }
}

class _MapCard extends ConsumerStatefulWidget {
  const _MapCard({
    required this.data,
    required this.route,
    required this.radius,
  });

  final UserLocationDiscovery data;
  final UserNearestRoute? route;
  final int radius;

  @override
  ConsumerState<_MapCard> createState() => _MapCardState();
}

class _MapCardState extends ConsumerState<_MapCard> {
  late final MapController _mapController;
  int _selectedIndex = 0;
  bool _mapReady = false;
  bool _expanded = false;
  bool _loadingSelectedRoute = false;
  UserNearestRoute? _selectedRoute;
  List<LatLng>? _realRoutePath;
  bool _realRouteFetched = false;

  UserLocationDiscovery get data => widget.data;
  UserNearestRoute? get route =>
      _selectedIndex == 0 ? widget.route : _selectedRoute;

  List<UserMapPharmacy> get _markers =>
      data.mapMarkers.take(3).toList(growable: false);

  UserMapPharmacy? get _selectedPharmacy => _markers.isEmpty
      ? null
      : _markers[_selectedIndex.clamp(0, _markers.length - 1)];

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    if (kScreenshotDemo) {
      _fetchRealRoute();
    }
  }

  bool _hasUsableRoute(UserNearestRoute? candidate) =>
      candidate != null &&
      candidate.routeAvailable &&
      candidate.path.length > 1;

  // The routing provider snaps its start/end points to the nearest road, so
  // the polyline usually stops a few meters (or a street) before the exact
  // user/pharmacy markers. Extend both ends to the exact coordinates so the
  // drawn route visually reaches the markers.
  List<LatLng> _routePolylinePoints(LatLng origin) {
    final List<LatLng> base =
        (_realRoutePath != null && _realRoutePath!.length > 1)
        ? List<LatLng>.from(_realRoutePath!)
        : route?.path
                  .map((point) => LatLng(point.latitude, point.longitude))
                  .toList(growable: false) ??
              const <LatLng>[];
    if (base.length < 2) return base;

    final points = List<LatLng>.from(base);
    if (_metersBetween(points.first, origin) > 1) {
      points.insert(0, origin);
    }
    final destination = _selectedPharmacy;
    if (destination != null) {
      final destinationPoint = LatLng(
        destination.latitude,
        destination.longitude,
      );
      if (_metersBetween(points.last, destinationPoint) > 1) {
        points.add(destinationPoint);
      }
    }
    return points;
  }

  static double _metersBetween(LatLng a, LatLng b) {
    const earthRadius = 6371000.0;
    double radians(double degrees) => degrees * math.pi / 180.0;
    final dLat = radians(b.latitude - a.latitude);
    final dLng = radians(b.longitude - a.longitude);
    final sLat = math.sin(dLat / 2);
    final sLng = math.sin(dLng / 2);
    final h = sLat * sLat +
        math.cos(radians(a.latitude)) *
            math.cos(radians(b.latitude)) *
            sLng *
            sLng;
    return 2 * earthRadius * math.asin(math.sqrt(h));
  }

  Future<void> _fetchRealRoute() async {
    // Demo mode always tries to render a real Google route over the mock
    // points (the mock path is kept as an offline fallback). Live mode only
    // falls back to Google when the backend did not provide a drawable route.
    if (!kScreenshotDemo && _hasUsableRoute(widget.route)) return;
    if (_realRouteFetched) return;
    _realRouteFetched = true;
    final result = await _fetchDirectionsRoute(
      originLat: data.latitude,
      originLng: data.longitude,
      destLat: _markers.isNotEmpty ? _markers[0].latitude : data.latitude,
      destLng: _markers.isNotEmpty ? _markers[0].longitude : data.longitude,
    );
    if (mounted && result != null && result.length > 1) {
      setState(() => _realRoutePath = result);
    }
  }

  @override
  void didUpdateWidget(covariant _MapCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_selectedIndex >= _markers.length) _selectedIndex = 0;
    if (_mapReady &&
        (oldWidget.data.latitude != data.latitude ||
            oldWidget.data.longitude != data.longitude ||
            oldWidget.data.mapMarkers.length != data.mapMarkers.length ||
            oldWidget.route?.path.length != route?.path.length)) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _fitAll());
    }
    if (!kScreenshotDemo &&
        !_hasUsableRoute(widget.route) &&
        _realRoutePath == null &&
        oldWidget.route?.path.length != widget.route?.path.length) {
      _fetchRealRoute();
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final center = LatLng(data.latitude, data.longitude);
    final routePoints = _routePolylinePoints(center);

    final expandedHeight = (MediaQuery.sizeOf(context).height - 155)
        .clamp(540.0, 780.0)
        .toDouble();
    return AnimatedContainer(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      height: _expanded ? expandedHeight : 472,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: context.appColors.border, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: RepaintBoundary(child: _buildFlutterMap(center, routePoints)),
          ),
          PositionedDirectional(
            top: 14,
            start: 14,
            end: 72,
            child: _loadingSelectedRoute
                ? const LinearProgressIndicator()
                : _RouteOverview(route: route),
          ),
          PositionedDirectional(
            top: 14,
            end: 14,
            child: Column(
              children: [
                _MapControl(
                  icon: Icons.my_location_rounded,
                  tooltip: l10n.backToMyLocation,
                  onTap: _centerOnUser,
                ),
                const SizedBox(height: 9),
                _MapControl(
                  icon: Icons.fit_screen_rounded,
                  tooltip: l10n.showAllLocations,
                  onTap: _fitAll,
                ),
                const SizedBox(height: 9),
                _MapControl(
                  icon: _expanded
                      ? Icons.fullscreen_exit_rounded
                      : Icons.fullscreen_rounded,
                  tooltip: _expanded ? l10n.shrinkMap : l10n.expandMap,
                  onTap: () {
                    setState(() => _expanded = !_expanded);
                    WidgetsBinding.instance.addPostFrameCallback(
                      (_) => _fitAll(),
                    );
                  },
                ),
              ],
            ),
          ),
          if (_selectedPharmacy case final pharmacy?)
            PositionedDirectional(
              start: 13,
              end: 13,
              bottom: 13,
              child: _MapPharmacyPreview(
                number: _selectedIndex + 1,
                pharmacy: pharmacy,
                route: route,
                onOpen: () => _openPharmacy(pharmacy),
                onDirections: () => _openDirections(route, pharmacy),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFlutterMap(LatLng center, List<LatLng> routePoints) {
    final l10n = AppLocalizations.of(context);
    return Builder(
      builder: (context) {
        try {
          return FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: center,
              initialZoom: 13.5,
              minZoom: 4,
              maxZoom: 18,
              interactionOptions: const InteractionOptions(
                flags:
                    InteractiveFlag.drag |
                    InteractiveFlag.pinchZoom |
                    InteractiveFlag.doubleTapZoom,
              ),
              onMapReady: () {
                _mapReady = true;
                WidgetsBinding.instance.addPostFrameCallback((_) => _fitAll());
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.pharmacy_app',
                tileBuilder: _softMapTileBuilder,
              ),
              if (routePoints.length > 1)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: routePoints,
                      strokeWidth: 6,
                      borderStrokeWidth: 5,
                      borderColor: Colors.white.withValues(alpha: 0.92),
                      gradientColors: [
                        context.appColors.primary,
                        context.appColors.primaryDark,
                        context.appColors.secondary,
                      ],
                    ),
                  ],
                ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: center,
                    width: 58,
                    height: 58,
                    child: const _UserMarker(),
                  ),
                  ..._markers.asMap().entries.map(
                    (entry) => Marker(
                      point: LatLng(
                        entry.value.latitude,
                        entry.value.longitude,
                      ),
                      width: 68,
                      height: 76,
                      child: _PharmacyMarker(
                        key: ValueKey(
                          'pharmacy-map-marker-${entry.value.markerId}',
                        ),
                        number: entry.key + 1,
                        nearest: entry.key == 0,
                        selected: entry.key == _selectedIndex,
                        pharmacyName: entry.value.name,
                        onTap: () => _selectMarker(entry.key),
                      ),
                    ),
                  ),
                ],
              ),
              const RichAttributionWidget(
                alignment: AttributionAlignment.bottomLeft,
                attributions: [TextSourceAttribution('OpenStreetMap')],
              ),
            ],
          );
        } catch (_) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.map_outlined,
                    color: context.appColors.textMuted,
                    size: 40,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.mapLoadFailed,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.mapLoadFailedSubtitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  void _selectMarker(int index) {
    setState(() {
      _selectedIndex = index;
      _selectedRoute = null;
    });
    final pharmacy = _markers[index];
    final zoom = _mapController.camera.zoom < 14.5
        ? 14.5
        : _mapController.camera.zoom;
    try {
      _mapController.move(LatLng(pharmacy.latitude, pharmacy.longitude), zoom);
    } catch (_) {}
    if (index > 0 && pharmacy.pharmacyId != null) {
      _loadSelectedRoute(pharmacy.pharmacyId!);
    }
  }

  Future<void> _loadSelectedRoute(String pharmacyId) async {
    setState(() => _loadingSelectedRoute = true);
    try {
      final value = await ref
          .read(userRepositoryProvider)
          .getNearestRoute(
            UserNearbyQuery(radiusInMeters: widget.radius),
            pharmacyId: pharmacyId,
          );
      if (!mounted || _selectedPharmacy?.pharmacyId != pharmacyId) return;
      setState(() => _selectedRoute = value);
      WidgetsBinding.instance.addPostFrameCallback((_) => _fitAll());
    } catch (_) {
    } finally {
      if (mounted) setState(() => _loadingSelectedRoute = false);
    }
  }

  void _centerOnUser() {
    if (!_mapReady) return;
    try {
      _mapController.move(LatLng(data.latitude, data.longitude), 15);
    } catch (_) {}
  }

  void _fitAll() {
    if (!_mapReady) return;
    final points = <LatLng>[
      LatLng(data.latitude, data.longitude),
      ..._markers.map((item) => LatLng(item.latitude, item.longitude)),
      ...?route?.path.map((point) => LatLng(point.latitude, point.longitude)),
    ];
    try {
      if (points.length == 1) {
        _mapController.move(points.first, 14.5);
        return;
      }
      _mapController.fitCamera(
        CameraFit.coordinates(
          coordinates: points,
          padding: const EdgeInsets.fromLTRB(48, 88, 48, 145),
          minZoom: 9,
          maxZoom: 15.5,
        ),
      );
    } catch (_) {}
  }

  void _openPharmacy(UserMapPharmacy pharmacy) {
    if (pharmacy.pharmacyId != null) {
      context.push('/user/pharmacies/${pharmacy.pharmacyId}');
    } else if (pharmacy.externalPlaceId != null) {
      context.push(
        '/pharmacies/external/${Uri.encodeComponent(pharmacy.externalPlaceId!)}',
      );
    }
  }

  Future<void> _openDirections(
    UserNearestRoute? route,
    UserMapPharmacy pharmacy,
  ) async {
    final l10n = AppLocalizations.of(context);
    final raw = route?.directionsUrl.isNotEmpty == true
        ? route!.directionsUrl
        : pharmacy.googleMapsUrl;
    final uri = raw == null ? null : Uri.tryParse(raw);
    if (uri != null) {
      try {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.mapOpenFailed)));
        }
      }
    }
  }
}

Widget _softMapTileBuilder(
  BuildContext context,
  Widget tileWidget,
  TileImage tile,
) {
  return ColorFiltered(
    colorFilter: const ColorFilter.matrix([
      0.49,
      0.46,
      0.05,
      0,
      13,
      0.14,
      0.81,
      0.05,
      0,
      13,
      0.14,
      0.46,
      0.40,
      0,
      13,
      0,
      0,
      0,
      1,
      0,
    ]),
    child: tileWidget,
  );
}

class _RouteOverview extends StatelessWidget {
  const _RouteOverview({required this.route});

  final UserNearestRoute? route;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final minutes = route?.durationSeconds == null
        ? null
        : (route!.durationSeconds! / 60).ceil();
    final routeReady = route?.routeAvailable == true && route!.path.length > 1;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.appColors.primaryDeep,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: context.appColors.primary.withValues(alpha: 0.15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 31,
              height: 31,
              decoration: BoxDecoration(
                color: context.appColors.secondary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                routeReady ? Icons.route_rounded : Icons.map_outlined,
                color: context.appColors.secondary,
                size: 18,
              ),
            ),
            const SizedBox(width: 9),
            Flexible(
              child: Text(
                routeReady
                    ? l10n.routeToNearest(
                        _distance(l10n, route!.distanceMeters),
                        minutes == null ? '' : ' · $minutes ${l10n.minuteUnit}',
                      )
                    : l10n.exploreMapHint,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapControl extends StatelessWidget {
  const _MapControl({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Container(
        decoration: BoxDecoration(
          color: context.appColors.surface,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: context.appColors.border),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(icon, color: context.appColors.primaryDark, size: 21),
          ),
        ),
      ),
    );
  }
}

class _MapPharmacyPreview extends StatelessWidget {
  const _MapPharmacyPreview({
    required this.number,
    required this.pharmacy,
    required this.route,
    required this.onOpen,
    required this.onDirections,
  });

  final int number;
  final UserMapPharmacy pharmacy;
  final UserNearestRoute? route;
  final VoidCallback onOpen;
  final VoidCallback onDirections;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final minutes = route?.durationSeconds == null
        ? null
        : (route!.durationSeconds! / 60).ceil();
    final canNavigate =
        route?.directionsUrl.isNotEmpty == true ||
        pharmacy.googleMapsUrl?.isNotEmpty == true;
    return Container(
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: context.appColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          onTap: onOpen,
          child: Padding(
            padding: const EdgeInsets.all(13),
            child: Row(
              children: [
                Container(
                  width: 47,
                  height: 47,
                  decoration: BoxDecoration(
                    color: number == 1
                        ? context.appColors.secondary
                        : context.appColors.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$number',
                    style: TextStyle(
                      color: number == 1
                          ? context.appColors.primaryDeep
                          : Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        pharmacy.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.near_me_rounded,
                            size: 14,
                            color: context.appColors.primary.withValues(
                              alpha: 0.8,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              '${_distance(l10n, pharmacy.distanceMeters)}${minutes == null ? '' : ' · ${l10n.routeMinutes(minutes)}'}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: canNavigate ? onDirections : null,
                  tooltip: l10n.startDirections,
                  style: IconButton.styleFrom(
                    backgroundColor: context.appColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: context.appColors.border,
                  ),
                  icon: const Icon(Icons.navigation_rounded, size: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UserMarker extends StatelessWidget {
  const _UserMarker();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.appColors.primary.withValues(alpha: 0.18),
          ),
        ),
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: context.appColors.primary,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
          ),
        ),
        const Icon(Icons.person_rounded, color: Colors.white, size: 10),
      ],
    );
  }
}

class _PharmacyMarker extends StatelessWidget {
  const _PharmacyMarker({
    required this.number,
    required this.nearest,
    required this.selected,
    required this.pharmacyName,
    required this.onTap,
    super.key,
  });

  final int number;
  final bool nearest;
  final bool selected;
  final String pharmacyName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = nearest
        ? context.appColors.secondary
        : context.appColors.primaryDark;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.local_pharmacy_rounded,
                  color: nearest ? context.appColors.primaryDeep : Colors.white,
                  size: 16,
                ),
                PositionedDirectional(
                  top: 1,
                  end: 2,
                  child: Container(
                    width: 13,
                    height: 13,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$number',
                      style: TextStyle(
                        color: context.appColors.primaryDeep,
                        fontSize: 7,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 30,
            child: Transform.rotate(
              angle: 0.785398,
              child: Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  color: color,
                  border: const Border(
                    right: BorderSide(color: Colors.white, width: 1.5),
                    bottom: BorderSide(color: Colors.white, width: 1.5),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultsSummary extends StatelessWidget {
  const _ResultsSummary({required this.data});

  final UserLocationDiscovery data;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.nearestThreePharmacies,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                l10n.resultsSummaryCounts(
                  data.registeredCount,
                  data.externalCount,
                ),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        Icon(Icons.route_rounded, color: context.appColors.primary),
      ],
    );
  }
}

class _NearbyItem extends StatelessWidget {
  const _NearbyItem({
    required this.number,
    required this.pharmacy,
    required this.isNearest,
    this.route,
  });

  final int number;
  final UserMapPharmacy pharmacy;
  final bool isNearest;
  final UserNearestRoute? route;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final minutes = route?.durationSeconds == null
        ? null
        : (route!.durationSeconds! / 60).ceil();
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isNearest
              ? context.appColors.primary.withValues(alpha: 0.35)
              : context.appColors.border,
        ),
      ),
      child: InkWell(
        onTap: pharmacy.pharmacyId != null
            ? () => context.push('/user/pharmacies/${pharmacy.pharmacyId}')
            : pharmacy.externalPlaceId != null
            ? () => context.push(
                '/pharmacies/external/${Uri.encodeComponent(pharmacy.externalPlaceId!)}',
              )
            : null,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: isNearest
                      ? context.appColors.primary
                      : context.appColors.background,
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Text(
                  '$number',
                  style: TextStyle(
                    color: isNearest ? Colors.white : context.appColors.text,
                    fontWeight: FontWeight.w900,
                    fontSize: 17,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pharmacy.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _distance(l10n, pharmacy.distanceMeters),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 5,
                      children: [
                        _InfoPill(
                          icon: Icons.schedule_rounded,
                          text: pharmacy.statusText,
                        ),
                        if (minutes != null)
                          _InfoPill(
                            icon: Icons.route_rounded,
                            text: l10n.routeMinutes(minutes),
                          ),
                        if (isNearest)
                          _InfoPill(
                            icon: Icons.bolt_rounded,
                            text: l10n.nearestLabel,
                            highlighted: true,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton.filledTonal(
                onPressed: () => _openDirections(route, pharmacy),
                tooltip: l10n.directions,
                icon: const Icon(Icons.navigation_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openDirections(
    UserNearestRoute? route,
    UserMapPharmacy pharmacy,
  ) async {
    final raw = route?.directionsUrl.isNotEmpty == true
        ? route!.directionsUrl
        : pharmacy.googleMapsUrl;
    if (raw == null || raw.isEmpty) return;
    final uri = Uri.tryParse(raw);
    if (uri != null) {
      try {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (_) {
        // Silently fail — the user can try again or use another app.
      }
    }
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.icon,
    required this.text,
    this.highlighted = false,
  });

  final IconData icon;
  final String text;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final color = highlighted
        ? context.appColors.secondary
        : context.appColors.textMuted;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ManualLocationSheet extends StatelessWidget {
  const _ManualLocationSheet({required this.latitude, required this.longitude});

  final TextEditingController latitude;
  final TextEditingController longitude;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final key = GlobalKey<FormState>();
    // The custom BottomNav is 76px tall + SafeArea ~12px.
    // Add enough bottom padding so the form content stays above the bar.
    final bottomPadding = MediaQuery.viewInsetsOf(context).bottom + 88 + 24;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, bottomPadding),
      child: Form(
        key: key,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.manualLocationTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 7),
            Text(
              l10n.manualLocationSubtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: latitude,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              decoration: InputDecoration(
                labelText: l10n.latitudeLabel,
                prefixIcon: const Icon(Icons.north_rounded),
              ),
              validator: (value) {
                final number = double.tryParse(value?.trim() ?? '');
                return number == null || number < -90 || number > 90
                    ? l10n.latitudeInvalid
                    : null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: longitude,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              decoration: InputDecoration(
                labelText: l10n.longitudeLabel,
                prefixIcon: const Icon(Icons.east_rounded),
              ),
              validator: (value) {
                final number = double.tryParse(value?.trim() ?? '');
                return number == null || number < -180 || number > 180
                    ? l10n.longitudeInvalid
                    : null;
              },
            ),
            const SizedBox(height: 19),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  if (!key.currentState!.validate()) return;
                  Navigator.pop(
                    context,
                    UserLocationUpdate(
                      latitude: double.parse(latitude.text.trim()),
                      longitude: double.parse(longitude.text.trim()),
                    ),
                  );
                },
                icon: const Icon(Icons.check_rounded),
                label: Text(l10n.saveLocation),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoLocationCard extends StatelessWidget {
  const _NoLocationCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _CenteredMessage(
      icon: Icons.location_off_rounded,
      title: l10n.noLocationTitle,
      message: l10n.noLocationMessage,
    );
  }
}

class _EmptyNearby extends StatelessWidget {
  const _EmptyNearby();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _CenteredMessage(
      icon: Icons.local_pharmacy_outlined,
      title: l10n.noNearbyTitle,
      message: l10n.noNearbyMessage,
    );
  }
}

class _CenteredMessage extends StatelessWidget {
  const _CenteredMessage({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            Icon(icon, color: context.appColors.textMuted, size: 35),
            const SizedBox(height: 11),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 5),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

String _distance(AppLocalizations l10n, double meters) => meters < 1000
    ? l10n.distanceMeters('${meters.round()}')
    : l10n.distanceKm((meters / 1000).toStringAsFixed(1));

bool _isMissingLocation(Object error) {
  return error is ApiException && error.isLocationRequired;
}
