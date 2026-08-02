import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/supply_chain_models.dart';
import '../../data/repositories/supply_chain_repository.dart';

final supplyDashboardProvider = FutureProvider.autoDispose<SupplyDashboard>(
  (ref) => ref.watch(supplyChainRepositoryProvider).dashboard(),
);
final supplyBatchesProvider = FutureProvider.autoDispose<List<MedicineBatch>>(
  (ref) => ref.watch(supplyChainRepositoryProvider).batches(),
);
final supplyMarketplaceProvider =
    FutureProvider.autoDispose<List<WarehouseMarketplace>>(
      (ref) => ref.watch(supplyChainRepositoryProvider).marketplace(),
    );
final supplyOrdersProvider = FutureProvider.autoDispose<List<SupplyOrder>>(
  (ref) => ref.watch(supplyChainRepositoryProvider).orders(),
);
final supplyRepresentativesProvider =
    FutureProvider.autoDispose<List<Representative>>(
      (ref) => ref.watch(supplyChainRepositoryProvider).representatives(),
    );
final supplyInvoicesProvider = FutureProvider.autoDispose<List<SupplyInvoice>>(
  (ref) => ref.watch(supplyChainRepositoryProvider).invoices(),
);
final supplyReturnsProvider = FutureProvider.autoDispose<List<SupplyReturn>>(
  (ref) => ref.watch(supplyChainRepositoryProvider).returns(),
);
final supplyRecallsProvider = FutureProvider.autoDispose<List<MedicineRecall>>(
  (ref) => ref.watch(supplyChainRepositoryProvider).recalls(),
);
final supplySuggestionsProvider =
    FutureProvider.autoDispose<List<RestockSuggestion>>(
      (ref) => ref.watch(supplyChainRepositoryProvider).suggestions(),
    );
final supplyCatalogProvider = FutureProvider.autoDispose
    .family<List<WarehouseCatalogItem>, String>(
      (ref, id) => ref.watch(supplyChainRepositoryProvider).catalog(id),
    );
