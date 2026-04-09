import '../domain/bonus_ledger_entry.dart';
import '../domain/bonus_ledger_reason.dart';
import '../domain/bonus_wallet_repository.dart';

class BonusWalletRepositoryImpl implements BonusWalletRepository {
  BonusWalletRepositoryImpl() {
    _entries.add(
      BonusLedgerEntry(
        id: 'w-seed-1',
        occurredAt: DateTime(2025, 10, 1, 10, 0),
        signedAmount: 250,
        reason: BonusLedgerReason.promo,
        detail: 'Приветственный бонус',
      ),
    );
  }

  final List<BonusLedgerEntry> _entries = <BonusLedgerEntry>[];

  @override
  Future<List<BonusLedgerEntry>> listEntries() async {
    return List<BonusLedgerEntry>.unmodifiable(_entries);
  }

  @override
  Future<void> recordCredit(
    int amount,
    BonusLedgerReason reason, {
    String? detail,
  }) async {
    if (amount <= 0) {
      return;
    }
    _prepend(
      BonusLedgerEntry(
        id: 'w-${DateTime.now().microsecondsSinceEpoch}',
        occurredAt: DateTime.now(),
        signedAmount: amount,
        reason: reason,
        detail: detail,
      ),
    );
  }

  @override
  Future<void> recordDebit(
    int amount,
    BonusLedgerReason reason, {
    String? detail,
  }) async {
    if (amount <= 0) {
      return;
    }
    _prepend(
      BonusLedgerEntry(
        id: 'w-${DateTime.now().microsecondsSinceEpoch}',
        occurredAt: DateTime.now(),
        signedAmount: -amount,
        reason: reason,
        detail: detail,
      ),
    );
  }

  void _prepend(BonusLedgerEntry entry) {
    _entries.insert(0, entry);
  }
}
