import '../../../../core/constants/app_roles.dart';

String? moduleLocationFor(AppRole role, String routeName) {
  return switch (routeName) {
    'health-profile' => '/user/health',
    'medicine-search' => '/user/search',
    'nearby-pharmacies' => '/user/nearby-pharmacies',
    'medicine-requests' => '/user/requests',
    'prescriptions' => '/user/prescriptions',
    'donations' => '/user/donations',
    'organizations' => '/organizations',
    'chat' => '/user/chat',
    'pharmacy-inventory' => '/pharmacy/inventory',
    'pharmacy-requests' => '/pharmacy/requests',
    'pharmacy-prescriptions' => '/pharmacy/prescriptions',
    'pharmacy-profile' => '/pharmacy/profile',
    'working-hours' => '/pharmacy/working-hours',
    'pharmacy-donations' => '/pharmacy/donations',
    'supply-chain' => '/supply-chain',
    'intelligence' => '/intelligence',
    'medicine-catalog' =>
      role == AppRole.admin ? '/medicines' : '/pharmacy/inventory',
    'campaigns' => '/organization/workspace?section=campaigns',
    'donation-offers' => '/organization/workspace?section=donations',
    'assistance-requests' => '/organization/workspace?section=assistance',
    'organization-profile' => '/organization/workspace?section=profile',
    'approvals' => '/admin/workspace?section=approvals',
    'accounts' => '/admin/workspace?section=accounts',
    'home-ticker' => '/admin/workspace?section=ticker',
    _ => null,
  };
}
