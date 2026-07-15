import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_colors.dart';
import '../../cart/presentation/cart_screen.dart';
import '../../cart/providers/cart_provider.dart';
import '../../categories/presentation/categories_screen.dart';
import '../../favorites/presentation/favorites_screen.dart';
import '../../home/presentation/home_screen.dart';
import '../../profile/presentation/profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});
  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _index = 0;

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
    final cartCount = context.watch<CartProvider>().itemsCount;

    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(icon: Icons.home_rounded,       label: 'الرئيسية', index: 0, current: _index, onTap: _go),
                _NavItem(icon: Icons.grid_view_rounded,  label: 'الأقسام',  index: 1, current: _index, onTap: _go),
                _CartBtn(count: cartCount,               current: _index, onTap: _go),
                _NavItem(icon: Icons.favorite_rounded,   label: 'المفضلة', index: 3, current: _index, onTap: _go),
                _NavItem(icon: Icons.person_rounded,     label: 'حسابي',   index: 4, current: _index, onTap: _go),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _go(int i) => setState(() => _index = i);
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
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: sel ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: sel ? AppColors.primary : AppColors.textHint, size: 24),
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
    );
  }
}

// ── Cart Center Button ────────────────────────────────────────────
class _CartBtn extends StatelessWidget {
  final int count, current;
  final void Function(int) onTap;

  const _CartBtn({required this.count, required this.current, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final sel = current == 2;
    return GestureDetector(
      onTap: () => onTap(2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 52, height: 52,
                decoration: BoxDecoration(
                  gradient: sel
                      ? const LinearGradient(
                          colors: [AppColors.primary, AppColors.gradientEnd])
                      : null,
                  color: sel ? null : AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  Icons.shopping_cart_rounded,
                  color: sel ? Colors.white : AppColors.primary,
                  size: 26,
                ),
              ),
              if (count > 0)
                Positioned(
                  top: -4, left: -4,
                  child: Container(
                    width: 20, height: 20,
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
    );
  }
}
