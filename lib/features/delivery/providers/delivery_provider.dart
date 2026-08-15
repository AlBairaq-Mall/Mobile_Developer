// import 'package:flutter/foundation.dart';

// import '../domain/repositories/delivery_repository.dart';
// import '../models/delivery_order_model.dart';

// class DeliveryProvider extends ChangeNotifier {
//   DeliveryProvider(this._repository);

//   final DeliveryRepository _repository;

//   List<DeliveryOrderModel> _orders = [];
//   DeliveryOrderModel? _selectedOrder;

//   bool _isLoading = false;
//   bool _isUpdating = false;
//   String? _error;

//   List<DeliveryOrderModel> get orders => _orders;
//   DeliveryOrderModel? get selectedOrder => _selectedOrder;
//   bool get isLoading => _isLoading;
//   bool get isUpdating => _isUpdating;
//   String? get error => _error;
//   bool get isEmpty => !_isLoading && _orders.isEmpty && _error == null;

//   // ── Orders List ──────────────────────────────────────────────────────────

//   Future<void> loadOrders() async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();

//     final response = await _repository.getOrders();

//     if (response.isSuccess) {
//       _orders = response.data ?? [];
//     } else {
//       _orders = [];
//       _error = response.message;
//     }

//     _isLoading = false;
//     notifyListeners();
//   }

//   Future<void> refresh() => loadOrders();

//   // ── Order Detail ─────────────────────────────────────────────────────────

//   Future<void> loadOrder(String id) async {
//     _selectedOrder = null;
//     _isLoading = true;
//     _error = null;
//     notifyListeners();

//     final response = await _repository.getOrderById(id);

//     if (response.isSuccess && response.data != null) {
//       _selectedOrder = response.data;
//     } else {
//       _error = response.message;
//     }

//     _isLoading = false;
//     notifyListeners();
//   }

//   // ── Update Status ────────────────────────────────────────────────────────

//   /// Returns null on success, or an error message on failure.
//   Future<String?> updateStatus({
//     required String orderId,
//     required String status,
//     String? paymentStatus,
//   }) async {
//     _isUpdating = true;
//     notifyListeners();

//     final response = await _repository.updateOrderStatus(
//       orderId: orderId,
//       status: status,
//       paymentStatus: paymentStatus,
//     );

//     _isUpdating = false;

//     if (response.isSuccess) {
//       // Optimistic update in-list
//       final idx = _orders.indexWhere((o) => o.id == orderId);
//       if (idx != -1) {
//         _orders[idx] = _orders[idx].copyWith(
//           status: status,
//           paymentStatus: paymentStatus ?? _orders[idx].paymentStatus,
//         );
//       }
//       if (_selectedOrder?.id == orderId) {
//         _selectedOrder = _selectedOrder!.copyWith(
//           status: status,
//           paymentStatus: paymentStatus ?? _selectedOrder!.paymentStatus,
//         );
//       }
//       notifyListeners();
//       return null;
//     }

//     notifyListeners();
//     return response.message;
//   }

//   /// Start delivery for an assigned order.
//   ///
//   /// confirmed / processing -> shipped
//   ///
//   /// We reuse the existing status endpoint instead of creating
//   /// another repository/data-source method.
//   ///
//   /// Payment status is preserved because starting delivery does
//   /// not mean the customer has paid yet.
//   Future<String?> startDelivery(String orderId) async {
//     final orderIndex = _orders.indexWhere((order) => order.id == orderId);

//     if (orderIndex == -1) {
//       return 'لم يتم العثور على الطلب';
//     }

//     final order = _orders[orderIndex];

//     if (order.status == 'shipped') {
//       return null;
//     }

//     if (order.status != 'confirmed' && order.status != 'processing') {
//       return 'لا يمكن بدء التوصيل لهذه الحالة';
//     }

//     _isUpdating = true;
//     notifyListeners();

//     final response = await _repository.updateOrderStatus(
//       orderId: orderId,
//       status: 'shipped',
//       paymentStatus: order.paymentStatus,
//     );

//     _isUpdating = false;

//     if (!response.isSuccess) {
//       notifyListeners();
//       return response.message;
//     }

//     _orders[orderIndex] = order.copyWith(status: 'shipped');

//     if (_selectedOrder?.id == orderId) {
//       _selectedOrder = _selectedOrder!.copyWith(status: 'shipped');
//     }

//     notifyListeners();

//     return null;
//   }

//   // ── Assign Driver ────────────────────────────────────────────────────────

//   /// Returns null on success, or an error message on failure.
//   Future<String?> assignDriver({
//     required String orderId,
//     required int deliveryDriverId,
//   }) async {
//     _isUpdating = true;
//     notifyListeners();

//     final response = await _repository.assignDriver(
//       orderId: orderId,
//       deliveryDriverId: deliveryDriverId,
//     );

//     _isUpdating = false;
//     notifyListeners();

//     return response.isSuccess ? null : response.message;
//   }

