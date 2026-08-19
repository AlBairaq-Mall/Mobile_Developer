import 'package:flutter/material.dart';

import '../../../core/models/product_model.dart';
import '../../products/domain/repositories/product_repository.dart';

/// حالة تحميل المنتجات في الصفحة الرئيسية.
///
/// - [initial]  : لم يُطلب شيء بعد.
/// - [loading]  : طلب جارٍ (أول تحميل — القائمة فارغة).
/// - [refreshing]: طلب جارٍ لكن البيانات القديمة لا تزال ظاهرة.
/// - [success]  : تم التحميل بنجاح وهناك منتجات.
/// - [empty]    : تم التحميل بنجاح لكن لا توجد منتجات.
/// - [error]    : فشل الطلب (timeout / network error / server error).
enum HomeLoadState { initial, loading, refreshing, success, empty, error }

class HomeProvider extends ChangeNotifier {
  HomeProvider(this._repository) {
    loadProducts();
  }

  final ProductRepository _repository;

  List<ProductModel> _products = [];

  String _selectedCategory = '';
  String _searchText = '';

  HomeLoadState _state = HomeLoadState.initial;
  String? _error;

  List<ProductModel>? _cachedFilteredProducts;

  int _requestId = 0;

  // ── Public getters ────────────────────────────────────────────────────────

  HomeLoadState get state => _state;

  /// true فقط أثناء أول تحميل (لا توجد بيانات بعد).
  bool get isLoading =>
      _state == HomeLoadState.loading || _state == HomeLoadState.initial;

  /// true أثناء refresh (البيانات القديمة لا تزال ظاهرة).
  bool get isRefreshing => _state == HomeLoadState.refreshing;

  bool get hasError => _state == HomeLoadState.error;

  bool get isEmpty => _state == HomeLoadState.empty;

  String? get error => _error;

  String get selectedCategory => _selectedCategory;

  String get searchText => _searchText;

  List<ProductModel> get products {
    final filtered = _getCachedFilteredProducts();

    final featuredIds = {
      ...flashDeals.take(4).map((e) => e.id),
      ...bestSellerProducts.take(4).map((e) => e.id),
      ...recommendedProducts.take(4).map((e) => e.id),
    };

    return filtered
        .where((product) => !featuredIds.contains(product.id))
        .toList();
  }

  List<ProductModel> get bestSellerProducts => _getCachedFilteredProducts()
      .where((product) => product.isBestSeller)
      .toList();

  List<ProductModel> get flashDeals => _getCachedFilteredProducts()
      .where((product) => product.isFlashDeal)
      .toList();

  List<ProductModel> get recommendedProducts => _getCachedFilteredProducts()
      .where((product) => product.isRecommended)
      .toList();

  // ── Load ──────────────────────────────────────────────────────────────────

  Future<void> loadProducts({bool showLoading = true}) async {
    final request = ++_requestId;

    // أثناء أول تحميل نُظهر spinner؛ أثناء refresh نحتفظ بالبيانات القديمة.
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
        '[HomeProvider] REQUEST PRODUCTS start (requestId=$request, showLoading=$showLoading)',
      );
      return true;
    }());

    try {
      final response = await _repository.getProducts();

      stopwatch.stop();

      if (request != _requestId) {
        // طلب أجدد استبدل هذا الطلب — تجاهله.
        return;
      }

      assert(() {
        debugPrint(
          '[HomeProvider] RESPONSE PRODUCTS '
          '(success=${response.isSuccess}, count=${response.data?.length}, '
          'duration=${stopwatch.elapsedMilliseconds}ms)',
        );
        return true;
      }());

      if (response.isSuccess && response.data != null) {
        _products = List<ProductModel>.from(response.data!);
        _error = null;
        _invalidateCache();
        _state =
            _products.isEmpty ? HomeLoadState.empty : HomeLoadState.success;
      } else {
        // فشل من الـ server (4xx/5xx) مع رسالة.
        _error = response.message;
        _state = HomeLoadState.error;
      }
    } catch (e) {
      stopwatch.stop();

      if (request != _requestId) {
        return;
      }

      _error = 'تعذر تحديث المنتجات';
      // لا نمسح _products القديمة عند فشل refresh حتى لا تختفي البيانات.
      _state = HomeLoadState.error;
      debugPrint(
        '[HomeProvider] ERROR PRODUCTS '
        '(duration=${stopwatch.elapsedMilliseconds}ms, error=$e)',
      );
    } finally {
      if (request == _requestId) {
        assert(() {
          debugPrint(
            '[HomeProvider] UI UPDATED '
            '(state=$_state, products=${_products.length})',
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

  // ── Cache ─────────────────────────────────────────────────────────────────

  List<ProductModel> _getCachedFilteredProducts() {
    if (_cachedFilteredProducts != null) {
      return _cachedFilteredProducts!;
    }

    _cachedFilteredProducts = _products.where((product) {
      final categoryMatch =
          _selectedCategory.isEmpty || product.categoryId == _selectedCategory;

      final searchMatch = _searchText.isEmpty ||
          product.name.toLowerCase().contains(_searchText.toLowerCase());

      return categoryMatch && searchMatch;
    }).toList();

    return _cachedFilteredProducts!;
  }

  void _invalidateCache() {
    _cachedFilteredProducts = null;
  }

  // ── Filters ───────────────────────────────────────────────────────────────

  void selectCategory(String categoryId) {
    if (_selectedCategory == categoryId) return;

    _selectedCategory = categoryId;
    _invalidateCache();
    notifyListeners();
  }

  void clearCategory() {
    if (_selectedCategory.isEmpty) return;

    _selectedCategory = '';
    _invalidateCache();
    notifyListeners();
  }

  void search(String value) {
    final text = value.trim();

    if (_searchText == text) return;

    _searchText = text;
    _invalidateCache();
    notifyListeners();
  }

  void clearSearch() {
    if (_searchText.isEmpty) return;

    _searchText = '';
    _invalidateCache();
    notifyListeners();
  }
}
