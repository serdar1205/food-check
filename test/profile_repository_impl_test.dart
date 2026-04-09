import 'package:flutter_test/flutter_test.dart';
import 'package:food_check/core/result/result.dart';
import 'package:food_check/features/profile/data/profile_repository_impl.dart';
import 'package:food_check/features/wallet/data/bonus_wallet_repository_impl.dart';

void main() {
  test(
    'getProfile then applyBonusAward increases balance and logs credit',
    () async {
      final wallet = BonusWalletRepositoryImpl();
      final repo = ProfileRepositoryImpl(wallet);

      final first = await repo.getProfile();
      expect(first, isA<Success>());
      expect((first as Success).value.bonusBalance, 250);

      await repo.applyBonusAward(50);

      final second = await repo.getProfile();
      expect((second as Success).value.bonusBalance, 300);

      final ledger = await wallet.listEntries();
      expect(ledger.first.signedAmount, 50);
      expect(ledger.first.signedAmount, greaterThan(0));
    },
  );

  test('spendBonusPoints decreases balance and logs debit', () async {
    final wallet = BonusWalletRepositoryImpl();
    final repo = ProfileRepositoryImpl(wallet);

    await repo.spendBonusPoints(100, ledgerDetail: 'Купон');

    final p = await repo.getProfile();
    expect((p as Success).value.bonusBalance, 150);

    final ledger = await wallet.listEntries();
    expect(ledger.first.signedAmount, -100);
  });

  test('spendBonusPoints fails when balance too low', () async {
    final wallet = BonusWalletRepositoryImpl();
    final repo = ProfileRepositoryImpl(wallet);

    final out = await repo.spendBonusPoints(500);
    expect(out, isA<Failure>());
  });

  test('updateDisplayName trims and updates profile', () async {
    final wallet = BonusWalletRepositoryImpl();
    final repo = ProfileRepositoryImpl(wallet);

    await repo.updateDisplayName('  Мария  ');
    final p = await repo.getProfile();
    expect((p as Success).value.name, 'Мария');
  });
}
