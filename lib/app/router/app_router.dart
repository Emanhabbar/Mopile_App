import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_roles.dart';
import '../../features/account/presentation/pages/account_profile_page.dart';
import '../../features/account/presentation/pages/change_password_page.dart';
import '../../features/admin/presentation/pages/admin_home_page.dart';
import '../../features/admin/presentation/pages/admin_workspace_page.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/controllers/splash_controller.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/registration_success_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/chat/presentation/pages/chat_sessions_page.dart';
import '../../features/dashboard/presentation/pages/home_shell.dart';
import '../../features/donations/presentation/pages/donation_form_page.dart';
import '../../features/donations/presentation/pages/donations_page.dart';
import '../../features/donations/presentation/pages/pharmacy_donations_page.dart';
import '../../features/medicines/presentation/pages/create_medicine_page.dart';
import '../../features/medicines/presentation/pages/medicine_details_page.dart';
import '../../features/medicines/presentation/pages/medicines_page.dart';
import '../../features/intelligence/presentation/pages/intelligence_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/organization/presentation/pages/organization_home_page.dart';
import '../../features/organization/presentation/pages/organization_workspace_page.dart';
import '../../features/organization/presentation/pages/public_organization_details_page.dart';
import '../../features/organization/presentation/pages/public_organizations_page.dart';
import '../../features/pharmacy/presentation/pages/pharmacy_dashboard_page.dart';
import '../../features/pharmacy/presentation/pages/pharmacy_inventory_page.dart';
import '../../features/pharmacy/presentation/pages/pharmacy_license_verification_page.dart';
import '../../features/pharmacy/presentation/pages/pharmacy_profile_page.dart';
import '../../features/pharmacy/presentation/pages/pharmacy_request_details_page.dart';
import '../../features/pharmacy/presentation/pages/pharmacy_requests_page.dart';
import '../../features/pharmacy/presentation/pages/pharmacy_working_hours_page.dart';
import '../../features/pharmacy_discovery/presentation/pages/external_pharmacy_details_page.dart';
import '../../features/prescriptions/presentation/pages/pharmacy_prescription_orders_page.dart';
import '../../features/prescriptions/presentation/pages/prescription_details_page.dart';
import '../../features/prescriptions/presentation/pages/prescriptions_page.dart';
import '../../features/supply_chain/presentation/pages/representative_home_page.dart';
import '../../features/supply_chain/presentation/pages/supply_chain_workspace_page.dart';
import '../../features/supply_chain/presentation/pages/warehouse_home_page.dart';
import '../../features/settings/presentation/pages/settings_details_pages.dart';
import '../../features/user/presentation/pages/health_profile_page.dart';
import '../../features/user/presentation/pages/medicine_request_details_page.dart';
import '../../features/user/presentation/pages/medicine_requests_page.dart';
import '../../features/user/presentation/pages/medicine_search_page.dart';
import '../../features/user/presentation/pages/nearby_pharmacies_page.dart';
import '../../features/user/presentation/pages/pharmacy_details_page.dart';
import '../../features/user/presentation/pages/search_history_page.dart';
import '../../features/user/presentation/pages/user_dashboard_page.dart';
import '../../features/auth/data/models/auth_session.dart';

final _routerRefreshProvider = Provider<_RouterRefreshNotifier>((ref) {
  final notifier = _RouterRefreshNotifier();
  ref.listen(authControllerProvider, (_, _) => notifier.refresh());
  ref.listen(splashCompletedProvider, (_, _) => notifier.refresh());
  ref.onDispose(notifier.dispose);
  return notifier;
});

