import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../home/providers/home_provider.dart';
import '../providers/category_provider.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router/app_routes.dart';
import '../../../core/models/category_model.dart';
import 'category_chip.dart';

class CategoriesPinned extends StatelessWidget {
  const CategoriesPinned({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<CategoryProvider>();
    final homeProvider = context.watch<HomeProvider>();

    final categories = [
      const CategoryModel(
        id: 'special_offers',
        nameAr: 'العروض',
        nameEn: 'Offers',
        image: '',
        parentId: null,
        sortOrder: 0,
      ),
      ...categoryProvider.mainCategories,
    ];

    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsetsDirectional.fromSTEB(0, 6, 0, 4),
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(height: 4),
            SizedBox(
              height: 78,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 2),
                itemCount: categories.length + 1,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, index) {
                  if (index == 0) {
                    return CategoryChip(
                      category: null,
                      selected: homeProvider.selectedCategory.isEmpty,
                      onTap: homeProvider.clearCategory,
                    );
                  }

                  final category = categories[index - 1];

                  return CategoryChip(
                    category: category,
                    selected: homeProvider.selectedCategory == category.id,
                    onTap: () {
                      if (category.id == 'special_offers') {
                        context.push('${AppRoutes.categories}/special_offers?name=${Uri.encodeComponent('العروض')}');
                      } else {
                        homeProvider.selectCategory(category.id);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
