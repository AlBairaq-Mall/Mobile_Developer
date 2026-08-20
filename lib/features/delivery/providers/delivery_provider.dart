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

//   List<DeliveryOrderModel> get orders => List.unmodifiable(_orders);

//   DeliveryOrderModel? get selectedOrder => _selectedOrder;

//   bool get isLoading => _isLoading;

//   bool get isUpdating => _isUpdating;

//   String? get error => _error;

//   bool get isEmpty => !_isLoading && _orders.isEmpty && _error == null;

//   /// الطلبات التي ما زالت تحتاج إجراء من السائق.
//   ///
//   /// حسب العقد الحالي للـBackend، الطلبات النشطة تكون قبل:
//   /// delivered / cancelled
//   List<DeliveryOrderModel> get activeOrders {
//     return _orders
//         .where(
//           (order) => order.status != 'delivered' && order.status != 'cancelled',
//         )
//         .toList();
//   }

//   /// الطلبات المكتملة أو الملغاة.
//   List<DeliveryOrderModel> get historyOrders {
//     return _orders
//         .where(
//           (order) => order.status == 'delivered' || order.status == 'cancelled',
//         )
//         .toList();
//   }

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

//   // ── Update Status ─────────────────────────────────────────────────────────

//   /// تحديث حالة الطلب وحالة الدفع من خلال:
//   ///
//   /// PATCH /api/delivery/orders/{id}/status
//   ///
//   /// الحالات المدعومة حسب عقد الـAPI الحالي:
//   /// - delivered
//   /// - cancelled
//   ///
//   /// وحالات الدفع:
//   /// - pending
//   /// - paid
//   /// - failed
//   Future<String?> updateStatus({
//     required String orderId,
//     required String status,
//     String? paymentStatus,
//   }) async {
//     if (!_isValidOrderStatus(status)) {
//       return 'حالة الطلب غير مدعومة';
//     }

//     if (paymentStatus != null && !_isValidPaymentStatus(paymentStatus)) {
//       return 'حالة الدفع غير مدعومة';
//     }

//     _isUpdating = true;
//     notifyListeners();

//     final response = await _repository.updateOrderStatus(
//       orderId: orderId,
//       status: status,
//       paymentStatus: paymentStatus,
//     );

//     _isUpdating = false;

//     if (!response.isSuccess) {
//       notifyListeners();
//       return response.message;
//     }

//     _updateLocalOrder(
//       orderId: orderId,
//       status: status,
//       paymentStatus: paymentStatus,
//     );

//     notifyListeners();

//     return null;
//   }

//   // ── Local Update ─────────────────────────────────────────────────────────

//   void _updateLocalOrder({
//     required String orderId,
//     required String status,
//     String? paymentStatus,
//   }) {
//     final index = _orders.indexWhere((order) => order.id == orderId);

//     if (index != -1) {
//       final current = _orders[index];

//       _orders[index] = current.copyWith(
//         status: status,
//         paymentStatus: paymentStatus,
//       );
//     }

//     if (_selectedOrder?.id == orderId) {
//       _selectedOrder = _selectedOrder!.copyWith(
//         status: status,
//         paymentStatus: paymentStatus,
//       );
//     }
//   }

//   // ── Assign Driver ────────────────────────────────────────────────────────

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

//     if (!response.isSuccess) {
//       notifyListeners();
//       return response.message;
//     }

//     notifyListeners();
//     return null;
//   }

//   // ── Validation ───────────────────────────────────────────────────────────

//   bool _isValidOrderStatus(String status) {
//     return status == 'delivered' || status == 'cancelled';
//   }

//   bool _isValidPaymentStatus(String status) {
//     return status == 'pending' || status == 'paid' || status == 'failed';
//   }
// }

import 'package:flutter/foundation.dart';

import '../domain/repositories/delivery_repository.dart';
import '../models/delivery_order_model.dart';

class DeliveryProvider extends ChangeNotifier {
  DeliveryProvider(this._repository);

  final DeliveryRepository _repository;

  List<DeliveryOrderModel> _availableOrders = [];
  List<DeliveryOrderModel> _orders = [];

  DeliveryOrderModel? _selectedOrder;

