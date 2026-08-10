import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTheme {
  static const String _fontFamily = 'IBM Plex Sans Arabic';
  static const List<String> _fontFallback = [
    'Noto Sans Arabic',
    'Segoe UI',
    'Arial',
    'sans-serif',
  ];

  static ThemeData get light => _buildTheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    primaryDark: AppColors.primaryDark,
    primaryDeep: AppColors.primaryDeep,
    secondary: AppColors.secondary,
    background: AppColors.background,
    surface: AppColors.surface,
    surfaceSoft: AppColors.surfaceSoft,
    text: AppColors.text,
    textMuted: AppColors.textMuted,
    border: AppColors.border,
    danger: AppColors.danger,
    shadow: AppColors.shadow,
  );

  static ThemeData get dark => _buildTheme(
    brightness: Brightness.dark,
    primary: DarkColors.primary,
    primaryDark: DarkColors.primaryDark,
    primaryDeep: DarkColors.primaryDeep,
    secondary: DarkColors.secondary,
    background: DarkColors.background,
    surface: DarkColors.surface,
    surfaceSoft: DarkColors.surfaceSoft,
    text: DarkColors.text,
    textMuted: DarkColors.textMuted,
    border: DarkColors.border,
    danger: DarkColors.danger,
    shadow: DarkColors.shadow,
  );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color primary,
    required Color primaryDark,
    required Color primaryDeep,
    required Color secondary,
    required Color background,
    required Color surface,
    required Color surfaceSoft,
    required Color text,
    required Color textMuted,
    required Color border,
    required Color danger,
    required Color shadow,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: brightness,
      primary: primary,
      secondary: secondary,
      surface: surface,
      error: danger,
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      fontFamily: _fontFamily,
      fontFamilyFallback: _fontFallback,
      textTheme: TextTheme(
        displaySmall: TextStyle(
          color: text,
          fontSize: 34,
          fontWeight: FontWeight.w900,
          height: 1.16,
          letterSpacing: -0.6,
        ),
        headlineSmall: TextStyle(
          color: text,
          fontSize: 24,
          fontWeight: FontWeight.w800,
          height: 1.24,
          letterSpacing: -0.25,
        ),
        titleLarge: TextStyle(
          color: text,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          height: 1.3,
        ),
        titleMedium: TextStyle(
          color: text,
          fontSize: 15.5,
          fontWeight: FontWeight.w700,
          height: 1.35,
        ),
        bodyLarge: TextStyle(color: text, fontSize: 15, height: 1.55),
        bodyMedium: TextStyle(
          color: textMuted,
          fontSize: 13.5,
          height: 1.55,
        ),
        bodySmall: TextStyle(
          color: textMuted,
          fontSize: 12,
          height: 1.45,
        ),
        labelLarge: TextStyle(
          color: text,
          fontSize: 14,
          fontWeight: FontWeight.w800,
        ),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: background,
        foregroundColor: text,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          color: text,
          fontSize: 19,
          fontWeight: FontWeight.w800,
          fontFamily: _fontFamily,
          fontFamilyFallback: _fontFallback,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 1,
        shadowColor: shadow.withValues(alpha: 0.09),
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: border.withValues(alpha: 0.82)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: TextStyle(
          color: textMuted.withValues(alpha: 0.78),
          fontSize: 13.5,
          fontFamily: _fontFamily,
          fontFamilyFallback: _fontFallback,
        ),
        labelStyle: TextStyle(
          color: textMuted,
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          fontFamily: _fontFamily,
          fontFamilyFallback: _fontFallback,
        ),
        floatingLabelStyle: TextStyle(
          color: primary,
          fontWeight: FontWeight.w700,
          fontFamily: _fontFamily,
          fontFamilyFallback: _fontFallback,
        ),
        prefixIconColor: primary,
        suffixIconColor: textMuted,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: BorderSide(color: primary, width: 1.7),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: BorderSide(color: danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: BorderSide(color: danger, width: 1.7),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 54),
          backgroundColor: primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: border,
          disabledForegroundColor: textMuted,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            fontFamily: _fontFamily,
            fontFamilyFallback: _fontFallback,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 52),
          foregroundColor: primaryDark,
          side: BorderSide(color: border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w800,
            fontFamily: _fontFamily,
            fontFamilyFallback: _fontFallback,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w800,
            fontFamily: _fontFamily,
            fontFamilyFallback: _fontFallback,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        elevation: 0,
        height: 68,
        indicatorColor: surfaceSoft,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            size: 23,
            color: states.contains(WidgetState.selected)
                ? primary
                : textMuted,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            color: states.contains(WidgetState.selected)
                ? primary
                : textMuted,
            fontSize: 11.5,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w800
                : FontWeight.w600,
            fontFamily: _fontFamily,
            fontFamilyFallback: _fontFallback,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceSoft,
        selectedColor: primary.withValues(alpha: 0.13),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        labelStyle: TextStyle(
          color: text,
          fontWeight: FontWeight.w700,
          fontFamily: _fontFamily,
          fontFamilyFallback: _fontFallback,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: border,
        thickness: 1,
        space: 1,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: primary,
        textColor: text,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
        titleTextStyle: TextStyle(
          color: text,
          fontSize: 14.5,
          fontWeight: FontWeight.w700,
          fontFamily: _fontFamily,
          fontFamilyFallback: _fontFallback,
        ),
        subtitleTextStyle: TextStyle(
          color: textMuted,
          fontSize: 12,
          height: 1.45,
          fontFamily: _fontFamily,
          fontFamilyFallback: _fontFallback,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? Colors.white
              : textMuted,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? primary
              : border,
        ),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titleTextStyle: TextStyle(
          color: text,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          fontFamily: _fontFamily,
          fontFamilyFallback: _fontFallback,
        ),
        contentTextStyle: TextStyle(
          color: textMuted,
          fontSize: 14,
          height: 1.55,
          fontFamily: _fontFamily,
          fontFamilyFallback: _fontFallback,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: border,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primary,
        linearTrackColor: surfaceSoft,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: primaryDeep,
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontFamily: _fontFamily,
          fontFamilyFallback: _fontFallback,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dividerColor: border,
    );

    return base.copyWith(
      splashColor: primary.withValues(alpha: 0.06),
      highlightColor: primary.withValues(alpha: 0.035),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
