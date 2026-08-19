import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/models/product_model.dart';
import '../../../core/widgets/app_message.dart';
import '../../cart/providers/cart_provider.dart';
import '../../ads/providers/offers_provider.dart';

class ProductCartControl extends StatelessWidget {
  final ProductModel product;

  const ProductCartControl({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // 1. Get default unit
    final selectedUnit = product.units.isEmpty
        ? null
        : product.units.firstWhere(
            (unit) => unit.isDefault,
            orElse: () => product.units.first,
          );

    final unitId = selectedUnit?.id ?? "0";

    // 2. Select only this product/unit from cart provider to avoid unnecessary rebuilds
    final cartQuantity = context.select<CartProvider, int>(
        (cart) => cart.getProductQuantity(product.id, unitId));
    final isProcessing = context.select<CartProvider, bool>(
        (cart) => cart.isItemProcessing(product.id, unitId));

    if (cartQuantity == 0) {
      return _buildAddButton(context, selectedUnit, isProcessing);
    }

    return _buildQuantitySelector(
        context, selectedUnit, cartQuantity, isProcessing);
  }

  Widget _buildAddButton(
      BuildContext context, dynamic selectedUnit, bool isProcessing) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: isProcessing
            ? null
            : () async {
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
                          originalPrice:
                              offerUnit?.oldPrice ?? selectedUnit.price,
                        );

                if (!context.mounted) return;

                if (!response.isSuccess) {
                  AppMessage.error(context, response.message);
                }
              },
        child: Ink(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xff39BFE7), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .08),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: isProcessing
              ? const Center(
                  child: SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xff39BFE7),
                    ),
                  ),
                )
              : const Icon(
                  Icons.add_rounded,
                  color: Color(0xff39BFE7),
                  size: 20,
                ),
        ),
      ),
    );
  }

  Widget _buildQuantitySelector(BuildContext context, dynamic selectedUnit,
      int quantity, bool isProcessing) {
    final unitId = selectedUnit?.id ?? "0";

    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: isProcessing
                ? null
                : () {
                    final index = context
                        .read<CartProvider>()
                        .getCartItemIndex(product.id, unitId);
                    if (index != -1) {
                      context.read<CartProvider>().increase(index);
                    }
                  },
            child: const SizedBox(
              width: 22,
              child: Icon(Icons.add, size: 16, color: AppColors.primary),
            ),
          ),
          SizedBox(
            width: 22,
            child: Center(
              child: isProcessing
                  ? const SizedBox(
                      width: 10,
                      height: 10,
                      child: CircularProgressIndicator(
                          strokeWidth: 1.5, color: AppColors.primary),
                    )
                  : Text(
                      quantity.toString(),
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
          InkWell(
            onTap: isProcessing
                ? null
                : () {
                    final index = context
                        .read<CartProvider>()
                        .getCartItemIndex(product.id, unitId);
                    if (index != -1) {
                      context.read<CartProvider>().decrease(index);
                    }
                  },
            child: const SizedBox(
              width: 22,
              child: Icon(Icons.remove, size: 16, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
