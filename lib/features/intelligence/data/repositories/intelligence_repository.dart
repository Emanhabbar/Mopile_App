import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../data_sources/intelligence_remote_data_source.dart';

final intelligenceRepositoryProvider = Provider<IntelligenceRemoteDataSource>(
  (ref) => IntelligenceRemoteDataSource(ref.watch(dioProvider)),
);
