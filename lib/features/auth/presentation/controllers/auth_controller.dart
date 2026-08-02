import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/auth_session.dart';
import '../../data/models/registration_request.dart';
import '../../data/repositories/auth_repository.dart';

final authControllerProvider =
    AsyncNotifierProvider<AuthController, AuthSession?>(AuthController.new);

final registrationCompletedProvider = StateProvider<bool>((ref) => false);

class AuthController extends AsyncNotifier<AuthSession?> {
  @override
  Future<AuthSession?> build() {
    return ref.watch(authRepositoryProvider).restoreSession();
  }

  Future<bool> login({required String email, required String password}) async {
    ref.read(registrationCompletedProvider.notifier).state = false;
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(authRepositoryProvider)
          .login(email: email, password: password),
    );
    return !state.hasError;
  }

  Future<bool> register(RegistrationRequest request) async {
    ref.read(registrationCompletedProvider.notifier).state = false;
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).register(request),
    );
    final succeeded = !result.hasError;
    if (succeeded) {
      ref.read(registrationCompletedProvider.notifier).state = true;
    }
    state = result;
    return succeeded;
  }

  void clearError() {
    if (state.hasError) state = const AsyncData(null);
  }

  Future<void> updateCurrentUser(AuthUser user) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final updated = current.copyWith(user: user);
    await ref.read(authRepositoryProvider).saveSession(updated);
    state = AsyncData(updated);
  }

  Future<void> logout() async {
    ref.read(registrationCompletedProvider.notifier).state = false;
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncData(null);
  }
}
