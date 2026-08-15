import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/search_provider.dart';

class SearchAppBar extends StatelessWidget {
  const SearchAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<SearchProvider>();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: provider.controller,
        autofocus: true,

        onChanged: provider.updateQuery,

        // onChanged: (value) {
        //   provider.search(value);
        // },
        decoration: InputDecoration(
          hintText: 'ابحث عن منتج',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: provider.controller.text.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    provider.controller.clear();
                    provider.clear();
                  },
                ),
        ),
      ),
    );
  }
}
