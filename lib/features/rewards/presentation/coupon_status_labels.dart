import '../domain/coupon_status.dart';

extension CouponStatusRu on CouponStatus {
  String get labelRu {
    return switch (this) {
      CouponStatus.active => 'Активен',
      CouponStatus.used => 'Использован',
      CouponStatus.expired => 'Истёк',
    };
  }
}
