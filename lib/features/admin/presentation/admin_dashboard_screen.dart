import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../auth/providers/auth_provider.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة التحكم'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthProvider>().logout();
              context.go(AppRoutes.adminLogin);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.admin_panel_settings, color: Colors.white, size: 36),
                  const SizedBox(height: 10),
                  Text('مرحباً، ${user?.name ?? 'مدير النظام'}',
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(user?.email ?? '',
                      style: const TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Stats Grid
            const Text('الإحصائيات',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: const [
                _StatCard(label: 'إجمالي الطلبات', value: '1,245', icon: Icons.receipt_long, color: Colors.blue),
                _StatCard(label: 'المبيعات اليوم', value: '45,000 ر.ي', icon: Icons.attach_money, color: AppColors.success),
                _StatCard(label: 'المستخدمون', value: '320', icon: Icons.people_outline, color: Colors.purple),
                _StatCard(label: 'طلبات معلقة', value: '12', icon: Icons.pending_outlined, color: Colors.orange),
              ],
            ),
            const SizedBox(height: 24),

            // Quick Actions
            const Text('الإجراءات السريعة',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _QuickActionGrid(actions: [
              _QuickAction('إدارة الطلبات', Icons.receipt_long_outlined,
                  () => context.push(AppRoutes.adminOrders)),
              _QuickAction('إدارة المنتجات', Icons.inventory_2_outlined,
                  () => context.push(AppRoutes.adminProducts)),
              _QuickAction('إدارة المستخدمين', Icons.people_outline,
                  () => context.push(AppRoutes.adminUsers)),
              _QuickAction('إدارة التوصيل', Icons.delivery_dining_outlined,
                  () => context.push(AppRoutes.adminDelivery)),
              _QuickAction('التقارير', Icons.bar_chart_outlined,
                  () => context.push(AppRoutes.adminReports)),
              _QuickAction('الإعدادات', Icons.settings_outlined,
                  () => context.push(AppRoutes.adminSettings)),
            ]),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _StatCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: color, size: 28),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
                Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction { final String label; final IconData icon; final VoidCallback onTap;
  _QuickAction(this.label, this.icon, this.onTap); }

class _QuickActionGrid extends StatelessWidget {
  final List<_QuickAction> actions;
  const _QuickActionGrid({required this.actions});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 0.9,
      children: actions.map((a) => GestureDetector(
        onTap: a.onTap,
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(a.icon, size: 32, color: AppColors.primary),
              const SizedBox(height: 8),
              Text(a.label, textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      )).toList(),
    );
  }
}
