import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/receipt_flow_colors.dart';

/// Shown when there is no image file (e.g. missing path or desktop without camera).
class ReceiptImagePlaceholder extends StatelessWidget {
  const ReceiptImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surface,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.receipt_long_rounded,
                size: 64,
                color: ReceiptFlowColors.previewSheetGold.withValues(
                  alpha: 0.85,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Предпросмотр недоступен',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
