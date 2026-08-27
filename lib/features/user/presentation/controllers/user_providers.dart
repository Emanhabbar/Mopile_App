import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/user_discovery_models.dart';
import '../../data/models/user_models.dart';
import '../../data/models/user_request_models.dart';
import '../../data/repositories/user_repository.dart';

final userDashboardProvider = FutureProvider.autoDispose<UserDashboard>(
  (ref) => ref.watch(userRepositoryProvider).getDashboard(),
);

final userProfileProvider = FutureProvider.autoDispose<UserProfile>(
  (ref) => ref.watch(userRepositoryProvider).getProfile(),
);

final userHealthCardProvider = FutureProvider.autoDispose<UserHealthCard>(
  (ref) => ref.watch(userRepositoryProvider).getHealthCard(),
);

typedef UserDiscoveryParameters = ({int radiusInMeters, String sortBy});

final userLocationDiscoveryProvider = FutureProvider.autoDispose
    .family<UserLocationDiscovery, UserDiscoveryParameters>(
      (ref, parameters) => ref
          .watch(userRepositoryProvider)
          .getLocationContext(
            UserNearbyQuery(
              radiusInMeters: parameters.radiusInMeters,
              take: 20,
              externalTake: 4,
              sortBy: parameters.sortBy,
            ),
          ),
    );

final userNearestRouteProvider = FutureProvider.autoDispose
    .family<UserNearestRoute, int>(
      (ref, radiusInMeters) => ref
          .watch(userRepositoryProvider)
          .getNearestRoute(UserNearbyQuery(radiusInMeters: radiusInMeters)),
    );

final userNearestPharmaciesProvider = FutureProvider.autoDispose
    .family<List<UserPharmacySummary>, UserDiscoveryParameters>(
      (ref, parameters) => ref
          .watch(userRepositoryProvider)
          .getNearestPharmacies(
            UserNearbyQuery(
              radiusInMeters: parameters.radiusInMeters,
              take: 20,
              externalTake: 4,
              sortBy: parameters.sortBy,
            ),
          ),
    );

final userMedicineSearchProvider =
    AsyncNotifierProvider.autoDispose<
      UserMedicineSearchController,
      List<NearbyMedicineResult>
    >(UserMedicineSearchController.new);

final userPharmacyDetailsProvider = FutureProvider.autoDispose
    .family<UserPharmacyDetails, String>(
      (ref, pharmacyId) =>
          ref.watch(userRepositoryProvider).getPharmacyDetails(pharmacyId),
    );

final userMedicineRequestsProvider = FutureProvider.autoDispose
    .family<List<UserMedicineRequest>, String?>(
      (ref, status) =>
          ref.watch(userRepositoryProvider).getMedicineRequests(status: status),
    );

final userMedicineRequestDetailsProvider = FutureProvider.autoDispose
    .family<UserMedicineRequestDetails, String>(
      (ref, requestId) =>
          ref.watch(userRepositoryProvider).getMedicineRequest(requestId),
    );

final userSearchHistoryProvider =
    FutureProvider.autoDispose<List<UserSearchRecord>>(
      (ref) => ref.watch(userRepositoryProvider).getSearchHistory(),
    );

class UserMedicineSearchController
    extends AutoDisposeAsyncNotifier<List<NearbyMedicineResult>> {
  @override
  Future<List<NearbyMedicineResult>> build() async => const [];

  Future<void> search(UserMedicineSearch request) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(userRepositoryProvider).searchMedicines(request),
    );
  }
}

void invalidateUserDiscovery(Ref ref) {
  ref.invalidate(userLocationDiscoveryProvider);
  ref.invalidate(userNearestRouteProvider);
  ref.invalidate(userNearestPharmaciesProvider);
  ref.invalidate(userDashboardProvider);
  ref.invalidate(userProfileProvider);
}

final userMedicalProfileProvider =
    AsyncNotifierProvider.autoDispose<
      UserMedicalProfileController,
      UserMedicalProfile
    >(UserMedicalProfileController.new);

class UserMedicalProfileController
    extends AutoDisposeAsyncNotifier<UserMedicalProfile> {
  @override
  Future<UserMedicalProfile> build() {
    return ref.watch(userRepositoryProvider).getMedicalProfile();
  }

  Future<bool> save(UpdateMedicalProfileRequest request) async {
    final previous = state.valueOrNull;
    state = const AsyncLoading<UserMedicalProfile>().copyWithPrevious(state);
    try {
      final updated = await ref
          .read(userRepositoryProvider)
          .updateMedicalProfile(request);
      state = AsyncData(updated);
      ref.invalidate(userHealthCardProvider);
      ref.invalidate(userDashboardProvider);
      ref.invalidate(userProfileProvider);
      return true;
    } catch (error, stackTrace) {
      state = AsyncError<UserMedicalProfile>(error, stackTrace)
          .copyWithPrevious(
            previous == null
                ? const AsyncLoading<UserMedicalProfile>()
                : AsyncData(previous),
          );
      return false;
    }
  }
}
