import 'package:flutter/material.dart';

import '../domain/repositories/order_repository.dart';
import '../models/order_model.dart';

class OrdersProvider extends ChangeNotifier {
  OrdersProvider(this._repository);

  final OrderRepository _repository;

  List<OrderModel> _orders = [];
  bool _isLoading = false;
  String? _error;

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadOrders() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final response = await _repository.getMyOrders();
    if (response.isSuccess && response.data != null) {
      _orders = response.data!;
    } else {
      _orders = [];
      _error = response.message;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() => loadOrders();
}
