import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/repositories/auth_repository.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _emailKey = GlobalKey<FormState>();
  final _resetKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _token = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  var _step = 0;
  var _loading = false;
  var _hidePassword = true;
  String? _message;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _token.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  Future<void> _requestCode() async {
    FocusScope.of(context).unfocus();
    if (!(_emailKey.currentState?.validate() ?? false)) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await ref
          .read(authRepositoryProvider)
          .requestPasswordReset(_email.text);
      if (!mounted) return;
      if ((result.developmentToken ?? '').isNotEmpty) {
        _token.text = result.developmentToken!;
      }
      setState(() {
        _message = result.message.isEmpty ? null : result.message;
        _step = 1;
      });
    } catch (error) {
      if (mounted) setState(() => _error = _errorText(error));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _resetPassword() async {
    FocusScope.of(context).unfocus();
    if (!(_resetKey.currentState?.validate() ?? false)) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref
          .read(authRepositoryProvider)
          .resetPassword(
            email: _email.text,
            token: _token.text,
            newPassword: _password.text,
            confirmPassword: _confirmPassword.text,
          );
      if (mounted) setState(() => _step = 2);
    } catch (error) {
      if (mounted) setState(() => _error = _errorText(error));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _errorText(Object error) => error is ApiException
      ? error.localize(AppLocalizations.of(context))
      : AppLocalizations.of(context).forgotOperationFailed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.go('/login'),
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: AppLocalizations.of(context).forgotBack,
        ),
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 320),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween(
                      begin: const Offset(0.04, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                ),
                child: switch (_step) {
                  0 => _emailStep(),
                  1 => _resetStep(),
                  _ => _successStep(),
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _header({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Column(
      children: [
        Container(
          width: 78,
          height: 78,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [context.appColors.primary, context.appColors.primaryDark],
            ),
            borderRadius: BorderRadius.circular(26),
          ),
          child: Icon(icon, color: context.appColors.secondary, size: 35),
        ),
        const SizedBox(height: 20),
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 7),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _emailStep() {
    final l10n = AppLocalizations.of(context);
    return Column(
    key: const ValueKey('email'),
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _header(
        icon: Icons.lock_reset_rounded,
        title: l10n.forgotTitle,
        subtitle: l10n.forgotSubtitle,
      ),
      const SizedBox(height: 30),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _emailKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  label: l10n.forgotEmailLabel,
                  hint: 'name@example.com',
                  controller: _email,
                  icon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _requestCode(),
                  validator: _validateEmail,
                ),
                if (_error != null) _errorBox(),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: _loading ? null : _requestCode,
                  icon: _loading
                      ? _progress()
                      : const Icon(Icons.arrow_forward_rounded),
                  label: Text(_loading ? l10n.forgotVerifying : l10n.forgotContinue),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
  }

  Widget _resetStep() {
    final l10n = AppLocalizations.of(context);
    return Column(
    key: const ValueKey('reset'),
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _header(
        icon: Icons.mark_email_read_outlined,
        title: l10n.forgotSetNewTitle,
        subtitle: _message ?? l10n.forgotResetSubtitle,
      ),
      const SizedBox(height: 24),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _resetKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  label: l10n.forgotTokenLabel,
                  controller: _token,
                  icon: Icons.key_rounded,
                  textInputAction: TextInputAction.next,
                  validator: (value) => (value ?? '').trim().isEmpty
                      ? l10n.forgotTokenRequired
                      : null,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: l10n.forgotNewPasswordLabel,
                  controller: _password,
                  icon: Icons.lock_outline_rounded,
                  obscureText: _hidePassword,
                  textInputAction: TextInputAction.next,
                  suffixIcon: IconButton(
                    onPressed: () =>
                        setState(() => _hidePassword = !_hidePassword),
                    icon: Icon(
                      _hidePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                  validator: _validatePassword,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: l10n.forgotConfirmPasswordLabel,
                  controller: _confirmPassword,
                  icon: Icons.verified_user_outlined,
                  obscureText: _hidePassword,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _resetPassword(),
                  validator: (value) => value != _password.text
                      ? l10n.forgotPasswordsMismatch
                      : null,
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.forgotPasswordHint,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (_error != null) _errorBox(),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: _loading ? null : _resetPassword,
                  icon: _loading
                      ? _progress()
                      : const Icon(Icons.check_rounded),
                  label: Text(_loading ? l10n.forgotSaving : l10n.forgotSavePassword),
                ),
                TextButton(
                  onPressed: _loading ? null : _requestCode,
                  child: Text(l10n.forgotSendNewCode),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
  }

  Widget _successStep() {
    final l10n = AppLocalizations.of(context);
    return Column(
    key: const ValueKey('success'),
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _header(
        icon: Icons.check_circle_outline_rounded,
        title: l10n.forgotSuccessTitle,
        subtitle: l10n.forgotSuccessSubtitle,
      ),
      const SizedBox(height: 30),
      FilledButton.icon(
        onPressed: () => context.go('/login'),
        icon: const Icon(Icons.login_rounded),
        label: Text(l10n.forgotBackToLogin),
      ),
    ],
  );
  }

  Widget _errorBox() => Padding(
    padding: const EdgeInsets.only(top: 14),
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.appColors.danger.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(_error!, style: TextStyle(color: context.appColors.danger)),
    ),
  );

  Widget _progress() => const SizedBox.square(
    dimension: 19,
    child: CircularProgressIndicator(strokeWidth: 2.2, color: Colors.white),
  );

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)
        ? null
        : AppLocalizations.of(context).forgotEmailInvalid;
  }

  String? _validatePassword(String? value) {
    final password = value ?? '';
    if (password.length < 8 ||
        !RegExp('[A-Z]').hasMatch(password) ||
        !RegExp('[a-z]').hasMatch(password) ||
        !RegExp('[0-9]').hasMatch(password) ||
        !RegExp(r'[^A-Za-z0-9]').hasMatch(password)) {
      return AppLocalizations.of(context).forgotPasswordRequirements;
    }
    return null;
  }
}
