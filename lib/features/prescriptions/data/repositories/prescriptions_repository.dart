import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../data_sources/prescriptions_remote_data_source.dart';
import '../models/prescription_models.dart';

final prescriptionsRepositoryProvider = Provider<PrescriptionsRepository>(
  (ref) => PrescriptionsRepository(
    PrescriptionsRemoteDataSource(ref.watch(dioProvider)),
  ),
);

class PrescriptionsRepository {
  const PrescriptionsRepository(this.remote);

  final PrescriptionsRemoteDataSource remote;

  Future<PrescriptionOrder> analyze({
    required String filePath,
    required String fileName,
  }) => remote.analyze(filePath: filePath, fileName: fileName);

  Future<List<PrescriptionOrder>> getMine() => remote.getMine();
  Future<PrescriptionOrder> getById(String orderId) => remote.getById(orderId);
  Future<PrescriptionOrder> reserve(String orderId, String pharmacyId) =>
      remote.reserve(orderId, pharmacyId);
  Future<PrescriptionOrder> cancel(String orderId) => remote.cancel(orderId);
  Future<PrescriptionOrder> activateReminders(
    String orderId,
    PrescriptionReminderRequest request,
  ) => remote.activateReminders(orderId, request);
  Future<List<PrescriptionOrder>> getPharmacyOrders() =>
      remote.getPharmacyOrders();
  Future<PrescriptionOrder> updatePharmacyStatus(
    String orderId, {
    required String status,
    String? pickupCode,
  }) => remote.updatePharmacyStatus(
    orderId,
    status: status,
    pickupCode: pickupCode,
  );
}
