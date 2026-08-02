import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/admin_models.dart';
import '../../data/repositories/admin_repository.dart';

final adminDashboardProvider = FutureProvider.autoDispose<AdminDashboard>(
  (ref) => ref.watch(adminRepositoryProvider).getDashboard(),
);
final adminPendingPharmaciesProvider =
    FutureProvider.autoDispose<List<AdminPharmacy>>(
      (ref) => ref.watch(adminRepositoryProvider).getPendingPharmacies(),
    );
final adminPendingOrganizationsProvider =
    FutureProvider.autoDispose<List<AdminOrganization>>(
      (ref) => ref.watch(adminRepositoryProvider).getPendingOrganizations(),
    );
final adminPendingWarehousesProvider =
    FutureProvider.autoDispose<List<AdminWarehouse>>(
      (ref) => ref.watch(adminRepositoryProvider).getPendingWarehouses(),
    );
final adminAccountsProvider = FutureProvider.autoDispose<List<AdminAccount>>(
  (ref) => ref.watch(adminRepositoryProvider).getAccounts(),
);
final adminTickerProvider = FutureProvider.autoDispose<List<HomeTickerItem>>(
  (ref) => ref.watch(adminRepositoryProvider).getTicker(),
);
