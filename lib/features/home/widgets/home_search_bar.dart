import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_colors.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.search),
      child: AbsorbPointer(
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              const Icon(Icons.search_rounded,
                  color: AppColors.primary, size: 22),
              const SizedBox(width: 10),
              Text(
                'ابحث عن منتج...',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.outline,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              Container(
                margin: const EdgeInsets.all(6),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'بحث',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
