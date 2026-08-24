// import 'package:bhm_supermarket/core/models/product_model.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:bhm_supermarket/features/cart/providers/cart_provider.dart';
// import 'package:bhm_supermarket/features/ads/providers/offers_provider.dart';

// class ProductAddButton extends StatelessWidget {
//   final ProductModel product;

//   const ProductAddButton({super.key, required this.product});

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         borderRadius: BorderRadius.circular(10),
//         onTap: () async {
//           final selectedUnit = product.units.isEmpty
//               ? null
//               : product.units.firstWhere(
//                   (unit) => unit.isDefault,
//                   orElse: () => product.units.first,
//                 );
//           final offerUnit = selectedUnit == null
//               ? null
//               : context.read<OffersProvider>().productUnitOffer(
//                     productId: product.id,
//                     unitId: selectedUnit.id,
//                   );
//           final response = selectedUnit == null
//               ? await context.read<CartProvider>().add(product)
//               : await context.read<CartProvider>().addItem(
//                     product: product,
//                     selectedUnit: selectedUnit,
//                     unitPrice: offerUnit?.price ?? selectedUnit.price,
//                   );

//           if (!context.mounted) return;

//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(
//                 response.isSuccess
//                     ? "تمت إضافة ${product.name}"
//                     : response.message,
//               ),
//             ),
//           );
//         },
//         child: Ink(
//           width: 28,
//           height: 28,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(6),
//             border: Border.all(color: const Color(0xff39BFE7), width: 1.2),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withValues(alpha: .08),
//                 blurRadius: 10,
//                 offset: const Offset(0, 3),
//               ),
//             ],
//           ),
//           child: const Icon(
//             Icons.add_rounded,
//             color: Color(0xff39BFE7),
//             size: 20,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/product_model.dart';
import '../../ads/providers/offers_provider.dart';
import '../../cart/providers/cart_provider.dart';

class ProductAddButton extends StatelessWidget {
  final ProductModel product;

  const ProductAddButton({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () async {
          final selectedUnit =
              product.units.isEmpty ? null : product.units.first;

          final offerUnit = selectedUnit == null
              ? null
              : context.read<OffersProvider>().productUnitOffer(
                    productId: product.id,
                    unitId: selectedUnit.id,
                  );

          final response = selectedUnit == null
              ? await context.read<CartProvider>().add(product)
              : await context.read<CartProvider>().addItem(
                    product: product,
                    selectedUnit: selectedUnit,
                    unitPrice: offerUnit?.price ?? selectedUnit.price,
                    originalPrice: offerUnit?.oldPrice ?? selectedUnit.price,
                  );

          if (!context.mounted) {
            return;
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                response.isSuccess
                    ? 'تمت إضافة ${product.name}'
                    : response.message,
              ),
            ),
          );
        },
        child: Ink(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: const Color(0xff39BFE7),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .08),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(
            Icons.add_rounded,
            color: Color(0xff39BFE7),
            size: 20,
          ),
        ),
      ),
    );
  }
}
