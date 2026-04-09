import '../domain/bonus_ledger_reason.dart';

extension BonusLedgerReasonRu on BonusLedgerReason {
  String get labelRu {
    return switch (this) {
      BonusLedgerReason.reviewAward => 'Начисление за отзыв',
      BonusLedgerReason.couponRedeem => 'Обмен на купон',
      BonusLedgerReason.promo => 'Акция / бонус',
    };
  }
}
