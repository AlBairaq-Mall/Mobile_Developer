import 'package:flutter/material.dart';

import '../../../core/models/product_model.dart';
import '../../products/domain/repositories/product_repository.dart';

class HomeProvider extends ChangeNotifier {
  HomeProvider(this._repository) {
    loadProducts();
  }

  final ProductRepository _repository;

  List<ProductModel> _products = [];
  String _selectedCategory = '';
  String _searchText = '';
  bool _isLoading = false;
  String? _error;

  List<ProductModel> get products => _products;
  String get selectedCategory => _selectedCategory;
  String get searchText => _searchText;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final response = await _repository.getProducts();
    if (response.isSuccess && response.data != null) {
      _products = response.data!;
    } else {
      _error = response.message;
      _products = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  List<ProductModel> get bestSellerProducts => _filterProducts();

  List<ProductModel> get flashDeals => const [];

  List<ProductModel> get recommendedProducts => const [];

  List<ProductModel> _filterProducts() => _products.where((product) {
        final categoryMatch = _selectedCategory.isEmpty ||
            product.categoryId == _selectedCategory;
        final searchMatch = _searchText.isEmpty ||
            product.name.toLowerCase().contains(_searchText.toLowerCase());
        return categoryMatch && searchMatch;
      }).toList();

  void selectCategory(String categoryId) {
    _selectedCategory = categoryId;
    notifyListeners();
  }

  void clearCategory() {
    _selectedCategory = '';
    notifyListeners();
  }

  void search(String value) {
    _searchText = value;
    notifyListeners();
  }

  void clearSearch() {
    _searchText = '';
    notifyListeners();
  }

  Future<void> refresh() => loadProducts();
}
