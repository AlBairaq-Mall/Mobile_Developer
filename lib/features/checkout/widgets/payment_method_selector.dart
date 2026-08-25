import 'package:flutter/material.dart';

import '../models/payment_method.dart';

class PaymentMethodSelector extends StatelessWidget {
  const PaymentMethodSelector({
    super.key,
    required this.selectedMethod,
    required this.onChanged,
  });

  final PaymentMethod selectedMethod;
  final ValueChanged<PaymentMethod> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ignore: deprecated_member_use
        RadioListTile<PaymentMethod>(
          value: PaymentMethod.cash,
          // ignore: deprecated_member_use
          groupValue: selectedMethod,
          // ignore: deprecated_member_use
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
          title: Text(PaymentMethod.cash.label),
        ),
        // ignore: deprecated_member_use
        RadioListTile<PaymentMethod>(
          value: PaymentMethod.card,
          // ignore: deprecated_member_use
          groupValue: selectedMethod,
          // ignore: deprecated_member_use
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
          title: Text(PaymentMethod.card.label),
        ),
      ],
    );
  }
}
