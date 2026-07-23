import 'package:flutter/material.dart';

Color orderStatusColor(String status) {
  switch (status) {
    case "pending":
      return Colors.orange;

    case "confirmed":
      return Colors.blue;

    case "processing":
      return Colors.indigo;

    case "shipped":
      return Colors.teal;

    case "delivered":
      return Colors.green;

    case "cancelled":
      return Colors.red;

    default:
      return Colors.grey;
  }
}

String orderStatusText(String status) {
  switch (status) {
    case "pending":
      return "بانتظار التأكيد";

    case "confirmed":
      return "تم التأكيد";

    case "processing":
      return "قيد التجهيز";

    case "shipped":
      return "خرج للتوصيل";

    case "delivered":
      return "تم التسليم";

    case "cancelled":
      return "ملغي";

    default:
      return status;
  }
}
