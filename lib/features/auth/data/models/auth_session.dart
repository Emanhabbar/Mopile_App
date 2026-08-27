import '../../../../core/constants/app_roles.dart';

class AuthSession {
  const AuthSession({
    required this.accessToken,
    required this.expiresAtUtc,
    required this.user,
  });

  final String accessToken;
  final DateTime expiresAtUtc;
  final AuthUser user;

  bool get isExpired => DateTime.now().toUtc().isAfter(
    expiresAtUtc.subtract(const Duration(seconds: 30)),
  );

  AuthSession copyWith({AuthUser? user}) => AuthSession(
    accessToken: accessToken,
    expiresAtUtc: expiresAtUtc,
    user: user ?? this.user,
  );

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    return AuthSession(
      accessToken: json['accessToken'] as String? ?? '',
      expiresAtUtc:
          DateTime.tryParse(json['expiresAtUtc'] as String? ?? '')?.toUtc() ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      user: AuthUser.fromJson(
        json['user'] is Map<String, dynamic>
            ? json['user'] as Map<String, dynamic>
            : const {},
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'accessToken': accessToken,
    'expiresAtUtc': expiresAtUtc.toIso8601String(),
    'user': user.toJson(),
  };
}

class AuthUser {
  const AuthUser({
    required this.userId,
    required this.email,
    required this.fullName,
    required this.roles,
    this.pharmacyProfileId,
    this.organizationProfileId,
    this.hasProfileImage = false,
    this.profileImageUpdatedAtUtc,
  });

  final String userId;
  final String email;
  final String fullName;
  final List<String> roles;
  final String? pharmacyProfileId;
  final String? organizationProfileId;
  final bool hasProfileImage;
  final DateTime? profileImageUpdatedAtUtc;

  AppRole get primaryRole => AppRole.fromRoles(roles);

  String get initials {
    final parts = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2);
    final value = parts.map((part) => part.substring(0, 1)).join();
    return value.isEmpty ? 'ح' : value;
  }

  AuthUser copyWith({
    String? email,
    String? fullName,
    List<String>? roles,
    String? pharmacyProfileId,
    String? organizationProfileId,
    bool? hasProfileImage,
    DateTime? profileImageUpdatedAtUtc,
    bool clearProfileImageUpdatedAt = false,
  }) => AuthUser(
    userId: userId,
    email: email ?? this.email,
    fullName: fullName ?? this.fullName,
    roles: roles ?? this.roles,
    pharmacyProfileId: pharmacyProfileId ?? this.pharmacyProfileId,
    organizationProfileId: organizationProfileId ?? this.organizationProfileId,
    hasProfileImage: hasProfileImage ?? this.hasProfileImage,
    profileImageUpdatedAtUtc: clearProfileImageUpdatedAt
        ? null
        : profileImageUpdatedAtUtc ?? this.profileImageUpdatedAtUtc,
  );

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      userId: json['userId']?.toString() ?? '',
      email: json['email'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      roles:
          (json['roles'] as List?)
              ?.map((role) => role.toString())
              .toList(growable: false) ??
          const [],
      pharmacyProfileId: json['pharmacyProfileId']?.toString(),
      organizationProfileId: json['organizationProfileId']?.toString(),
      hasProfileImage: json['hasProfileImage'] as bool? ?? false,
      profileImageUpdatedAtUtc: DateTime.tryParse(
        json['profileImageUpdatedAtUtc'] as String? ?? '',
      )?.toUtc(),
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'email': email,
    'fullName': fullName,
    'roles': roles,
    'pharmacyProfileId': pharmacyProfileId,
    'organizationProfileId': organizationProfileId,
    'hasProfileImage': hasProfileImage,
    'profileImageUpdatedAtUtc': profileImageUpdatedAtUtc?.toIso8601String(),
  };
}
