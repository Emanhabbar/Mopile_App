import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';

import '../../../../core/errors/api_exception.dart';

import '../../../../core/widgets/app_text_field.dart';

import '../widgets/auth_widgets.dart';

import '../controllers/auth_controller.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  bool _obscurePassword = true;

  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  static const String _logoPath = 'assets/brand/newlogo.png';

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) return;

    await ref.read(authControllerProvider.notifier).login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final authState = ref.watch(authControllerProvider);

    final String? error = authState.hasError
        ? authState.error is ApiException
            ? (authState.error! as ApiException).message
            : 'تعذر تسجيل الدخول. تحقق من البيانات وحاول مجددًا.'
        : null;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: colors.background,
        body: SafeArea(
          child: Column(
            children: [
              _TopBar(
                onBack: () {
                  if (context.canPop()) context.pop();
                },
              ),
              Expanded(
                child: Center(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: Form(
                          key: _formKey,
                          child: AutofillGroup(
                            child: _buildForm(
                              authState: authState,
                              error: error,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm({
    required AsyncValue authState,
    required String? error,
  }) {
    final colors = context.appColors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Logo ──
        Center(
          child: Image.asset(
            _logoPath,
            width: 64,
            height: 64,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
            errorBuilder: (_, _, _) => Icon(
              Icons.local_pharmacy_rounded,
              color: colors.primary,
              size: 56,
            ),
          ),
        ),

        const SizedBox(height: 24),

        // ── Title ──
        Text(
          'تسجيل الدخول',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: colors.text,
                fontSize: 26,
              ),
        ),

        const SizedBox(height: 8),

        // ── Subtitle ──
        Text(
          'أدخل بيانات حسابك للوصول إلى خدماتك.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colors.textMuted,
                fontSize: 14,
              ),
        ),

        const SizedBox(height: 32),

        // ── Email ──
        AppTextField(
          label: 'البريد الإلكتروني',
          hint: 'name@example.com',
          controller: _emailController,
          focusNode: _emailFocusNode,
          icon: Icons.mail_outline_rounded,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.email],
          onSubmitted: (_) => _passwordFocusNode.requestFocus(),
          validator: (value) {
            final email = value?.trim() ?? '';
            final isValid = RegExp(
              r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
            ).hasMatch(email);
            if (!isValid) return 'أدخل بريدًا إلكترونيًا صحيحًا.';
            return null;
          },
        ),

        const SizedBox(height: 16),

        // ── Password ──
        AppTextField(
          label: 'كلمة المرور',
          hint: '••••••••',
          controller: _passwordController,
          focusNode: _passwordFocusNode,
          icon: Icons.lock_outline_rounded,
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.password],
          onSubmitted: (_) => _submit(),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() => _obscurePassword = !_obscurePassword);
            },
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: colors.textMuted,
              size: 20,
            ),
            tooltip: _obscurePassword
                ? 'إظهار كلمة المرور'
                : 'إخفاء كلمة المرور',
          ),
          validator: (value) {
            if ((value ?? '').isEmpty) return 'أدخل كلمة المرور.';
            return null;
          },
        ),

        // ── Forgot password ──
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: authState.isLoading
                ? null
                : () => context.push('/forgot-password'),
            style: TextButton.styleFrom(
              foregroundColor: colors.primary,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: const EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 12,
              ),
            ),
            child: const Text(
              'نسيت كلمة المرور؟',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        // ── Error ──
        if (error != null) ...[
          const SizedBox(height: 4),
          ErrorBanner(message: error),
        ],

        const SizedBox(height: 8),

        // ── Login button ──
        SizedBox(
          height: 52,
          child: FilledButton(
            onPressed: authState.isLoading ? null : _submit,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: authState.isLoading
                  ? const SizedBox(
                      key: ValueKey('loading'),
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'تسجيل الدخول',
                      key: ValueKey('text'),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // ── Divider ──
        const AuthDivider(text: 'أو'),

        const SizedBox(height: 24),

        // ── Create account ──
        AuthFooter(
          onCreateAccount: () {
            ref.read(authControllerProvider.notifier).clearError();
            context.go('/register');
          },
          isLoading: authState.isLoading,
        ),

        const SizedBox(height: 20),

        // ── Terms ──
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: 'بالمتابعة، أنت توافق على '),
              TextSpan(
                text: 'شروط الاستخدام',
                style: TextStyle(
                  color: colors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const TextSpan(text: ' و'),
              TextSpan(
                text: 'سياسة الخصوصية',
                style: TextStyle(
                  color: colors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const TextSpan(text: '.'),
            ],
          ),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: colors.textMuted,
            fontSize: 12,
            height: 1.6,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: IconButton(
          onPressed: onBack,
          icon: Icon(
            Icons.arrow_back_rounded,
            color: colors.text,
            size: 24,
          ),
        ),
      ),
    );
  }
}
