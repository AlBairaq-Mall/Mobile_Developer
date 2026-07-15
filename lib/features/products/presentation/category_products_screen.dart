import 'package:flutter/material.dart';

import '../../../app/di/dependency_injection.dart';
import '../../../core/models/product_model.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_widget.dart';
import '../widgets/products_grid.dart';

/// Category products screen — loads from the product repository.
class CategoryProductsScreen extends StatefulWidget {
  final String categoryId;
  final String? categoryName;

  const CategoryProductsScreen({
    super.key,
    required this.categoryId,
    this.categoryName,
  });

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  List<ProductModel> _products = [];
  bool _isLoading = true;
  String? _error;
  String _searchQuery = '';
  String _sortBy = 'default';

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final response = await DependencyInjection.productRepository.getProducts(
      categoryId: widget.categoryId,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      if (response.isSuccess && response.data != null) {
        _products = response.data!;
      } else {
        _products = [];
        _error = response.message;
      }
    });
  }

  List<ProductModel> get _filtered {
    var filtered = List<ProductModel>.from(_products);

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((p) =>
              p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              p.brand.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    switch (_sortBy) {
      case 'price_asc':
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_desc':
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'name':
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.categoryName ?? 'المنتجات';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'ابحث في $title...',
                prefixIcon: const Icon(Icons.search),
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (val) => setState(() => _sortBy = val),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'default', child: Text('الترتيب الافتراضي')),
              PopupMenuItem(value: 'price_asc', child: Text('السعر: من الأقل')),
              PopupMenuItem(value: 'price_desc', child: Text('السعر: من الأعلى')),
              PopupMenuItem(value: 'name', child: Text('الاسم')),
            ],
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingWidget();
    }

    if (_error != null) {
      return EmptyState(
        emoji: '⚠️',
        title: 'تعذر تحميل المنتجات',
        subtitle: _error,
        actionLabel: 'إعادة المحاولة',
        onAction: _loadProducts,
      );
    }

    final filtered = _filtered;
    if (filtered.isEmpty) {
      return const EmptyState(
        emoji: '📦',
        title: 'لا توجد منتجات',
        subtitle: 'لا توجد منتجات في هذا القسم حالياً',
      );
    }

    return ProductsGrid(products: filtered);
  }
}