  bool _isLoading = false;
  bool _isUpdating = false;
  String? _error;

  List<DeliveryOrderModel> get availableOrders =>
      List.unmodifiable(_availableOrders);

  List<DeliveryOrderModel> get orders => List.unmodifiable(_orders);

  DeliveryOrderModel? get selectedOrder => _selectedOrder;

  bool get isLoading => _isLoading;

  bool get isUpdating => _isUpdating;

  String? get error => _error;

  bool get isEmpty =>
      !_isLoading &&
      _availableOrders.isEmpty &&
      _orders.isEmpty &&
      _error == null;

  List<DeliveryOrderModel> get activeOrders {
    return _orders
        .where(
          (order) => order.status != 'delivered' && order.status != 'cancelled',
        )
        .toList();
  }

  List<DeliveryOrderModel> get historyOrders {
    return _orders
        .where(
          (order) => order.status == 'delivered' || order.status == 'cancelled',
        )
        .toList();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // Available Orders
  // ══════════════════════════════════════════════════════════════════════════

  Future<void> loadAvailableOrders() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final response = await _repository.getAvailableOrders();

    if (response.isSuccess) {
      _availableOrders = response.data ?? [];
    } else {
      // لا تمسح الطلبات القديمة أو تتسبب في اختفائها عند الفشل
      // فقط اظهر الخطأ
      _error = response.message;
    }

    _isLoading = false;
    notifyListeners();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // My Orders
  // ══════════════════════════════════════════════════════════════════════════

  Future<void> loadOrders() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final response = await _repository.getOrders();

    if (response.isSuccess) {
      _orders = response.data ?? [];
    } else {
      // لا تمسح الطلبات القديمة أو تتسبب في اختفائها عند الفشل
      _error = response.message;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    await Future.wait([
      loadAvailableOrders(),
      loadOrders(),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // Claim Order
  // ══════════════════════════════════════════════════════════════════════════

  Future<String?> claimOrder(String orderId) async {
    if (_isUpdating) return 'يوجد إجراء قيد التنفيذ';

    _isUpdating = true;
    _error = null;
    notifyListeners();

    final response = await _repository.claimOrder(orderId);

    _isUpdating = false;

    if (!response.isSuccess || response.data == null) {
      notifyListeners();
      return response.message; // عند الفشل، لا نمسح الطلب من القائمة
    }

    final claimedOrder = response.data!;

    // إزالة الطلب من الطلبات المتاحة.
    _availableOrders.removeWhere(
      (order) => order.id == orderId,
    );

    // إضافة الطلب إلى طلبات السائق.
    final existingIndex = _orders.indexWhere(
      (order) => order.id == orderId,
    );

    if (existingIndex == -1) {
      _orders.insert(0, claimedOrder);
    } else {
      _orders[existingIndex] = claimedOrder;
    }

    notifyListeners();

    return null;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // Order Detail
  // ══════════════════════════════════════════════════════════════════════════

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

  // ══════════════════════════════════════════════════════════════════════════
  // Update Status
  // ══════════════════════════════════════════════════════════════════════════

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

    if (_isUpdating) {
      return 'يوجد إجراء قيد التنفيذ';
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

  // ══════════════════════════════════════════════════════════════════════════
  // Local Update
  // ══════════════════════════════════════════════════════════════════════════

  void _updateLocalOrder({
    required String orderId,
    required String status,
    String? paymentStatus,
  }) {
    final index = _orders.indexWhere(
      (order) => order.id == orderId,
    );

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

  // ══════════════════════════════════════════════════════════════════════════
  // Assign Driver
  // ══════════════════════════════════════════════════════════════════════════

  Future<String?> assignDriver({
    required String orderId,
    required int deliveryDriverId,
  }) async {
    if (_isUpdating) {
      return 'يوجد إجراء قيد التنفيذ';
    }

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

  // ══════════════════════════════════════════════════════════════════════════
  // Validation
  // ══════════════════════════════════════════════════════════════════════════

  bool _isValidOrderStatus(String status) {
    return status == 'delivered' || status == 'cancelled';
  }

  bool _isValidPaymentStatus(String status) {
    return status == 'pending' || status == 'paid' || status == 'failed';
  }
}
