import 'package:flutter/material.dart';

import '../../../../core/constants/profile_ui_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/profile_screen_colors.dart';
import '../../domain/user_profile.dart';

class ProfileUserIdentityCard extends StatelessWidget {
  const ProfileUserIdentityCard({super.key, required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ProfileUiConstants.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _Avatar(url: profile.avatarUrl, name: profile.name),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  profile.email,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.url, required this.name});

  final String url;
  final String name;

  @override
  Widget build(BuildContext context) {
    final initials = _initials(name);
    return ClipOval(
      child: SizedBox(
        width: 72,
        height: 72,
        child: Image.network(
          url,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, progress) {
            if (progress == null) {
              return child;
            }
            return ColoredBox(
              color: ProfileScreenColors.menuIconBg,
              child: Center(
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: ProfileScreenColors.olive.withValues(alpha: 0.5),
                  ),
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return ColoredBox(
              color: ProfileScreenColors.menuIconBg,
              child: Center(
                child: Text(
                  initials,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: ProfileScreenColors.olive,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    final list = parts.toList();
    if (list.isEmpty) {
      return '?';
    }
    if (list.length == 1) {
      return _firstCharUpper(list.first);
    }
    return '${_firstCharUpper(list[0])}${_firstCharUpper(list[1])}';
  }

  static String _firstCharUpper(String s) {
    if (s.isEmpty) {
      return '';
    }
    return s.substring(0, 1).toUpperCase();
  }
}
