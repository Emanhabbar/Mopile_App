import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/storage/app_preferences_storage.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/models/onboarding_item.dart';

const onboardingStorageKey = 'onboarding_completed';

class OnboardingCompletionController extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final storage = ref.read(appPreferencesStorageProvider);
    final value = await storage.read(onboardingStorageKey);
    return value == 'true';
  }

  Future<void> complete() async {
    final storage = ref.read(appPreferencesStorageProvider);
    await storage.write(onboardingStorageKey, 'true');
    state = const AsyncData(true);
  }
}

final onboardingCompletedProvider =
    AsyncNotifierProvider<OnboardingCompletionController, bool>(
      OnboardingCompletionController.new,
    );

List<OnboardingItem> buildOnboardingItems(AppLocalizations l10n) {
  return [
    OnboardingItem(
      title: l10n.onboardingIntroTitle,
      description: l10n.onboardingIntroDesc,
      imagePath: 'assets/onboarding/onboarding_intro.png',
      accentColor: const Color(0xFF216474),
    ),
    OnboardingItem(
      title: l10n.onboardingSearchTitle,
      description: l10n.onboardingSearchDesc,
      imagePath: 'assets/onboarding/onboarding_search.png',
      accentColor: const Color(0xFF1B8A5A),
    ),
    OnboardingItem(
      title: l10n.onboardingPharmaciesTitle,
      description: l10n.onboardingPharmaciesDesc,
      imagePath: 'assets/onboarding/onboarding_pharmacies.png',
      accentColor: const Color(0xFF2B6CB0),
    ),
    OnboardingItem(
      title: l10n.onboardingInventoryTitle,
      description: l10n.onboardingInventoryDesc,
      imagePath: 'assets/onboarding/onboarding_inventory.png',
      accentColor: const Color(0xFFB7791F),
    ),
    OnboardingItem(
      title: l10n.onboardingDonationsTitle,
      description: l10n.onboardingDonationsDesc,
      imagePath: 'assets/onboarding/onboarding_donations.png',
      accentColor: const Color(0xFF6C5CE7),
    ),
  ];
}
