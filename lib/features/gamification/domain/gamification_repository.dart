import 'achievement.dart';
import 'user_level_snapshot.dart';

abstract interface class GamificationRepository {
  Future<UserLevelSnapshot> getLevelSnapshot();

  Future<List<Achievement>> listAchievements();
}
