import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bhm_supermarket/features/ads/providers/ads_provider.dart';
import 'package:bhm_supermarket/features/ads/providers/offers_provider.dart';
import 'package:bhm_supermarket/features/categories/providers/category_provider.dart';
import 'package:bhm_supermarket/features/categories/widgets/categories_pinned.dart';

import '../../../app/theme/app_spacing.dart';
import '../providers/home_provider.dart';
import '../widgets/home_banner.dart';
import '../widgets/home_header.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/product_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isRefreshing = false;

  Future<void> _refreshHome() async {
    if (_isRefreshing) return;
    _isRefreshing = true;
    assert(() {
      debugPrint('========== HOME REFRESH START ==========');
      return true;
    }());

    try {
      await Future.wait([
        context.read<HomeProvider>().refresh(),
        context.read<CategoryProvider>().refresh(),
        context.read<AdsProvider>().refresh(),
        context.read<OffersProvider>().refresh(),
      ]);

      assert(() {
        debugPrint('========== HOME REFRESH DONE ==========');
        return true;
      }());
    } catch (e, stackTrace) {
      assert(() {
        debugPrint('========== HOME REFRESH ERROR: $e ==========');
        debugPrintStack(stackTrace: stackTrace);
        return true;
      }());
    } finally {
      if (mounted) {
        _isRefreshing = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          // NestedScrollView يدير OuterScrollView (headers) + InnerScrollView (body).
          // يجب أن يكون RefreshIndicator على الـ inner scroll view مباشرةً
          // وليس على NestedScrollView ككل — هذا هو سبب عدم عمل pull-to-refresh.
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          headerSliverBuilder: (
            BuildContext context,
            bool innerBoxIsScrolled,
          ) {
            return [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: 6,
                  ),
                  child: const Column(
                    children: [
                      HomeHeader(),
                      SizedBox(height: AppSpacing.lg),
                      HomeBanner(),
                    ],
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: const _SearchDelegate(),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: const _CategoriesDelegate(),
              ),
            ];
          },
          // RefreshIndicator على الـ inner CustomScrollView مباشرةً
          body: RefreshIndicator(
            displacement: 50,
            onRefresh: _refreshHome,
            child: const _HomeBody(),
          ),
        ),
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();

    // ── أول تحميل — spinner ─────────────────────────────────────────────────
    if (provider.state == HomeLoadState.loading ||
        provider.state == HomeLoadState.initial) {
      return const CustomScrollView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: CircularProgressIndicator()),
          ),
        ],
      );
    }

    // ── فشل التحميل ويجب ألا تكون هناك بيانات قديمة (أول محاولة) ──────────
    if (provider.state == HomeLoadState.error && provider.products.isEmpty) {
      return CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.wifi_off_rounded,
                      size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'تعذر تحميل المنتجات',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    provider.error ?? 'تحقق من اتصالك بالإنترنت وأعد المحاولة',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () =>
                        context.read<HomeProvider>().loadProducts(),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    // ── نجاح التحميل + لا يوجد منتجات (حقاً فارغ من الـ Backend) ──────────
    if (provider.state == HomeLoadState.empty) {
      return CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.inventory_2_outlined,
                      size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'لا توجد منتجات حالياً',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'سيتم إضافة منتجات قريباً',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    // ── success أو refreshing (نعرض البيانات الموجودة) ─────────────────────
    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        // banner خطأ صغير عند فشل refresh (البيانات القديمة ما زالت ظاهرة)
        if (provider.state == HomeLoadState.error)
          SliverToBoxAdapter(
            child: Container(
              color: Colors.orange.shade50,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: Colors.orange, size: 18),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'تعذر تحديث المنتجات — تعرض بيانات قديمة',
                      style: TextStyle(fontSize: 12, color: Colors.orange),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    onPressed: () => context.read<HomeProvider>().refresh(),
                    child: const Text('إعادة', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
          ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            10,
            AppSpacing.lg,
            AppSpacing.xxl,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // ============================================================
              // HOME MODE
              // لا يوجد قسم محدد ولا بحث
              // ============================================================
              if (provider.selectedCategory.isEmpty) ...[
                if (provider.flashDeals.isNotEmpty) ...[
                  ProductSection(
                    title: 'العروض',
                    products: provider.flashDeals,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
                if (provider.bestSellerProducts.isNotEmpty) ...[
                  ProductSection(
                    title: 'الأكثر مبيعاً',
                    products: provider.bestSellerProducts,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
                if (provider.recommendedProducts.isNotEmpty) ...[
                  ProductSection(
                    title: 'مختارة لك',
                    products: provider.recommendedProducts,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ],

              // ============================================================
              // PRODUCTS / CATEGORY / SEARCH MODE
              // ============================================================
              if (provider.products.isNotEmpty)
                ProductSection(
                  title: provider.selectedCategory.isNotEmpty
                      ? 'منتجات القسم'
                      : 'جميع المنتجات',
                  products: provider.products,
                ),

              const SizedBox(height: AppSpacing.xxl),
            ]),
          ),
        ),
      ],
    );
  }
}

class _SearchDelegate extends SliverPersistentHeaderDelegate {
  const _SearchDelegate();

  @override
  double get minExtent => 64;

  @override
  double get maxExtent => 64;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(
      elevation: overlapsContent ? 2 : 0,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            8,
            AppSpacing.lg,
            8,
          ),
          child: const HomeSearchBar(enableHero: true),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _SearchDelegate oldDelegate) => false;
}

class _CategoriesDelegate extends SliverPersistentHeaderDelegate {
  const _CategoriesDelegate();

  @override
  double get minExtent => 128;

  @override
  double get maxExtent => 128;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      elevation: overlapsContent ? 3 : 0,
      child: const SafeArea(bottom: false, child: CategoriesPinned()),
    );
  }

  @override
  bool shouldRebuild(covariant _CategoriesDelegate oldDelegate) {
    return false;
  }
}
