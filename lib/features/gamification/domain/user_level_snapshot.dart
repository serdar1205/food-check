class UserLevelSnapshot {
  const UserLevelSnapshot({
    required this.levelTitle,
    required this.currentXp,
    required this.xpToNextLevel,
    required this.activityBonusHint,
  });

  final String levelTitle;
  final int currentXp;
  final int xpToNextLevel;
  final String activityBonusHint;

  double get progressFraction {
    if (xpToNextLevel <= 0) {
      return 1;
    }
    return (currentXp / (currentXp + xpToNextLevel)).clamp(0.0, 1.0);
  }
}
