import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/storage/app_preferences_storage.dart';

class SettingsPreferences {
  const SettingsPreferences({
    this.themeMode = ThemeMode.system,
    this.notificationsEnabled = true,
    this.requestUpdates = true,
    this.healthReminders = true,
    this.campaignUpdates = true,
  });

  final ThemeMode themeMode;
  final bool notificationsEnabled;
  final bool requestUpdates;
  final bool healthReminders;
  final bool campaignUpdates;

  SettingsPreferences copyWith({
    ThemeMode? themeMode,
    bool? notificationsEnabled,
    bool? requestUpdates,
    bool? healthReminders,
    bool? campaignUpdates,
  }) => SettingsPreferences(
    themeMode: themeMode ?? this.themeMode,
    notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    requestUpdates: requestUpdates ?? this.requestUpdates,
    healthReminders: healthReminders ?? this.healthReminders,
    campaignUpdates: campaignUpdates ?? this.campaignUpdates,
  );
}

final settingsControllerProvider =
    StateNotifierProvider<SettingsController, SettingsPreferences>((ref) {
      return SettingsController(ref.watch(appPreferencesStorageProvider));
    });

class SettingsController extends StateNotifier<SettingsPreferences> {
  SettingsController(this._storage) : super(const SettingsPreferences()) {
    _restore();
  }

  final AppPreferencesStorage _storage;

  Future<void> _restore() async {
    final values = await Future.wait([
      _storage.read('theme'),
      _storage.read('notifications'),
      _storage.read('request_updates'),
      _storage.read('health_reminders'),
      _storage.read('campaign_updates'),
    ]);
    if (!mounted) return;
    state = SettingsPreferences(
      themeMode: switch (values[0]) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      },
      notificationsEnabled: values[1] != 'false',
      requestUpdates: values[2] != 'false',
      healthReminders: values[3] != 'false',
      campaignUpdates: values[4] != 'false',
    );
  }

  Future<void> setThemeMode(ThemeMode value) async {
    state = state.copyWith(themeMode: value);
    await _storage.write('theme', value.name);
  }

  Future<void> setNotificationsEnabled(bool value) async {
    state = state.copyWith(notificationsEnabled: value);
    await _storage.write('notifications', '$value');
  }

  Future<void> setRequestUpdates(bool value) async {
    state = state.copyWith(requestUpdates: value);
    await _storage.write('request_updates', '$value');
  }

  Future<void> setHealthReminders(bool value) async {
    state = state.copyWith(healthReminders: value);
    await _storage.write('health_reminders', '$value');
  }

  Future<void> setCampaignUpdates(bool value) async {
    state = state.copyWith(campaignUpdates: value);
    await _storage.write('campaign_updates', '$value');
  }
}
