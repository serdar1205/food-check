import 'package:flutter/material.dart';

import '../../../../app/navigation_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/review_result_colors.dart';
import '../../domain/review_result.dart';

class ReviewResultSuccessBody extends StatelessWidget {
  const ReviewResultSuccessBody({super.key, required this.result});

  final ReviewResultEntity result;

  @override
  Widget build(BuildContext context) {
    final bonus = result.bonusPoints;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                Center(
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.white,
                                ReviewResultColors.iconHalo.withValues(
                                  alpha: 0.3,
                                ),
                                Colors.white,
                              ],
                              stops: const [0.0, 0.45, 1.0],
                            ),
                          ),
                        ),
                        Container(
                          width: 108,
                          height: 108,
                          decoration: const BoxDecoration(
                            color: ReviewResultColors.successGreen,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x332E7D32),
                                blurRadius: 24,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 64,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Отзыв принят!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Text(
                    'Спасибо за ваш вклад в развитие нашего сообщества.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.45,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                _BonusCard(bonusPoints: bonus),
                // const SizedBox(height: 28),
                // const Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 4),
                //   child: ReviewSilkDecoration(),
                // ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          child: SizedBox(
            height: 54,
            width: double.infinity,
            child: FilledButton(
              onPressed: () => navigateToMainHome(context),
              style: FilledButton.styleFrom(
                backgroundColor: ReviewResultColors.actionGold,
                foregroundColor: AppColors.textPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(27),
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'На главную',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded, size: 22),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BonusCard extends StatelessWidget {
  const _BonusCard({required this.bonusPoints});

  final int bonusPoints;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: ReviewResultColors.actionGold,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.star_rounded,
                  color: AppColors.textPrimary,
                  size: 22,
                ),
                const SizedBox(width: 6),
                Text(
                  '+$bonusPoints',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'ВАМ НАЧИСЛЕНО $bonusPoints БОНУСОВ',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.4,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Обновите профиль, чтобы увидеть баланс',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
