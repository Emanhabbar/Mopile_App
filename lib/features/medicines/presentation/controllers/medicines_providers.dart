import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/medicine_models.dart';
import '../../data/repositories/medicines_repository.dart';

typedef MedicinesQuery = ({String searchTerm, int pageNumber, int pageSize});

final medicinesProvider = FutureProvider.autoDispose
    .family<MedicinePage, MedicinesQuery>(
      (ref, query) => ref
          .watch(medicinesRepositoryProvider)
          .getMedicines(
            searchTerm: query.searchTerm,
            pageNumber: query.pageNumber,
            pageSize: query.pageSize,
          ),
    );

final medicineDetailsProvider = FutureProvider.autoDispose
    .family<Medicine, String>(
      (ref, id) => ref.watch(medicinesRepositoryProvider).getMedicine(id),
    );
