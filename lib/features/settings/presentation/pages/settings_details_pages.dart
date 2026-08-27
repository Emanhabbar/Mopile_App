import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../controllers/settings_controller.dart';

class AppearanceSettingsPage extends ConsumerWidget {
  const AppearanceSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(settingsControllerProvider).themeMode;
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsAppearance)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _IntroCard(
            icon: Icons.palette_outlined,
            title: l10n.appearanceIntroTitle,
            subtitle: l10n.appearanceIntroSubtitle,
          ),
          const SizedBox(height: 18),
          Container(
            decoration: BoxDecoration(
              color: context.appColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: context.appColors.border),
            ),
            child: Column(
              children: ThemeMode.values.map((value) {
                final data = switch (value) {
                  ThemeMode.system => (
                    l10n.themeSystem,
                    l10n.themeSystemDesc,
                    Icons.brightness_auto_outlined,
                  ),
                  ThemeMode.light => (
                    l10n.themeLight,
                    l10n.themeLightDesc,
                    Icons.light_mode_outlined,
                  ),
                  ThemeMode.dark => (
                    l10n.themeDark,
                    l10n.themeDarkDesc,
                    Icons.dark_mode_outlined,
                  ),
                };
                final selected = value == mode;
                return ListTile(
                  onTap: () => ref
                      .read(settingsControllerProvider.notifier)
                      .setThemeMode(value),
                  leading: Icon(data.$3, color: context.appColors.primary),
                  title: Text(data.$1),
                  subtitle: Text(data.$2),
                  trailing: Icon(
                    selected
                        ? Icons.check_circle_rounded
                        : Icons.circle_outlined,
                    color: selected ? context.appColors.primary : context.appColors.border,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationPreferencesPage extends ConsumerWidget {
  const NotificationPreferencesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);
    final enabled = preferences.notificationsEnabled;
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsNotifications)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _IntroCard(
            icon: Icons.notifications_active_outlined,
            title: l10n.notifIntroTitle,
            subtitle: l10n.notifIntroSubtitle,
          ),
          const SizedBox(height: 18),
          Container(
            decoration: BoxDecoration(
              color: context.appColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: context.appColors.border),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  value: enabled,
                  onChanged: controller.setNotificationsEnabled,
                  secondary: const Icon(Icons.notifications_outlined),
                  title: Text(l10n.notifInApp),
                  subtitle: Text(l10n.notifInAppDesc),
                ),
                const Divider(height: 1, indent: 20, endIndent: 20),
                SwitchListTile(
                  value: enabled && preferences.requestUpdates,
                  onChanged: enabled ? controller.setRequestUpdates : null,
                  secondary: const Icon(Icons.receipt_long_outlined),
                  title: Text(l10n.notifRequestUpdates),
                  subtitle: Text(l10n.notifRequestUpdatesDesc),
                ),
                const Divider(height: 1, indent: 20, endIndent: 20),
                SwitchListTile(
                  value: enabled && preferences.healthReminders,
                  onChanged: enabled ? controller.setHealthReminders : null,
                  secondary: const Icon(Icons.alarm_outlined),
                  title: Text(l10n.notifHealthReminders),
                  subtitle: Text(l10n.notifHealthRemindersDesc),
                ),
                const Divider(height: 1, indent: 20, endIndent: 20),
                SwitchListTile(
                  value: enabled && preferences.campaignUpdates,
                  onChanged: enabled ? controller.setCampaignUpdates : null,
                  secondary: const Icon(Icons.volunteer_activism_outlined),
                  title: Text(l10n.notifCampaigns),
                  subtitle: Text(l10n.notifCampaignsDesc),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PermissionsSettingsPage extends StatefulWidget {
  const PermissionsSettingsPage({super.key});

  @override
  State<PermissionsSettingsPage> createState() =>
      _PermissionsSettingsPageState();
}

class _PermissionsSettingsPageState extends State<PermissionsSettingsPage> {
  LocationPermission? _locationPermission;
  bool _serviceEnabled = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final values = await Future.wait([
      Geolocator.isLocationServiceEnabled(),
      Geolocator.checkPermission(),
    ]);
    if (!mounted) return;
    setState(() {
      _serviceEnabled = values[0] as bool;
      _locationPermission = values[1] as LocationPermission;
    });
  }

  Future<void> _requestLocation() async {
    await Geolocator.requestPermission();
    await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final granted =
        _locationPermission == LocationPermission.always ||
        _locationPermission == LocationPermission.whileInUse;
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsPermissions)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _IntroCard(
            icon: Icons.admin_panel_settings_outlined,
            title: l10n.permIntroTitle,
            subtitle: l10n.permIntroSubtitle,
          ),
          const SizedBox(height: 18),
          Container(
            decoration: BoxDecoration(
              color: context.appColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: context.appColors.border),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.location_on_outlined),
                  title: Text(l10n.permLocation),
                  subtitle: Text(
                    granted
                        ? _serviceEnabled
                              ? l10n.permLocationAllowed
                              : l10n.permLocationServiceOff
                        : l10n.permLocationNotAllowed,
                  ),
                  trailing: granted
                      ? Icon(Icons.check_circle, color: context.appColors.success)
                      : TextButton(
                          onPressed: _requestLocation,
                          child: Text(l10n.permAllow),
                        ),
                ),
                const Divider(height: 1, indent: 20, endIndent: 20),
                ListTile(
                  leading: const Icon(Icons.camera_alt_outlined),
                  title: Text(l10n.permCameraFiles),
                  subtitle: Text(l10n.permCameraFilesDesc),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (!_serviceEnabled)
            OutlinedButton.icon(
              onPressed: Geolocator.openLocationSettings,
              icon: const Icon(Icons.location_searching_rounded),
              label: Text(l10n.permOpenLocationSettings),
            ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: Geolocator.openAppSettings,
            icon: const Icon(Icons.settings_outlined),
            label: Text(l10n.permOpenAppSettings),
          ),
        ],
      ),
    );
  }
}

