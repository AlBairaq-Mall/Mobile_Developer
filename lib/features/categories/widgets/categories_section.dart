import 'package:bhm_supermarket/features/navigation/providers/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/widgets/app_section.dart';
import '../../home/providers/home_provider.dart';
import '../providers/category_provider.dart';
import 'category_chip.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<CategoryProvider>();
    final homeProvider = context.watch<HomeProvider>();

    final categories = categoryProvider.mainCategories;

    return AppSection(
      title: 'الأقسام',
      onSeeAll: () => context.read<NavigationProvider>().changeTab(1),
      child: SizedBox(
        height: 86,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 2),
          physics: const BouncingScrollPhysics(),
          itemCount: categories.length + 1,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (_, index) {
            if (index == 0) {
              return CategoryChip(
                category: null,
                selected: homeProvider.selectedCategory.isEmpty,
                onTap: () {
                  homeProvider.clearCategory();
                },
              );
            }

            final category = categories[index - 1];

            return CategoryChip(
              category: category,
              selected: homeProvider.selectedCategory == category.id,
              onTap: () {
                homeProvider.selectCategory(category.id);
              },
            );
          },
        ),
      ),
    );
  }
}
