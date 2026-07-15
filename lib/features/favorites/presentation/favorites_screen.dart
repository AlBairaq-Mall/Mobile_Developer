import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/empty_state.dart';
import '../../cart/providers/cart_provider.dart';
import '../providers/favorites_provider.dart';
import '../../products/widgets/product_card.dart';

/// Favorites screen backed by [FavoritesProvider].
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favProv = context.watch<FavoritesProvider>();
    final cartProv = context.read<CartProvider>();
    final favProducts = favProv.products;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('المفضلة'),
            if (favProducts.isNotEmpty) ...[
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(10)),
                child: Text('${favProducts.length}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ],
        ),
        actions: [
          if (favProducts.isNotEmpty)
            TextButton.icon(
              onPressed: () {
                for (final p in favProducts) {
                  cartProv.add(p);
                }
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content:
                      Text('تمت إضافة ${favProducts.length} منتج للسلة'),
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                ));
              },
              icon: const Icon(Icons.shopping_cart_outlined, size: 16),
              label: const Text('نقل الكل للسلة',
                  style: TextStyle(fontSize: 12)),
            ),
        ],
      ),
      body: favProducts.isEmpty
          ? const EmptyState(
              emoji: '♥',
              title: 'المفضلة فارغة',
              subtitle: 'اضغط على قلب أي منتج لإضافته هنا',
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (_, i) => ProductCard(product: favProducts[i]),
            ),
    );
  }
}
