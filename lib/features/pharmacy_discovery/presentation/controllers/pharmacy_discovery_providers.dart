import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/pharmacy_discovery_models.dart';
import '../../data/repositories/pharmacy_discovery_repository.dart';

final externalPharmacyDetailsProvider = FutureProvider.autoDispose
    .family<ExternalPharmacy, String>(
      (ref, placeId) => ref
          .watch(pharmacyDiscoveryRepositoryProvider)
          .getExternalDetails(placeId),
    );

final pharmacyLocatorHealthProvider =
    FutureProvider.autoDispose<PharmacyLocatorHealth>(
      (ref) => ref.watch(pharmacyDiscoveryRepositoryProvider).getHealth(),
    );
