import '../../../core/errors/app_failures.dart';
import '../../../core/result/result.dart';
import '../../profile/domain/profile_repository.dart';
import '../domain/activated_coupon.dart';
import '../domain/coupon_status.dart';
import '../domain/reward_offer.dart';
import '../domain/rewards_failure.dart';
import '../domain/rewards_repository.dart';

class RewardsRepositoryImpl implements RewardsRepository {
  RewardsRepositoryImpl(this._profile);

  final ProfileRepository _profile;

  static const List<RewardOffer> _offers = <RewardOffer>[
    RewardOffer(
      id: 'offer-coffee',
      title: 'Кофе в подарок',
      description: 'Любой напиток до 250 мл в сети партнёров.',
      costPoints: 80,
    ),
    RewardOffer(
      id: 'offer-dessert',
      title: 'Десерт',
      description: 'На выбор: чизкейк или тирамису.',
      costPoints: 120,
    ),
    RewardOffer(
      id: 'offer-discount',
      title: 'Скидка 10%',
      description: 'Один чек до 3000 ₽ в выбранных ресторанах.',
      costPoints: 200,
    ),
  ];

  @override
  Future<List<RewardOffer>> listOffers() async {
    return List<RewardOffer>.unmodifiable(_offers);
  }

  @override
  Future<Result<ActivatedCoupon, RewardsFailure>> redeem(String offerId) async {
    RewardOffer? offer;
    for (final RewardOffer o in _offers) {
      if (o.id == offerId) {
        offer = o;
        break;
      }
    }
    if (offer == null) {
      return const Failure(RewardsFailure.offerNotFound);
    }

    final spent = await _profile.spendBonusPoints(
      offer.costPoints,
      ledgerDetail: offer.title,
    );
    return spent.when(
      success: (_) {
        final coupon = ActivatedCoupon(
          id: 'c-${DateTime.now().microsecondsSinceEpoch}',
          title: offer!.title,
          description: offer.description,
          qrPayload:
              'FOOD_CHECK|${offer.id}|${DateTime.now().millisecondsSinceEpoch}',
          expiresAt: DateTime.now().add(const Duration(days: 30)),
          status: CouponStatus.active,
          usageHint:
              'Покажите этот экран или QR-код сотруднику при оплате. '
              'Купон действует один раз.',
        );
        return Success(coupon);
      },
      failure: (ProfileFailure e) {
        if (e == ProfileFailure.insufficientBalance) {
          return const Failure(RewardsFailure.insufficientBalance);
        }
        return const Failure(RewardsFailure.unknown);
      },
    );
  }
}
