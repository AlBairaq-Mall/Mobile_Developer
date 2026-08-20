import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../auth/models/user_model.dart';
import '../../providers/admin_users_provider.dart';

class AdminDriverPickerSheet extends StatelessWidget {
  const AdminDriverPickerSheet({super.key});

  static Future<int?> show(BuildContext context) {
    return showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AdminDriverPickerSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'اختر سائق التوصيل',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Consumer<AdminUsersProvider>(
              builder: (context, provider, _) {
                // Fetch users if not loaded yet
                if (provider.users.isEmpty && !provider.loading && provider.error == null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    provider.loadUsers();
                  });
                }

                if (provider.loading && provider.users.isEmpty) {
                  return const Center(child: AppLoading());
                }

                if (provider.error != null && provider.users.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(provider.error!),
                        ElevatedButton(
                          onPressed: provider.loadUsers,
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  );
                }

                final drivers = provider.users.where((u) => u.role == UserRole.delivery).toList();

                if (drivers.isEmpty) {
                  return const Center(
                    child: Text('لا يوجد سائقو توصيل متاحين'),
                  );
                }

                return ListView.separated(
                  itemCount: drivers.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final driver = drivers[index];
                    return ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.delivery_dining, color: Colors.white),
                      ),
                      title: Text(driver.name),
                      subtitle: Text(driver.phone ?? driver.email),
                      onTap: () {
                        Navigator.pop(context, driver.id);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
