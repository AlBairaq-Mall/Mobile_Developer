import '../../checkout/models/payment_method.dart';

String paymentApiValue(PaymentMethod method) {
  switch (method) {
    case PaymentMethod.cash:
      return "cash";

    case PaymentMethod.card:
      return "card";

    case PaymentMethod.wallet:
      return "cash";
  }
}
