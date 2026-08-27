enum AppRole {
  user,
  pharmacy,
  organization,
  warehouse,
  representative,
  admin;

  static AppRole fromRoles(Iterable<String> roles) {
    final normalized = roles.map((role) => role.toLowerCase()).toSet();
    if (normalized.contains('admin')) return AppRole.admin;
    if (normalized.contains('pharmacy')) return AppRole.pharmacy;
    if (normalized.contains('organization')) return AppRole.organization;
    if (normalized.contains('warehouse')) return AppRole.warehouse;
    if (normalized.contains('representative')) return AppRole.representative;
    return AppRole.user;
  }
}
