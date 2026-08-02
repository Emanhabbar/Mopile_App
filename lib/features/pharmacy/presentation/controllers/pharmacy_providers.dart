import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/pharmacy_models.dart';
import '../../data/repositories/pharmacy_repository.dart';

final pharmacyDashboardProvider = FutureProvider.autoDispose<PharmacyDashboard>(
  (ref) => ref.watch(pharmacyRepositoryProvider).getDashboard(),
);
final pharmacyProfileProvider = FutureProvider.autoDispose<PharmacyDashboard>(
  (ref) => ref.watch(pharmacyRepositoryProvider).getProfile(),
);
final pharmacyOpenStatusProvider =
    FutureProvider.autoDispose<PharmacyOpenStatus>(
      (ref) => ref.watch(pharmacyRepositoryProvider).getOpenStatus(),
    );
final pharmacyWorkingHoursProvider =
    FutureProvider.autoDispose<List<PharmacyWorkingPeriod>>(
      (ref) => ref.watch(pharmacyRepositoryProvider).getWorkingHours(),
    );

typedef PharmacyInventoryFilter = ({String search, String? stockStatus});
final pharmacyInventoryProvider = FutureProvider.autoDispose
    .family<List<PharmacyInventoryItem>, PharmacyInventoryFilter>(
      (ref, filter) => ref
          .watch(pharmacyRepositoryProvider)
          .getInventory(
            searchTerm: filter.search,
            stockStatus: filter.stockStatus,
          ),
    );
final pharmacyCatalogProvider = FutureProvider.autoDispose
    .family<List<PharmacyCatalogMedicine>, String>(
      (ref, query) =>
          ref.watch(pharmacyRepositoryProvider).searchCatalog(query),
    );

typedef PharmacyRequestFilter = ({String search, String? status});
final pharmacyRequestsProvider = FutureProvider.autoDispose
    .family<List<PharmacyRequest>, PharmacyRequestFilter>(
      (ref, filter) => ref
          .watch(pharmacyRepositoryProvider)
          .getRequests(searchTerm: filter.search, status: filter.status),
    );
final pharmacyRequestDetailsProvider = FutureProvider.autoDispose
    .family<PharmacyRequestDetails, String>(
      (ref, id) => ref.watch(pharmacyRepositoryProvider).getRequest(id),
    );
