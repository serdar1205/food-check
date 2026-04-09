import 'package:flutter_test/flutter_test.dart';
import 'package:food_check/features/wallet/data/bonus_wallet_repository_impl.dart';
import 'package:food_check/features/wallet/domain/bonus_ledger_reason.dart';

void main() {
  test('recordCredit prepends positive entry', () async {
    final repo = BonusWalletRepositoryImpl();
    await repo.recordCredit(40, BonusLedgerReason.reviewAward);
    final list = await repo.listEntries();
    expect(list.first.signedAmount, 40);
    expect(list.first.reason, BonusLedgerReason.reviewAward);
  });

  test('recordDebit prepends negative entry', () async {
    final repo = BonusWalletRepositoryImpl();
    await repo.recordDebit(25, BonusLedgerReason.couponRedeem, detail: 'X');
    final list = await repo.listEntries();
    expect(list.first.signedAmount, -25);
  });
}
