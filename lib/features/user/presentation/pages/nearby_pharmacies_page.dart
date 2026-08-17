import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../../core/location/device_location_service.dart';
import '../../../../core/widgets/app_reveal.dart';
import '../../../../core/widgets/async_states.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/models/user_discovery_models.dart';
import '../../data/repositories/user_repository.dart';
import '../controllers/user_providers.dart';

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
    final discovery = ref.watch(userLocationDiscoveryProvider(_parameters));
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
          final AsyncValue<UserNearestRoute?> route =
              data.hasSavedLocation && data.mapMarkers.isNotEmpty
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
    await ref.read(userRepositoryProvider).updateLocation(request);
    ref
      ..invalidate(userLocationDiscoveryProvider)
      ..invalidate(userNearestRouteProvider)
      ..invalidate(userNearestPharmaciesProvider)
      ..invalidate(userDashboardProvider)
      ..invalidate(userProfileProvider);
    _showMessage(AppLocalizations.of(context).locationUpdated);
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

String _messageFor(Object error) =>
    error is ApiException
        ? error.message
        : AppLocalizations.of(context).locationUpdateFailed;
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
            hasLocation ? 'اكتشف الأقرب إليك' : 'حدد موقعك أولًا',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: Colors.white, fontSize: 22),
          ),
          const SizedBox(height: 6),
          Text(
            'اعرض أقرب ثلاث صيدليات والطريق إلى الخيار الأقرب.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(
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
                      isUpdating ? 'جاري التحديد...' : 'موقعي الحالي',
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
                  label: const Text(
                    'يدوي',
                    style: TextStyle(
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
    const options = {1000: '1 كم', 3000: '3 كم', 5000: '5 كم', 10000: '10 كم'};
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('نطاق البحث', style: Theme.of(context).textTheme.titleMedium),
            const Spacer(),
            Text(
              'اسحب الخريطة للاستكشاف',
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
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final center = LatLng(data.latitude, data.longitude);
    final routePoints =
        route?.path
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList(growable: false) ??
        const <LatLng>[];

    final expandedHeight = (MediaQuery.sizeOf(context).height - 155)
        .clamp(540.0, 780.0)
        .toDouble();
    return AnimatedContainer(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      height: _expanded ? expandedHeight : 472,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: context.appColors.border,
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: RepaintBoundary(
              child: Builder(
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
                          WidgetsBinding.instance.addPostFrameCallback(
                            (_) => _fitAll(),
                          );
                        },
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
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
                              'تعذر تحميل الخريطة',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'تأكد من اتصالك بالإنترنت ثم حاول مجددًا.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
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
                  tooltip: 'العودة إلى موقعي',
                  onTap: _centerOnUser,
                ),
                const SizedBox(height: 9),
                _MapControl(
                  icon: Icons.fit_screen_rounded,
                  tooltip: 'عرض جميع المواقع',
                  onTap: _fitAll,
                ),
                const SizedBox(height: 9),
                _MapControl(
                  icon: _expanded
                      ? Icons.fullscreen_exit_rounded
                      : Icons.fullscreen_rounded,
                  tooltip: _expanded ? 'تصغير الخريطة' : 'تكبير الخريطة',
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
      // The pharmacy card still exposes its external directions URL as fallback.
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
    final raw = route?.directionsUrl.isNotEmpty == true
        ? route!.directionsUrl
        : pharmacy.googleMapsUrl;
    final uri = raw == null ? null : Uri.tryParse(raw);
    if (uri != null) {
      try {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تعذر فتح تطبيق الخرائط.')),
          );
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
                    ? '${_distance(route!.distanceMeters)}${minutes == null ? '' : ' · $minutes د'} إلى الأقرب'
                    : 'استكشف الصيدليات على الخريطة',
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
                    color: number == 1 ? context.appColors.primaryDeep : Colors.white,
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
                          color: context.appColors.primary.withValues(alpha: 0.8),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '${_distance(pharmacy.distanceMeters)}${minutes == null ? '' : ' · نحو $minutes دقيقة'}',
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
                tooltip: 'بدء الاتجاهات',
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
    return Semantics(
      label: 'موقعك الحالي',
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.appColors.primary.withValues(alpha: 0.14),
            ),
          ),
          Container(
            width: 27,
            height: 27,
            decoration: BoxDecoration(
              color: context.appColors.primary,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
            ),
          ),
          const Icon(Icons.person_rounded, color: Colors.white, size: 13),
        ],
      ),
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
    final color = nearest ? context.appColors.secondary : context.appColors.primaryDark;
    return Semantics(
      button: true,
      selected: selected,
      label: 'الصيدلية رقم $number، $pharmacyName',
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: selected ? 56 : 49,
              height: selected ? 56 : 49,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(selected ? 19 : 17),
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.local_pharmacy_rounded,
                    color: nearest ? context.appColors.primaryDeep : Colors.white,
                    size: selected ? 25 : 22,
                  ),
                  PositionedDirectional(
                    top: 2,
                    end: 3,
                    child: Container(
                      width: 17,
                      height: 17,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$number',
                        style: TextStyle(
                          color: context.appColors.primaryDeep,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: selected ? 50 : 44,
              child: Transform.rotate(
                angle: 0.785398,
                child: Container(
                  width: 13,
                  height: 13,
                  decoration: BoxDecoration(
                    color: color,
                    border: const Border(
                      right: BorderSide(color: Colors.white, width: 2.2),
                      bottom: BorderSide(color: Colors.white, width: 2.2),
                    ),
                  ),
                ),
              ),
            ),
            if (selected)
              Positioned(
                bottom: -2,
                child: Container(
                  width: 9,
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.appColors.shadow.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ResultsSummary extends StatelessWidget {
  const _ResultsSummary({required this.data});

  final UserLocationDiscovery data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'أقرب 3 صيدليات',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                '${data.registeredCount} مسجلة · ${data.externalCount} خيارات إضافية',
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
                  color: isNearest ? context.appColors.primary : context.appColors.background,
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
                      _distance(pharmacy.distanceMeters),
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
                            text: 'نحو $minutes دقيقة',
                          ),
                        if (isNearest)
                          const _InfoPill(
                            icon: Icons.bolt_rounded,
                            text: 'الأقرب',
                            highlighted: true,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton.filledTonal(
                onPressed: () => _openDirections(route, pharmacy),
                tooltip: 'الاتجاهات',
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
    final color = highlighted ? context.appColors.secondary : context.appColors.textMuted;
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
    final key = GlobalKey<FormState>();
    // الـ BottomNav المخصص بارتفاع 76px + SafeArea ~12px.
    // نضيف padding سفلية كافية عشان محتوى النموذج يظهر فوق الشريط.
    final bottomPadding =
        MediaQuery.viewInsetsOf(context).bottom + 88 + 24;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, bottomPadding),
      child: Form(
        key: key,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'إدخال الموقع يدويًا',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 7),
            Text(
              'أدخل الإحداثيات الدقيقة لموقعك الحالي.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: latitude,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              decoration: const InputDecoration(
                labelText: 'خط العرض',
                prefixIcon: Icon(Icons.north_rounded),
              ),
              validator: (value) {
                final number = double.tryParse(value?.trim() ?? '');
                return number == null || number < -90 || number > 90
                    ? 'أدخل خط عرض بين -90 و90.'
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
              decoration: const InputDecoration(
                labelText: 'خط الطول',
                prefixIcon: Icon(Icons.east_rounded),
              ),
              validator: (value) {
                final number = double.tryParse(value?.trim() ?? '');
                return number == null || number < -180 || number > 180
                    ? 'أدخل خط طول بين -180 و180.'
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
                label: const Text('حفظ الموقع'),
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
    return const _CenteredMessage(
      icon: Icons.location_off_rounded,
      title: 'لم يتم تحديد الموقع',
      message: 'استخدم موقع الجهاز أو أدخل الإحداثيات لعرض الصيدليات.',
    );
  }
}

class _EmptyNearby extends StatelessWidget {
  const _EmptyNearby();

  @override
  Widget build(BuildContext context) {
    return const _CenteredMessage(
      icon: Icons.local_pharmacy_outlined,
      title: 'لا توجد صيدليات ضمن النطاق',
      message: 'وسّع مسافة البحث أو حدّث موقعك ثم حاول مجددًا.',
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

String _distance(double meters) => meters < 1000
    ? '${meters.round()} م'
    : '${(meters / 1000).toStringAsFixed(1)} كم';

bool _isMissingLocation(Object error) {
  return error is ApiException && error.isLocationRequired;
}