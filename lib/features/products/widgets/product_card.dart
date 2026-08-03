import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_shadows.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/widgets/app_cached_image.dart';
import '../../../app/widgets/app_card.dart';
import '../../../app/widgets/app_price.dart';
import '../../../core/models/product_model.dart';
import '../../cart/providers/cart_provider.dart';
import '../../favorites/providers/favorites_provider.dart';
import '../widgets/product_details_sheet.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>();
    final isFavorite = favorites.isFavorite(product.id);

    return AppCard(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
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
                child: ProductDetailsSheet(
                  product: product,
                ),
              );
            },
          ),
        );
      },
      child: Column(
        children: [
          //--------------------------------------------------
          // IMAGE
          //--------------------------------------------------

          Expanded(
            flex: 15,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: AppSpacing.md,
                      left: AppSpacing.md,
                      right: AppSpacing.md,
                    ),
                    child: Hero(
                      tag: 'product_${product.id}',
                      child: AppCachedImage(
                        imageUrl: product.image,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                //------------------------------------------------
                // OFFER
                //------------------------------------------------

                if (product.isFlashDeal)
                  PositionedDirectional(
                    top: AppSpacing.sm,
                    end: AppSpacing.sm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.badgeSale,
                        borderRadius: BorderRadius.circular(
                          AppRadius.chip,
                        ),
                      ),
                      child: Text(
                        "عرض السوبر",
                        style: AppTypography.badge,
                      ),
                    ),
                  ),

                if (product.isBestSeller && !product.isFlashDeal)
                  PositionedDirectional(
                    top: AppSpacing.sm,
                    end: AppSpacing.sm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.badgeBest,
                        borderRadius: BorderRadius.circular(
                          AppRadius.chip,
                        ),
                      ),
                      child: Text(
                        "الأكثر",
                        style: AppTypography.badge,
                      ),
                    ),
                  ),

                //------------------------------------------------
                // FAVORITE
                //------------------------------------------------

                PositionedDirectional(
                  top: AppSpacing.sm,
                  start: AppSpacing.sm,
                  child: Material(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    elevation: 2,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () {
                        favorites.toggle(product.id);
                      },
                      child: SizedBox(
                        width: 34,
                        height: 34,
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite
                              ? AppColors.favorite
                              : AppColors.textHint,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                //------------------------------------------------
                // ADD BUTTON
                //------------------------------------------------

                PositionedDirectional(
                  bottom: -10,
                  start: AppSpacing.md,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(
                        AppRadius.button,
                      ),
                      onTap: () async {
                        final response =
                            await context.read<CartProvider>().add(product);

                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              response.isSuccess
                                  ? "تمت إضافة ${product.name}"
                                  : response.message,
                            ),
                            backgroundColor: response.isSuccess
                                ? AppColors.primary
                                : AppColors.error,
                          ),
                        );
                      },
                      child: Ink(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(
                            AppRadius.button,
                          ),
                          boxShadow: AppShadows.floating,
                        ),
                        child: const Icon(
                          Icons.add_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          //--------------------------------------------------
          // CONTENT
          //--------------------------------------------------

          Expanded(
            flex: 8,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (product.brand.isNotEmpty)
                    Text(
                      product.brand,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.productBrand.copyWith(
                        color: AppColors.textHint,
                      ),
                    ),
                  const SizedBox(
                    height: AppSpacing.xs,
                  ),
                  SizedBox(
                    height: 38,
                    child: Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.productName,
                    ),
                  ),
                  const Spacer(),
                  AppPrice(
                    price: product.price,
                    oldPrice: product.oldPrice,
                  ),
                  const SizedBox(
                    height: AppSpacing.xs,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
