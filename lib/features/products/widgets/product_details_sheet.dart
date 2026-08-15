import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/widgets/app_cached_image.dart';
import '../../../core/models/product_model.dart';
import '../../auth/providers/auth_provider.dart';
import '../../cart/providers/cart_provider.dart';
import '../../ads/models/offer_model.dart';
import '../../ads/providers/offers_provider.dart';
import '../../../core/widgets/app_message.dart';
import '../../../core/widgets/app_dialog.dart';
import '../../favorites/providers/favorites_provider.dart';
import '../models/product_unit_model.dart';
import '../providers/product_provider.dart';

// ══════════════════════════════════════════════════════════════════════════════
// ProductDetailsSheet
// ══════════════════════════════════════════════════════════════════════════════

/// Bottom-sheet احترافي لعرض تفاصيل المنتج.
///
/// إذا كانت وحدات المنتج محملة مسبقاً في [product.units]، يُستخدم
/// [ProductProvider.setProduct] لتجنب طلب API إضافي.
/// في حال لم تكن الوحدات متوفرة يُجرى [ProductProvider.loadProduct].
class ProductDetailsSheet extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsSheet({super.key, required this.product});

  @override
  State<ProductDetailsSheet> createState() => _ProductDetailsSheetState();
}

class _ProductDetailsSheetState extends State<ProductDetailsSheet> {
  int _quantity = 1;
  bool _isAddingToCart = false;
  int _imageIndex = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final provider = context.read<ProductProvider>();
      if (widget.product.units.isNotEmpty) {
        // الوحدات موجودة → لا حاجة لطلب API
        provider.setProduct(widget.product);
      } else {
        // الوحدات غير موجودة → جلب من API
        provider.loadProduct(widget.product.id);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // ── Cart Actions ─────────────────────────────────────────────────────────

  Future<void> _addToCart() async {
    // التحقق من تسجيل الدخول أولاً
    final auth = context.read<AuthProvider>();
    if (!auth.isLoggedIn) {
      _showLoginRequired();
      return;
    }

    final provider = context.read<ProductProvider>();
    final selectedUnit = provider.selectedUnit;
    if (selectedUnit == null) return;

    setState(() => _isAddingToCart = true);

    final cart = context.read<CartProvider>();
    final offerUnit = context.read<OffersProvider>().productUnitOffer(
      productId: widget.product.id,
      unitId: selectedUnit.id,
    );
    final response = await cart.addItem(
      product: widget.product,
      selectedUnit: selectedUnit,
      unitPrice: offerUnit?.price ?? selectedUnit.price,
      quantity: _quantity,
    );

    if (!mounted) return;
    setState(() => _isAddingToCart = false);

    if (response.isSuccess) {
      // احفظ ScaffoldMessenger قبل pop
      final messenger = ScaffoldMessenger.of(context);
      context.pop();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AppMessage.success(
          messenger.context,
          'تمت إضافة ${widget.product.name} (${selectedUnit.unitName}) للسلة',
        );
      });
    } else {
      AppMessage.error(
        context,
        response.message.isNotEmpty
            ? response.message
            : 'حدث خطأ، حاول مرة أخرى',
      );
    }
  }

  void _showLoginRequired() {
    AppDialog.loginRequired(
      context,
      message: 'يجب تسجيل الدخول لإضافة منتجات إلى سلة التسوق.',
    ).then((confirmed) {
      if (confirmed == true && mounted) {
        context.pop(); // إغلاق الـ sheet
        context.push(AppRoutes.login);
      }
    });
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();
    final isFavorite = context.select<FavoritesProvider, bool>(
      (f) => f.isFavorite(widget.product.id),
    );

    final units = provider.units;
    final selectedUnit = provider.selectedUnit;
    final selectedOffer = selectedUnit == null
        ? null
        : context.select<OffersProvider, OfferProductUnitModel?>(
            (offers) => offers.productUnitOffer(
              productId: widget.product.id,
              unitId: selectedUnit.id,
            ),
          );
    final images = widget.product.images;

    return SafeArea(
      top: false,
      child: Column(
        children: [
          // ── Drag Handle ────────────────────────────────────────────────
          const _DragHandle(),

          // ── Scrollable Content ─────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // صورة المنتج
                  _ImageSection(
                    images: images,
                    productId: widget.product.id,
                    isFavorite: isFavorite,
                    currentIndex: _imageIndex,
                    pageController: _pageController,
                    onPageChanged: (i) => setState(() => _imageIndex = i),
                    onClose: () => context.pop(),
                    onFavoriteToggle: () => context
                        .read<FavoritesProvider>()
                        .toggle(widget.product.id),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // التصنيف
                        if (widget.product.categoryName.isNotEmpty)
                          _CategoryChip(label: widget.product.categoryName),

                        const SizedBox(height: 10),

                        // اسم المنتج
                        Text(
                          widget.product.name,
                          style: AppTypography.headlineSmall,
                        ),

                        // البراند
                        if (widget.product.brand.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            widget.product.brand,
                            style: AppTypography.bodySmall,
                          ),
                        ],

                        // الوصف
                        if (widget.product.description.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Text(
                            widget.product.description,
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.65,
                            ),
                          ),
                        ],

                        const SizedBox(height: 24),

                        // ── قسم الوحدات ──────────────────────────────
                        if (provider.isLoading)
                          const _UnitsLoadingState()
                        else if (provider.error != null)
                          _UnitsErrorState(error: provider.error!)
                        else if (units.isNotEmpty)
                          _UnitsSection(
                            units: units,
                            selectedIndex: provider.selectedUnitIndex,
                            onSelect: (i) =>
                                context.read<ProductProvider>().selectUnit(i),
                          )
                        else
                          const _NoUnitsWarning(),

                        // مسافة لشريط الأسفل
                        const SizedBox(height: 110),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Bottom Action Bar ──────────────────────────────────────────
          if (selectedUnit != null)
            _BottomBar(
              selectedUnit: selectedUnit,
              price: selectedOffer?.price ?? selectedUnit.price,
              oldPrice: selectedOffer?.hasDiscount == true
                  ? selectedOffer!.oldPrice
                  : selectedUnit.oldPrice,
              quantity: _quantity,
              isLoading: _isAddingToCart,
              onIncrease: () => setState(() => _quantity++),
              onDecrease: () {
                if (_quantity > 1) setState(() => _quantity--);
              },
              onAddToCart: _addToCart,
            )
          else if (!provider.isLoading)
            const _UnavailableBottomBar(),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// _DragHandle
// ══════════════════════════════════════════════════════════════════════════════

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 4),
      child: Center(
        child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.outline,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// _ImageSection
// ══════════════════════════════════════════════════════════════════════════════

class _ImageSection extends StatelessWidget {
  final List<String> images;
  final String productId;
  final bool isFavorite;
  final int currentIndex;
  final PageController pageController;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onClose;
  final VoidCallback onFavoriteToggle;

  const _ImageSection({
    required this.images,
    required this.productId,
    required this.isFavorite,
    required this.currentIndex,
    required this.pageController,
    required this.onPageChanged,
    required this.onClose,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final hasImages = images.isNotEmpty;

    return SizedBox(
      height: 260,
      child: Stack(
        children: [
          // ── الصورة / المعرض ──────────────────────────────────────────
          if (hasImages)
            PageView.builder(
              controller: pageController,
              onPageChanged: onPageChanged,
              itemCount: images.length,
              itemBuilder: (_, i) => Hero(
                tag: 'product_$productId',
                child: AppCachedImage(
                  imageUrl: images[i],
                  width: double.infinity,
                  height: 260,
                  radius: 0,
                  fit: BoxFit.cover,
                ),
              ),
            )
          else
            Container(
              width: double.infinity,
              color: AppColors.surfaceVariant,
              child: const Center(
                child: Icon(
                  Icons.shopping_bag_rounded,
                  size: 80,
                  color: AppColors.primary,
                ),
              ),
            ),

          // ── Dot Indicators (عند تعدد الصور) ─────────────────────────
          if (images.length > 1)
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  images.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: currentIndex == i ? 20 : 7,
                    height: 7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: currentIndex == i
                          ? AppColors.primary
                          : Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ),
            ),

          // ── زر الإغلاق ───────────────────────────────────────────────
          PositionedDirectional(
            top: 12,
            start: 12,
            child: _CircleButton(icon: Icons.close_rounded, onTap: onClose),
          ),

          // ── زر المفضلة ───────────────────────────────────────────────
          PositionedDirectional(
            top: 12,
            end: 12,
            child: _CircleButton(
              icon: isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              iconColor: isFavorite ? AppColors.favorite : null,
              onTap: onFavoriteToggle,
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// _CircleButton
// ══════════════════════════════════════════════════════════════════════════════

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final VoidCallback onTap;

  const _CircleButton({
    required this.icon,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.9),
      shape: const CircleBorder(),
      elevation: 1,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            size: 22,
            color: iconColor ?? AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// _CategoryChip
// ══════════════════════════════════════════════════════════════════════════════

class _CategoryChip extends StatelessWidget {
  final String label;
  const _CategoryChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryExtraLight,
        borderRadius: BorderRadius.circular(AppRadius.chip),
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(color: AppColors.primaryDark),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// _UnitsSection
// ══════════════════════════════════════════════════════════════════════════════

class _UnitsSection extends StatelessWidget {
  final List<ProductUnitModel> units;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const _UnitsSection({
    required this.units,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // عنوان القسم
        Row(
          children: [
            const Icon(
              Icons.layers_outlined,
              size: 18,
              color: AppColors.primary,
            ),
            const SizedBox(width: 6),
            Text('اختر الوحدة', style: AppTypography.titleSmall),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppRadius.chip),
              ),
              child: Text('${units.length}', style: AppTypography.badge),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // بطاقات الوحدات
        ...List.generate(units.length, (i) {
          return _UnitCard(
            unit: units[i],
            isSelected: selectedIndex == i,
            onTap: () => onSelect(i),
          );
        }),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// _UnitCard
// ══════════════════════════════════════════════════════════════════════════════

class _UnitCard extends StatelessWidget {
  final ProductUnitModel unit;
  final bool isSelected;
  final VoidCallback onTap;

  const _UnitCard({
    required this.unit,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryExtraLight
              : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // ── مؤشر الاختيار (radio) ────────────────────────────────
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.outline,
                  width: 2,
                ),
                color: isSelected ? AppColors.primary : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check_rounded,
                      size: 14,
                      color: Colors.white,
                    )
                  : null,
            ),

            const SizedBox(width: 12),

            // ── اسم الوحدة + الكمية ──────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    unit.unitName,
                    style: AppTypography.titleSmall.copyWith(
                      color: isSelected
                          ? AppColors.primaryDark
                          : AppColors.textPrimary,
                    ),
                  ),
                  if (unit.quantity > 1) ...[
                    const SizedBox(height: 2),
                    Text('${unit.quantity}', style: AppTypography.bodySmall),
                  ],
                ],
              ),
            ),

            // ── السعر ───────────────────────────────────────────────
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (unit.oldPrice != null)
                  Text(
                    '${unit.oldPrice!.toStringAsFixed(2)} ر.ي',
                    style: AppTypography.caption.copyWith(
                      decoration: TextDecoration.lineThrough,
                      color: AppColors.textHint,
                    ),
                  ),
                Text(
                  '${unit.price.toStringAsFixed(2)} ر.ي',
                  style: AppTypography.priceMedium.copyWith(
                    color: isSelected ? AppColors.primaryDark : AppColors.price,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// _BottomBar
// ══════════════════════════════════════════════════════════════════════════════

class _BottomBar extends StatelessWidget {
  final ProductUnitModel selectedUnit;
  final double price;
  final double? oldPrice;
  final int quantity;
  final bool isLoading;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onAddToCart;

  const _BottomBar({
    required this.selectedUnit,
    required this.price,
    this.oldPrice,
    required this.quantity,
    required this.isLoading,
    required this.onIncrease,
    required this.onDecrease,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 14, 20, bottomPadding + 14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── اختيار الكمية ± ───────────────────────────────────────
          _QuantitySelector(
            quantity: quantity,
            onIncrease: onIncrease,
            onDecrease: onDecrease,
          ),

          const SizedBox(width: 14),

          // ── السعر الإجمالي ────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (oldPrice != null && oldPrice! > price)
                  Text(
                    '${(oldPrice! * quantity).toStringAsFixed(2)} ر.ي',
                    style: AppTypography.caption.copyWith(
                      decoration: TextDecoration.lineThrough,
                      color: AppColors.textHint,
                    ),
                  ),
                Text(
                  '${(price * quantity).toStringAsFixed(2)} ر.ي',
                  style: AppTypography.priceLarge,
                ),
                Text(selectedUnit.unitName, style: AppTypography.caption),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // ── زر الإضافة للسلة ─────────────────────────────────────
          SizedBox(
            height: 48,
            child: FilledButton.icon(
              onPressed: isLoading ? null : onAddToCart,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.primary.withValues(
                  alpha: 0.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 18),
              ),
              icon: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.shopping_cart_outlined, size: 20),
              label: Text(
                isLoading ? 'جاري الإضافة...' : 'أضف للسلة',
                style: AppTypography.button,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// _QuantitySelector
// ══════════════════════════════════════════════════════════════════════════════

class _QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const _QuantitySelector({
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QtyButton(icon: Icons.add_rounded, onTap: onIncrease),
          SizedBox(
            width: 36,
            child: Center(
              child: Text('$quantity', style: AppTypography.titleSmall),
            ),
          ),
          _QtyButton(
            icon: Icons.remove_rounded,
            onTap: quantity > 1 ? onDecrease : null,
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Icon(
          icon,
          size: 18,
          color: onTap != null ? AppColors.primary : AppColors.textHint,
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// State Widgets
// ══════════════════════════════════════════════════════════════════════════════

class _UnitsLoadingState extends StatelessWidget {
  const _UnitsLoadingState();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        2,
        (_) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          height: 62,
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),
    );
  }
}

class _UnitsErrorState extends StatelessWidget {
  final String error;
  const _UnitsErrorState({required this.error});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.errorLight,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: AppColors.error),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              error.isNotEmpty ? error : 'تعذر تحميل بيانات المنتج',
              style: AppTypography.bodySmall.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoUnitsWarning extends StatelessWidget {
  const _NoUnitsWarning();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warningLight,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: AppColors.warning),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'لم يتم ربط وحدات بهذا المنتج بعد.',
              style: AppTypography.bodySmall.copyWith(color: AppColors.warning),
            ),
          ),
        ],
      ),
    );
  }
}

class _UnavailableBottomBar extends StatelessWidget {
  const _UnavailableBottomBar();

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 14, 20, bottomPadding + 14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.block_rounded, color: AppColors.textHint, size: 18),
          const SizedBox(width: 8),
          Text(
            'هذا المنتج غير متاح للشراء حالياً',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textHint),
          ),
        ],
      ),
    );
  }
}
