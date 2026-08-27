import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/prescription_models.dart';
import '../../data/repositories/prescriptions_repository.dart';

final myPrescriptionsProvider =
    FutureProvider.autoDispose<List<PrescriptionOrder>>(
      (ref) => ref.watch(prescriptionsRepositoryProvider).getMine(),
    );

final prescriptionDetailsProvider = FutureProvider.autoDispose
    .family<PrescriptionOrder, String>(
      (ref, orderId) =>
          ref.watch(prescriptionsRepositoryProvider).getById(orderId),
    );

final pharmacyPrescriptionOrdersProvider =
    FutureProvider.autoDispose<List<PrescriptionOrder>>(
      (ref) => ref.watch(prescriptionsRepositoryProvider).getPharmacyOrders(),
    );
