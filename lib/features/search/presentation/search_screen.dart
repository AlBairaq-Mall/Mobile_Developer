import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/search_provider.dart';
import '../widgets/search_app_bar.dart';
import '../widgets/search_result_card.dart';
import '../widgets/recent_searches.dart';
import '../widgets/empty_search.dart';
import '../../products/widgets/product_quick_view.dart';

/// خطأ كان موجود: استدعاء provider.search() داخل build() يسبب حلقة لانهائية
/// لأن search() تستدعي notifyListeners() مما يعيد تشغيل build() مجدداً.
/// الحل: إزالة الاستدعاء من build() والاعتماد على SearchAppBar → onChanged.
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                const SearchAppBar(),

                Expanded(
                  child: provider.query.isEmpty
                      ? const RecentSearches()
                      : provider.results.isEmpty
                      ? const EmptySearch()
                      : ListView.builder(
                          itemCount: provider.results.length,
                          itemBuilder: (context, index) {
                            return SearchResultCard(
                              product: provider.results[index],

                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (_) => ProductQuickView(
                                    product: provider.results[index],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

