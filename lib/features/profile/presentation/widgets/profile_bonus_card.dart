import 'package:flutter/material.dart';

import '../../../../core/constants/profile_ui_constants.dart';
import '../../../../core/theme/profile_screen_colors.dart';

class ProfileBonusCard extends StatelessWidget {
  const ProfileBonusCard({super.key, required this.bonusPoints, this.onTap});

  final int bonusPoints;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ProfileScreenColors.bonusYellow,
      borderRadius: BorderRadius.circular(ProfileUiConstants.cardRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ProfileUiConstants.cardRadius),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 14, 18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: ProfileScreenColors.starCircle,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.star_rounded,
                  color: ProfileScreenColors.olive,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ваши бонусы',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: ProfileScreenColors.olive.withValues(alpha: 0.9),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '$bonusPoints',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            height: 1,
                            color: ProfileScreenColors.olive,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            'бонусных баллов',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: ProfileScreenColors.olive,
                              height: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: ProfileScreenColors.olive.withValues(alpha: 0.65),
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
