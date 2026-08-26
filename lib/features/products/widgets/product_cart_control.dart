import 'package:bhm_supermarket/features/products/models/product_unit_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/network/api_response.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/design_system/components/app_icon.dart';
import '../../../core/models/product_model.dart';
import '../../../core/widgets/app_message.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../ads/providers/offers_provider.dart';
import '../../cart/providers/cart_provider.dart';

class ProductCartControl extends StatelessWidget {
  final ProductModel product;

  const ProductCartControl({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final selectedUnit = product.units.isEmpty ? null : product.units.first;

    final unitId = selectedUnit?.id ?? '0';

    final cartQuantity = context.select<CartProvider, int>(
      (cart) => cart.getProductQuantity(
        product.id,
        unitId,
      ),
    );

    final isProcessing = context.select<CartProvider, bool>(
      (cart) => cart.isItemProcessing(
        product.id,
        unitId,
      ),
    );

    if (cartQuantity == 0) {
      return _buildAddButton(
        context,
        selectedUnit,
        isProcessing,
      );
    }

    return _buildQuantitySelector(
      context,
      selectedUnit,
      cartQuantity,
      isProcessing,
    );
  }

  Widget _buildAddButton(
    BuildContext context,
    ProductUnitModel? selectedUnit,
    bool isProcessing,
  ) {
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
                    ? ApiResponse.failure('لم يتم اختيار وحدة')
                    : await context.read<CartProvider>().addItem(
                          product: product,
                          unit: selectedUnit,
                          unitPrice: offerUnit?.price ?? selectedUnit.price,
                          originalPrice:
                              offerUnit?.oldPrice ?? selectedUnit.price,
                        );

                if (!context.mounted) {
                  return;
                }

                if (!response.isSuccess) {
                  AppMessage.error(
                    context,
                    response.message,
                  );
                }
              },
        child: Semantics(
          button: true,
          label: 'إضافة إلى السلة',
          child: Ink(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(
                color: const Color(0xff39BFE7), // Intentional Exception
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .08), // Intentional Exception to retain specific blur
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: isProcessing
                ? const Center(
                    child: AppLoading(
                      type: AppLoadingType.dots,
                      size: 12,
                      color: Color(0xff39BFE7),
                    ),
                  )
                : const AppIcon(
                    Icons.add_rounded,
                    color: Color(0xff39BFE7),
                    size: AppIconSize.small,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuantitySelector(
    BuildContext context,
    ProductUnitModel? selectedUnit,
    int quantity,
    bool isProcessing,
  ) {
    final unitId = selectedUnit?.id ?? '0';

    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: isProcessing
                ? null
                : () {
                    final index = context.read<CartProvider>().getCartItemIndex(
                          product.id,
                          unitId,
                        );

                    if (index != -1) {
                      context.read<CartProvider>().increase(index);
                    }
                  },
            child: Semantics(
              button: true,
              label: 'زيادة الكمية',
              child: SizedBox(
                width: 22,
                child: AppIcon(
                  Icons.add,
                  size: AppIconSize.small,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 22,
            child: Center(
              child: isProcessing
                  ? AppLoading(
                      type: AppLoadingType.dots,
                      size: 14,
                      color: Theme.of(context).colorScheme.primary,
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
                    final index = context.read<CartProvider>().getCartItemIndex(
                          product.id,
                          unitId,
                        );

                    if (index != -1) {
                      context.read<CartProvider>().decrease(index);
                    }
                  },
            child: Semantics(
              button: true,
              label: 'إنقاص الكمية',
              child: SizedBox(
                width: 22,
                child: AppIcon(
                  Icons.remove,
                  size: AppIconSize.small,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
