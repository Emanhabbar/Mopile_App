import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../data_sources/organization_remote_data_source.dart';

final organizationRepositoryProvider = Provider<OrganizationRemoteDataSource>(
  (ref) => OrganizationRemoteDataSource(ref.watch(dioProvider)),
);
