import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../core/config/app_config.dart';
import '../../core/network/api_endpoints.dart';
import '../../features/auth/data/models/auth_session.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({required this.user, super.key, this.radius = 24});

  final AuthUser user;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final baseUri = AppConfig.apiUri(
      ApiEndpoints.accountAvatarByUser(user.userId),
    );
    final imageUri = user.profileImageUpdatedAtUtc == null
        ? baseUri
        : baseUri.replace(
            queryParameters: {
              'v': user.profileImageUpdatedAtUtc!.millisecondsSinceEpoch
                  .toString(),
            },
          );

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.surfaceSoft,
        foregroundColor: AppColors.primary,
        backgroundImage: user.hasProfileImage
            ? NetworkImage('$imageUri')
            : null,
        child: user.hasProfileImage
            ? null
            : Text(
                user.initials,
                style: TextStyle(
                  fontSize: radius * 0.64,
                  fontWeight: FontWeight.w900,
                ),
              ),
      ),
    );
  }
}
