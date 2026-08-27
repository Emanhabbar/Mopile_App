import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../data_sources/home_ticker_remote_data_source.dart';
import '../models/home_ticker_item.dart';

final homeTickerRepositoryProvider = Provider<HomeTickerRepository>(
  (ref) =>
      HomeTickerRepository(HomeTickerRemoteDataSource(ref.watch(dioProvider))),
);

class HomeTickerRepository {
  const HomeTickerRepository(this.remote);

  final HomeTickerRemoteDataSource remote;

  Future<List<HomeTickerItem>> getPublished() => remote.getPublished();
}
