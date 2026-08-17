// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../../app/theme/app_colors.dart';
// import '../../../app/theme/app_typography.dart';
// import '../../../app/widgets/app_price.dart';
// import '../../../core/models/product_model.dart';
// import '../../ads/models/offer_model.dart';
// import '../../ads/providers/offers_provider.dart';

// class ProductInfo extends StatelessWidget {
//   final ProductModel product;
//   final Widget? quantityWidget;

//   const ProductInfo({super.key, required this.product, this.quantityWidget});

//   @override
//   Widget build(BuildContext context) {
//     final rtl = Directionality.of(context) == TextDirection.rtl;

//     final defaultUnit = product.units.isEmpty
//         ? null
//         : product.units.firstWhere(
//             (unit) => unit.isDefault,
//             orElse: () => product.units.first,
//           );

//     final offerUnit = context.select<OffersProvider, OfferProductUnitModel?>(
//       (offers) => defaultUnit == null
//           ? null
//           : offers.productUnitOffer(
//               productId: product.id,
//               unitId: defaultUnit.id,
//             ),
//     );

//     final price = offerUnit?.price ?? product.price;

//     final double? oldPrice = offerUnit?.hasDiscount == true
//         ? offerUnit?.oldPrice
//         : product.oldPrice;

//     final hasDiscount = oldPrice != null && oldPrice > price;

//     final info = Expanded(
//       child: Padding(
//         padding: EdgeInsetsDirectional.only(
//           start: rtl ? 0 : 2,
//           end: rtl ? 2 : 0,
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Product name
//             Text(
//               product.name,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//               textAlign: rtl ? TextAlign.right : TextAlign.left,
//               style: AppTypography.bodyMedium.copyWith(
//                 fontWeight: FontWeight.w700,
//               ),
//             ),

//             const SizedBox(height: 4),

//             // Unit + old price
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 if (product.package.isNotEmpty)
//                   Expanded(
//                     child: Text(
//                       '${product.package} ${product.unit}',
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       textAlign: rtl ? TextAlign.right : TextAlign.left,
//                       style: AppTypography.caption.copyWith(
//                         color: AppColors.textHint,
//                       ),
//                     ),
//                   )
//                 else
//                   const Spacer(),
//                 if (hasDiscount) ...[
//                   const SizedBox(width: 6),
//                   Flexible(
//                     child: Text(
//                       '${oldPrice.toStringAsFixed(0)} ر.ي',
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       textAlign: rtl ? TextAlign.left : TextAlign.right,
//                       style: AppTypography.caption.copyWith(
//                         color: AppColors.discount,
//                         decoration: TextDecoration.lineThrough,
//                         decorationColor: AppColors.discount,
//                       ),
//                     ),
//                   ),
//                 ],
//               ],
//             ),

//             const SizedBox(height: 2),

//             // Current price
//             Align(
//               alignment: rtl ? Alignment.centerRight : Alignment.centerLeft,
//               child: AppPrice(
//                 price: price,
//                 crossAxisAlignment: rtl
//                     ? CrossAxisAlignment.end
//                     : CrossAxisAlignment.start,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );

//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: rtl
//           ? [
//               info,
//               if (quantityWidget != null) ...[
//                 const SizedBox(width: 10),
//                 quantityWidget!,
//               ],
//             ]
//           : [
//               if (quantityWidget != null) ...[
//                 quantityWidget!,
//                 const SizedBox(width: 10),
//               ],
//               info,
//             ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/widgets/app_price.dart';
import '../../../core/models/product_model.dart';
import '../../ads/models/offer_model.dart';
import '../../ads/providers/offers_provider.dart';

class ProductInfo extends StatelessWidget {
  final ProductModel product;
  final Widget? quantityWidget;

  const ProductInfo({
    super.key,
    required this.product,
    this.quantityWidget,
  });

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;

    final defaultUnit = product.units.isEmpty
        ? null
        : product.units.firstWhere(
            (unit) => unit.isDefault,
            orElse: () => product.units.first,
          );

    final offerUnit = context.select<OffersProvider, OfferProductUnitModel?>(
      (offers) => defaultUnit == null
          ? null
          : offers.productUnitOffer(
              productId: product.id,
              unitId: defaultUnit.id,
            ),
    );

    final price = offerUnit?.price ?? product.price;

    final double? oldPrice =
        offerUnit?.hasDiscount == true ? offerUnit?.oldPrice : product.oldPrice;

    final hasDiscount = oldPrice != null && oldPrice > price;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Product Name (Full width top row)
        Text(
          product.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 4),

        // 2. Secondary Info (Unit & Old Price)
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (product.package.isNotEmpty && hasDiscount)
              if (hasDiscount)
                Flexible(
                  child: Text(
                    '${oldPrice.toStringAsFixed(0)} ر.ي',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.discount,
                      decoration: TextDecoration.lineThrough,
                      decorationColor: AppColors.discount,
                    ),
                  ),
                ),
            if (product.package.isNotEmpty) const SizedBox(width: 8),
            Flexible(
              child: Text(
                '${product.package} ${product.unit}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textHint,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 6),

        // 3. Current Price + Quantity Control (Bottom row)
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Current Price
            Expanded(
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: AppPrice(
                    price: price,
                    crossAxisAlignment:
                        rtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  ),
                ),
              ),
            ),

            // Quantity Control
            if (quantityWidget != null) ...[
              const SizedBox(width: 8),
              quantityWidget!,
            ],
          ],
        ),
      ],
    );
  }
}
