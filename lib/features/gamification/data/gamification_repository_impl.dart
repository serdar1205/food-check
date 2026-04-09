import '../domain/achievement.dart';
import '../domain/gamification_repository.dart';
import '../domain/user_level_snapshot.dart';

class GamificationRepositoryImpl implements GamificationRepository {
  @override
  Future<UserLevelSnapshot> getLevelSnapshot() async {
    return const UserLevelSnapshot(
      levelTitle: 'Гурман II',
      currentXp: 320,
      xpToNextLevel: 180,
      activityBonusHint:
          'Оставляйте отзывы с чеком и обменивайте купоны — так растёт уровень и начисляются дополнительные бонусы.',
    );
  }

  @override
  Future<List<Achievement>> listAchievements() async {
    return const <Achievement>[
      Achievement(
        id: 'a1',
        title: 'Первый отзыв',
        description: 'Отправьте первый отзыв с чеком.',
        unlocked: true,
      ),
      Achievement(
        id: 'a2',
        title: 'Три заведения',
        description: 'Оцените три разных ресторана.',
        unlocked: true,
      ),
      Achievement(
        id: 'a3',
        title: 'Серия недели',
        description: 'Три отзыва за 7 дней.',
        unlocked: false,
      ),
    ];
  }
}
