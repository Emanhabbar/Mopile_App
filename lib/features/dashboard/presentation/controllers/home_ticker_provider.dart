import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/home_ticker_item.dart';
import '../../data/repositories/home_ticker_repository.dart';

final homeTickerProvider = FutureProvider.autoDispose<List<HomeTickerItem>>(
  (ref) => ref.watch(homeTickerRepositoryProvider).getPublished(),
);
