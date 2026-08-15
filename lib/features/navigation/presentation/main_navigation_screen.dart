import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_colors.dart';
import '../../cart/presentation/cart_screen.dart';
import '../../cart/providers/cart_provider.dart';
import '../../categories/presentation/categories_screen.dart';
import '../../favorites/presentation/favorites_screen.dart';
import '../../home/presentation/home_screen.dart';
import '../../profile/presentation/profile_screen.dart';
import '../providers/navigation_provider.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});
  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  // 5 screens: 0=Home 1=Categories 2=Cart 3=Favorites 4=Profile
  static const _screens = [
    HomeScreen(),
    CategoriesScreen(),
    CartScreen(),
    FavoritesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // select: rebuilds only when the cart badge count changes, not on every cart mutation.
    final cartCount = context.select<CartProvider, int>((c) => c.itemsCount);
    final navigation = context.watch<NavigationProvider>();

    return Scaffold(
      body: IndexedStack(
        index: navigation.index,
        children: [
          for (var i = 0; i < _screens.length; i++)
            HeroMode(enabled: i == navigation.index, child: _screens[i]),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
          child: Container(
            height: 74,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .16),
                  blurRadius: 45,
                  spreadRadius: 1,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(
                    icon: Icons.home_rounded,
                    label: 'الرئيسية',
                    index: 0,
                    current: navigation.index,
                    onTap: (i) => _go(context, i),
                  ),
                  _NavItem(
                    icon: Icons.grid_view_rounded,
                    label: 'الأقسام',
                    index: 1,
                    current: navigation.index,
                    onTap: (i) => _go(context, i),
                  ),
                  _CartBtn(
                    count: cartCount,
                    current: navigation.index,
                    onTap: (i) => _go(context, i),
                  ),
                  _NavItem(
                    icon: Icons.favorite_rounded,
                    label: 'المفضلة',
                    index: 3,
                    current: navigation.index,
                    onTap: (i) => _go(context, i),
                  ),
                  _NavItem(
                    icon: Icons.person_rounded,
                    label: 'حسابي',
                    index: 4,
                    current: navigation.index,
                    onTap: (i) => _go(context, i),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _go(BuildContext context, int i) {
    context.read<NavigationProvider>().changeTab(i);
  }
}

// ── Regular Nav Item ──────────────────────────────────────────────
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index, current;
  final void Function(int) onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final sel = index == current;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTap(index),
        borderRadius: BorderRadius.circular(14),
        child: AnimatedScale(
          scale: sel ? 1.05 : 1,
          duration: const Duration(milliseconds: 180),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: sel
                  ? AppColors.primary.withValues(alpha: .08)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: Icon(
                    icon,
                    key: ValueKey(sel),
                    size: 26,
                    color: sel ? AppColors.primary : AppColors.textHint,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: sel ? AppColors.primary : AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Cart Center Button ────────────────────────────────────────────
class _CartBtn extends StatelessWidget {
  final int count, current;
  final void Function(int) onTap;

  const _CartBtn({
    required this.count,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final sel = current == 2;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => onTap(2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedScale(
                  scale: sel ? 1.05 : 1,
                  duration: const Duration(milliseconds: 180),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: sel
                          ? const LinearGradient(
                              colors: [AppColors.primary, AppColors.brand],
                            )
                          : null,
                      color: sel
                          ? null
                          : AppColors.primary.withValues(alpha: .08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.shopping_cart_rounded,
                      color: sel ? Colors.white : AppColors.primary,
                      size: 26,
                    ),
                  ),
                ),
                if (count > 0)
                  PositionedDirectional(
                    top: -2,
                    end: -2,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$count',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              'السلة',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: sel ? AppColors.primary : AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
