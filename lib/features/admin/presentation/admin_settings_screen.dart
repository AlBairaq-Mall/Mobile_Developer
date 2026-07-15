import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/theme_provider.dart';
import '../../../app/localization/language_provider.dart';

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final lang  = context.watch<LanguageProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('إعدادات النظام')),
      body: ListView(
        children: [
          // واجهة التطبيق
          const _SectionTitle('واجهة التطبيق'),
          SwitchListTile(
            title: const Text('الوضع الليلي'),
            subtitle: const Text('تغيير المظهر للوضع الداكن'),
            secondary: const Icon(Icons.dark_mode_outlined),
            value: theme.isDark,
            activeColor: AppColors.primary,
            onChanged: (v) => theme.setDark(v),
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
          const Divider(),

          // إعدادات الطلبات
          const _SectionTitle('إعدادات الطلبات'),
          const ListTile(leading: Icon(Icons.monetization_on_outlined), title: Text('رسوم التوصيل'), subtitle: Text('1000 ر.ي'), trailing: Icon(Icons.chevron_left)),
          const ListTile(leading: Icon(Icons.timer_outlined), title: Text('الحد الأدنى للطلب'), subtitle: Text('2000 ر.ي'), trailing: Icon(Icons.chevron_left)),
          const Divider(),

          // إدارة المديرين
          const _SectionTitle('إدارة المديرين والسائقين'),
          ListTile(
            leading: const Icon(Icons.admin_panel_settings_outlined),
            title: const Text('حسابات المديرين'),
            subtitle: const Text('إضافة / تعديل / حذف حسابات الإدارة'),
            trailing: const Icon(Icons.chevron_left),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.delivery_dining_outlined),
            title: const Text('حسابات السائقين'),
            subtitle: const Text('إضافة / تعديل / حذف حسابات التوصيل'),
            trailing: const Icon(Icons.chevron_left),
            onTap: () {},
          ),
          const Divider(),

          // Laravel API
          const _SectionTitle('إعدادات API (ربط Laravel)'),
          const ListTile(leading: Icon(Icons.link), title: Text('رابط الـ API'), subtitle: Text('https://api.bhmstore.com'), trailing: Icon(Icons.chevron_left)),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
    child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.outline, fontSize: 12)),
  );
}
