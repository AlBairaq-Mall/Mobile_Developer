import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/payment_method.dart';
import '../providers/checkout_provider.dart';

class PaymentMethodSelector extends StatelessWidget {
  const PaymentMethodSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CheckoutProvider>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RadioListTile<PaymentMethod>(
          value: PaymentMethod.cash,
          groupValue: provider.paymentMethod,
          title: const Text('الدفع عند الاستلام'),
          onChanged: (value) {
            if (value != null) {
              provider.setPaymentMethod(value);
            }
          },
        ),
        RadioListTile<PaymentMethod>(
          value: PaymentMethod.wallet,
          groupValue: provider.paymentMethod,
          title: const Text('المحفظة'),
          onChanged: (value) {
            if (value != null) {
              provider.setPaymentMethod(value);
            }
          },
        ),
        RadioListTile<PaymentMethod>(
          value: PaymentMethod.card,
          groupValue: provider.paymentMethod,
          title: const Text('بطاقة بنكية'),
          onChanged: (value) {
            if (value != null) {
              provider.setPaymentMethod(value);
            }
          },
        ),
      ],
    );
  }
}
