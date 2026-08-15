import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../../core/widgets/app_reveal.dart';
import '../../data/repositories/account_repository.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _saving = false;
  bool _obscureCurrent = true;
  bool _obscureNew = true;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('تغيير كلمة المرور'),
          Text(
            'حافظ على أمان حسابك',
            style: TextStyle(
              color: context.appColors.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 36),
      children: [
        const AppReveal(child: _PasswordHero()),
        const SizedBox(height: 24),
        Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: context.appColors.surface,
              borderRadius: BorderRadius.circular(23),
              border: Border.all(color: context.appColors.border),
            ),
            child: Column(
              children: [
                TextFormField(
                  controller: _currentController,
                  obscureText: _obscureCurrent,
                  cursorColor: context.appColors.primary,
                  cursorWidth: 1.4,
                  style: TextStyle(
                    color: context.appColors.text,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    labelText: 'كلمة المرور الحالية',
                    labelStyle: TextStyle(
                      color: context.appColors.text,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsetsDirectional.only(
                        start: 14,
                        end: 10,
                      ),
                      child: Icon(
                        Icons.lock_outline_rounded,
                        size: 21,
                        color: context.appColors.primary,
                      ),
                    ),
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 46,
                      minHeight: 52,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () =>
                          setState(() => _obscureCurrent = !_obscureCurrent),
                      icon: Icon(
                        _obscureCurrent
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: context.appColors.textMuted,
                        size: 21,
                      ),
                    ),
                    suffixIconConstraints: const BoxConstraints(
                      minWidth: 48,
                      minHeight: 52,
                    ),
                    filled: true,
                    fillColor: context.appColors.surfaceSoft,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 15,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: context.appColors.primary.withValues(alpha: 0.4),
                        width: 1.2,
                      ),
                    ),
                  ),
                  validator: (value) => (value?.isEmpty ?? true)
                      ? 'أدخل كلمة المرور الحالية'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _newController,
                  obscureText: _obscureNew,
                  cursorColor: context.appColors.primary,
                  cursorWidth: 1.4,
                  style: TextStyle(
                    color: context.appColors.text,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    labelText: 'كلمة المرور الجديدة',
                    labelStyle: TextStyle(
                      color: context.appColors.text,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsetsDirectional.only(
                        start: 14,
                        end: 10,
                      ),
                      child: Icon(
                        Icons.password_rounded,
                        size: 21,
                        color: context.appColors.primary,
                      ),
                    ),
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 46,
                      minHeight: 52,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () =>
                          setState(() => _obscureNew = !_obscureNew),
                      icon: Icon(
                        _obscureNew
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: context.appColors.textMuted,
                        size: 21,
                      ),
                    ),
                    suffixIconConstraints: const BoxConstraints(
                      minWidth: 48,
                      minHeight: 52,
                    ),
                    filled: true,
                    fillColor: context.appColors.surfaceSoft,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 15,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: context.appColors.primary.withValues(alpha: 0.4),
                        width: 1.2,
                      ),
                    ),
                  ),
                  validator: (value) {
                    final length = value?.length ?? 0;
                    if (length < 8) return 'يجب ألا تقل عن 8 أحرف';
                    if (length > 128) return 'يجب ألا تتجاوز 128 حرفًا';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _confirmController,
                  obscureText: _obscureNew,
                  cursorColor: context.appColors.primary,
                  cursorWidth: 1.4,
                  style: TextStyle(
                    color: context.appColors.text,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    labelText: 'تأكيد كلمة المرور الجديدة',
                    labelStyle: TextStyle(
                      color: context.appColors.text,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsetsDirectional.only(
                        start: 14,
                        end: 10,
                      ),
                      child: Icon(
                        Icons.verified_user_outlined,
                        size: 21,
                        color: context.appColors.primary,
                      ),
                    ),
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 46,
                      minHeight: 52,
                    ),
                    filled: true,
                    fillColor: context.appColors.surfaceSoft,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 15,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: context.appColors.primary.withValues(alpha: 0.4),
                        width: 1.2,
                      ),
                    ),
                  ),
                  validator: (value) => value != _newController.text
                      ? 'كلمتا المرور غير متطابقتين'
                      : null,
                ),
                const SizedBox(height: 22),
                FilledButton.icon(
                  onPressed: _saving ? null : _submit,
                  icon: _saving
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.check_rounded),
                  label: const Text('تغيير كلمة المرور'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    try {
      await ref
          .read(accountRepositoryProvider)
          .changePassword(
            currentPassword: _currentController.text,
            newPassword: _newController.text,
            confirmNewPassword: _confirmController.text,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تغيير كلمة المرور بنجاح')),
      );
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error is ApiException
                ? error.message
                : 'تعذر تغيير كلمة المرور حاليًا.',
          ),
          backgroundColor: context.appColors.danger,
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

class _PasswordHero extends StatelessWidget {
  const _PasswordHero();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: context.appColors.primaryDeep,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: context.appColors.primary.withValues(alpha: 0.15)),
    ),
    child: const Row(
      children: [
        _PasswordHeroIcon(),
        SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'تحديث كلمة المرور',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'اختر كلمة مختلفة وقوية لا تقل عن 8 أحرف.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _PasswordHeroIcon extends StatelessWidget {
  const _PasswordHeroIcon();
  @override
  Widget build(BuildContext context) => Container(
    width: 52,
    height: 52,
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Icon(
      Icons.lock_reset_rounded,
      color: context.appColors.secondary,
      size: 27,
    ),
  );
}
