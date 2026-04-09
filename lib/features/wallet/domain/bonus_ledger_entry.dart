import 'bonus_ledger_reason.dart';

/// One line in the bonus wallet. [signedAmount] > 0 credit, < 0 debit.
class BonusLedgerEntry {
  const BonusLedgerEntry({
    required this.id,
    required this.occurredAt,
    required this.signedAmount,
    required this.reason,
    this.detail,
  });

  final String id;
  final DateTime occurredAt;
  final int signedAmount;
  final BonusLedgerReason reason;
  final String? detail;
}
