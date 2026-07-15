import 'package:flutter/material.dart';

import '../../../core/models/category_model.dart';
import '../domain/repositories/category_repository.dart';

class CategoryProvider extends ChangeNotifier {
  CategoryProvider(this._repository) {
    loadCategories();
  }

  final CategoryRepository _repository;

  List<CategoryModel> _categories = [];
  bool _isLoading = false;
  String? _error;

  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<CategoryModel> get mainCategories =>
      _categories.where((c) => c.parentId == null).toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

  List<CategoryModel> subCategories(String parentId) =>
      _categories.where((c) => c.parentId == parentId).toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

  Future<void> loadCategories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final response = await _repository.getCategories();
    if (response.isSuccess && response.data != null) {
      _categories = response.data!;
    } else {
      _categories = [];
      _error = response.message;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() => loadCategories();
}
