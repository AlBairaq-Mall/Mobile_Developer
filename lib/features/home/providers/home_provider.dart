import 'package:flutter/material.dart';

import '../../../core/models/product_model.dart';
import '../../products/domain/repositories/product_repository.dart';

enum HomeLoadState {
  initial,
  loading,
  refreshing,
  success,
  empty,
  error,
}

class HomeProvider extends ChangeNotifier {
  HomeProvider(this._repository) {
    loadProducts();
  }

  final ProductRepository _repository;

  List<ProductModel> _products = [];
  List<ProductModel> _flashDeals = [];
  List<ProductModel> _bestSellerProducts = [];
  List<ProductModel> _recommendedProducts = [];

  String _selectedCategory = '';
  String _searchText = '';

  HomeLoadState _state = HomeLoadState.initial;
  String? _error;

  int _requestId = 0;

  // ---------------------------------------------------------------------------
  // Public getters
  // ---------------------------------------------------------------------------

  HomeLoadState get state => _state;

  bool get isLoading =>
      _state == HomeLoadState.loading || _state == HomeLoadState.initial;

  bool get isRefreshing => _state == HomeLoadState.refreshing;

  bool get hasError => _state == HomeLoadState.error;

  bool get isEmpty => _state == HomeLoadState.empty;

  String? get error => _error;

  String get selectedCategory => _selectedCategory;

  String get searchText => _searchText;
  // نضع جميع العناصر التي ستعرض على الهوم في متغير واحد
  List<ProductModel> _uniqueProducts(
    List<ProductModel> products,
  ) {
    final seen = <String>{};

    return products.where((product) {
      return seen.add(product.id);
    }).toList();
  }

  List<ProductModel> get flashDeals =>
      List.unmodifiable(_uniqueProducts(_flashDeals).take(4).toList());

  List<ProductModel> get bestSellerProducts {
    final usedIds = {
      ...flashDeals.map((product) => product.id),
    };

    return List.unmodifiable(
      _uniqueProducts(
        _bestSellerProducts
            .where(
              (product) => !usedIds.contains(product.id),
            )
            .toList(),
      ).take(4).toList(),
    );
  }

  List<ProductModel> get recommendedProducts {
    final usedIds = {
      ...flashDeals.map((product) => product.id),
      ...bestSellerProducts.map((product) => product.id),
    };

    return List.unmodifiable(
      _uniqueProducts(
        _recommendedProducts
            .where(
              (product) => !usedIds.contains(product.id),
            )
            .toList(),
      ).take(4).toList(),
    );
  }

  List<ProductModel> get products {
    final usedIds = {
      ...flashDeals.map((product) => product.id),
      ...bestSellerProducts.map((product) => product.id),
      ...recommendedProducts.map((product) => product.id),
    };

    return List.unmodifiable(
      _uniqueProducts(
        _products
            .where(
              (product) => !usedIds.contains(product.id),
            )
            .toList(),
      ),
    );
  }

  // عشان ما تتكرر العناصر ووققفناها وعملنا التي فوق
  // List<ProductModel> get products => List.unmodifiable(_products);

  // List<ProductModel> get flashDeals => List.unmodifiable(_flashDeals);

  // List<ProductModel> get bestSellerProducts =>
  //     List.unmodifiable(_bestSellerProducts);

  // List<ProductModel> get recommendedProducts =>
  //     List.unmodifiable(_recommendedProducts);

  // ---------------------------------------------------------------------------
  // Load
  // ---------------------------------------------------------------------------

