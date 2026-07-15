import 'package:flutter/material.dart';

import '../models/payment_method.dart';

class CheckoutProvider extends ChangeNotifier {
  PaymentMethod _paymentMethod = PaymentMethod.cash;

  PaymentMethod get paymentMethod => _paymentMethod;

  void setPaymentMethod(PaymentMethod value) {
    _paymentMethod = value;

    notifyListeners();
  }
}
