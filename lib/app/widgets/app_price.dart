import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppPrice extends StatelessWidget {
  final double price;
  final double? oldPrice;

  const AppPrice({
    super.key,
    required this.price,
    this.oldPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (oldPrice != null)
          Text(
            '${oldPrice!.toStringAsFixed(0)} ر.ي',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 9,
              color: Colors.grey,
              decoration: TextDecoration.lineThrough,
              height: 1,
            ),
          ),
        const SizedBox(height: 2),
        Text(
          '${price.toStringAsFixed(0)} ر.ي',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
            height: 1,
          ),
        ),
      ],
    );
  }
}
