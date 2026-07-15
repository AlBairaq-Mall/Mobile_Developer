import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/theme/app_spacing.dart';
import '../widgets/home_header.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/home_banner.dart';
import '../../categories/widgets/categories_section.dart';
import '../widgets/product_section.dart';
import '../providers/home_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: provider.refresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HomeHeader already handles notifications navigation
                const HomeHeader(),
                const SizedBox(height: 20),

                // HomeSearchBar already handles navigation to search
                const HomeSearchBar(),
                const SizedBox(height: 20),

                const HomeBanner(),
                const SizedBox(height: 28),

                const CategoriesSection(),
                const SizedBox(height: 28),

                if (provider.isLoading)
                  const Center(child: CircularProgressIndicator())
                else ...[
                  if (provider.bestSellerProducts.isNotEmpty) ...[
                    ProductSection(
                      title: 'الأكثر مبيعاً',
                      products: provider.bestSellerProducts,
                    ),
                    const SizedBox(height: 28),
                  ],

                  if (provider.flashDeals.isNotEmpty) ...[
                    ProductSection(
                      title: 'عروض اليوم 🔥',
                      products: provider.flashDeals,
                    ),
                    const SizedBox(height: 28),
                  ],

                  if (provider.recommendedProducts.isNotEmpty)
                    ProductSection(
                      title: 'مقترحة لك',
                      products: provider.recommendedProducts,
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
