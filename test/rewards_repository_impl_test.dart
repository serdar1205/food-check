import 'package:flutter_test/flutter_test.dart';
import 'package:food_check/core/result/result.dart';
import 'package:food_check/features/profile/data/profile_repository_impl.dart';
import 'package:food_check/features/rewards/data/rewards_repository_impl.dart';
import 'package:food_check/features/rewards/domain/rewards_failure.dart';
import 'package:food_check/features/wallet/data/bonus_wallet_repository_impl.dart';

void main() {
  test('redeem deducts points and returns coupon', () async {
    final wallet = BonusWalletRepositoryImpl();
    final profile = ProfileRepositoryImpl(wallet);
    final rewards = RewardsRepositoryImpl(profile);

    final result = await rewards.redeem('offer-coffee');

    expect(result, isA<Success>());
    final p = await profile.getProfile();
    expect((p as Success).value.bonusBalance, 250 - 80);
  });

  test('redeem fails when insufficient balance', () async {
    final wallet = BonusWalletRepositoryImpl();
    final profile = ProfileRepositoryImpl(wallet);
    final rewards = RewardsRepositoryImpl(profile);

    await profile.spendBonusPoints(200);

    final result = await rewards.redeem('offer-discount');

    expect(result, isA<Failure>());
    expect((result as Failure).error, RewardsFailure.insufficientBalance);
  });
}
