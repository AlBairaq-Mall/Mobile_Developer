import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_radius.dart';
import '../../favorites/providers/favorites_provider.dart';
import '../../../core/models/product_model.dart';
import '../widgets/product_details_sheet.dart';
import 'product_card_container.dart';
import 'product_favorite_button.dart';
import 'product_image.dart';
import 'product_info.dart';
import 'product_cart_control.dart';
import '../../auth/utils/auth_gate.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // select: only rebuilds this card when THIS product's favorite state changes.
    final isFavorite = context.select<FavoritesProvider, bool>(
      (f) => f.isFavorite(product.id),
    );

    return ProductCardContainer(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (_) => DraggableScrollableSheet(
            expand: false,
            initialChildSize: .92,
            maxChildSize: .96,
            minChildSize: .55,
            builder: (_, __) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppRadius.sheet),
                  ),
                ),
                child: ProductDetailsSheet(product: product),
              );
            },
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 180,
            child: Stack(
              children: [
                Positioned.fill(
                  child: ProductImage(
                    image: product.image,
                    heroTag: 'product_${product.id}',
                  ),
                ),

                /// Favorite
                PositionedDirectional(
                  top: 8,
                  end: 8,
                  child: ProductFavoriteButton(
                    isFavorite: isFavorite,
                    onTap: () {
                      AuthGate.check(
                        context,
                        onAuthenticated: () {
                          context.read<FavoritesProvider>().toggle(product.id);
                        },
                      );
                    },
                  ),
                ),



                /// Add button (Removed from here, now unified inside ProductInfo)
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 4, 10, 10),
              child: ProductInfo(
                product: product,
                quantityWidget: ProductCartControl(product: product),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
