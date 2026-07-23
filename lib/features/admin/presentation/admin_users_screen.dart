import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  // TODO: استبدل بـ GET /api/admin/users
  static const _users = [
    _UserRow(
        name: 'أحمد علي',
        phone: '777123456',
        role: 'customer',
        orders: 12,
        joined: '2025-01'),
    _UserRow(
        name: 'سارة محمد',
        phone: '771456789',
        role: 'customer',
        orders: 8,
        joined: '2025-02'),
    _UserRow(
        name: 'محمد التوصيل',
        phone: '733000001',
        role: 'delivery',
        orders: 145,
        joined: '2024-12'),
    _UserRow(
        name: 'مدير النظام',
        phone: '000000001',
        role: 'admin',
        orders: 0,
        joined: '2024-01'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المستخدمين'),
        actions: [
          IconButton(
              icon: const Icon(Icons.person_add_outlined),
              onPressed: () {},
              tooltip: 'إضافة مستخدم'),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                _FilterChip('الكل', true),
                const SizedBox(width: 8),
                _FilterChip('عملاء', false),
                const SizedBox(width: 8),
                _FilterChip('سائقون', false),
                const SizedBox(width: 8),
                _FilterChip('مديرون', false),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              itemCount: _users.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final u = _users[i];
                return Card(
                  child: Material(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _roleColor(u.role).withOpacity(0.15),
                        child:
                            Icon(_roleIcon(u.role), color: _roleColor(u.role)),
                      ),
                      title: Text(u.name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${u.phone}  •  ${u.orders} طلب'),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: _roleColor(u.role).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(_roleName(u.role),
                                style: TextStyle(
                                    color: _roleColor(u.role),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Text(u.joined,
                              style: const TextStyle(
                                  fontSize: 11, color: Colors.grey)),
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

  Color _roleColor(String r) {
    if (r == 'admin') return Colors.red;
    if (r == 'delivery') return Colors.blue;
    return AppColors.success;
  }

  IconData _roleIcon(String r) {
    if (r == 'admin') return Icons.admin_panel_settings;
    if (r == 'delivery') return Icons.delivery_dining;
    return Icons.person;
  }

  String _roleName(String r) {
    if (r == 'admin') return 'مدير';
    if (r == 'delivery') return 'سائق';
    return 'عميل';
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  const _FilterChip(this.label, this.selected);
  @override
  Widget build(BuildContext context) =>
      FilterChip(label: Text(label), selected: selected, onSelected: (_) {});
}

class _UserRow {
  final String name, phone, role, joined;
  final int orders;
  const _UserRow(
      {required this.name,
      required this.phone,
      required this.role,
      required this.orders,
      required this.joined});
}
