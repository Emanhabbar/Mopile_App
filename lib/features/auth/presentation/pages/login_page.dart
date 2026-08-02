import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/locale_controller.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../../core/widgets/app_reveal.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref
        .read(authControllerProvider.notifier)
        .login(
          email: _emailController.text,
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final locale = ref.watch(localeControllerProvider);
    final isArabic = locale.languageCode == 'ar';
    final error = authState.hasError
        ? authState.error is ApiException
              ? (authState.error! as ApiException).message
              : isArabic
              ? 'تعذر تسجيل الدخول. حاول مجددًا.'
              : 'Unable to sign in. Please try again.'
        : null;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Stack(
              children: [
                const Positioned.fill(child: _PageBackground()),
                Column(
                  children: [
                    const SizedBox(height: 266),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 470),
                          child: AppReveal(
                            delay: const Duration(milliseconds: 90),
                            child: _LoginCard(
                              formKey: _formKey,
                              emailController: _emailController,
                              passwordController: _passwordController,
                              obscurePassword: _obscurePassword,
                              isArabic: isArabic,
                              isLoading: authState.isLoading,
                              error: error,
                              onTogglePassword: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                              onSubmit: _submit,
                              onForgotPassword: () =>
                                  context.push('/forgot-password'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 17),
                    _CreateAccountPrompt(
                      isArabic: isArabic,
                      disabled: authState.isLoading,
                      onPressed: () {
                        ref.read(authControllerProvider.notifier).clearError();
                        context.go('/register');
                      },
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 26),
                      child: Text(
                        isArabic
                            ? 'دواؤك واحتياجاتك الصحية في مكان واحد.'
                            : 'Your medicine and health needs, all in one place.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
                PositionedDirectional(
                  top: 0,
                  start: 0,
                  end: 0,
                  child: _LoginHero(
                    isArabic: isArabic,
                    onToggleLanguage: () =>
                        ref.read(localeControllerProvider.notifier).toggle(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginHero extends StatelessWidget {
  const _LoginHero({required this.isArabic, required this.onToggleLanguage});

  final bool isArabic;
  final VoidCallback onToggleLanguage;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;
    return SizedBox(
      height: 326,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: ClipPath(
              clipper: const _OrganicHeaderClipper(),
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [AppColors.primaryDeep, AppColors.primaryDark],
                  ),
                ),
              ),
            ),
          ),
          PositionedDirectional(
            top: -48,
            end: -36,
            child: _GlowCircle(
              size: 190,
              color: AppColors.primary.withValues(alpha: 0.5),
            ),
          ),
          PositionedDirectional(
            bottom: 8,
            start: -72,
            child: _GlowCircle(
              size: 168,
              color: AppColors.primaryLight.withValues(alpha: 0.08),
            ),
          ),
          PositionedDirectional(
            top: topPadding + 10,
            end: 18,
            child: TextButton.icon(
              onPressed: onToggleLanguage,
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.white.withValues(alpha: 0.1),
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 9,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
                ),
              ),
              icon: const Icon(Icons.language_rounded, size: 18),
              label: Text(isArabic ? 'English' : 'العربية'),
            ),
          ),
          PositionedDirectional(
            top: topPadding + 62,
            start: 24,
            end: 24,
            child: AppReveal(
              child: Column(
                children: [
                  Container(
                    width: 82,
                    height: 82,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [AppColors.primary, AppColors.primaryDeep],
                      ),
                      borderRadius: BorderRadius.circular(27),
                      border: Border.all(color: AppColors.secondary, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      'assets/brand/dawaai-icon-foreground.png',
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                      cacheWidth: 180,
                    ),
                  ),
                  const SizedBox(height: 13),
                  Text(
                    'دوائي',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    isArabic
                        ? 'رعاية دوائية أقرب إليك'
                        : 'Medicine care, closer to you',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.72),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginCard extends StatelessWidget {
  const _LoginCard({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.isArabic,
    required this.isLoading,
    required this.onTogglePassword,
    required this.onSubmit,
    required this.onForgotPassword,
    this.error,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final bool isArabic;
  final bool isLoading;
  final String? error;
  final VoidCallback onTogglePassword;
  final VoidCallback onSubmit;
  final VoidCallback onForgotPassword;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 25, 22, 22),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.12),
            blurRadius: 38,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: AutofillGroup(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                isArabic ? 'مرحبًا بعودتك' : 'Welcome back',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(fontSize: 25),
              ),
              const SizedBox(height: 7),
              Text(
                isArabic
                    ? 'سجّل دخولك للوصول إلى خدماتك ومتابعة احتياجاتك.'
                    : 'Sign in to access your services and keep track of your needs.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              AppTextField(
                label: isArabic ? 'البريد الإلكتروني' : 'Email address',
                hint: 'name@example.com',
                controller: emailController,
                icon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                validator: (value) {
                  final email = value?.trim() ?? '';
                  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
                    return isArabic
                        ? 'أدخل بريدًا إلكترونيًا صحيحًا.'
                        : 'Enter a valid email address.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 17),
              AppTextField(
                label: isArabic ? 'كلمة المرور' : 'Password',
                controller: passwordController,
                icon: Icons.lock_outline_rounded,
                obscureText: obscurePassword,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                onSubmitted: (_) => onSubmit(),
                suffixIcon: IconButton(
                  onPressed: onTogglePassword,
                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  tooltip: isArabic
                      ? obscurePassword
                            ? 'إظهار كلمة المرور'
                            : 'إخفاء كلمة المرور'
                      : obscurePassword
                      ? 'Show password'
                      : 'Hide password',
                ),
                validator: (value) {
                  if ((value ?? '').isEmpty) {
                    return isArabic
                        ? 'أدخل كلمة المرور.'
                        : 'Enter your password.';
                  }
                  return null;
                },
              ),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  onPressed: isLoading ? null : onForgotPassword,
                  child: Text(
                    isArabic ? 'نسيت كلمة المرور؟' : 'Forgot password?',
                  ),
                ),
              ),
              if (error != null) ...[
                const SizedBox(height: 15),
                _LoginError(message: error!),
              ],
              const SizedBox(height: 23),
              FilledButton.icon(
                onPressed: isLoading ? null : onSubmit,
                icon: isLoading
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.4,
                        ),
                      )
                    : const Icon(Icons.login_rounded),
                label: Text(
                  isLoading
                      ? isArabic
                            ? 'جاري الدخول...'
                            : 'Signing in...'
                      : isArabic
                      ? 'تسجيل الدخول'
                      : 'Sign in',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreateAccountPrompt extends StatelessWidget {
  const _CreateAccountPrompt({
    required this.isArabic,
    required this.disabled,
    required this.onPressed,
  });

  final bool isArabic;
  final bool disabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 2,
      children: [
        Text(
          isArabic ? 'ليس لديك حساب؟' : 'New to Dawaai?',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        TextButton(
          onPressed: disabled ? null : onPressed,
          child: Text(isArabic ? 'إنشاء حساب جديد' : 'Create account'),
        ),
      ],
    );
  }
}

class _LoginError extends StatelessWidget {
  const _LoginError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.danger.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.danger.withValues(alpha: 0.14)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.danger,
            size: 20,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.danger,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageBackground extends StatelessWidget {
  const _PageBackground();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: AppColors.background),
      child: Stack(
        children: [
          PositionedDirectional(
            bottom: 55,
            start: -75,
            child: _GlowCircle(
              size: 175,
              color: AppColors.primaryLight.withValues(alpha: 0.1),
            ),
          ),
          PositionedDirectional(
            bottom: -50,
            end: -60,
            child: _GlowCircle(
              size: 155,
              color: AppColors.secondary.withValues(alpha: 0.11),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  const _GlowCircle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color),
  );
}

class _OrganicHeaderClipper extends CustomClipper<Path> {
  const _OrganicHeaderClipper();

  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(0, size.height - 42)
      ..cubicTo(
        size.width * 0.18,
        size.height - 6,
        size.width * 0.34,
        size.height - 76,
        size.width * 0.56,
        size.height - 48,
      )
      ..cubicTo(
        size.width * 0.78,
        size.height - 20,
        size.width * 0.87,
        size.height - 3,
        size.width,
        size.height - 34,
      )
      ..lineTo(size.width, 0)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
