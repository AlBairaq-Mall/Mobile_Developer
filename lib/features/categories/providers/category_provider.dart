import 'package:flutter/material.dart';

import '../../../core/models/category_model.dart';
import '../domain/repositories/category_repository.dart';

class CategoryProvider extends ChangeNotifier {
  CategoryProvider(this._repository) {
    loadCategories();
  }

  final CategoryRepository _repository;

  List<CategoryModel> _categories = [];
  // Pre-sorted cache — rebuilt only when _categories changes.
  List<CategoryModel> _cachedMainCategories = [];
  bool _isLoading = false;
  // guard لمنع double-load: إذا كان هناك طلب جارٍ، لا نُطلق طلباً آخر.
  bool _inFlight = false;
  String? _error;

  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Returns main categories sorted by sortOrder.
  /// Result is cached; no allocation on repeated calls.
  List<CategoryModel> get mainCategories => _cachedMainCategories;

  List<CategoryModel> subCategories(String parentId) =>
      _categories.where((c) => c.parentId == parentId).toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

  Future<void> loadCategories({bool showLoading = true}) async {
    // ──────────────────────────────────────────────────────────────────────
    // Guard: لا نُطلق request جديد إذا كان هناك طلب جارٍ بالفعل.
    // هذا يمنع double-call من constructor + refresh() متزامنَين.
    // ──────────────────────────────────────────────────────────────────────
    if (_inFlight) {
      assert(() {
        debugPrint('[CategoryProvider] SKIPPED duplicate request (already in flight)');
        return true;
      }());
      return;
    }

    _inFlight = true;

    if (showLoading) {
      _isLoading = true;
      _error = null;
      notifyListeners();
    } else {
      _error = null;
    }

    final stopwatch = Stopwatch()..start();

    assert(() {
      debugPrint('[CategoryProvider] REQUEST CATEGORIES start');
      return true;
    }());

    try {
      final response = await _repository.getCategories();

      stopwatch.stop();

      assert(() {
        debugPrint(
          '[CategoryProvider] RESPONSE CATEGORIES '
          '(success=${response.isSuccess}, count=${response.data?.length}, '
          'duration=${stopwatch.elapsedMilliseconds}ms)',
        );
        return true;
      }());

      if (response.isSuccess && response.data != null) {
        _categories = response.data!;
        _error = null;
      } else {
        _error = response.message;
      }
    } catch (e) {
      stopwatch.stop();
      _error = 'تعذر تحميل الأقسام';
      debugPrint(
        '[CategoryProvider] ERROR CATEGORIES '
        '(duration=${stopwatch.elapsedMilliseconds}ms, error=$e)',
      );
    } finally {
      _cachedMainCategories =
          _categories.where((c) => c.parentId == null).toList()
            ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

      _isLoading = false;
      _inFlight = false;
      notifyListeners();
    }
  }

  Future<void> refresh() {
    return loadCategories(showLoading: false);
  }
}
