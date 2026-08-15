import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_shadows.dart';

class ProductFavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onTap;

  const ProductFavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: AppShadows.xs,
          ),
          child: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
            size: 18,
            color: isFavorite ? AppColors.favorite : AppColors.textHint,
          ),
        ),
      ),
    );
  }
}
