import 'package:bhm_supermarket/features/navigation/providers/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/section_header.dart';
import '../../home/providers/home_provider.dart';
import '../providers/category_provider.dart';
import 'category_chip.dart';

class CategoriesPinned extends StatelessWidget {
  const CategoriesPinned({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<CategoryProvider>();
    final homeProvider = context.watch<HomeProvider>();

    final categories = categoryProvider.mainCategories;

    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.fromLTRB(0, 6, 0, 4),
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 2),
            //   child: SectionHeader(
            //     title: 'الأقسام',
            //     onSeeAll: () => context.read<NavigationProvider>().changeTab(1),
            //   ),
            // ),
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
                      homeProvider.selectCategory(category.id);
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