//   /// ─────────────────────────────────────────────────────────────────────
//   /// PATCH /api/delivery/orders/{id}/status
//   /// ─────────────────────────────────────────────────────────────────────
// }

import 'package:flutter/foundation.dart';

import '../domain/repositories/delivery_repository.dart';
import '../models/delivery_order_model.dart';

class DeliveryProvider extends ChangeNotifier {
  DeliveryProvider(this._repository);

  final DeliveryRepository _repository;

  List<DeliveryOrderModel> _orders = [];
  DeliveryOrderModel? _selectedOrder;

  bool _isLoading = false;
  bool _isUpdating = false;
  String? _error;

  List<DeliveryOrderModel> get orders => List.unmodifiable(_orders);

  DeliveryOrderModel? get selectedOrder => _selectedOrder;

  bool get isLoading => _isLoading;

  bool get isUpdating => _isUpdating;

  String? get error => _error;

  bool get isEmpty => !_isLoading && _orders.isEmpty && _error == null;

  /// الطلبات التي ما زالت تحتاج إجراء من السائق.
  ///
  /// حسب العقد الحالي للـBackend، الطلبات النشطة تكون قبل:
  /// delivered / cancelled
  List<DeliveryOrderModel> get activeOrders {
    return _orders
        .where(
          (order) => order.status != 'delivered' && order.status != 'cancelled',
        )
        .toList();
  }

  /// الطلبات المكتملة أو الملغاة.
  List<DeliveryOrderModel> get historyOrders {
    return _orders
        .where(
          (order) => order.status == 'delivered' || order.status == 'cancelled',
        )
        .toList();
  }

  // ── Orders List ──────────────────────────────────────────────────────────

  Future<void> loadOrders() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final response = await _repository.getOrders();

    if (response.isSuccess) {
      _orders = response.data ?? [];
    } else {
      _orders = [];
      _error = response.message;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() => loadOrders();

  // ── Order Detail ─────────────────────────────────────────────────────────

  Future<void> loadOrder(String id) async {
    _selectedOrder = null;
    _isLoading = true;
    _error = null;
    notifyListeners();

    final response = await _repository.getOrderById(id);

    if (response.isSuccess && response.data != null) {
      _selectedOrder = response.data;
    } else {
      _error = response.message;
    }

    _isLoading = false;
    notifyListeners();
  }

  // ── Update Status ─────────────────────────────────────────────────────────

  /// تحديث حالة الطلب وحالة الدفع من خلال:
  ///
  /// PATCH /api/delivery/orders/{id}/status
  ///
  /// الحالات المدعومة حسب عقد الـAPI الحالي:
  /// - delivered
  /// - cancelled
  ///
  /// وحالات الدفع:
  /// - pending
  /// - paid
  /// - failed
  Future<String?> updateStatus({
    required String orderId,
    required String status,
    String? paymentStatus,
  }) async {
    if (!_isValidOrderStatus(status)) {
      return 'حالة الطلب غير مدعومة';
    }

    if (paymentStatus != null && !_isValidPaymentStatus(paymentStatus)) {
      return 'حالة الدفع غير مدعومة';
    }

    _isUpdating = true;
    notifyListeners();

    final response = await _repository.updateOrderStatus(
      orderId: orderId,
      status: status,
      paymentStatus: paymentStatus,
    );

    _isUpdating = false;

    if (!response.isSuccess) {
      notifyListeners();
      return response.message;
    }

    _updateLocalOrder(
      orderId: orderId,
      status: status,
      paymentStatus: paymentStatus,
    );

    notifyListeners();

    return null;
  }

  // ── Local Update ─────────────────────────────────────────────────────────

  void _updateLocalOrder({
    required String orderId,
    required String status,
    String? paymentStatus,
  }) {
    final index = _orders.indexWhere((order) => order.id == orderId);

    if (index != -1) {
      final current = _orders[index];

      _orders[index] = current.copyWith(
        status: status,
        paymentStatus: paymentStatus,
      );
    }

    if (_selectedOrder?.id == orderId) {
      _selectedOrder = _selectedOrder!.copyWith(
        status: status,
        paymentStatus: paymentStatus,
      );
    }
  }

  // ── Assign Driver ────────────────────────────────────────────────────────

  Future<String?> assignDriver({
    required String orderId,
    required int deliveryDriverId,
  }) async {
    _isUpdating = true;
    notifyListeners();

    final response = await _repository.assignDriver(
      orderId: orderId,
      deliveryDriverId: deliveryDriverId,
    );

    _isUpdating = false;

    if (!response.isSuccess) {
      notifyListeners();
      return response.message;
    }

    notifyListeners();
    return null;
  }

  // ── Validation ───────────────────────────────────────────────────────────

  bool _isValidOrderStatus(String status) {
    return status == 'delivered' || status == 'cancelled';
  }

  bool _isValidPaymentStatus(String status) {
    return status == 'pending' || status == 'paid' || status == 'failed';
  }
}
