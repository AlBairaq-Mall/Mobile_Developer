import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
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
  String _searchQuery = '';
  String _sortBy = 'default';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadCategory(widget.categoryId);
    });
  }

  List<ProductModel> get _filtered {
    final provider = context.read<ProductProvider>();

    var filtered = List<ProductModel>.from(provider.products);

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
    final provider = context.watch<ProductProvider>();

    final products = provider.products;
    final isLoading = provider.isLoading;
    final error = provider.error;
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
              PopupMenuItem(
                  value: 'price_desc', child: Text('السعر: من الأعلى')),
              PopupMenuItem(value: 'name', child: Text('الاسم')),
            ],
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final provider = context.watch<ProductProvider>();

    if (provider.isLoading) {
      return const LoadingWidget();
    }

    if (provider.error != null) {
      return EmptyState(
        emoji: '⚠️',
        title: 'تعذر تحميل المنتجات',
        subtitle: provider.error,
        actionLabel: 'إعادة المحاولة',
        onAction: () => provider.loadCategory(widget.categoryId),
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