  Future<void> loadProducts({bool showLoading = true}) async {
    final request = ++_requestId;

    if (showLoading && _products.isEmpty) {
      _state = HomeLoadState.loading;
    } else if (!showLoading) {
      _state = HomeLoadState.refreshing;
    }

    _error = null;
    notifyListeners();

    final stopwatch = Stopwatch()..start();

    assert(() {
      debugPrint(
        '[HomeProvider] REQUEST HOME start '
        '(requestId=$request, showLoading=$showLoading)',
      );
      return true;
    }());

    try {
      /*
       * نرسل الطلبات الأربعة بالتوازي:
       *
       * 1. المنتجات العامة
       * 2. Flash Deals
       * 3. Best Sellers
       * 4. Recommended
       *
       * category_id و search يتم تطبيقهما على المنتجات العامة فقط،
       * لأنهما مرتبطان بتصفح/بحث المنتجات العادي.
       */

      final responses = await Future.wait([
        _repository.getProducts(
          categoryId: _selectedCategory.isEmpty ? null : _selectedCategory,
          search: _searchText.isEmpty ? null : _searchText,
          page: 1,
        ),
        _repository.getProducts(
          page: 1,
          isFlashDeal: true,
        ),
        _repository.getProducts(
          page: 1,
          isBestSeller: true,
        ),
        _repository.getProducts(
          page: 1,
          isRecommended: true,
        ),
      ]);

      stopwatch.stop();

      if (request != _requestId) {
        return;
      }

      final generalResponse = responses[0];
      final flashResponse = responses[1];
      final bestSellerResponse = responses[2];
      final recommendedResponse = responses[3];

      // -----------------------------------------------------------------------
      // General products
      // -----------------------------------------------------------------------

      if (!generalResponse.isSuccess || generalResponse.data == null) {
        _error = generalResponse.message;
        _state = HomeLoadState.error;
        return;
      }

      // -----------------------------------------------------------------------
      // General
      // -----------------------------------------------------------------------

      _products = List<ProductModel>.from(
        generalResponse.data!.items,
      );

      // -----------------------------------------------------------------------
      // Flash Deals
      // -----------------------------------------------------------------------

      _flashDeals = flashResponse.isSuccess && flashResponse.data != null
          ? List<ProductModel>.from(
              flashResponse.data!.items.take(4),
            )
          : [];

      // -----------------------------------------------------------------------
      // Best Sellers
      // -----------------------------------------------------------------------

      _bestSellerProducts =
          bestSellerResponse.isSuccess && bestSellerResponse.data != null
              ? List<ProductModel>.from(
                  bestSellerResponse.data!.items.take(4),
                )
              : [];

      // -----------------------------------------------------------------------
      // Recommended
      // -----------------------------------------------------------------------

      _recommendedProducts =
          recommendedResponse.isSuccess && recommendedResponse.data != null
              ? List<ProductModel>.from(
                  recommendedResponse.data!.items.take(4),
                )
              : [];

      _error = null;

      _state = _products.isEmpty &&
              _flashDeals.isEmpty &&
              _bestSellerProducts.isEmpty &&
              _recommendedProducts.isEmpty
          ? HomeLoadState.empty
          : HomeLoadState.success;

      assert(() {
        debugPrint(
          '[HomeProvider] RESPONSE HOME '
          '(general=${_products.length}, '
          'flash=${_flashDeals.length}, '
          'bestSeller=${_bestSellerProducts.length}, '
          'recommended=${_recommendedProducts.length}, '
          'duration=${stopwatch.elapsedMilliseconds}ms)',
        );
        return true;
      }());
    } catch (e) {
      stopwatch.stop();

      if (request != _requestId) {
        return;
      }

      _error = 'تعذر تحديث المنتجات';
      _state = HomeLoadState.error;

      debugPrint(
        '[HomeProvider] ERROR HOME '
        '(duration=${stopwatch.elapsedMilliseconds}ms, error=$e)',
      );
    } finally {
      if (request == _requestId) {
        assert(() {
          debugPrint(
            '[HomeProvider] UI UPDATED '
            '(state=$_state, '
            'general=${_products.length}, '
            'flash=${_flashDeals.length}, '
            'bestSeller=${_bestSellerProducts.length}, '
            'recommended=${_recommendedProducts.length})',
          );
          return true;
        }());

        notifyListeners();
      }
    }
  }

  Future<void> refresh() {
    return loadProducts(showLoading: false);
  }

  // ---------------------------------------------------------------------------
  // Category
  // ---------------------------------------------------------------------------

  void selectCategory(String categoryId) {
    if (_selectedCategory == categoryId) {
      return;
    }

    _selectedCategory = categoryId;

    loadProducts(showLoading: false);
  }

  void clearCategory() {
    if (_selectedCategory.isEmpty) {
      return;
    }

    _selectedCategory = '';

    loadProducts(showLoading: false);
  }

  // ---------------------------------------------------------------------------
  // Search
  // ---------------------------------------------------------------------------

  void search(String value) {
    final text = value.trim();

    if (_searchText == text) {
      return;
    }

    _searchText = text;

    loadProducts(showLoading: false);
  }

  void clearSearch() {
    if (_searchText.isEmpty) {
      return;
    }

    _searchText = '';

    loadProducts(showLoading: false);
  }
}
