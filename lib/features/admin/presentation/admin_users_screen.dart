import 'package:bhm_supermarket/core/widgets/app_page_header.dart';
import 'package:bhm_supermarket/core/widgets/loading_widget.dart';
import 'package:bhm_supermarket/core/widgets/app_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_colors.dart';
import '../providers/admin_users_provider.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminUsersProvider>().loadUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppPageHeader(
        title: 'إدارة المستخدمين',
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_outlined),
            tooltip: 'إضافة مستخدم',
            onPressed: () {
              AppMessage.error(
                context,
                'إنشاء المستخدمين من لوحة التحكم غير مدعوم حالياً من الـ API.',
              );
            },
          ),
        ],
      ),
      body: Consumer<AdminUsersProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterChip(
                        'الكل',
                        provider.selectedRoleFilter == 'الكل',
                        () => provider.setRoleFilter('الكل'),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        'عملاء',
                        provider.selectedRoleFilter == 'عملاء',
                        () => provider.setRoleFilter('عملاء'),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        'سائقون',
                        provider.selectedRoleFilter == 'سائقون',
                        () => provider.setRoleFilter('سائقون'),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        'مديرون',
                        provider.selectedRoleFilter == 'مديرون',
                        () => provider.setRoleFilter('مديرون'),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: _buildBody(provider),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(AdminUsersProvider provider) {
    if (provider.loading && provider.users.isEmpty) {
      return const Center(child: AppLoading());
    }

    if (provider.error != null && provider.users.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(provider.error!),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: provider.loadUsers,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    final filtered = provider.filteredUsers;

    if (filtered.isEmpty) {
      return RefreshIndicator(
        onRefresh: provider.refresh,
        child: ListView(
          padding: const EdgeInsets.all(14),
          children: const [
            SizedBox(height: 100),
            Center(child: Text('لا يوجد مستخدمين')),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: provider.refresh,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        itemCount: filtered.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) {
          final u = filtered[i];
          return Card(
            child: Material(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      _roleColor(u.role.name).withValues(alpha: 0.15),
                  child: Icon(
                    _roleIcon(u.role.name),
                    color: _roleColor(u.role.name),
                  ),
                ),
                title: Text(
                  u.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  u.phone?.isNotEmpty == true ? u.phone! : u.email,
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _roleColor(u.role.name).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _roleName(u.role.name),
                        style: TextStyle(
                          color: _roleColor(u.role.name),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _roleColor(String r) {
    if (r == 'admin') return Colors.purple;
    if (r == 'delivery') return Colors.blue;
    return AppColors.primary;
  }

  IconData _roleIcon(String r) {
    if (r == 'admin') return Icons.admin_panel_settings_outlined;
    if (r == 'delivery') return Icons.delivery_dining;
    return Icons.person_outline;
  }

  String _roleName(String r) {
    if (r == 'admin') return 'مدير النظام';
    if (r == 'delivery') return 'سائق';
    return 'عميل';
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;
  const _FilterChip(this.label, this.selected, this.onSelected);
  @override
  Widget build(BuildContext context) => FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onSelected(),
      );
}
