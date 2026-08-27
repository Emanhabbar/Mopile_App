import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/intelligence_models.dart';
import '../../data/repositories/intelligence_repository.dart';

final intelligenceHealthProvider =
    FutureProvider.autoDispose<IntelligenceHealth>(
      (ref) => ref.watch(intelligenceRepositoryProvider).getHealth(),
    );

final medicineAlternativesProvider = FutureProvider.autoDispose
    .family<AlternativeMedicineResult, String>(
      (ref, medicineName) => ref
          .watch(intelligenceRepositoryProvider)
          .getAlternatives(medicineName),
    );
