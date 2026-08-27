import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme/app_colors.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.label,
    required this.controller,
    this.hint,
    this.hintText,
    this.icon,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
    this.onSubmitted,
    this.autofillHints,
    this.focusNode,
    this.inputFormatters,
    this.maxLines = 1,
    this.minLines,
    this.enabled = true,
    this.readOnly = false,
    this.onChanged,
    this.onTap,
    this.textCapitalization = TextCapitalization.none,
  });

  /// عنوان الحقل فوق الـ TextField.
  ///
  /// أصبح اختياريًا حتى يمكن استخدام AppTextField
  /// بدون عنوان، مثل حقول البحث.
  final String? label;

  final TextEditingController controller;

  /// النص التلميحي داخل الحقل.
  final String? hint;

  /// يدعم أيضًا hintText للتوافق مع الاستخدامات الموجودة
  /// في الصفحات القديمة.
  final String? hintText;

  final IconData? icon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onSubmitted;
  final Iterable<String>? autofillHints;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final int? minLines;
  final bool enabled;
  final bool readOnly;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    // إذا تم تمرير hintText نستخدمه،
    // وإلا نستخدم hint.
    final effectiveHint = hintText ?? hint;

    final textField = TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      maxLines: obscureText ? 1 : maxLines,
      minLines: obscureText ? 1 : minLines,
      inputFormatters: inputFormatters,
      validator: validator,
      onFieldSubmitted: onSubmitted,
      autofillHints: autofillHints,
      enabled: enabled,
      readOnly: readOnly,
      onChanged: onChanged,
      onTap: onTap,
      textCapitalization: textCapitalization,
      cursorColor: colors.primary,
      cursorWidth: 1.4,
      style: TextStyle(
        color: colors.text,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: effectiveHint,
        hintStyle: TextStyle(
          color: colors.textMuted.withValues(alpha: 0.6),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: colors.surfaceSoft,

        prefixIcon: icon != null
            ? Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 14,
                  end: 10,
                ),
                child: Icon(
                  icon,
                  size: 21,
                  color: colors.primary,
                ),
              )
            : null,

        prefixIconConstraints: icon != null
            ? const BoxConstraints(
                minWidth: 46,
                minHeight: 52,
              )
            : null,

        suffixIcon: suffixIcon,

        suffixIconConstraints: const BoxConstraints(
          minWidth: 48,
          minHeight: 52,
        ),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),

        errorStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: colors.danger,
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
            color: colors.primary.withValues(alpha: 0.4),
            width: 1.2,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: colors.danger.withValues(alpha: 0.5),
            width: 1,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: colors.danger.withValues(alpha: 0.7),
            width: 1.2,
          ),
        ),
      ),
    );

    // إذا ما في label، نرجع الحقل مباشرة.
    if (label == null || label!.trim().isEmpty) {
      return textField;
    }

    // إذا في label، نعرضه فوق الحقل.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label!,
          style: TextStyle(
            color: colors.text,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 8),
        textField,
      ],
    );
  }
}