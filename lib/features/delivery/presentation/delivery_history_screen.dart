import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/app_back_button.dart';

class DeliveryHistoryScreen extends StatelessWidget {
  const DeliveryHistoryScreen({super.key});

  // TODO: GET /api/delivery/history
  static const _history = [
    _HistoryItem(
        id: '1042',
        customer: 'فاطمة أحمد',
        address: 'خور مكسر',
        amount: 8000,
        date: '2026-06-30',
        status: 'تم التسليم'),
    _HistoryItem(
        id: '1041',
        customer: 'خالد حسن',
        address: 'المنصورة',
        amount: 4500,
        date: '2026-06-30',
        status: 'تم التسليم'),
    _HistoryItem(
        id: '1038',
        customer: 'محمد علي',
        address: 'التواهي',
        amount: 12000,
        date: '2026-06-29',
        status: 'تم التسليم'),
    _HistoryItem(
        id: '1035',
        customer: 'ريم محمد',
        address: 'كريتر',
        amount: 3500,
        date: '2026-06-29',
        status: 'تم التسليم'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('سجل التوصيل'),
      ),
      body: Column(
        children: [
          // ملخص
          Container(
            margin: const EdgeInsets.all(14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _SummaryItem('هذا الأسبوع', '4 طلبات'),
                _SummaryItem('الأرباح', '28,000 ر.ي'),
                _SummaryItem('التقييم', '4.8 ★'),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              itemCount: _history.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final h = _history[i];
                return Card(
                  child: Material(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.success.withValues(alpha: 0.1),
                        child: const Icon(Icons.check_circle_outline,
                            color: AppColors.success),
                      ),
                      title: Text(h.customer,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${h.address}  •  ${h.date}'),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${h.amount.toStringAsFixed(0)} ر.ي',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text(h.status,
                              style: const TextStyle(
                                  color: AppColors.success, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label, value;
  const _SummaryItem(this.label, this.value);
  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.primary)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      );
}

class _HistoryItem {
  final String id, customer, address, date, status;
  final double amount;
  const _HistoryItem(
      {required this.id,
      required this.customer,
      required this.address,
      required this.amount,
      required this.date,
      required this.status});
}
