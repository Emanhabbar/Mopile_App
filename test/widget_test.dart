import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pharmacy_app/app/app.dart';
import 'package:pharmacy_app/core/storage/secure_session_storage.dart';
import 'package:pharmacy_app/features/auth/data/models/auth_session.dart';
import 'package:pharmacy_app/features/auth/presentation/pages/registration_success_page.dart';

import 'helpers.dart';

void main() {
  testWidgets('shows the Arabic login page for a signed-out user', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionStorageProvider.overrideWithValue(_MemorySessionStorage()),
        ],
        child: const PharmacyApp(),
      ),
    );

    await tester.pump();
    expect(find.text('نجهّز تجربتك'), findsOneWidget);
    expect(find.text('دواؤك أقرب، ورعايتك أسهل'), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text('تسجيل الدخول'), findsWidgets);
    expect(find.text('البريد الإلكتروني'), findsOneWidget);
    expect(find.text('كلمة المرور'), findsOneWidget);
  });

  testWidgets('opens registration and shows the supported account types', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionStorageProvider.overrideWithValue(_MemorySessionStorage()),
        ],
        child: const PharmacyApp(),
      ),
    );

    await tester.pumpAndSettle();
    final createAccountButton = find.widgetWithText(
      TextButton,
      'إنشاء حساب',
    );
    await tester.ensureVisible(createAccountButton);
    await tester.pumpAndSettle();
    await tester.tap(createAccountButton);
    await tester.pumpAndSettle();

    expect(find.text('اختر نوع الحساب'), findsOneWidget);
    expect(find.text('مستخدم'), findsOneWidget);
    expect(find.text('صيدلية'), findsOneWidget);
    expect(find.text('منظمة'), findsOneWidget);
    expect(find.text('مستودع أدوية'), findsOneWidget);
  });

  testWidgets('opens the password recovery flow from login', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionStorageProvider.overrideWithValue(_MemorySessionStorage()),
        ],
        child: const PharmacyApp(),
      ),
    );

    await tester.pumpAndSettle();
    final forgotPassword = find.text('نسيت كلمة المرور؟');
    await tester.ensureVisible(forgotPassword);
    await tester.tap(forgotPassword);
    await tester.pumpAndSettle();

    expect(find.text('استعادة الحساب'), findsOneWidget);
    expect(find.text('البريد الإلكتروني'), findsOneWidget);
    expect(find.text('متابعة'), findsOneWidget);
  });

  testWidgets('shows the registration success state with the user name', (
    tester,
  ) async {
    final session = AuthSession(
      accessToken: 'test-token',
      expiresAtUtc: DateTime.now().toUtc().add(const Duration(hours: 1)),
      user: const AuthUser(
        userId: 'user-1',
        email: 'user@example.com',
        fullName: 'أحمد محمد',
        roles: ['User'],
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionStorageProvider.overrideWithValue(
            _MemorySessionStorage(session),
          ),
        ],
        child: appUnderTest(const RegistrationSuccessPage()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('مرحبًا أحمد'), findsOneWidget);
    expect(find.text('تم إنشاء حسابك'), findsOneWidget);
    expect(find.text('الانتقال إلى الرئيسية'), findsOneWidget);
  });
}

class _MemorySessionStorage implements SessionStorage {
  _MemorySessionStorage([this.session]);

  AuthSession? session;

  @override
  Future<void> clear() async => session = null;

  @override
  Future<AuthSession?> read() async => session;

  @override
  Future<void> write(AuthSession value) async => session = value;
}
