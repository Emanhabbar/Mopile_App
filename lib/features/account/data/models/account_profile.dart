import '../../../auth/data/models/auth_session.dart';

class AccountProfile {
  const AccountProfile({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.roles,
    required this.isActive,
    required this.createdAtUtc,
    required this.hasProfileImage,
    this.phoneNumber,
    this.profileImageUpdatedAtUtc,
  });

  factory AccountProfile.fromJson(Map<String, dynamic> json) => AccountProfile(
    userId: json['userId']?.toString() ?? '',
    fullName: json['fullName']?.toString() ?? '',
    email: json['email']?.toString() ?? '',
    phoneNumber: _optional(json['phoneNumber']),
    roles:
        (json['roles'] as List?)
            ?.map((role) => role.toString())
            .toList(growable: false) ??
        const [],
    isActive: json['isActive'] == true,
    createdAtUtc:
        DateTime.tryParse(json['createdAtUtc']?.toString() ?? '')?.toUtc() ??
        DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
    hasProfileImage: json['hasProfileImage'] == true,
    profileImageUpdatedAtUtc: DateTime.tryParse(
      json['profileImageUpdatedAtUtc']?.toString() ?? '',
    )?.toUtc(),
  );

  final String userId;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final List<String> roles;
  final bool isActive;
  final DateTime createdAtUtc;
  final bool hasProfileImage;
  final DateTime? profileImageUpdatedAtUtc;

  AuthUser mergeInto(AuthUser current) => current.copyWith(
    email: email,
    fullName: fullName,
    roles: roles,
    hasProfileImage: hasProfileImage,
    profileImageUpdatedAtUtc: profileImageUpdatedAtUtc,
    clearProfileImageUpdatedAt: !hasProfileImage,
  );
}

String? _optional(Object? value) {
  final text = value?.toString().trim();
  return text == null || text.isEmpty ? null : text;
}
