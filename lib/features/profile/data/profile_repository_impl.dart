import '../../../core/errors/app_failures.dart';
import '../../../core/result/result.dart';
import '../../wallet/domain/bonus_ledger_reason.dart';
import '../../wallet/domain/bonus_wallet_repository.dart';
import '../domain/profile_repository.dart';
import '../domain/user_profile.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._wallet);

  final BonusWalletRepository _wallet;

  UserProfile _profile = const UserProfile(
    name: 'Иван Иванов',
    email: 'ivanov@example.com',
    avatarUrl: 'https://i.pravatar.cc/256?img=12',
    bonusBalance: 250,
  );

  @override
  Future<Result<UserProfile, ProfileFailure>> getProfile() async {
    return Success(_profile);
  }

  @override
  Future<Result<void, ProfileFailure>> applyBonusAward(int points) async {
    if (points < 0) {
      return const Failure(ProfileFailure.unknown);
    }
    if (points == 0) {
      return const Success(null);
    }
    _profile = UserProfile(
      name: _profile.name,
      email: _profile.email,
      avatarUrl: _profile.avatarUrl,
      bonusBalance: _profile.bonusBalance + points,
    );
    await _wallet.recordCredit(
      points,
      BonusLedgerReason.reviewAward,
      detail: 'За отправленный отзыв',
    );
    return const Success(null);
  }

  @override
  Future<Result<void, ProfileFailure>> spendBonusPoints(
    int points, {
    String? ledgerDetail,
  }) async {
    if (points <= 0) {
      return const Failure(ProfileFailure.unknown);
    }
    if (_profile.bonusBalance < points) {
      return const Failure(ProfileFailure.insufficientBalance);
    }
    _profile = UserProfile(
      name: _profile.name,
      email: _profile.email,
      avatarUrl: _profile.avatarUrl,
      bonusBalance: _profile.bonusBalance - points,
    );
    await _wallet.recordDebit(
      points,
      BonusLedgerReason.couponRedeem,
      detail: ledgerDetail,
    );
    return const Success(null);
  }

  @override
  Future<Result<void, ProfileFailure>> updateDisplayName(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      return const Failure(ProfileFailure.unknown);
    }
    _profile = UserProfile(
      name: trimmed,
      email: _profile.email,
      avatarUrl: _profile.avatarUrl,
      bonusBalance: _profile.bonusBalance,
    );
    return const Success(null);
  }
}
