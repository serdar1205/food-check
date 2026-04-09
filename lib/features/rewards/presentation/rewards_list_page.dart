import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/di.dart';
import '../../../core/application/request_status.dart';
import '../../../core/theme/app_colors.dart';
import '../application/rewards_list_cubit.dart';
import '../domain/reward_offer.dart';
import 'activated_coupon_page.dart';

class RewardsListPage extends StatelessWidget {
  const RewardsListPage({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => dependencies.createRewardsListCubit()..load(),
      child: const _RewardsListView(),
    );
  }
}

class _RewardsListView extends StatelessWidget {
  const _RewardsListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Купоны / награды'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: BlocConsumer<RewardsListCubit, RewardsListState>(
        listenWhen: (prev, next) =>
            next.errorMessage != null && next.errorMessage != prev.errorMessage,
        listener: (context, state) {
          final msg = state.errorMessage;
          if (msg != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(msg)));
            context.read<RewardsListCubit>().clearRedeemMessage();
          }
        },
        builder: (context, state) {
          if (state.status == RequestStatus.loading && state.offers.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.authAccentYellow,
              ),
            );
          }
          if (state.status == RequestStatus.failure && state.offers.isEmpty) {
            return Center(
              child: Text(
                state.errorMessage ?? 'Ошибка',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }
          final offers = state.offers;
          return RefreshIndicator(
            color: AppColors.authAccentYellow,
            onRefresh: () => context.read<RewardsListCubit>().load(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: offers.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final offer = offers[index];
                return _RewardCard(offer: offer);
              },
            ),
          );
        },
      ),
    );
  }
}

class _RewardCard extends StatelessWidget {
  const _RewardCard({required this.offer});

  final RewardOffer offer;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              offer.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.splashTitle,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              offer.description,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  '${offer.costPoints} б.',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.authAccentYellow,
                  ),
                ),
                const Spacer(),
                FilledButton(
                  onPressed: () async {
                    final cubit = context.read<RewardsListCubit>();
                    final coupon = await cubit.redeem(offer.id);
                    if (context.mounted && coupon != null) {
                      await Navigator.of(context).push<void>(
                        MaterialPageRoute<void>(
                          builder: (_) => ActivatedCouponPage(coupon: coupon),
                        ),
                      );
                    }
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.authAccentYellow,
                    foregroundColor: AppColors.textPrimary,
                  ),
                  child: const Text('Обменять'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
