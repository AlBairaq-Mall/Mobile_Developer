// import 'package:flutter/material.dart';

// class EmptySearch extends StatelessWidget {
//   const EmptySearch({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.search, size: 90, color: Colors.grey.shade400),
//           const SizedBox(height: 20),
//           Text(
//             "ابحث عن أي منتج",
//             style: Theme.of(context).textTheme.titleMedium,
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class EmptySearch extends StatelessWidget {
  final String query;

  const EmptySearch({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 90,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 22),
            Text(
              "لا توجد نتائج",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Text(
              'لم نعثر على "$query"',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              "جرّب البحث باسم آخر أو بالباركود أو باسم القسم.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
