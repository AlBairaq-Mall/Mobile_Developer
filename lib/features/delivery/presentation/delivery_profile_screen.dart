import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/theme_provider.dart';
import '../../../app/localization/language_provider.dart';
import '../../auth/providers/auth_provider.dart';

class DeliveryProfileScreen extends StatelessWidget {
  const DeliveryProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user   = context.watch<AuthProvider>().user;
    final theme  = context.watch<ThemeProvider>();
    final lang   = context.watch<LanguageProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('الملف الشخصي')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // بطاقة المعلومات
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.blue.shade700.withOpacity(0.1),
                    child: Icon(Icons.delivery_dining, size: 40, color: Colors.blue.shade700),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user?.name ?? 'سائق التوصيل',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(user?.email ?? '', style: const TextStyle(color: Colors.grey)),
                      Text(user?.phone ?? '', style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // إعدادات
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.dark_mode_outlined),
                  title: const Text('الوضع الليلي'),
                  value: theme.isDark,
                  activeColor: AppColors.primary,
                  onChanged: theme.setDark,
                ),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text('اللغة'),
                  subtitle: Text(lang.isArabic ? 'العربية' : 'English'),
                  trailing: ToggleButtons(
                    borderRadius: BorderRadius.circular(8),
                    isSelected: [lang.isArabic, lang.isEnglish],
                    onPressed: (i) => i == 0 ? lang.setArabic() : lang.setEnglish(),
                    children: const [
                      Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('ع')),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('EN')),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // تسجيل الخروج
          ListTile(
            tileColor: Colors.red.withOpacity(0.06),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('تسجيل الخروج', style: TextStyle(color: Colors.red)),
            onTap: () {
              context.read<AuthProvider>().logout();
              context.go(AppRoutes.deliveryLogin);
            },
          ),
        ],
      ),
    );
  }
}
