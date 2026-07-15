import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/di/dependency_injection.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/app_button.dart';
import '../../../core/models/product_model.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../cart/providers/cart_provider.dart';
import '../../favorites/providers/favorites_provider.dart';
import '../models/product_unit_model.dart';
import '../widgets/product_card.dart';

/// Full product details screen with unit selection and related products.
class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  ProductModel? _product;
  List<ProductUnitModel> _units = [];
  List<ProductModel> _related = [];
  int _selectedUnitIdx = 0;
  int _quantity = 1;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final repo = DependencyInjection.productRepository;
    final productResponse = await repo.getProductById(widget.productId);

    if (!mounted) return;

    if (!productResponse.isSuccess || productResponse.data == null) {
      setState(() {
        _isLoading = false;
        _error = productResponse.message ?? 'تعذر تحميل المنتج';
      });
      return;
    }

    final product = productResponse.data!;
    final unitsResponse = await repo.getProductUnits(product.itemCode);
    final relatedResponse =
        await repo.getProducts(categoryId: product.categoryId);

    if (!mounted) return;

    final related = (relatedResponse.data ?? [])
        .where((p) => p.id != product.id)
        .take(6)
        .toList();

    final units = unitsResponse.data ?? [];
    final defaultIdx = units.indexWhere((u) => u.isDefault);

    setState(() {
      _product = product;
      _units = units;
      _related = related;
      _selectedUnitIdx = defaultIdx >= 0 ? defaultIdx : 0;
      _isLoading = false;
    });
  }

  ProductUnitModel? get _selected =>
      _units.isEmpty ? null : _units[_selectedUnitIdx];

  void _addToCart() {
    final product = _product;
    if (product == null || _selected == null) return;
    context.read<CartProvider>().addItem(
      product: product,
      unit: _selected!.unitName,
      unitPrice: _selected!.price,
      quantity: _quantity,
    );
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    messenger.showSnackBar(SnackBar(
      content: Text('تمت إضافة ${product.name} × $_quantity'),
      backgroundColor: AppColors.primary,
      behavior: SnackBarBehavior.floating,
    ));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: LoadingWidget());
    }

    if (_error != null || _product == null) {
      return Scaffold(
        appBar: AppBar(),
        body: EmptyState(
          emoji: '⚠️',
          title: 'تعذر تحميل المنتج',
          subtitle: _error,
          actionLabel: 'إعادة المحاولة',
          onAction: _loadProduct,
        ),
      );
    }

    final product = _product!;
    final favProv = context.watch<FavoritesProvider>();
    final isFav = favProv.isFavorite(product.id);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 280,
                  pinned: true,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  leading: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child:
                          const Icon(Icons.close, color: AppColors.textPrimary),
                    ),
                  ),
                  actions: [
                    GestureDetector(
                      onTap: () => favProv.toggle(product.id),
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFav
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: isFav ? AppColors.error : AppColors.textHint,
                        ),
                      ),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      color: AppColors.background,
                      child: product.image.isEmpty
                          ? const Center(
                              child: Text('🛍️',
                                  style: TextStyle(fontSize: 100)))
                          : Image.asset(product.image,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => const Center(
                                  child: Text('🛍️',
                                      style: TextStyle(fontSize: 80)))),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Chip(
                          label: Text('SKU: ${product.itemCode}',
                              style: const TextStyle(
                                  fontSize: 11, fontFamily: 'monospace')),
                          backgroundColor:
                              AppColors.primary.withValues(alpha: 0.1),
                          side: const BorderSide(color: AppColors.primary),
                          visualDensity: VisualDensity.compact,
                        ),
                        const SizedBox(height: 10),
                        Text(product.name,
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                height: 1.3)),
                        if (product.brand.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(product.brand,
                              style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14)),
                        ],
                        const SizedBox(height: 20),
                        if (_units.isNotEmpty) ...[
                          const Text('اختر الوحدة',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 10,
                            runSpacing: 8,
                            children: List.generate(_units.length, (i) {
                              final u = _units[i];
                              final sel = _selectedUnitIdx == i;
                              return GestureDetector(
                                onTap: () =>
                                    setState(() => _selectedUnitIdx = i),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: sel
                                        ? AppColors.primary
                                        : Colors.transparent,
                                    border: Border.all(
                                        color: sel
                                            ? AppColors.primary
                                            : AppColors.border,
                                        width: 1.5),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(u.unitName,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                sel ? Colors.white : null,
                                          )),
                                      Text(u.package,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: sel
                                                ? Colors.white70
                                                : AppColors.textHint,
                                          )),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                        if (_selected != null) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.primary.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                  color: AppColors.primary
                                      .withValues(alpha: 0.2)),
                            ),
                            child: Column(
                              children: [
                                _DetailRow('العبوة', _selected!.package),
                                if (_selected!.description.isNotEmpty)
                                  _DetailRow('الوصف', _selected!.description),
                                _DetailRow('رمز الوحدة', product.itemCode),
                              ],
                            ),
                          ),
                        ],
                        if (product.description.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          const Text('الوصف',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(product.description,
                              style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  height: 1.7)),
                        ],
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            const Text('الكمية',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            const Spacer(),
                            _QtyControl(
                              quantity: _quantity,
                              onDecrease: () {
                                if (_quantity > 1) {
                                  setState(() => _quantity--);
                                }
                              },
                              onIncrease: () => setState(() => _quantity++),
                            ),
                          ],
                        ),
                        if (_related.isNotEmpty) ...[
                          const SizedBox(height: 28),
                          const Text('منتجات ذات صلة',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 240,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: _related.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 10),
                              itemBuilder: (_, i) => SizedBox(
                                width: 150,
                                child: ProductCard(product: _related[i]),
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_selected != null)
            Container(
              padding: EdgeInsets.fromLTRB(
                  20, 14, 20, MediaQuery.of(context).padding.bottom + 14),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.07),
                      blurRadius: 16,
                      offset: const Offset(0, -4))
                ],
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_selected!.oldPrice != null)
                        Text('${_selected!.oldPrice!.toStringAsFixed(0)} ر.ي',
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: AppColors.textHint,
                              fontSize: 12,
                            )),
                      Text(
                        '${(_selected!.price * _quantity).toStringAsFixed(0)} ر.ي',
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary),
                      ),
                      Text(_selected!.unitName,
                          style: const TextStyle(
                              color: AppColors.textHint, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppButton(
                      text: 'إضافة للسلة',
                      icon: Icons.shopping_cart_outlined,
                      onPressed: _addToCart,
                      height: 50,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label, value;
  const _DetailRow(this.label, this.value);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            SizedBox(
                width: 80,
                child: Text(label,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 13))),
            const SizedBox(width: 8),
            Expanded(
                child: Text(value,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 13))),
          ],
        ),
      );
}

class _QtyControl extends StatelessWidget {
  final int quantity;
  final VoidCallback onDecrease, onIncrease;
  const _QtyControl(
      {required this.quantity,
      required this.onDecrease,
      required this.onIncrease});
  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(14)),
        child: Row(
          children: [
            _Btn(Icons.remove_rounded, onDecrease),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text('$quantity',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18))),
            _Btn(Icons.add_rounded, onIncrease, isAdd: true),
          ],
        ),
      );
}

class _Btn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isAdd;
  const _Btn(this.icon, this.onTap, {this.isAdd = false});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              color: isAdd ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(12)),
          child: Icon(icon,
              size: 20,
              color: isAdd ? Colors.white : AppColors.textPrimary),
        ),
      );
}
