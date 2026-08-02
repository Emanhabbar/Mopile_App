import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/account_profile.dart';
import '../../data/repositories/account_repository.dart';

final accountProfileProvider = FutureProvider.autoDispose<AccountProfile>(
  (ref) => ref.watch(accountRepositoryProvider).getProfile(),
);
