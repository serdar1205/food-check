import 'bonus_ledger_entry.dart';
import 'bonus_ledger_reason.dart';

abstract interface class BonusWalletRepository {
  Future<List<BonusLedgerEntry>> listEntries();

  Future<void> recordCredit(
    int amount,
    BonusLedgerReason reason, {
    String? detail,
  });

  Future<void> recordDebit(
    int amount,
    BonusLedgerReason reason, {
    String? detail,
  });
}
