import 'package:bhm_supermarket/app/localization/language_provider.dart';
import 'package:bhm_supermarket/app/widgets/app_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/widgets/loading_widget.dart';
import '../providers/category_provider.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final catProv = context.watch<CategoryProvider>();
    final isArabic = context.watch<LanguageProvider>().isArabic;

    if (catProv.isLoading) {
      return const SizedBox(height: 110, child: LoadingWidget());
    }

    final mainCategories = catProv.mainCategories;
    if (mainCategories.isEmpty) {
      return const SizedBox(
        height: 110,
        child: Center(
          child: Text('لا توجد أقسام متاحة',
              style: TextStyle(color: Colors.grey, fontSize: 13)),
        ),
      );
    }

    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: mainCategories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final category = mainCategories[index];

          return SizedBox(
            width: 85,
            child: InkWell(
              onTap: () => context.push(
                '${AppRoutes.categories}/${category.id}?name=${Uri.encodeComponent(isArabic ? category.nameAr : category.nameEn)}',
              ),
              borderRadius: BorderRadius.circular(18),
              child: Column(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: category.image.isEmpty
                        ? const Icon(Icons.category)
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: AppCachedImage(
                              imageUrl: category.imageUrl,
                            )),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isArabic ? category.nameAr : category.nameEn,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
