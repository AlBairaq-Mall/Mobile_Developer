import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/payment_method.dart';
import '../providers/checkout_provider.dart';

class PaymentMethodSelector extends StatelessWidget {
  const PaymentMethodSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CheckoutProvider>();

    return RadioGroup<PaymentMethod>(
      groupValue: provider.paymentMethod,
      onChanged: (value) {
        if (value != null) {
          provider.setPaymentMethod(value);
        }
      },
      child: Column(
        children: const [
          RadioListTile<PaymentMethod>(
            value: PaymentMethod.cash,
            title: Text("الدفع عند الاستلام"),
          ),
          RadioListTile<PaymentMethod>(
            value: PaymentMethod.wallet,
            title: Text("المحفظة"),
          ),
          RadioListTile<PaymentMethod>(
            value: PaymentMethod.card,
            title: Text("بطاقة بنكية"),
          ),
        ],
      ),
    );
  }
}
