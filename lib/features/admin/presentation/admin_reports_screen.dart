import 'package:bhm_supermarket/core/widgets/app_page_header.dart';
import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

class AdminReportsScreen extends StatelessWidget {
  const AdminReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: ربط بـ GET /api/admin/reports
    return Scaffold(
      appBar: AppPageHeader(title: 'التقارير'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ملخص الأداء',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            _ReportCard(
              title: 'مبيعات اليوم',
              value: '45,000 ر.ي',
              change: '+12%',
              positive: true,
            ),
            _ReportCard(
              title: 'مبيعات الأسبوع',
              value: '280,000 ر.ي',
              change: '+8%',
              positive: true,
            ),
            _ReportCard(
              title: 'مبيعات الشهر',
              value: '1,200,000 ر.ي',
              change: '-2%',
              positive: false,
            ),
            const SizedBox(height: 20),
            const Text(
              'أكثر المنتجات مبيعاً',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            const _TopProductRow(
              name: 'كوكاكولا شدة',
              qty: '142 شدة',
              amount: '1,349,000 ر.ي',
            ),
            const _TopProductRow(
              name: 'بيبسي حبة',
              qty: '980 حبة',
              amount: '490,000 ر.ي',
            ),
            const _TopProductRow(
              name: 'شيبس بطاطس',
              qty: '560 باكت',
              amount: '280,000 ر.ي',
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final String title, value, change;
  final bool positive;
  const _ReportCard({
    required this.title,
    required this.value,
    required this.change,
    required this.positive,
  });

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 10),
    child: Material(
      child: ListTile(
        title: Text(title),
        subtitle: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        trailing: Chip(
          label: Text(change),
          backgroundColor: (positive ? AppColors.success : Colors.red)
              .withValues(alpha: 0.1),
          labelStyle: TextStyle(
            color: positive ? AppColors.success : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}

class _TopProductRow extends StatelessWidget {
  final String name, qty, amount;
  const _TopProductRow({
    required this.name,
    required this.qty,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 8),
    child: Material(
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: AppColors.primary,
          child: Icon(Icons.trending_up, color: Colors.white, size: 16),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(qty),
        trailing: Text(
          amount,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
    ),
  );
}
