import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/checkout_provider.dart';
import '../models/payment_method.dart';

class PaymentMethodSelector extends StatelessWidget {
  const PaymentMethodSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CheckoutProvider>();

    return Column(
      children: [
        RadioListTile(
          title: const Text('الدفع عند الاستلام'),

          value: PaymentMethod.cash,

          groupValue: provider.paymentMethod,

          onChanged: (value) {
            provider.setPaymentMethod(value!);
          },
        ),

        RadioListTile(
          title: const Text('المحفظة'),

          value: PaymentMethod.wallet,

          groupValue: provider.paymentMethod,

          onChanged: (value) {
            provider.setPaymentMethod(value!);
          },
        ),

        RadioListTile(
          title: const Text('بطاقة بنكية'),

          value: PaymentMethod.card,

          groupValue: provider.paymentMethod,

          onChanged: (value) {
            provider.setPaymentMethod(value!);
          },
        ),
      ],
    );
  }
}
