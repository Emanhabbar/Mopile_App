import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/presentation/controllers/auth_controller.dart';
import '../features/settings/presentation/controllers/settings_controller.dart';
import '../l10n/generated/app_localizations.dart';
import 'localization/locale_controller.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class PharmacyApp extends ConsumerWidget {
  const PharmacyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final locale = ref.watch(localeControllerProvider);
    final settings = ref.watch(settingsControllerProvider);

    return MaterialApp.router(
      title: 'دوائي',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: settings.themeMode,
      builder: (context, child) => _SessionExpiredListener(child: child),
    );
  }
}

class _SessionExpiredListener extends ConsumerStatefulWidget {
  const _SessionExpiredListener({required this.child});

  final Widget? child;

  @override
  ConsumerState<_SessionExpiredListener> createState() =>
      _SessionExpiredListenerState();
}

class _SessionExpiredListenerState
    extends ConsumerState<_SessionExpiredListener> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  void _check() {
    final expired = ref.read(sessionExpiredProvider);
    if (expired) {
      ref.read(sessionExpiredProvider.notifier).state = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('انتهت جلستك، سجّل دخولك مجدداً.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<bool>(sessionExpiredProvider, (previous, next) {
      if (next && mounted) {
        ref.read(sessionExpiredProvider.notifier).state = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('انتهت جلستك، سجّل دخولك مجدداً.'),
          ),
        );
      }
    });
    return widget.child ?? const SizedBox.shrink();
  }
}
