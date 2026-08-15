// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../providers/search_provider.dart';

// class RecentSearches extends StatelessWidget {
//   const RecentSearches({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<SearchProvider>();

//     if (provider.recentSearches.isEmpty) {
//       return const SizedBox();
//     }

//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: provider.recentSearches.length,
//       itemBuilder: (_, index) {
//         final item = provider.recentSearches[index];

//         return ListTile(
//           leading: const Icon(Icons.history),
//           title: Text(item),
//           trailing: IconButton(
//             icon: const Icon(Icons.close),
//             onPressed: () {
//               provider.removeRecent(item);
//             },
//           ),
//           onTap: () {
//             provider.search(item);
//           },
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/theme/app_spacing.dart';
import '../providers/search_provider.dart';

class RecentSearches extends StatelessWidget {
  const RecentSearches({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SearchProvider>();

    if (provider.recentSearches.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_rounded, size: 70, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              "ابدأ بكتابة اسم المنتج",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(
              "يمكنك البحث بالاسم أو الباركود أو القسم",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.sm,
          ),
          child: Row(
            children: [
              Text(
                "عمليات البحث الأخيرة",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              TextButton(
                onPressed: provider.clearRecentSearches,
                child: const Text("مسح الكل"),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemCount: provider.recentSearches.length,
            separatorBuilder: (_, __) =>
                Divider(height: 1, color: Colors.grey.shade200),
            itemBuilder: (_, index) {
              final item = provider.recentSearches[index];

              return ListTile(
                leading: const Icon(Icons.history),
                title: Text(item),
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => provider.removeRecent(item),
                ),
                onTap: () {
                  provider.controller.text = item;

                  provider.controller.selection = TextSelection.collapsed(
                    offset: item.length,
                  );

                  provider.search(item);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
