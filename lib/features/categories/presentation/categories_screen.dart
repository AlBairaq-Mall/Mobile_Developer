import 'package:bhm_supermarket/core/widgets/app_page_header.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_shadows.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/widgets/app_cached_image.dart';
import '../../../core/models/category_model.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_widget.dart';
import '../providers/category_provider.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  void _open(BuildContext context, CategoryModel category) {
    context.push(
      '${AppRoutes.categories}/${category.id}?name=${Uri.encodeComponent(category.name)}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CategoryProvider>();

    if (provider.isLoading) {
      return const Scaffold(body: LoadingWidget());
    }

    if (provider.error != null) {
      return Scaffold(
        appBar: const AppPageHeader(title: "الأقسام", showBack: false),
        body: EmptyState(
          emoji: "⚠️",
          title: "تعذر تحميل الأقسام",
          subtitle: provider.error,
          actionLabel: "إعادة المحاولة",
          onAction: provider.refresh,
        ),
      );
    }

    final categories = provider.mainCategories;

    if (categories.isEmpty) {
      return const Scaffold(
        body: EmptyState(
          emoji: "📦",
          title: "لا توجد أقسام",
          subtitle: "سيتم إضافة الأقسام قريباً",
        ),
      );
    }

    return Scaffold(
      appBar: const AppPageHeader(title: "الأقسام", showBack: false),
      body: GridView.builder(
        padding: const EdgeInsets.all(AppSpacing.lg),
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
          childAspectRatio: .92,
        ),
        itemBuilder: (_, index) {
          final category = categories[index];

          return Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadius.xl),
              onTap: () => _open(context, category),
              child: Ink(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  boxShadow: AppShadows.card,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [
                      Expanded(
                        child: Hero(
                          tag: 'cat_${category.id}',
                          child: category.imageUrl.isNotEmpty
                              ? AppCachedImage(
                                  imageUrl: category.imageUrl,
                                  fit: BoxFit.contain,
                                )
                              : Icon(
                                  Icons.category_rounded,
                                  size: 42,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        category.name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
