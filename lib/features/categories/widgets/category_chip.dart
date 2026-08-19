import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/widgets/app_cached_image.dart';
import '../../../core/models/category_model.dart';

class CategoryChip extends StatelessWidget {
  final CategoryModel? category;
  final bool selected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    this.category,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final title = category?.name ?? 'الكل';

    return SizedBox(
      width: 72,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected
                    ? AppColors.primary.withValues(alpha: .12)
                    : const Color(0xffF5F6F8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(11),
                child: category == null
                    ? Icon(
                        Icons.apps_rounded,
                        color:
                            selected ? AppColors.primary : AppColors.textHint,
                        size: 24,
                      )
                    : Hero(
                        tag: 'cat_${category!.id}',
                        child: category!.imageUrl.isNotEmpty
                            ? AppCachedImage(
                                imageUrl: category!.imageUrl,
                                fit: BoxFit.contain,
                                radius: 0,
                              )
                            : Icon(
                                Icons.category_rounded,
                                color: selected
                                    ? AppColors.primary
                                    : AppColors.textHint,
                                size: 24,
                              ),
                      ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTypography.labelSmall.copyWith(
                fontSize: 11,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                color: selected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
