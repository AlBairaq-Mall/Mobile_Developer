import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_shadows.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/widgets/app_cached_image.dart';
import '../../../app/widgets/app_section.dart';
import '../../../core/models/category_model.dart';
import '../providers/category_provider.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CategoryProvider>();

    final categories = provider.mainCategories;

    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }

    return AppSection(
      title: 'الأقسام',
      onSeeAll: () => context.push(AppRoutes.categories),
      child: SizedBox(
        height: 118,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          padding: EdgeInsets.zero,
          separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
          itemBuilder: (_, index) {
            return _CategoryCard(
              category: categories[index],
            );
          },
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final CategoryModel category;

  const _CategoryCard({
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      onTap: () {
        context.push(
          '${AppRoutes.categories}/${category.id}?name=${Uri.encodeComponent(category.name)}',
        );
      },
      child: Ink(
        width: 92,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: AppShadows.card,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: category.imageUrl.isNotEmpty
                      ? AppCachedImage(
                          imageUrl: category.imageUrl,
                          fit: BoxFit.contain,
                        )
                      : Icon(
                          Icons.category_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                category.name,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.labelMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
