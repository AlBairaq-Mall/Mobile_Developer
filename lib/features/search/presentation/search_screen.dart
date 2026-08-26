import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../core/design_system/components/app_icon.dart';
import '../../../core/design_system/patterns/app_responsive.dart';
import '../../../core/widgets/app_page_header.dart';
import '../../home/widgets/home_search_bar.dart';
import '../../products/widgets/product_card.dart';
import '../providers/search_provider.dart';
import '../widgets/empty_search.dart';
import '../widgets/recent_searches.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: const AppPageHeader(title: "البحث"),
          body: AppConstrainedContent(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.md,
                    AppSpacing.lg,
                    AppSpacing.sm,
                  ),
                  child: HomeSearchBar(
                    enableHero: false,
                    readOnly: false,
                    autofocus: true,
                    controller: provider.controller,
                    onChanged: provider.updateQuery,
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: provider.isLoading
                      ? const LinearProgressIndicator(minHeight: 2)
                      : const SizedBox(height: 2),
                ),
                Expanded(child: _SearchBody(provider: provider)),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SearchBody extends StatelessWidget {
  final SearchProvider provider;

  const _SearchBody({required this.provider});

  @override
  Widget build(BuildContext context) {
    if (provider.query.isEmpty) {
      return const RecentSearches();
    }

    if (!provider.isLoading && provider.results.isEmpty) {
      return EmptySearch(query: provider.query);
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.md,
          ),
          child: Row(
            children: [
              AppIcon(
                Icons.inventory_2_outlined,
                color: Theme.of(context).colorScheme.primary,
                size: AppIconSize.medium,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                "${provider.results.length} منتج",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = (constraints.maxWidth / 160).floor();
              if (crossAxisCount < 2) crossAxisCount = 2;

              return GridView.builder(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  0,
                  AppSpacing.lg,
                  AppSpacing.xxl,
                ),
                physics: const BouncingScrollPhysics(),
                itemCount: provider.results.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                  childAspectRatio: .63,
                ),
                itemBuilder: (_, index) {
                  return ProductCard(product: provider.results[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
