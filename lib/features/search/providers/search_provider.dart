import 'package:flutter/material.dart';

import '../../../core/models/product_model.dart';
import '../../products/domain/repositories/product_repository.dart';

class SearchProvider extends ChangeNotifier {
  SearchProvider(this._repository);

  final ProductRepository _repository;
  final TextEditingController controller = TextEditingController();

  final List<String> _recentSearches = [];
  String _query = '';
  List<ProductModel> _results = [];
  bool _isLoading = false;
  String? _error;

  List<String> get recentSearches => _recentSearches;
  String get query => _query;
  List<ProductModel> get results => _results;
  bool get isLoading => _isLoading;
  String? get error => _error;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void updateQuery(String value) {
    controller.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
    search(value);
  }

  Future<void> search(String value) async {
    _query = value.trim();

    if (_query.isNotEmpty) {
      _recentSearches.remove(_query);
      _recentSearches.insert(0, _query);
      if (_recentSearches.length > 8) _recentSearches.removeLast();
    }

    if (_query.isEmpty) {
      _results = [];
      _error = null;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    final response = await _repository.getProducts(search: _query);
    if (response.isSuccess && response.data != null) {
      _results = response.data!;
    } else {
      _results = [];
      _error = response.message;
    }

    _isLoading = false;
    notifyListeners();
  }

  void clear() {
    _query = '';
    _results = [];
    _error = null;
    notifyListeners();
  }

  void removeRecent(String value) {
    _recentSearches.remove(value);
    notifyListeners();
  }
}
