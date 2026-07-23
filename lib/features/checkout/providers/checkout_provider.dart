import 'package:flutter/material.dart';

import '../models/payment_method.dart';

class CheckoutProvider extends ChangeNotifier {
  PaymentMethod _paymentMethod = PaymentMethod.cash;

  PaymentMethod get paymentMethod => _paymentMethod;

  bool _placingOrder = false;

  bool get placingOrder => _placingOrder;

  void setPaymentMethod(PaymentMethod value) {
    _paymentMethod = value;
    notifyListeners();
  }

  void setPlacing(bool value) {
    _placingOrder = value;
    notifyListeners();
  }
}
