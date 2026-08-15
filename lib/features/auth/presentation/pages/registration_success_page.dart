import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_roles.dart';
import '../controllers/auth_controller.dart';

class RegistrationSuccessPage extends ConsumerWidget {
  const RegistrationSuccessPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).valueOrNull?.user;
    final role = user?.primaryRole ?? AppRole.user;
    final colors = context.appColors;

    final message = switch (role) {
      AppRole.pharmacy =>
        'تم استلام بيانات الصيدلية بنجاح. يمكنك الآن متابعة حسابك واستكمال معلومات الصيدلية.',
      AppRole.organization =>
        'تم استلام بيانات المنظمة بنجاح. يمكنك الآن متابعة الحساب واستكمال بيانات التحقق.',
      _ =>
        'أصبح حسابك جاهزًا. يمكنك الآن الوصول إلى خدمات دوائي ومتابعة احتياجاتك بسهولة.',
    };

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
                        'مرحبًا $firstName',
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
                      'تم إنشاء حسابك',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                            color: colors.text,
                            fontSize: 26,
                          ),
                    ),

                    // const SizedBox(height: 10),

                    // ── Message ──
                    // Text(
                    //   message,
                    //   textAlign: TextAlign.center,
                    //   style: Theme.of(context)
                    //       .textTheme
                    //       .bodyMedium
                    //       ?.copyWith(
                    //         color: colors.textMuted,
                    //         fontSize: 14,
                    //         height: 1.6,
                    //       ),
                    // ),

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
                        child: const Text(
                          'الانتقال إلى الرئيسية',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    // const SizedBox(height: 16),

                    // // ── Tagline ──
                    // Text(
                    //   'أهلًا بك في دوائي',
                    //   textAlign: TextAlign.center,
                    //   style: TextStyle(
                    //     color: colors.textMuted,
                    //     fontSize: 13,
                    //     fontWeight: FontWeight.w600,
                    //   ),
                    // ),
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
