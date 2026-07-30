// import 'package:bhm_supermarket/features/products/providers/product_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../app/theme/app_colors.dart';
// import '../../../app/widgets/app_button.dart';
// import '../../../app/widgets/app_card.dart';
// import '../../../app/widgets/app_cached_image.dart';
// import '../../../app/widgets/app_price.dart';
// import '../../../core/models/product_model.dart';
// import '../../cart/providers/cart_provider.dart';
// import '../../favorites/providers/favorites_provider.dart';
// import '../widgets/product_details_sheet.dart';

// class ProductCard extends StatelessWidget {
//   final ProductModel product;
//   const ProductCard({super.key, required this.product});

//   @override
//   Widget build(BuildContext context) {
//     final favProvider = context.watch<FavoritesProvider>();
//     final isFav = favProvider.isFavorite(product.id);

//     return GestureDetector(
//       onTap: () => showModalBottomSheet(
//         context: context,
//         isScrollControlled: true,
//         backgroundColor: Colors.transparent,
//         builder: (_) => DraggableScrollableSheet(
//           expand: false,
//           initialChildSize: 0.92,
//           maxChildSize: 0.95,
//           minChildSize: 0.5,
//           builder: (_, sc) => Container(
//             decoration: BoxDecoration(
//               color: Theme.of(context).colorScheme.surface,
//               borderRadius:
//                   const BorderRadius.vertical(top: Radius.circular(28)),
//             ),
//             child: ProductDetailsSheet(product: product),
//           ),
//         ),
//       ),
//       child: AppCard(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Image + Badges
//             Stack(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(16),
//                   child: Container(
//                     height: 130,
//                     width: double.infinity,
//                     color: AppColors.background,
//                     child: product.image.isEmpty
//                         ? const Center(
//                             child: Text('🛍️', style: TextStyle(fontSize: 50)))
//                         : AppCachedImage(
//                             imageUrl: product.image, fit: BoxFit.contain),
//                   ),
//                 ),
//                 // Flash deal badge
//                 if (product.isFlashDeal)
//                   Positioned(
//                     top: 8,
//                     right: 8,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 8, vertical: 3),
//                       decoration: BoxDecoration(
//                         color: AppColors.error,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: const Text('🔥 خصم',
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 10,
//                               fontWeight: FontWeight.bold)),
//                     ),
//                   ),
//                 // Best seller badge
//                 if (product.isBestSeller && !product.isFlashDeal)
//                   Positioned(
//                     top: 8,
//                     right: 8,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 8, vertical: 3),
//                       decoration: BoxDecoration(
//                         color: AppColors.accent,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: const Text('⭐ الأكثر',
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 10,
//                               fontWeight: FontWeight.bold)),
//                     ),
//                   ),
//                 // Favorite
//                 Positioned(
//                   top: 6,
//                   left: 6,
//                   child: GestureDetector(
//                     onTap: () => favProvider.toggle(product.id),
//                     child: Container(
//                       width: 32,
//                       height: 32,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                               color: Colors.black.withOpacity(0.08),
//                               blurRadius: 8)
//                         ],
//                       ),
//                       child: Icon(
//                         isFav
//                             ? Icons.favorite_rounded
//                             : Icons.favorite_border_rounded,
//                         color: isFav ? AppColors.error : AppColors.textHint,
//                         size: 17,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // Name
//                     Text(
//                       product.name,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(
//                           fontSize: 13,
//                           fontWeight: FontWeight.bold,
//                           height: 1.3),
//                     ),

//                     // Brand
//                     if (product.brand.isNotEmpty)
//                       Text(
//                         product.brand,
//                         style: const TextStyle(
//                             fontSize: 11, color: AppColors.textHint),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),

//                     // Price + Add
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Expanded(
//                           child: AppPrice(
//                             price: product.price,
//                             oldPrice: product.oldPrice,
//                           ),
//                         ),
//                         GestureDetector(
//                           onTap: () async {
//                             final provider = context.read<ProductProvider>();

//                             await provider.loadProduct(product.id);

//                             if (provider.selectedUnit == null) return;

//                             context.read<CartProvider>().add(product);

//                             if (!context.mounted) return;

//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content: Text('تمت إضافة ${product.name}'),
//                                 backgroundColor: AppColors.primary,
//                                 behavior: SnackBarBehavior.floating,
//                               ),
//                             );
//                           },
//                           child: Container(
//                             width: 34,
//                             height: 34,
//                             decoration: BoxDecoration(
//                               color: AppColors.primary,
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: const Icon(Icons.add_rounded,
//                                 color: Colors.white, size: 20),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/app_cached_image.dart';
import '../../../app/widgets/app_card.dart';
import '../../../app/widgets/app_price.dart';
import '../../../core/models/product_model.dart';
import '../../cart/providers/cart_provider.dart';
import '../../favorites/providers/favorites_provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_details_sheet.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final favProvider = context.watch<FavoritesProvider>();
    final isFav = favProvider.isFavorite(product.id);

    return Hero(
      tag: product.id,
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => DraggableScrollableSheet(
              expand: false,
              initialChildSize: .92,
              maxChildSize: .95,
              minChildSize: .5,
              builder: (_, sc) {
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(28),
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
        child: AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //----------------------------------------------------
              // الصورة
              //----------------------------------------------------
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: SizedBox(
                      height: 120,
                      width: double.infinity,
                      child: product.image.isEmpty
                          ? Container(
                              color: Colors.grey.shade100,
                              child: const Icon(
                                Icons.image_outlined,
                                size: 70,
                                color: Colors.grey,
                              ),
                            )
                          : AppCachedImage(
                              imageUrl: product.image,
                              // fit: BoxFit.cover,
                              fit: BoxFit.contain,
                            ),
                    ),
                  ),

                  //------------------------------------------
                  // الخصم
                  //------------------------------------------
                  if (product.isFlashDeal)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                            )
                          ],
                        ),
                        child: const Text(
                          "🔥 خصم",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  if (product.isBestSeller && !product.isFlashDeal)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                            )
                          ],
                        ),
                        child: const Text(
                          "⭐ الأكثر",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  //------------------------------------------
                  // المفضلة
                  //------------------------------------------
                  Positioned(
                    top: 8,
                    left: 8,
                    child: GestureDetector(
                      onTap: () {
                        favProvider.toggle(product.id);
                      },
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.08),
                              blurRadius: 8,
                            )
                          ],
                        ),
                        child: Icon(
                          isFav
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          size: 12,
                          color: isFav ? Colors.red : Colors.grey.shade500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //------------------------------------
                      // اسم المنتج
                      //------------------------------------
                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                        ),
                      ),

                      const SizedBox(height: 3),

                      //------------------------------------
                      // الماركة
                      //------------------------------------
                      if (product.brand.isNotEmpty)
                        Text(
                          product.brand,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 9,
                            color: Colors.grey.shade600,
                          ),
                        ),

                      const SizedBox(height: 6),

                      //------------------------------------
                      // السعر + السلة
                      //------------------------------------
                      Row(
                        children: [
                          Expanded(
                            child: AppPrice(
                              price: product.price,
                              oldPrice: product.oldPrice,
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: () async {
                                final provider =
                                    context.read<ProductProvider>();

                                await provider.loadProduct(product.id);

                                if (provider.selectedUnit == null) {
                                  return;
                                }

                                context.read<CartProvider>().add(product);

                                if (!context.mounted) {
                                  return;
                                }

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("تمت إضافة ${product.name}"),
                                    backgroundColor: AppColors.primary,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              child: Ink(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(.30),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.add_shopping_cart_rounded,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
