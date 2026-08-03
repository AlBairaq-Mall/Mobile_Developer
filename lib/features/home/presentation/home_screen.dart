import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/theme/app_spacing.dart';
import '../../categories/widgets/categories_section.dart';
import '../providers/home_provider.dart';
import '../widgets/home_banner.dart';
import '../widgets/home_header.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/product_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: provider.refresh,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      //----------------------------------------------------
                      // Header
                      //----------------------------------------------------

                      const HomeHeader(),

                      const SizedBox(height: AppSpacing.lg),

                      //----------------------------------------------------
                      // Search
                      //----------------------------------------------------

                      const HomeSearchBar(),

                      const SizedBox(height: AppSpacing.xl),

                      //----------------------------------------------------
                      // Banner
                      //----------------------------------------------------

                      const HomeBanner(),

                      const SizedBox(height: AppSpacing.xl),

                      //----------------------------------------------------
                      // Categories
                      //----------------------------------------------------

                      const CategoriesSection(),

                      const SizedBox(height: AppSpacing.xl),

                      //----------------------------------------------------
                      // Loading
                      //----------------------------------------------------

                      if (provider.isLoading)
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: AppSpacing.xxl,
                          ),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),

                      //----------------------------------------------------
                      // Content
                      //----------------------------------------------------

                      if (!provider.isLoading) ...[
                        if (provider.flashDeals.isNotEmpty) ...[
                          ProductSection(
                            title: 'العروض',
                            products: provider.flashDeals.take(4).toList(),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                        ],
                        if (provider.bestSellerProducts.isNotEmpty) ...[
                          ProductSection(
                            title: 'الأكثر مبيعاً',
                            products:
                                provider.bestSellerProducts.take(4).toList(),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                        ],
                        if (provider.recommendedProducts.isNotEmpty) ...[
                          ProductSection(
                            title: 'مختارة لك',
                            products:
                                provider.recommendedProducts.take(4).toList(),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                        ],
                        if (provider.products.isNotEmpty)
                          ProductSection(
                            title: 'جميع المنتجات',
                            products: provider.products,
                          ),
                        const SizedBox(height: AppSpacing.xxl),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
