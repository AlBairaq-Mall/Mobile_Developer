import 'package:bhm_supermarket/core/widgets/app_page_header.dart';
import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

/// شاشة الأرباح للسائق
class DeliveryEarningsScreen extends StatelessWidget {
  const DeliveryEarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: GET /api/delivery/earnings
    return Scaffold(
      appBar: const AppPageHeader(title: 'أرباحي', showBack: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Summary Cards
            Row(
              children: const [
                Expanded(
                  child: _EarningsCard(
                    'اليوم',
                    '1,200 ر.ي',
                    Icons.today_outlined,
                    AppColors.primary,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _EarningsCard(
                    'الأسبوع',
                    '8,400 ر.ي',
                    Icons.date_range_outlined,
                    Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: const [
                Expanded(
                  child: _EarningsCard(
                    'الشهر',
                    '32,000 ر.ي',
                    Icons.calendar_month_outlined,
                    AppColors.accent,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _EarningsCard(
                    'التوصيلات',
                    '145 طلب',
                    Icons.delivery_dining_outlined,
                    AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Daily breakdown
            const Text(
              'آخر 7 أيام',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...const [
              _DayRow('الأحد', '1,800 ر.ي', 6),
              _DayRow('الإثنين', '2,100 ر.ي', 7),
              _DayRow('الثلاثاء', '900 ر.ي', 3),
              _DayRow('الأربعاء', '1,500 ر.ي', 5),
              _DayRow('الخميس', '2,400 ر.ي', 8),
              _DayRow('الجمعة', '600 ر.ي', 2),
              _DayRow('السبت', '1,200 ر.ي', 4),
            ],
          ],
        ),
      ),
    );
  }
}

class _EarningsCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _EarningsCard(this.label, this.value, this.icon, this.color);

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 26),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
}

class _DayRow extends StatelessWidget {
  final String day, amount;
  final int deliveries;
  const _DayRow(this.day, this.amount, this.deliveries);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            SizedBox(
              width: 70,
              child: Text(day,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: deliveries / 10,
                  backgroundColor: AppColors.border,
                  color: AppColors.primary,
                  minHeight: 8,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(amount, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            Text(
              '($deliveries)',
              style: const TextStyle(color: AppColors.textHint, fontSize: 12),
            ),
          ],
        ),
      );
}
