import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/di.dart';
import '../../../core/application/request_status.dart';
import '../../../core/theme/app_colors.dart';
import '../application/notifications_cubit.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => dependencies.createNotificationsCubit()..load(),
      child: const _NotificationsView(),
    );
  }
}

class _NotificationsView extends StatelessWidget {
  const _NotificationsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Уведомления'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
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
          final items = state.items;
          if (items.isEmpty) {
            return Center(
              child: Text(
                'Нет уведомлений',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }
          return RefreshIndicator(
            color: AppColors.authAccentYellow,
            onRefresh: () => context.read<NotificationsCubit>().load(),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final n = items[index];
                final date =
                    '${n.createdAt.day.toString().padLeft(2, '0')}.'
                    '${n.createdAt.month.toString().padLeft(2, '0')}.'
                    '${n.createdAt.year}';
                return ListTile(
                  tileColor: n.read ? null : AppColors.background,
                  title: Text(
                    n.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: n.read
                          ? AppColors.textSecondary
                          : AppColors.textPrimary,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(n.body),
                        const SizedBox(height: 4),
                        Text(
                          date,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
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
