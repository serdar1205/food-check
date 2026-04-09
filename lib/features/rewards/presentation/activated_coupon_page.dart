import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../domain/activated_coupon.dart';
import 'coupon_status_labels.dart';

class ActivatedCouponPage extends StatelessWidget {
  const ActivatedCouponPage({super.key, required this.coupon});

  final ActivatedCoupon coupon;

  @override
  Widget build(BuildContext context) {
    final exp =
        '${coupon.expiresAt.day.toString().padLeft(2, '0')}.'
        '${coupon.expiresAt.month.toString().padLeft(2, '0')}.'
        '${coupon.expiresAt.year}';
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Ваш купон'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              coupon.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.splashTitle,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              coupon.description,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Статус: ${coupon.status.labelRu}',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Действителен до: $exp',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            Center(
              child: QrImageView(
                data: coupon.qrPayload,
                version: QrVersions.auto,
                size: 220,
                backgroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              coupon.usageHint,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
