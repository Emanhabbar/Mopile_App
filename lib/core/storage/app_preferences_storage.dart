import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final appPreferencesStorageProvider = Provider<AppPreferencesStorage>(
  (ref) => AppPreferencesStorage(),
);

class AppPreferencesStorage {
  AppPreferencesStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  Future<String?> read(String key) => _storage.read(key: 'dawaai_pref_$key');

  Future<void> write(String key, String value) =>
      _storage.write(key: 'dawaai_pref_$key', value: value);
}
