import 'package:flutter_test/flutter_test.dart';
import 'package:pharmacy_app/features/auth/data/models/password_reset_result.dart';

void main() {
  test('parses a development password reset token when supplied', () {
    final result = PasswordResetResult.fromJson(const {
      'message': 'تم استلام الطلب',
      'developmentToken': 'local-token',
    });

    expect(result.message, 'تم استلام الطلب');
    expect(result.developmentToken, 'local-token');
  });

  test('keeps the token absent for a generic production response', () {
    final result = PasswordResetResult.fromJson(const {
      'message': 'تحقق من بريدك',
    });

    expect(result.developmentToken, isNull);
  });
}
