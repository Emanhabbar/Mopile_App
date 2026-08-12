import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/errors/api_exception.dart';
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

  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  static const Color _primary = Color(0xFF076A73);
  static const Color _background = Color(0xFFF4F9F9);
  static const Color _surface = Color(0xFFFFFFFF);
  static const Color _fieldBackground = Color(0xFFFFFFFF);
  static const Color _border = Color(0xFFD4E2E4);
  static const Color _textPrimary = Color(0xFF153F45);
  static const Color _textSecondary = Color(0xFF7C9397);

  static const String _logoPath =
      'assets/brand/dawaai-icon-foreground.png';

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.025),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();

    _emailController.dispose();
    _passwordController.dispose();

    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();

    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    await ref.read(authControllerProvider.notifier).login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final keyboardVisible = MediaQuery.viewInsetsOf(context).bottom > 0;

    final String? error = authState.hasError
        ? authState.error is ApiException
            ? (authState.error! as ApiException).message
            : 'تعذر تسجيل الدخول. تحقق من البيانات وحاول مجددًا.'
        : null;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Theme(
        data: Theme.of(context),
        child: Scaffold(
        backgroundColor: _background,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            children: [
              _LoginHeader(
                imagePath: _logoPath,
                onBack: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/');
                  }
                },
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(
                        14,
                        keyboardVisible ? 16 : 28,
                        14,
                        keyboardVisible ? 22 : 28,
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight - 56,
                        ),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 520),
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: SlideTransition(
                                position: _slideAnimation,
                                child: Form(
                                  key: _formKey,
                                  child: AutofillGroup(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        const SizedBox(height: 24),
                                        _LoginFormCard(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        _FieldLabel(
                                          text: 'البريد الإلكتروني',
                                        ),
                                        const SizedBox(height: 10),
                                        _LoginTextField(
                                          controller: _emailController,
                                          focusNode: _emailFocusNode,
                                          hintText: 'name@example.com',
                                          leadingIcon:
                                              Icons.mail_outline_rounded,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          textInputAction:
                                              TextInputAction.next,
                                          autofillHints: const [
                                            AutofillHints.email,
                                          ],
                                          onSubmitted: (_) {
                                            _passwordFocusNode.requestFocus();
                                          },
                                          validator: (value) {
                                            final email =
                                                value?.trim() ?? '';

                                            final isValidEmail = RegExp(
                                              r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                                            ).hasMatch(email);

                                            if (!isValidEmail) {
                                              return 'أدخل بريدًا إلكترونيًا صحيحًا.';
                                            }

                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 16),
                                        _FieldLabel(
                                          text: 'كلمة المرور',
                                        ),
                                        const SizedBox(height: 10),
                                        _LoginTextField(
                                          controller: _passwordController,
                                          focusNode: _passwordFocusNode,
                                          hintText: '••••••••',
                                          leadingIcon:
                                              Icons.lock_outline_rounded,
                                          obscureText: _obscurePassword,
                                          textInputAction:
                                              TextInputAction.done,
                                          autofillHints: const [
                                            AutofillHints.password,
                                          ],
                                          onSubmitted: (_) => _submit(),
                                          trailing: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _obscurePassword =
                                                    !_obscurePassword;
                                              });
                                            },
                                            icon: Icon(
                                              _obscurePassword
                                                  ? Icons.visibility_outlined
                                                  : Icons
                                                      .visibility_off_outlined,
                                              color: _textSecondary,
                                              size: 25,
                                            ),
                                            tooltip: _obscurePassword
                                                ? 'إظهار كلمة المرور'
                                                : 'إخفاء كلمة المرور',
                                          ),
                                          validator: (value) {
                                            if ((value ?? '').isEmpty) {
                                              return 'أدخل كلمة المرور.';
                                            }

                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 3),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: TextButton(
                                            onPressed: authState.isLoading
                                                ? null
                                                : () {
                                                    context.push(
                                                      '/forgot-password',
                                                    );
                                                  },
                                            style: TextButton.styleFrom(
                                              foregroundColor: _primary,
                                              minimumSize: Size.zero,
                                              tapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 2,
                                                vertical: 13,
                                              ),
                                              textStyle: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                            child: Text(
                                              'نسيت كلمة المرور؟',
                                            ),
                                          ),
                                        ),
                                        if (error != null) ...[
                                          const SizedBox(height: 11),
                                          _ErrorMessage(message: error),
                                        ],
                                        const SizedBox(height: 20),
                                        _LoginButton(
                                                                    isLoading: authState.isLoading,
                                          onPressed: _submit,
                                        ),

                                        const SizedBox(height: 14),

                                        Divider(
                                          height: 1,
                                          thickness: 0.8,
                                          color: _border.withValues(alpha: 0.75),
                                        ),

                                        const SizedBox(height: 18),

                                        _CreateAccountSection(
                                                                    disabled: authState.isLoading,
                                          onPressed: () {
                                            ref
                                                .read(
                                                  authControllerProvider
                                                      .notifier,
                                                )
                                                .clearError();

                                            context.go('/register');
                                          },
                                        ),

                                        const SizedBox(height: 14),

                                        const _TermsText(),
                                      ],
                                    ),
                                  ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
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

