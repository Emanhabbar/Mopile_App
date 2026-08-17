import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../controllers/auth_controller.dart';

class RegistrationSuccessPage extends ConsumerWidget {
  const RegistrationSuccessPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).valueOrNull?.user;
    final colors = context.appColors;
    final l10n = AppLocalizations.of(context);

    final rawName = user?.fullName;
    final firstName = rawName != null && rawName.trim().isNotEmpty
        ? rawName.trim().split(RegExp(r'\s+')).first
        : null;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: colors.background,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ── Check icon ──
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.primary.withValues(alpha: 0.1),
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        color: colors.primary,
                        size: 44,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── Welcome name ──
                    if (firstName != null && firstName.isNotEmpty) ...[
                      Text(
                        l10n.welcomeName(firstName),
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(
                              color: colors.textMuted,
                              fontSize: 15,
                            ),
                      ),
                      const SizedBox(height: 6),
                    ],

                    // ── Title ──
                    Text(
                      l10n.accountCreatedTitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                            color: colors.text,
                            fontSize: 26,
                          ),
                    ),

                    const SizedBox(height: 32),

                    // ── Button ──
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton(
                        onPressed: () {
                          ref
                              .read(
                                registrationCompletedProvider.notifier,
                              )
                              .state = false;
                          context.go('/home');
                        },
                        child: Text(
                          l10n.goToHome,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
