import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class AppPrice extends StatelessWidget {
  final double price;
  final double? oldPrice;
  final CrossAxisAlignment crossAxisAlignment;

  const AppPrice({
    super.key,
    required this.price,
    this.oldPrice,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  bool get hasDiscount => oldPrice != null && oldPrice! > price;

  int get discountPercent {
    if (!hasDiscount) return 0;

    return (((oldPrice! - price) / oldPrice!) * 100).round();
  }

  @override
  Widget build(BuildContext context) {
    final currentStyle = AppTypography.currentPrice.copyWith(
      color: AppColors.primary,
    );

    final oldStyle = AppTypography.oldPrice.copyWith(
      color: AppColors.textHint,
    );

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasDiscount)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${oldPrice!.toStringAsFixed(0)} ر.ي',
                style: oldStyle,
              ),
              const SizedBox(
                width: AppSpacing.xs,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.badgeSale.withValues(alpha: .10),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  '-$discountPercent%',
                  style: TextStyle(
                    color: AppColors.badgeSale,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        if (hasDiscount)
          const SizedBox(
            height: AppSpacing.xxs,
          ),
        Text(
          '${price.toStringAsFixed(0)} ر.ي',
          style: currentStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
