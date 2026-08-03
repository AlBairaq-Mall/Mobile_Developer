import 'package:flutter/material.dart';

import '../domain/repositories/order_repository.dart';
import '../models/order_model.dart';

class OrdersProvider extends ChangeNotifier {
  OrdersProvider(this._repository);

  final OrderRepository _repository;

  List<OrderModel> _orders = [];

  bool _loading = false;

  List<OrderModel> get orders => _orders;

  bool get loading => _loading;

  Future<void> loadOrders() async {
    _loading = true;
    notifyListeners();

    final response = await _repository.getOrders();

    if (response.isSuccess && response.data != null) {
      _orders = response.data!;
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    await loadOrders();
  }
}
