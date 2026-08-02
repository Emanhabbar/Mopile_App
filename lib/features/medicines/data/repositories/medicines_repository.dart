import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../data_sources/medicines_remote_data_source.dart';
import '../models/medicine_models.dart';

final medicinesRepositoryProvider = Provider<MedicinesRepository>(
  (ref) =>
      MedicinesRepository(MedicinesRemoteDataSource(ref.watch(dioProvider))),
);

class MedicinesRepository {
  const MedicinesRepository(this._remote);

  final MedicinesRemoteDataSource _remote;

  Future<MedicinePage> getMedicines({
    String? searchTerm,
    int pageNumber = 1,
    int pageSize = 20,
  }) => _remote.getMedicines(
    searchTerm: searchTerm,
    pageNumber: pageNumber,
    pageSize: pageSize,
  );

  Future<Medicine> getMedicine(String id) => _remote.getMedicine(id);

  Future<Medicine> createMedicine(CreateMedicine request) =>
      _remote.createMedicine(request);
}