final appRouterProvider = Provider<GoRouter>((ref) {
  final splashCompleted = ref.watch(splashCompletedProvider);
  final role = ref.watch(
    authControllerProvider.select(
      (auth) => splashCompleted ? auth.valueOrNull?.user.primaryRole : null,
    ),
  );
  final refreshNotifier = ref.watch(_routerRefreshProvider);

  final auth = ref.read(authControllerProvider);
  final isAuthenticated = auth.valueOrNull != null;
  final initialLocation = !splashCompleted
      ? '/splash'
      : !isAuthenticated
      ? '/login'
      : ref.read(registrationCompletedProvider)
      ? '/registration-success'
      : '/home';

  final router = GoRouter(
    initialLocation: initialLocation,
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider);
      final location = state.matchedLocation;
      final splashCompleted = ref.read(splashCompletedProvider);

      if (!splashCompleted) {
        return location == '/splash' ? null : '/splash';
      }

      // أثناء تسجيل الدخول/إنشاء الحساب، الـ authControllerProvider بيصير
      // AsyncLoading، ومنّا نريد أن الـ router يهدم الصفحة (وبالتالي يضيّع
      // بيانات الفورم). فنبقى على صفحات الـ auth العامة وقت التحميل.
      if (auth.isLoading) {
        final isPublicAuthPage = location == '/login' ||
            location == '/register' ||
            location == '/forgot-password';
        if (isPublicAuthPage) {
          return null;
        }
        return location == '/splash' ? null : '/splash';
      }

      final isAuthenticated = auth.valueOrNull != null;
      if (!isAuthenticated) {
        final isPublicAuthPage =
            location == '/login' ||
            location == '/register' ||
            location == '/forgot-password';
        return isPublicAuthPage ? null : '/login';
      }

      final registrationCompleted = ref.read(registrationCompletedProvider);
      if (location == '/register' && registrationCompleted) {
        return '/registration-success';
      }
      if (location == '/registration-success') {
        return registrationCompleted ? null : '/home';
      }

      if (location == '/login' ||
          location == '/register' ||
          location == '/forgot-password' ||
          location == '/splash') {
        return '/home';
      }

      final userRole = auth.valueOrNull?.user.primaryRole;
      if (location.startsWith('/user/') && userRole != AppRole.user) {
        return '/home';
      }
      if (location.startsWith('/pharmacy/') &&
          userRole != AppRole.pharmacy) {
        return '/home';
      }
      if (location.startsWith('/organization/') &&
          userRole != AppRole.organization) {
        return '/home';
      }
      if (location.startsWith('/admin/') && userRole != AppRole.admin) {
        return '/home';
      }
      if (location.startsWith('/medicines') && userRole != AppRole.admin) {
        return '/home';
      }
      if (location.startsWith('/supply-chain') &&
          !{
            AppRole.pharmacy,
            AppRole.warehouse,
            AppRole.representative,
          }.contains(userRole)) {
        return '/home';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/registration-success',
        name: 'registration-success',
        builder: (context, state) => const RegistrationSuccessPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => HomeShell(
          navigationShell: navigationShell,
          role: role ?? AppRole.user,
        ),
        branches: _shellBranches(ref, role ?? AppRole.user),
      ),
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationsPage(),
      ),
      GoRoute(
        path: '/medicines/:medicineId',
        name: 'medicine-details',
        builder: (context, state) => MedicineDetailsPage(
          medicineId: state.pathParameters['medicineId']!,
        ),
      ),
      GoRoute(
        path: '/intelligence',
        name: 'intelligence',
        builder: (context, state) => const IntelligencePage(),
      ),
      GoRoute(
        path: '/account/profile',
        name: 'account-profile',
        builder: (context, state) => const AccountProfilePage(),
      ),
      GoRoute(
        path: '/account/password',
        name: 'account-password',
        builder: (context, state) => const ChangePasswordPage(),
      ),
      GoRoute(
        path: '/settings/appearance',
        name: 'settings-appearance',
        builder: (context, state) => const AppearanceSettingsPage(),
      ),
      GoRoute(
        path: '/settings/notifications',
        name: 'settings-notifications',
        builder: (context, state) => const NotificationPreferencesPage(),
      ),
      GoRoute(
        path: '/settings/permissions',
        name: 'settings-permissions',
        builder: (context, state) => const PermissionsSettingsPage(),
      ),
      GoRoute(
        path: '/settings/privacy',
        name: 'settings-privacy',
        builder: (context, state) =>
            const InformationPage(kind: InformationPageKind.privacy),
      ),
      GoRoute(
        path: '/settings/terms',
        name: 'settings-terms',
        builder: (context, state) =>
            const InformationPage(kind: InformationPageKind.terms),
      ),
      GoRoute(
        path: '/settings/help',
        name: 'settings-help',
        builder: (context, state) =>
            const InformationPage(kind: InformationPageKind.help),
      ),
      GoRoute(
        path: '/settings/about',
        name: 'settings-about',
        builder: (context, state) =>
            const InformationPage(kind: InformationPageKind.about),
      ),
      GoRoute(
        path: '/organizations',
        name: 'public-organizations',
        builder: (context, state) => const PublicOrganizationsPage(),
        routes: [
          GoRoute(
            path: ':organizationId',
            name: 'public-organization-details',
            builder: (context, state) => PublicOrganizationDetailsPage(
              organizationId: state.pathParameters['organizationId']!,
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/pharmacies/external/:placeId',
        name: 'external-pharmacy-details',
        builder: (context, state) => ExternalPharmacyDetailsPage(
          placeId: state.pathParameters['placeId']!,
        ),
      ),
      GoRoute(
        path: '/user/health',
        name: 'user-health',
        builder: (context, state) => const HealthProfilePage(),
      ),
      GoRoute(
        path: '/user/pharmacies/:pharmacyId',
        name: 'user-pharmacy-details',
        builder: (context, state) => PharmacyDetailsPage(
          pharmacyId: state.pathParameters['pharmacyId']!,
          initialMedicineId: state.uri.queryParameters['medicine'],
        ),
      ),
      GoRoute(
        path: '/user/requests/:requestId',
        name: 'user-medicine-request-details',
        builder: (context, state) => MedicineRequestDetailsPage(
          requestId: state.pathParameters['requestId']!,
        ),
      ),
      GoRoute(
        path: '/user/search-history',
        name: 'user-search-history',
        builder: (context, state) => const SearchHistoryPage(),
      ),
      GoRoute(
        path: '/user/prescriptions',
        name: 'user-prescriptions',
        builder: (context, state) => const PrescriptionsPage(),
        routes: [
          GoRoute(
            path: ':orderId',
            name: 'user-prescription-details',
            builder: (context, state) => PrescriptionDetailsPage(
              orderId: state.pathParameters['orderId']!,
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/user/donations',
        name: 'user-donations',
        builder: (context, state) => const DonationsPage(),
        routes: [
          GoRoute(
            path: 'create-offer',
            name: 'user-donation-offer-create',
            builder: (context, state) =>
                const DonationFormPage(mode: DonationFormMode.offer),
          ),
          GoRoute(
            path: 'create-request',
            name: 'user-assistance-request-create',
            builder: (context, state) =>
                const DonationFormPage(mode: DonationFormMode.assistance),
          ),
        ],
      ),
      GoRoute(
        path: '/user/chat',
        name: 'user-chat-sessions',
        builder: (context, state) => const ChatSessionsPage(),
        routes: [
          GoRoute(
            path: ':sessionId',
            name: 'user-chat',
            builder: (context, state) =>
                ChatPage(sessionId: state.pathParameters['sessionId']!),
          ),
        ],
      ),
      GoRoute(
        path: '/pharmacy/profile',
        name: 'pharmacy-profile',
        builder: (context, state) => const PharmacyProfilePage(),
      ),
      GoRoute(
        path: '/pharmacy/working-hours',
        name: 'pharmacy-working-hours',
        builder: (context, state) => const PharmacyWorkingHoursPage(),
      ),
      GoRoute(
        path: '/pharmacy/license-verification',
        name: 'pharmacy-license-verification',
        builder: (context, state) => const PharmacyLicenseVerificationPage(),
      ),
      GoRoute(
        path: '/pharmacy/requests/:requestId',
        name: 'pharmacy-request-details',
        builder: (context, state) => PharmacyRequestDetailsPage(
          requestId: state.pathParameters['requestId']!,
        ),
      ),
      GoRoute(
        path: '/pharmacy/prescriptions',
        name: 'pharmacy-prescriptions',
        builder: (context, state) => const PharmacyPrescriptionOrdersPage(),
      ),
      GoRoute(
        path: '/pharmacy/donations',
        name: 'pharmacy-donations',
        builder: (context, state) => const PharmacyDonationsPage(),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});

List<StatefulShellBranch> _shellBranches(Ref ref, AppRole role) {
  return switch (role) {
    AppRole.user => [
      _branch([
        _homeRoute(
          ref,
          (user) => HomeTabShell(child: UserDashboardPage(user: user)),
        ),
      ]),
      _branch([
        GoRoute(
          path: '/user/search',
          name: 'user-medicine-search',
          builder: (context, state) => MedicineSearchPage(
            initialQuery: state.extra is String ? state.extra! as String : null,
          ),
        ),
      ]),
      _branch([
        GoRoute(
          path: '/user/nearby-pharmacies',
          name: 'user-nearby-pharmacies',
          builder: (context, state) => const NearbyPharmaciesPage(),
        ),
      ]),
      _branch([
        GoRoute(
          path: '/user/requests',
          name: 'user-medicine-requests',
          builder: (context, state) => const MedicineRequestsPage(),
        ),
      ]),
      _branch([_accountRoute]),
    ],
    AppRole.pharmacy => [
      _branch([
        _homeRoute(
          ref,
          (_) => const HomeTabShell(child: PharmacyDashboardPage()),
        ),
      ]),
      _branch([
        GoRoute(
          path: '/pharmacy/inventory',
          name: 'pharmacy-inventory',
          builder: (context, state) => const PharmacyInventoryPage(),
        ),
      ]),
      _branch([
        GoRoute(
          path: '/pharmacy/requests',
          name: 'pharmacy-requests',
          builder: (context, state) => const PharmacyRequestsPage(),
        ),
      ]),
      _branch([
        GoRoute(
          path: '/supply-chain',
          name: 'supply-chain-workspace',
          builder: (context, state) => const SupplyChainWorkspacePage(),
        ),
      ]),
      _branch([_accountRoute]),
    ],
    AppRole.admin => [
      _branch([
        _homeRoute(
          ref,
          (_) => const HomeTabShell(child: AdminHomePage()),
        ),
      ]),
      _branch([
        GoRoute(
          path: '/admin/workspace',
          name: 'admin-workspace',
          builder: (context, state) => AdminWorkspacePage(
            initialSection: switch (state.uri.queryParameters['section']) {
              'approvals' => 1,
              'accounts' => 2,
              'ticker' => 3,
              _ => 0,
            },
          ),
        ),
      ]),
      _branch([
        GoRoute(
          path: '/medicines',
          name: 'medicines',
          builder: (context, state) => const MedicinesPage(),
          routes: [
            GoRoute(
              path: 'create',
              name: 'medicine-create',
              redirect: (context, state) =>
                  ref
                          .read(authControllerProvider)
                          .valueOrNull
                          ?.user
                          .primaryRole ==
                      AppRole.admin
                  ? null
                  : '/medicines',
              builder: (context, state) => const CreateMedicinePage(),
            ),
          ],
        ),
      ]),
      _branch([_accountRoute]),
    ],
    AppRole.organization => [
      _branch([
        _homeRoute(
          ref,
          (_) => const HomeTabShell(child: OrganizationHomePage()),
        ),
      ]),
      _branch([
        GoRoute(
          path: '/organization/workspace',
          name: 'organization-workspace',
          builder: (context, state) => OrganizationWorkspacePage(
            initialSection: switch (state.uri.queryParameters['section']) {
              'campaigns' => 1,
              'donations' => 2,
              'assistance' => 3,
              'profile' => 4,
              _ => 0,
            },
          ),
        ),
      ]),
      _branch([_accountRoute]),
    ],
    AppRole.warehouse => [
      _branch([
        _homeRoute(
          ref,
          (_) => const HomeTabShell(child: WarehouseHomePage()),
        ),
      ]),
      _branch([
        GoRoute(
          path: '/supply-chain',
          name: 'supply-chain-workspace',
          builder: (context, state) => const SupplyChainWorkspacePage(),
        ),
      ]),
      _branch([_accountRoute]),
    ],
    AppRole.representative => [
      _branch([
        _homeRoute(
          ref,
          (_) => const HomeTabShell(child: RepresentativeHomePage()),
        ),
      ]),
      _branch([
        GoRoute(
          path: '/supply-chain',
          name: 'supply-chain-workspace',
          builder: (context, state) => const SupplyChainWorkspacePage(),
        ),
      ]),
      _branch([_accountRoute]),
    ],
  };
}

StatefulShellBranch _branch(List<GoRoute> routes) =>
    StatefulShellBranch(routes: routes);

GoRoute _homeRoute(Ref ref, Widget Function(AuthUser) pageBuilder) =>
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) {
        final user = ref.read(authControllerProvider).valueOrNull?.user;
        if (user == null) return const SizedBox.shrink();
        return pageBuilder(user);
      },
    );

final _accountRoute = GoRoute(
  path: '/account',
  name: 'account-tab',
  builder: (context, state) => const AccountTabPage(),
);

class _RouterRefreshNotifier extends ChangeNotifier {
  void refresh() => notifyListeners();
}