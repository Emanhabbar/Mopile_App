import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../data_sources/supply_chain_remote_data_source.dart';

final supplyChainRepositoryProvider = Provider<SupplyChainRemoteDataSource>(
  (ref) => SupplyChainRemoteDataSource(ref.watch(dioProvider)),
);
