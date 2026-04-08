import 'package:flutter_test/flutter_test.dart';
import 'package:food_check/core/result/result.dart';
import 'package:food_check/features/profile/data/profile_repository_impl.dart';

void main() {
  test('getProfile then applyBonusAward increases balance', () async {
    final repo = ProfileRepositoryImpl();

    final first = await repo.getProfile();
    expect(first, isA<Success>());
    expect((first as Success).value.bonusBalance, 250);

    await repo.applyBonusAward(50);

    final second = await repo.getProfile();
    expect((second as Success).value.bonusBalance, 300);
  });
}
