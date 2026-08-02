import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../errors/api_exception.dart';

final deviceLocationServiceProvider = Provider<DeviceLocationService>(
  (ref) => const DeviceLocationService(),
);

class DeviceLocationService {
  const DeviceLocationService();

  Future<DeviceLocation> determineCurrent() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const ApiException(
        'خدمة الموقع متوقفة. فعّلها من إعدادات الجهاز ثم حاول مجددًا.',
      );
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      throw const ApiException('لم يتم السماح بالوصول إلى الموقع.');
    }
    if (permission == LocationPermission.deniedForever) {
      throw const ApiException(
        'إذن الموقع موقوف لهذا التطبيق. يمكنك تفعيله من إعدادات الجهاز.',
      );
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 15),
      ),
    );
    return DeviceLocation(
      latitude: position.latitude,
      longitude: position.longitude,
      accuracyMeters: position.accuracy,
    );
  }
}

class DeviceLocation {
  const DeviceLocation({
    required this.latitude,
    required this.longitude,
    required this.accuracyMeters,
  });

  final double latitude;
  final double longitude;
  final double accuracyMeters;
}
