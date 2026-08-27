import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.primary,
    required this.primaryDark,
    required this.primaryDeep,
    required this.primaryLight,
    required this.secondary,
    required this.background,
    required this.surface,
    required this.surfaceSoft,
    required this.surfaceWarm,
    required this.text,
    required this.textMuted,
    required this.border,
    required this.success,
    required this.danger,
    required this.warning,
    required this.shadow,
  });

  // The mobile palette mirrors the established web identity.
  static const light = AppColors(
    primary: Color(0xFF216474),
    primaryDark: Color(0xFF174B57),
    primaryDeep: Color(0xFF102F37),
    primaryLight: Color(0xFF8BD0CB),
    secondary: Color(0xFFF5CB72),
    background: Color(0xFFF7FAF9),
    surface: Color(0xFFFFFFFF),
    surfaceSoft: Color(0xFFEEF6F5),
    surfaceWarm: Color(0xFFFFF9EB),
    text: Color(0xFF142E35),
    textMuted: Color(0xFF668087),
    border: Color(0xFFD9E4E5),
    success: Color(0xFF167D5A),
    danger: Color(0xFFB33A3A),
    warning: Color(0xFFB7791F),
    shadow: Color(0xFF123A43),
  );

  // Dark-mode equivalents of the same design identity.
  static const dark = AppColors(
    primary: Color(0xFF4A9BB0),
    primaryDark: Color(0xFF5FA9BC),
    primaryDeep: Color(0xFF1B4A55),
    primaryLight: Color(0xFF8BD0CB),
    secondary: Color(0xFFF5CB72),
    background: Color(0xFF0C1518),
    surface: Color(0xFF152327),
    surfaceSoft: Color(0xFF1E3036),
    surfaceWarm: Color(0xFF2A2212),
    text: Color(0xFFE4EDEF),
    textMuted: Color(0xFF93AAB0),
    border: Color(0xFF2B3E45),
    success: Color(0xFF4CB380),
    danger: Color(0xFFE0665F),
    warning: Color(0xFFD99A3D),
    shadow: Color(0xFF000000),
  );

  final Color primary;
  final Color primaryDark;
  final Color primaryDeep;
  final Color primaryLight;
  final Color secondary;
  final Color background;
  final Color surface;
  final Color surfaceSoft;
  final Color surfaceWarm;
  final Color text;
  final Color textMuted;
  final Color border;
  final Color success;
  final Color danger;
  final Color warning;
  final Color shadow;

  @override
  AppColors copyWith({
    Color? primary,
    Color? primaryDark,
    Color? primaryDeep,
    Color? primaryLight,
    Color? secondary,
    Color? background,
    Color? surface,
    Color? surfaceSoft,
    Color? surfaceWarm,
    Color? text,
    Color? textMuted,
    Color? border,
    Color? success,
    Color? danger,
    Color? warning,
    Color? shadow,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      primaryDark: primaryDark ?? this.primaryDark,
      primaryDeep: primaryDeep ?? this.primaryDeep,
      primaryLight: primaryLight ?? this.primaryLight,
      secondary: secondary ?? this.secondary,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceSoft: surfaceSoft ?? this.surfaceSoft,
      surfaceWarm: surfaceWarm ?? this.surfaceWarm,
      text: text ?? this.text,
      textMuted: textMuted ?? this.textMuted,
      border: border ?? this.border,
      success: success ?? this.success,
      danger: danger ?? this.danger,
      warning: warning ?? this.warning,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      primaryDeep: Color.lerp(primaryDeep, other.primaryDeep, t)!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceSoft: Color.lerp(surfaceSoft, other.surfaceSoft, t)!,
      surfaceWarm: Color.lerp(surfaceWarm, other.surfaceWarm, t)!,
      text: Color.lerp(text, other.text, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      border: Color.lerp(border, other.border, t)!,
      success: Color.lerp(success, other.success, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
    );
  }
}

extension AppColorsContext on BuildContext {
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
}