enum InformationPageKind { privacy, terms, help, about }

class InformationPage extends StatelessWidget {
  const InformationPage({required this.kind, super.key});

  final InformationPageKind kind;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final data = switch (kind) {
      InformationPageKind.privacy => (
        l10n.settingsPrivacy,
        Icons.shield_outlined,
        <(String, String)>[
          (
            l10n.infoAccountData,
            l10n.infoAccountDataDesc,
          ),
          (
            l10n.infoLocation,
            l10n.infoLocationDesc,
          ),
          (
            l10n.infoHealthData,
            l10n.infoHealthDataDesc,
          ),
          (
            l10n.infoControl,
            l10n.infoControlDesc,
          ),
        ],
      ),
      InformationPageKind.terms => (
        l10n.termsOfUse,
        Icons.description_outlined,
        <(String, String)>[
          (
            l10n.infoInfoAccuracy,
            l10n.infoInfoAccuracyDesc,
          ),
          (
            l10n.infoResponsibleUse,
            l10n.infoResponsibleUseDesc,
          ),
          (
            l10n.infoEmergency,
            l10n.infoEmergencyDesc,
          ),
          (
            l10n.infoAccount,
            l10n.infoAccountDesc,
          ),
        ],
      ),
      InformationPageKind.help => (
        l10n.settingsHelp,
        Icons.help_outline_rounded,
        <(String, String)>[
          (
            l10n.infoMapNotShown,
            l10n.infoMapNotShownDesc,
          ),
          (
            l10n.infoConnectionFailed,
            l10n.infoConnectionFailedDesc,
          ),
          (
            l10n.infoRecoveryCodeMissing,
            l10n.infoRecoveryCodeMissingDesc,
          ),
          (
            l10n.infoAccountIssue,
            l10n.infoAccountIssueDesc,
          ),
        ],
      ),
      InformationPageKind.about => (
        l10n.settingsAbout,
        Icons.info_outline_rounded,
        <(String, String)>[
          (
            l10n.appTitle,
            l10n.infoDawaaiDesc,
          ),
          (
            l10n.infoProjectGoal,
            l10n.infoProjectGoalDesc,
          ),
          (l10n.settingsVersion, '1.0.0'),
          (
            l10n.infoMedicalNotice,
            l10n.infoMedicalNoticeDesc,
          ),
        ],
      ),
    };
    return Scaffold(
      appBar: AppBar(title: Text(data.$1)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _IntroCard(icon: data.$2, title: data.$1, subtitle: data.$3.first.$2),
          const SizedBox(height: 18),
          ...data.$3
              .skip(1)
              .map(
                (section) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.appColors.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: context.appColors.border),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            section.$1,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 6),
                          Text(section.$2),
                        ],
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

class _IntroCard extends StatelessWidget {
  const _IntroCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: context.appColors.surfaceSoft,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: context.appColors.border),
    ),
    child: Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: context.appColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(icon, color: context.appColors.primary),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.appColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
