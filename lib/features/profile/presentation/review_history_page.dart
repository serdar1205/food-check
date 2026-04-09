import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/di.dart';
import '../../../core/application/request_status.dart';
import '../../../core/theme/app_colors.dart';
import '../../reviews/application/review_history_cubit.dart';
import '../../reviews/presentation/review_moderation_status_labels.dart';

class ReviewHistoryPage extends StatelessWidget {
  const ReviewHistoryPage({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => dependencies.createReviewHistoryCubit()..load(),
      child: const _ReviewHistoryView(),
    );
  }
}

class _ReviewHistoryView extends StatelessWidget {
  const _ReviewHistoryView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('История отзывов'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: BlocBuilder<ReviewHistoryCubit, ReviewHistoryState>(
        builder: (context, state) {
          if (state.status == RequestStatus.loading && state.entries.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.authAccentYellow,
              ),
            );
          }
          if (state.status == RequestStatus.failure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  state.errorMessage ?? 'Ошибка',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            );
          }
          final items = state.entries;
          if (items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Пока нет отправленных отзывов',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            );
          }
          return RefreshIndicator(
            color: AppColors.authAccentYellow,
            onRefresh: () => context.read<ReviewHistoryCubit>().load(),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final e = items[index];
                final date =
                    '${e.submittedAt.day.toString().padLeft(2, '0')}.'
                    '${e.submittedAt.month.toString().padLeft(2, '0')}.'
                    '${e.submittedAt.year}';
                final bonusText = e.bonusPoints > 0
                    ? '+${e.bonusPoints} бонусов'
                    : 'Бонусы не начислены';
                return ListTile(
                  title: Text(
                    e.restaurantName,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text('$date · $bonusText'),
                      const SizedBox(height: 6),
                      _StatusChip(label: e.status.labelRu),
                    ],
                  ),
                  isThreeLine: true,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.borderLight.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'Статус: $label',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
