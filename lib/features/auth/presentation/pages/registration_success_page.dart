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
    final message = switch (role) {
      AppRole.pharmacy =>
        'تم استلام بيانات الصيدلية بنجاح. يمكنك الآن متابعة حسابك واستكمال معلومات الصيدلية.',
      AppRole.organization =>
        'تم استلام بيانات المنظمة بنجاح. يمكنك الآن متابعة الحساب واستكمال بيانات التحقق.',
      _ =>
        'أصبح حسابك جاهزًا. يمكنك الآن الوصول إلى خدمات دوائي ومتابعة احتياجاتك بسهولة.',
    };

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                children: [
                  _SuccessHero(name: user?.fullName),
                  Transform.translate(
                    offset: const Offset(0, -30),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 470),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                          decoration: BoxDecoration(
                            color: context.appColors.surface,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.white),
                            boxShadow: [
                              BoxShadow(
                                color: context.appColors.shadow.withValues(alpha: 0.12),
                                blurRadius: 38,
                                offset: const Offset(0, 17),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'تم إنشاء حسابك',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(fontSize: 26),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                message,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 27),
                              FilledButton.icon(
                                onPressed: () {
                                  ref
                                          .read(
                                            registrationCompletedProvider
                                                .notifier,
                                          )
                                          .state =
                                      false;
                                  context.go('/home');
                                },
                                icon: const Icon(Icons.arrow_back_rounded),
                                label: const Text('الانتقال إلى الرئيسية'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Padding(
                    padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: Text(
                      'أهلًا بك في دوائي',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: context.appColors.textMuted,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SuccessHero extends StatelessWidget {
  const _SuccessHero({this.name});

  final String? name;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 360,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: ClipPath(
              clipper: const _SuccessClipper(),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [context.appColors.primaryDeep, context.appColors.primaryDark],
                  ),
                ),
              ),
            ),
          ),
          PositionedDirectional(
            top: -40,
            end: -32,
            child: Container(
              width: 190,
              height: 190,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.appColors.primary.withValues(alpha: 0.48),
              ),
            ),
          ),
          PositionedDirectional(
            bottom: 8,
            start: -55,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.appColors.primaryLight.withValues(alpha: 0.08),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              24,
              MediaQuery.paddingOf(context).top + 20,
              24,
              55,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 116,
                      height: 116,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.appColors.secondary.withValues(alpha: 0.2),
                      ),
                    ),
                    Container(
                      width: 82,
                      height: 82,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.appColors.secondary,
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        color: context.appColors.primaryDeep,
                        size: 46,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                if (name?.trim().isNotEmpty == true)
                  Text(
                    'مرحبًا ${name!.trim().split(RegExp(r'\s+')).first}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.72),
                      fontSize: 17,
                    ),
                  ),
                const SizedBox(height: 5),
                Text(
                  'بداية موفقة مع دوائي',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontSize: 27,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessClipper extends CustomClipper<Path> {
  const _SuccessClipper();

  @override
  Path getClip(Size size) => Path()
    ..lineTo(0, size.height - 50)
    ..quadraticBezierTo(
      size.width * 0.28,
      size.height,
      size.width * 0.52,
      size.height - 48,
    )
    ..quadraticBezierTo(
      size.width * 0.78,
      size.height - 96,
      size.width,
      size.height - 35,
    )
    ..lineTo(size.width, 0)
    ..close();

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
