import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/receipt_flow_ui_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/receipt_flow_colors.dart';
import '../../reviews/domain/review_draft.dart';
import '../application/receipt_flow_cubit.dart';
import '../domain/receipt_preview_data.dart';
import 'widgets/receipt_image_preview.dart';

class ReceiptPreviewScreen extends StatelessWidget {
  const ReceiptPreviewScreen({
    super.key,
    required this.draft,
    required this.imagePath,
  });

  final ReviewDraft draft;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ReceiptFlowCubit>();

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PreviewHeader(
            onBack: () => cubit.retake(),
            onHelp: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Справка — в разработке')),
              );
            },
          ),
          Expanded(
            child: ColoredBox(
              color: ReceiptFlowColors.previewDarkPanel,
              child: Center(
                child: FractionallySizedBox(
                  widthFactor: 0.88,
                  child: AspectRatio(
                    aspectRatio: 0.72,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: ReceiptImagePreview(path: imagePath),
                    ),
                  ),
                ),
              ),
            ),
          ),
          _PreviewBottomSheet(
            onSend: () => cubit.submitReview(draft),
            onRetake: () => cubit.retake(),
          ),
        ],
      ),
    );
  }
}

class _PreviewHeader extends StatelessWidget {
  const _PreviewHeader({required this.onBack, required this.onHelp});

  final VoidCallback onBack;
  final VoidCallback onHelp;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(
              children: [
                IconButton(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  color: ReceiptFlowColors.previewGold,
                ),
                const Expanded(
                  child: Text(
                    'Предпросмотр',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onHelp,
                  icon: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: ReceiptFlowColors.previewGold),
                    ),
                    child: Icon(
                      Icons.help_outline_rounded,
                      size: 18,
                      color: ReceiptFlowColors.previewGold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            color: ReceiptFlowColors.previewGold.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }
}

class _PreviewBottomSheet extends StatelessWidget {
  const _PreviewBottomSheet({required this.onSend, required this.onRetake});

  final VoidCallback onSend;
  final VoidCallback onRetake;

  @override
  Widget build(BuildContext context) {
    const data = ReceiptPreviewData.mock;

    return Material(
      color: AppColors.surface,
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(ReceiptFlowUiConstants.previewSheetRadius),
      ),
      elevation: 12,
      shadowColor: Colors.black26,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          22,
          20,
          MediaQuery.paddingOf(context).bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ДАТА ЧЕКА',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.6,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        data.dateLabel,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'ИТОГО К ОПЛАТЕ',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.6,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        data.totalLabel,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: ReceiptFlowColors.previewSheetGold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _InfoMiniCard(
                    icon: Icons.storefront_outlined,
                    label: 'МАГАЗИН',
                    value: data.storeName,
                    accent: false,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _InfoMiniCard(
                    icon: Icons.description_outlined,
                    label: 'ФД НОМЕР',
                    value: data.fdNumber,
                    accent: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            SizedBox(
              height: 54,
              child: FilledButton(
                onPressed: onSend,
                style: FilledButton.styleFrom(
                  backgroundColor: ReceiptFlowColors.previewSheetGold,
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
                      'Отправить',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.send_rounded, size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 54,
              child: OutlinedButton(
                onPressed: onRetake,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: AppColors.borderLight),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(27),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.photo_camera_outlined, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Переснять',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoMiniCard extends StatelessWidget {
  const _InfoMiniCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: accent
            ? Border(
                left: BorderSide(
                  color: ReceiptFlowColors.previewGold,
                  width: 3,
                ),
              )
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
