import 'package:flutter/material.dart';

/// Header / chrome accents for venue detail (reference: dark olive-brown).
abstract final class VenueChromeColors {
  static const Color foreground = Color(0xFF4A4035);
}

/// Positive overall-rating caption (e.g. «Отлично!»).
abstract final class VenueRatingCaptionColors {
  static const Color excellent = Color(0xFF43A047);
}

/// Progress bar fills for criteria rows.
abstract final class VenueCriteriaBarColors {
  static const Color food = Color(0xFFF2B705);
  static const Color service = Color(0xFF2E7D32);
  static const Color atmosphere = Color(0xFF1565C0);
  static const Color priceQuality = Color(0xFFE65100);
}
