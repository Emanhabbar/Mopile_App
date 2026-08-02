import 'package:flutter_test/flutter_test.dart';
import 'package:pharmacy_app/core/constants/app_roles.dart';
import 'package:pharmacy_app/features/dashboard/data/role_modules.dart';
import 'package:pharmacy_app/features/dashboard/presentation/navigation/module_navigation.dart';

void main() {
  test('every role module has an application destination', () {
    for (final role in AppRole.values) {
      for (final module in modulesForRole(role)) {
        expect(
          moduleLocationFor(role, module.routeName),
          isNotNull,
          reason: '${role.name}/${module.routeName} is not connected',
        );
      }
    }
  });

  test('role-specific services open their intended workspace sections', () {
    expect(
      moduleLocationFor(AppRole.organization, 'donation-offers'),
      '/organization/workspace?section=donations',
    );
    expect(
      moduleLocationFor(AppRole.admin, 'accounts'),
      '/admin/workspace?section=accounts',
    );
    expect(
      moduleLocationFor(AppRole.pharmacy, 'pharmacy-donations'),
      '/pharmacy/donations',
    );
    expect(
      moduleLocationFor(AppRole.warehouse, 'intelligence'),
      '/intelligence',
    );
  });
}
