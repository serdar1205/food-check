import 'package:flutter/material.dart';

/// FoodCheck palette from [docs/design.md] and splash reference.
abstract final class AppColors {
  /// Primary yellow (splash logo, active onboarding dot). Screenshot ~#F2B705.
  static const Color brandYellow = Color(0xFFF2B705);

  /// Auth screen primary actions / links (reference ~#F2B200).
  static const Color authAccentYellow = Color(0xFFF2B200);

  /// Design spec alternate warm yellow for buttons/cards elsewhere.
  static const Color primaryYellow = Color(0xFFF9D342);

  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Colors.white;

  static const Color textPrimary = Color(0xFF2D2D2D);
  static const Color textSecondary = Color(0xFF8E8E8E);

  /// Splash / onboarding title on white (reference: #000000).
  static const Color splashTitle = Color(0xFF000000);

  /// Splash subtitle (reference: #8E8E93).
  static const Color splashSubtitle = Color(0xFF8E8E93);

  /// Splash background (reference: #FFFFFF).
  static const Color splashBackground = Color(0xFFFFFFFF);

  static const Color borderLight = Color(0xFFE0E0E0);

  /// Inactive onboarding dot — faded yellow (reference: lighter than brand).
  static const Color onboardingDotFaded = Color(0x55F2B705);
}
