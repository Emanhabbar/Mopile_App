import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../data_sources/account_remote_data_source.dart';
import '../models/account_profile.dart';

final accountRepositoryProvider = Provider<AccountRepository>(
  (ref) => AccountRepository(AccountRemoteDataSource(ref.watch(dioProvider))),
);

class AccountRepository {
  const AccountRepository(this.remote);

  final AccountRemoteDataSource remote;

  Future<AccountProfile> getProfile() => remote.getProfile();

  Future<AccountProfile> updateProfile({
    required String fullName,
    String? phoneNumber,
  }) => remote.updateProfile(fullName: fullName, phoneNumber: phoneNumber);

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) => remote.changePassword(
    currentPassword: currentPassword,
    newPassword: newPassword,
    confirmNewPassword: confirmNewPassword,
  );

  Future<AccountProfile> updateAvatar({
    required String filePath,
    required String fileName,
  }) => remote.updateAvatar(filePath: filePath, fileName: fileName);

  Future<AccountProfile> deleteAvatar() => remote.deleteAvatar();
}
