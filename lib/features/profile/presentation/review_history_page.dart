import 'package:flutter/material.dart';

import '../../../app/di.dart';
import '../../../core/theme/app_colors.dart';
import '../../reviews/domain/review_history_entry.dart';

class ReviewHistoryPage extends StatefulWidget {
  const ReviewHistoryPage({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  State<ReviewHistoryPage> createState() => _ReviewHistoryPageState();
}

class _ReviewHistoryPageState extends State<ReviewHistoryPage> {
  late Future<List<ReviewHistoryEntry>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.dependencies.reviewHistoryRepository.listEntries();
  }

  Future<void> _reload() async {
    setState(() {
      _future = widget.dependencies.reviewHistoryRepository.listEntries();
    });
    await _future;
  }

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
      body: FutureBuilder<List<ReviewHistoryEntry>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.authAccentYellow,
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Не удалось загрузить список',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            );
          }
          final items = snapshot.data ?? <ReviewHistoryEntry>[];
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
            onRefresh: _reload,
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
                return ListTile(
                  title: Text(
                    'Заведение: ${e.restaurantId}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text('$date · +${e.bonusPoints} бонусов'),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
