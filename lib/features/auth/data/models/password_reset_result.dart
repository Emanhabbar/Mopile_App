class PasswordResetResult {
  const PasswordResetResult({required this.message, this.developmentToken});

  factory PasswordResetResult.fromJson(Map<String, dynamic> json) {
    return PasswordResetResult(
      message:
          json['message'] as String? ??
          'إذا كان البريد مسجلًا فستصلك تعليمات استعادة الحساب.',
      developmentToken: json['developmentToken'] as String?,
    );
  }

  final String message;
  final String? developmentToken;
}
