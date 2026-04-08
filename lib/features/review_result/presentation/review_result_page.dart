import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/review_result_colors.dart';
import '../domain/review_result.dart';
import 'widgets/review_result_failure_body.dart';
import 'widgets/review_result_success_body.dart';

class ReviewResultPage extends StatelessWidget {
  const ReviewResultPage({super.key, required this.result});

  final ReviewResultEntity result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: result.isSuccess
                ? ReviewResultColors.statusTitleGold
                : AppColors.textPrimary,
          ),
        ),
        title: Text(
          'REVIEW STATUS',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
            color: result.isSuccess
                ? ReviewResultColors.statusTitleGold
                : AppColors.textPrimary,
          ),
        ),
        actions: result.isSuccess
            ? null
            : [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Center(
                    child: Text(
                      'GOLDED',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                        color: ReviewResultColors.brandWordmark,
                      ),
                    ),
                  ),
                ),
              ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: result.isSuccess
              ? ReviewResultSuccessBody(result: result)
              : ReviewResultFailureBody(reason: result.reason),
        ),
      ),
    );
  }
}
