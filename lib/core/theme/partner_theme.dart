import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class PartnerTheme {
  static const Color accent = Color(0xFF2F6FED);
  static const Color accentLight = Color(0xFFEAF0FF);
  static const Color warning = Color(0xFFD84315);

  static const double pagePadding = 16;
  static const double cardRadius = 12;

  static BoxDecoration cardDecoration() {
    return BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(cardRadius),
      border: Border.all(color: AppColors.borderLight),
    );
  }
}
