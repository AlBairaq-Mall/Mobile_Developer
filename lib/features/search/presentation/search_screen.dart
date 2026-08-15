import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
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
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          child: Row(
            children: [
              Icon(
                Icons.inventory_2_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                "${provider.results.length} منتج",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
            physics: const BouncingScrollPhysics(),
            itemCount: provider.results.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: .63,
            ),
            itemBuilder: (_, index) {
              return ProductCard(product: provider.results[index]);
            },
          ),
        ),
      ],
    );
  }
}
