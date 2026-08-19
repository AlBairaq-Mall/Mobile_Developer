// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// import '../../../app/router/app_routes.dart';
// import '../../../app/theme/app_colors.dart';
// import '../../../app/theme/app_radius.dart';
// import '../../../app/theme/app_shadows.dart';
// import '../../../app/theme/app_spacing.dart';
// import '../../../app/theme/app_typography.dart';

// class HomeSearchBar extends StatelessWidget {
//   final bool enableHero;
//   final TextEditingController? controller;
//   final ValueChanged<String>? onChanged;
//   final VoidCallback? onTap;
//   final bool readOnly;
//   final String hint;
//   const HomeSearchBar({
//     super.key,
//     this.enableHero = true,
//     this.controller,
//     this.onChanged,
//     this.onTap,
//     this.readOnly = false,
//     this.hint = "ابحث عن أي منتج...",
//   });

//   @override
//   Widget build(BuildContext context) {
//     final widget = Material(
//       color: Colors.transparent,
//       child: InkWell(
//         borderRadius: BorderRadius.circular(AppRadius.pill),
//         onTap: () => context.push(AppRoutes.search),
//         child: Ink(
//           height: 48,
//           decoration: BoxDecoration(
//             color: AppColors.surface,
//             borderRadius: BorderRadius.circular(AppRadius.pill),
//             boxShadow: AppShadows.search,
//             border: Border.all(
//               color: AppColors.border.withValues(alpha: .35),
//             ),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(
//               horizontal: AppSpacing.sm,
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   width: 38,
//                   height: 38,
//                   decoration: BoxDecoration(
//                     color: AppColors.primarySoft,
//                     borderRadius: BorderRadius.circular(AppRadius.pill),
//                   ),
//                   child: const Icon(
//                     Icons.search_rounded,
//                     size: 20,
//                     color: AppColors.primary,
//                   ),
//                 ),
//                 const SizedBox(width: AppSpacing.md),
//                 Expanded(
//                   child: Text(
//                     "ابحث عن أي منتج...",
//                     style: AppTypography.bodyMedium.copyWith(
//                       color: AppColors.textHint,
//                     ),
//                   ),
//                 ),
//                 // زر الفلتره داخل السيرتش بار

//                 // Container(
//                 //   width: 38,
//                 //   height: 38,
//                 //   decoration: BoxDecoration(
//                 //     gradient: AppColors.primaryGradient,
//                 //     borderRadius: BorderRadius.circular(AppRadius.pill),
//                 //   ),
//                 //   child: const Icon(
//                 //     Icons.tune_rounded,
//                 //     color: Colors.white,
//                 //     size: 18,
//                 //   ),
//                 // ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );

//     return enableHero
//         ? Hero(
//             tag: 'home_search',
//             child: widget,
//           )
//         : widget;
//   }
// }
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_shadows.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';

class HomeSearchBar extends StatelessWidget {
  final bool enableHero;

  /// عند readOnly=true يعمل مثل الصفحة الرئيسية
  final bool readOnly;

  /// عند false يصبح TextField حقيقي
  final TextEditingController? controller;

  final ValueChanged<String>? onChanged;

  final VoidCallback? onTap;

  final String hint;

  final bool autofocus;

  const HomeSearchBar({
    super.key,
    this.enableHero = true,
    this.readOnly = true,
    this.controller,
    this.onChanged,
    this.onTap,
    this.hint = "ابحث عن أي منتج...",
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final child = Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColors.border.withValues(alpha: .35)),
        boxShadow: AppShadows.search,
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        readOnly: readOnly,
        autofocus: autofocus,
        textInputAction: TextInputAction.search,
        onTap: readOnly
            ? (onTap ??
                () {
                  context.push(AppRoutes.search);
                })
            : null,
        style: AppTypography.bodyMedium,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 13,
          ),
          hintText: hint,
          hintStyle: AppTypography.bodyMedium.copyWith(
            color: AppColors.textHint,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: const Icon(
              Icons.search_rounded,
              size: 20,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );

    if (!enableHero) return child;

    return Hero(
      tag: "home_search",
      child: Material(color: Colors.transparent, child: child),
    );
  }
}
