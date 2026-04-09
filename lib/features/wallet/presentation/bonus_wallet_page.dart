import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/di.dart';
import '../../../core/application/request_status.dart';
import '../../../core/theme/app_colors.dart';
import '../application/bonus_wallet_cubit.dart';
import 'bonus_ledger_reason_labels.dart';

class BonusWalletPage extends StatelessWidget {
  const BonusWalletPage({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => dependencies.createBonusWalletCubit()..load(),
      child: const _BonusWalletView(),
    );
  }
}

class _BonusWalletView extends StatelessWidget {
  const _BonusWalletView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Бонусы / кошелёк'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: BlocBuilder<BonusWalletCubit, BonusWalletState>(
        builder: (context, state) {
          if (state.status == RequestStatus.loading &&
              state.entries.isEmpty &&
              state.currentBalance == null) {
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
          final balance = state.currentBalance ?? 0;
          final entries = state.entries;
          return RefreshIndicator(
            color: AppColors.authAccentYellow,
            onRefresh: () => context.read<BonusWalletCubit>().load(),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Текущий баланс',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$balance',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: AppColors.splashTitle,
                          ),
                        ),
                        const Text(
                          'бонусных баллов',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'История операций',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (entries.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(
                        'Операций пока нет',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  )
                else
                  SliverList.separated(
                    itemCount: entries.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final e = entries[index];
                      final date =
                          '${e.occurredAt.day.toString().padLeft(2, '0')}.'
                          '${e.occurredAt.month.toString().padLeft(2, '0')}.'
                          '${e.occurredAt.year}';
                      final sign = e.signedAmount >= 0 ? '+' : '';
                      final amountStr = '$sign${e.signedAmount}';
                      final reasonLine =
                          e.detail != null && e.detail!.isNotEmpty
                          ? '${e.reason.labelRu} · ${e.detail}'
                          : e.reason.labelRu;
                      return ListTile(
                        title: Text(
                          reasonLine,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(date),
                        trailing: Text(
                          amountStr,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: e.signedAmount >= 0
                                ? const Color(0xFF2E7D32)
                                : ProfileDebitColor.debit,
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Keeps magic color out of inline widget tree.
abstract final class ProfileDebitColor {
  static const Color debit = Color(0xFFC62828);
}
