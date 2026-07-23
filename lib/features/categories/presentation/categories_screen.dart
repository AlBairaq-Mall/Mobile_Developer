import 'package:bhm_supermarket/app/localization/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../app/di/dependency_injection.dart';
import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/app_button.dart';
import '../../../core/models/category_model.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_widget.dart';
import '../providers/category_provider.dart';

/// All categories screen with main and sub-category navigation.
class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  CategoryModel? _selectedParent;

  void _navigate(CategoryModel cat) {
    context.push(
      '${AppRoutes.categories}/${cat.id}?name=${Uri.encodeComponent(
        cat.name,
      )}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final catProv = context.watch<CategoryProvider>();

    if (catProv.isLoading) {
      return const Scaffold(
        appBar: null,
        body: LoadingWidget(),
      );
    }

    if (catProv.error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('الأقسام')),
        body: EmptyState(
          emoji: '⚠️',
          title: 'تعذر تحميل الأقسام',
          subtitle: catProv.error,
          actionLabel: 'إعادة المحاولة',
          onAction: catProv.refresh,
        ),
      );
    }

    final mainCategories = catProv.mainCategories;
    if (mainCategories.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('الأقسام')),
        body: const EmptyState(
          emoji: '📂',
          title: 'لا توجد أقسام',
          subtitle: 'سيتم إضافة الأقسام قريباً',
        ),
      );
    }

    final selected = _selectedParent != null &&
            mainCategories.any((c) => c.id == _selectedParent!.id)
        ? _selectedParent!
        : mainCategories.first;
    final subs = catProv.subCategories(selected.id);

    return Scaffold(
      appBar: AppBar(title: const Text('الأقسام')),
      body: Row(
        children: [
          SizedBox(
            width: 100,
            child: ListView.builder(
              itemCount: mainCategories.length,
              itemBuilder: (_, i) {
                final cat = mainCategories[i];
                final isSelected = cat.id == selected.id;

                return GestureDetector(
                  onTap: () => setState(() => _selectedParent = cat),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : null,
                      border: isSelected
                          ? const Border(
                              right: BorderSide(
                                  color: AppColors.primary, width: 3),
                            )
                          : null,
                    ),
                    child: Text(
                      cat.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? AppColors.primary : null,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: subs.isEmpty
                ? GestureDetector(
                    onTap: () => _navigate(selected),
                    child: const Center(child: Text('عرض جميع المنتجات')),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.1,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: subs.length,
                    itemBuilder: (_, i) {
                      final sub = subs[i];
                      return GestureDetector(
                        onTap: () => _navigate(sub),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 6,
                                color: Color(0x0D000000),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.primary.withValues(alpha: 0.08),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.category_outlined,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                sub.name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
