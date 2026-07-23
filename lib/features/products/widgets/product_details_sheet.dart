import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/widgets/app_cached_image.dart';
import '../providers/product_provider.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/models/product_model.dart';
import '../../cart/providers/cart_provider.dart';
import '../../favorites/providers/favorites_provider.dart';
import '../models/product_unit_model.dart';
import '../../products/presentation/product_details_screen.dart';

/// شاشة تفاصيل المنتج مع Accordion للوحدات المرتبطة بنفس الـ Item Code.
/// الفكرة: كل وحدة (حبة / شدة / كرتون / باكت) تشترك في نفس Item Code
/// ويُعرضها بشكل Expandable بدون الخروج من الصفحة.
class ProductDetailsSheet extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsSheet({super.key, required this.product});

  @override
  State<ProductDetailsSheet> createState() => _ProductDetailsSheetState();
}

class _ProductDetailsSheetState extends State<ProductDetailsSheet> {
  int? _expandedIndex;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadProduct(widget.product.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();

    final units = provider.units;
    final selected = provider.selectedUnit;
    final selectedIndex = provider.selectedUnitIndex;
    final favProvider = context.watch<FavoritesProvider>();
    final isFavorite = favProvider.isFavorite(widget.product.id);
    final cs = Theme.of(context).colorScheme;

    return SafeArea(
      child: Column(
        children: [
          // ── شريط الأزرار العلوي ────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
                // كود الصنف - يظهر كـ Chip مميز
                Chip(
                  label: Text(
                    'SKU: ${widget.product.itemCode}',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  side: const BorderSide(color: AppColors.primary),
                ),
                IconButton(
                  onPressed: () => favProvider.toggle(widget.product.id),
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : null,
                  ),
                ),
              ],
            ),
          ),

          // ── محتوى قابل للتمرير ────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // صورة المنتج
                  _ProductImage(product: widget.product),

                  const SizedBox(height: 16),

                  // اسم المنتج + البراند
                  Text(
                    widget.product.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (widget.product.brand.isNotEmpty)
                    Text(
                      widget.product.brand,
                      style: TextStyle(color: cs.outline),
                    ),

                  if (widget.product.description.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(widget.product.description,
                        style: TextStyle(color: cs.outline, height: 1.6)),
                  ],

                  const SizedBox(height: 24),

                  // ── قسم الوحدات (Accordion/Accordion) ──
                  if (units.isNotEmpty) ...[
                    Row(
                      children: [
                        const Icon(Icons.inventory_2_outlined,
                            size: 18, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Text(
                          'الوحدات المتاحة',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${units.length} وحدة',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // كل وحدة = بطاقة قابلة للتوسع + راديو للاختيار
                    ...List.generate(units.length, (i) {
                      final unit = units[i];
                      final isSelected = selectedIndex == i;
                      final isExpanded = _expandedIndex == i;

                      return _UnitAccordionCard(
                        unit: unit,
                        isSelected: isSelected,
                        isExpanded: isExpanded,
                        onSelect: () =>
                            context.read<ProductProvider>().selectUnit(i),
                        onToggleExpand: () => setState(() {
                          _expandedIndex = isExpanded ? null : i;
                        }),
                      );
                    }),
                  ] else
                    const _NoUnitsWarning(),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),

          // ── شريط الإضافة السفلي ───────────────────────
          if (selected != null)
            _AddToCartBar(
              unit: selected,
              product: widget.product,
            ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
// بطاقة الوحدة (Accordion)
// ══════════════════════════════════════════════════════
class _UnitAccordionCard extends StatelessWidget {
  final ProductUnitModel unit;
  final bool isSelected;
  final bool isExpanded;
  final VoidCallback onSelect;
  final VoidCallback onToggleExpand;

  const _UnitAccordionCard({
    required this.unit,
    required this.isSelected,
    required this.isExpanded,
    required this.onSelect,
    required this.onToggleExpand,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onSelect,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.06)
              : cs.surfaceContainerHighest.withOpacity(0.4),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            // ── رأس البطاقة ──────────────────────────────
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  // راديو الاختيار
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? AppColors.primary : Colors.grey,
                        width: 2,
                      ),
                      color:
                          isSelected ? AppColors.primary : Colors.transparent,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : null,
                  ),

                  const SizedBox(width: 12),

                  // اسم الوحدة + العبوة
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              unit.unitName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: isSelected ? AppColors.primary : null,
                              ),
                            ),
                            if (unit.isDefault) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'افتراضية',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppColors.success,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        Text(unit.package,
                            style: TextStyle(fontSize: 12, color: cs.outline)),
                      ],
                    ),
                  ),

                  // السعر
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (unit.oldPrice != null)
                        Text(
                          '${unit.oldPrice!.toStringAsFixed(0)} ر.ي',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      Text(
                        '${unit.price.toStringAsFixed(0)} ر.ي',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isSelected ? AppColors.primary : null,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 8),

                  // زر التوسع
                  GestureDetector(
                    onTap: onToggleExpand,
                    child: AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: isSelected ? AppColors.primary : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── محتوى التوسع ─────────────────────────────
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 250),
              crossFadeState: isExpanded
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: Container(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(height: 1),
                    const SizedBox(height: 12),

                    // تفاصيل الوحدة
                    _detailRow('العبوة', unit.package),
                    _detailRow('السعر', '${unit.price.toStringAsFixed(0)} ر.ي'),
                    if (unit.oldPrice != null)
                      _detailRow('السعر القديم',
                          '${unit.oldPrice!.toStringAsFixed(0)} ر.ي'),
                    if (unit.description.isNotEmpty)
                      _detailRow('الوصف', unit.description),
                    if (unit.label != null) _detailRow('التصنيف', unit.label!),

                    // حساب التحويل للوحدات الأخرى (معلومة إضافية)
                    const SizedBox(height: 12),
                    const Text(
                      'SKU (رمز الصنف)',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    // TODO: استبدل بـ itemCode من API
                    Row(
                      children: [
                        const Icon(Icons.qr_code_2,
                            size: 16, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Text(
                          'مشترك مع وحدات المنتج الأخرى بنفس الرمز',
                          style: TextStyle(
                              fontSize: 12,
                              color: AppColors.primary.withOpacity(0.8)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              secondChild: const SizedBox(height: 0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(label,
                style: const TextStyle(color: Colors.grey, fontSize: 13)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(value,
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
// شريط الإضافة للسلة السفلي
// ══════════════════════════════════════════════════════
class _AddToCartBar extends StatelessWidget {
  final ProductUnitModel unit;
  final ProductModel product;

  const _AddToCartBar({required this.unit, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // السعر
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('السعر', style: TextStyle(color: Colors.grey, fontSize: 12)),
              Text(
                '${unit.price.toStringAsFixed(0)} ر.ي',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              Text(unit.unitName,
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),

          const SizedBox(width: 16),

          // زر الإضافة
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                final cart = context.read<CartProvider>();
                cart.add(product);

                final messenger = ScaffoldMessenger.of(context);
                Navigator.pop(context);
                messenger.showSnackBar(
                  SnackBar(
                    content: Text('تمت إضافة (${unit.unitName}) للسلة'),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              icon: const Icon(Icons.shopping_cart_outlined),
              label: const Text('إضافة للسلة'),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
// صورة المنتج
// ══════════════════════════════════════════════════════
class _ProductImage extends StatelessWidget {
  final ProductModel product;
  const _ProductImage({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: product.image.isEmpty
          ? const Center(
              child: Icon(
                Icons.image_outlined,
                size: 70,
                color: Colors.grey,
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: AppCachedImage(
                imageUrl: product.image,
                fit: BoxFit.cover,
              ),
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
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade300),
      ),
      child: const Row(
        children: [
          Icon(Icons.warning_outlined, color: Colors.orange),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'لم يتم ربط وحدات بهذا المنتج بعد.',
              style: TextStyle(color: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }
}
