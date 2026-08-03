import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/theme_provider.dart';
import '../../../app/localization/language_provider.dart';
import '../../../app/widgets/app_back_button.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final lang = context.watch<LanguageProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('الإعدادات'),
      ),
      body: ListView(
        children: [
          // المظهر
          const _SectionHeader('المظهر والواجهة'),
          SwitchListTile(
            secondary: Icon(theme.isDark ? Icons.dark_mode : Icons.light_mode,
                color: AppColors.primary),
            title: const Text('الوضع الليلي'),
            subtitle: Text(theme.isDark ? 'مفعّل' : 'معطّل'),
            value: theme.isDark,
            activeThumbColor: AppColors.primary,
            onChanged: theme.setDark,
          ),
          ListTile(
            leading: const Icon(Icons.language, color: AppColors.primary),
            title: const Text('اللغة'),
            subtitle: Text(lang.isArabic ? 'العربية' : 'English'),
            trailing: ToggleButtons(
              borderRadius: BorderRadius.circular(10),
              isSelected: [lang.isArabic, lang.isEnglish],
              selectedColor: Colors.white,
              fillColor: AppColors.primary,
              onPressed: (i) => i == 0 ? lang.setArabic() : lang.setEnglish(),
              children: const [
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text('ع',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text('EN',
                        style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          const Divider(),

          // الحساب
          const _SectionHeader('الحساب'),
          ListTile(
            leading: const Icon(Icons.notifications_outlined,
                color: AppColors.primary),
            title: const Text('الإشعارات'),
            trailing: const Icon(Icons.chevron_left),
            onTap: () => context.push(AppRoutes.notifications),
          ),
          ListTile(
            leading: const Icon(Icons.location_on_outlined,
                color: AppColors.primary),
            title: const Text('عناوين التوصيل'),
            trailing: const Icon(Icons.chevron_left),
            onTap: () => context.push(AppRoutes.addresses),
          ),
          const Divider(),

          // معلومات
          const _SectionHeader('معلومات'),
          ListTile(
            leading: const Icon(Icons.info_outline, color: AppColors.primary),
            title: const Text('من نحن'),
            trailing: const Icon(Icons.chevron_left),
            onTap: () => context.push(AppRoutes.aboutUs),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined,
                color: AppColors.primary),
            title: const Text('سياسة الخصوصية'),
            trailing: const Icon(Icons.chevron_left),
            onTap: () => context.push(AppRoutes.privacyPolicy),
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined,
                color: AppColors.primary),
            title: const Text('شروط الاستخدام'),
            trailing: const Icon(Icons.chevron_left),
            onTap: () => context.push(AppRoutes.termsOfUse),
          ),
          const Divider(),

          // الإصدار
          const ListTile(
            leading: Icon(Icons.info_outline, color: Colors.grey),
            title: Text('إصدار التطبيق', style: TextStyle(color: Colors.grey)),
            trailing: Text('v1.0.0', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Text(title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.outline,
                fontSize: 12)),
      );
}
