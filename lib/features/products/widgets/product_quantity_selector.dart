import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_typography.dart';

class ProductQuantitySelector extends StatefulWidget {
  const ProductQuantitySelector({super.key});

  @override
  State<ProductQuantitySelector> createState() =>
      _ProductQuantitySelectorState();
}

class _ProductQuantitySelectorState extends State<ProductQuantitySelector> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                quantity++;
              });
            },
            child: const SizedBox(
              width: 22,
              child: Icon(Icons.add, size: 16, color: AppColors.primary),
            ),
          ),
          SizedBox(
            width: 22,
            child: Center(
              child: Text(
                quantity.toString(),
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              if (quantity == 1) return;

              setState(() {
                quantity--;
              });
            },
            child: const SizedBox(
              width: 22,
              child: Icon(Icons.remove, size: 16, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
