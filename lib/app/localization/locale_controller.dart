import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/storage/app_preferences_storage.dart';

final localeControllerProvider =
    StateNotifierProvider<LocaleController, Locale>(
      (ref) => LocaleController(ref.watch(appPreferencesStorageProvider)),
    );

class LocaleController extends StateNotifier<Locale> {
  LocaleController(this._storage) : super(const Locale('ar')) {
    _restore();
  }

  final AppPreferencesStorage _storage;

  Future<void> _restore() async {
    final code = await _storage.read('locale');
    if (mounted && (code == 'ar' || code == 'en')) state = Locale(code!);
  }

  Future<void> toggle() async {
    state = state.languageCode == 'ar'
        ? const Locale('en')
        : const Locale('ar');
    await _storage.write('locale', state.languageCode);
  }

  Future<void> setLocale(Locale locale) async {
    if (locale.languageCode == 'ar' || locale.languageCode == 'en') {
      state = locale;
      await _storage.write('locale', state.languageCode);
    }
  }
}
