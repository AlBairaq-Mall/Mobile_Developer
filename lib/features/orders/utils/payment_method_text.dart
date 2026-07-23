String paymentMethodText(String value) {
  switch (value) {
    case "cash":
      return "الدفع نقداً";

    case "card":
      return "بطاقة بنكية";

    case "wallet":
      return "محفظة إلكترونية";

    default:
      return value;
  }
}
