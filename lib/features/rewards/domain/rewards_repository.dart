import '../../../core/result/result.dart';
import 'activated_coupon.dart';
import 'reward_offer.dart';
import 'rewards_failure.dart';

abstract interface class RewardsRepository {
  Future<List<RewardOffer>> listOffers();

  Future<Result<ActivatedCoupon, RewardsFailure>> redeem(String offerId);
}
