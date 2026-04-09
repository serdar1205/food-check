import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/di.dart';
import '../../../core/application/request_status.dart';
import '../../../core/theme/app_colors.dart';
import '../application/gamification_cubit.dart';
import '../domain/achievement.dart';

class GamificationPage extends StatelessWidget {
  const GamificationPage({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => dependencies.createGamificationCubit()..load(),
      child: const _GamificationView(),
    );
  }
}

class _GamificationView extends StatelessWidget {
  const _GamificationView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Уровни / достижения'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: BlocBuilder<GamificationCubit, GamificationState>(
        builder: (context, state) {
          if (state.status == RequestStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.authAccentYellow,
              ),
            );
          }
          if (state.status == RequestStatus.failure) {
            return Center(
              child: Text(
                state.errorMessage ?? 'Ошибка',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }
          final snap = state.snapshot;
          if (snap == null) {
            return const SizedBox.shrink();
          }
          return RefreshIndicator(
            color: AppColors.authAccentYellow,
            onRefresh: () => context.read<GamificationCubit>().load(),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  'Текущий уровень',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  snap.levelTitle,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.splashTitle,
                  ),
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: snap.progressFraction,
                    minHeight: 10,
                    backgroundColor: AppColors.borderLight,
                    color: AppColors.authAccentYellow,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${snap.currentXp} / ${snap.currentXp + snap.xpToNextLevel} XP до следующего уровня',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Бонусы за активность',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  snap.activityBonusHint,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.4,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  'Достижения',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                ...state.achievements.map(
                  (Achievement a) => _AchievementTile(achievement: a),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AchievementTile extends StatelessWidget {
  const _AchievementTile({required this.achievement});

  final Achievement achievement;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        child: ListTile(
          leading: Icon(
            achievement.unlocked
                ? Icons.emoji_events_rounded
                : Icons.lock_outline_rounded,
            color: achievement.unlocked
                ? AppColors.authAccentYellow
                : AppColors.textSecondary,
          ),
          title: Text(
            achievement.title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: achievement.unlocked
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
            ),
          ),
          subtitle: Text(achievement.description),
        ),
      ),
    );
  }
}