class _LoginHeader extends StatelessWidget {
  const _LoginHeader({
    required this.imagePath,
    required this.onBack,
  });

  final String imagePath;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(
        minHeight: 95,
      ),
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
      decoration: BoxDecoration(
        color: _LoginPageState._surface,
        border: Border(
          bottom: BorderSide(
            color: _LoginPageState._border.withValues(alpha: 0.75),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: _LoginPageState._primary.withValues(alpha: 0.035),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            right: 0,
            child: Material(
              color: _LoginPageState._background,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                onTap: onBack,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _LoginPageState._border,
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: _LoginPageState._textPrimary,
                    size: 25,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            child: SizedBox(
              width: 60,
              height: 48,
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
                errorBuilder: (_, _, _) {
                  return const Icon(
                    Icons.local_pharmacy_rounded,
                    color: _LoginPageState._primary,
                    size: 42,
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 64),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'تسجيل الدخول',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _LoginPageState._textPrimary,
                    fontSize: 24,
                    height: 1.2,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 7),
                const Text(
                  'أدخل بيانات حسابك للوصول إلى خدماتك.',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _LoginPageState._textSecondary,
                    fontSize: 12,
                    height: 1.45,
                    fontWeight: FontWeight.w500,
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

class _LoginFormCard extends StatelessWidget {
  const _LoginFormCard({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: child,
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.start,
      style: const TextStyle(
        color: _LoginPageState._textPrimary,
        fontSize: 14,
        height: 1.3,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _LoginTextField extends StatelessWidget {
  const _LoginTextField({
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.leadingIcon,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.obscureText = false,
    this.trailing,
    this.validator,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final IconData leadingIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final bool obscureText;
  final Widget? trailing;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      obscureText: obscureText,
      validator: validator,
      onFieldSubmitted: onSubmitted,
      cursorColor: _LoginPageState._primary,
      cursorWidth: 1.4,
      style: const TextStyle(
        color: _LoginPageState._textPrimary,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: _LoginPageState._textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Icon(
          leadingIcon,
          color: _LoginPageState._primary.withValues(alpha: 0.82),
          size: 25,
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 58,
          minHeight: 62,
        ),
        suffixIcon: trailing,
        suffixIconConstraints: const BoxConstraints(
          minWidth: 58,
          minHeight: 62,
        ),
        filled: true,
        fillColor: _LoginPageState._fieldBackground,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        errorStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: BorderSide(
            color: _LoginPageState._border.withValues(alpha: 0.78),
            width: 0.9,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: BorderSide(
            color: _LoginPageState._primary.withValues(alpha: 0.34),
            width: 1.05,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: BorderSide(
            color: context.appColors.danger.withValues(alpha: 0.55),
            width: 0.95,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: BorderSide(
            color: context.appColors.danger.withValues(alpha: 0.68),
            width: 1.1,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: BorderSide(
            color: _LoginPageState._border.withValues(alpha: 0.45),
            width: 0.8,
          ),
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({
    required this.isLoading,
    required this.onPressed,
  });

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: _LoginPageState._primary,
          disabledBackgroundColor:
              _LoginPageState._primary.withValues(alpha: 0.55),
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: isLoading
              ? const SizedBox.square(
                  key: ValueKey('loading'),
                  dimension: 23,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              : SizedBox(
                  key: const ValueKey('content'),
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        'تسجيل الدخول',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
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

class _CreateAccountSection extends StatelessWidget {
  const _CreateAccountSection({
    required this.disabled,
    required this.onPressed,
  });

  final bool disabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 4,
      runSpacing: 4,
      children: [
        Text(
          'ليس لديك حساب بعد؟',
          style: const TextStyle(
            color: _LoginPageState._textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        TextButton(
          onPressed: disabled ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: _LoginPageState._primary,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            overlayColor: _LoginPageState._primary.withValues(alpha: 0.06),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 4,
            ),
          ),
          child: Text(
            'إنشاء حساب',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class _TermsText extends StatelessWidget {
  const _TermsText();

  @override
  Widget build(BuildContext context) {
    return const Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'بالمتابعة، أنت توافق على ',
          ),
          TextSpan(
            text: 'شروط الاستخدام',
            style: TextStyle(
              color: _LoginPageState._primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          TextSpan(text: ' و'),
          TextSpan(
            text: 'سياسة الخصوصية',
            style: TextStyle(
              color: _LoginPageState._primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          TextSpan(text: '.'),
        ],
      ),
      textAlign: TextAlign.center,
      style: TextStyle(
        color: _LoginPageState._textSecondary,
        fontSize: 11.5,
        height: 1.65,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage({
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.appColors.danger.withValues(alpha: 0.055),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: context.appColors.danger.withValues(alpha: 0.13),
          width: 0.9,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: context.appColors.danger.withValues(alpha: 0.88),
            size: 23,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: context.appColors.danger.withValues(alpha: 0.92),
                fontSize: 13,
                height: 1.45,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}