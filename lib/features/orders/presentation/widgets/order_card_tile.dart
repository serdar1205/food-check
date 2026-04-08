import 'package:flutter/material.dart';

import '../../../../core/constants/orders_ui_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/order.dart';

class OrderCardTile extends StatelessWidget {
  const OrderCardTile({super.key, required this.order, this.onTap});

  final Order order;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final nameStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: AppColors.splashTitle,
    );
    final metaStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      fontSize: 13,
      color: AppColors.textSecondary,
      height: 1.35,
    );

    return Padding(
      padding: const EdgeInsets.only(
        bottom: OrdersUiConstants.cardMarginBottom,
      ),
      child: Material(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(OrdersUiConstants.cardRadius),
          side: const BorderSide(color: AppColors.borderLight),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.receipt_long_rounded,
                        color: AppColors.authAccentYellow,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.restaurantName,
                            style: nameStyle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(order.dateLabel, style: metaStyle),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _StatusChip(status: order.status),
                        const SizedBox(height: 6),
                        Text(
                          order.totalLabel,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  order.itemsSummary,
                  style: metaStyle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final (String label, Color bg, Color fg) = switch (status) {
      OrderStatus.completed => (
        'Выполнен',
        const Color(0xFFE8F5E9),
        const Color(0xFF2E7D32),
      ),
      OrderStatus.pending => (
        'В процессе',
        AppColors.authAccentYellow.withValues(alpha: 0.25),
        AppColors.splashTitle,
      ),
      OrderStatus.cancelled => (
        'Отменён',
        const Color(0xFFFFEBEE),
        const Color(0xFFC62828),
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }
}
