import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/search_provider.dart';

class RecentSearches extends StatelessWidget {
  const RecentSearches({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SearchProvider>();

    if (provider.recentSearches.isEmpty) {
      return const SizedBox();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: provider.recentSearches.length,
      itemBuilder: (_, index) {
        final item = provider.recentSearches[index];

        return ListTile(
          leading: const Icon(Icons.history),
          title: Text(item),
          trailing: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              provider.removeRecent(item);
            },
          ),
          onTap: () {
            provider.search(item);
          },
        );
      },
    );
  }
}
