import 'coupon_status.dart';

class ActivatedCoupon {
  const ActivatedCoupon({
    required this.id,
    required this.title,
    required this.description,
    required this.qrPayload,
    required this.expiresAt,
    required this.status,
    required this.usageHint,
  });

  final String id;
  final String title;
  final String description;
  final String qrPayload;
  final DateTime expiresAt;
  final CouponStatus status;
  final String usageHint;
}
