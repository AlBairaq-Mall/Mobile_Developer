import 'package:bhm_supermarket/features/address/providers/address_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../auth/providers/auth_provider.dart';
import '../../navigation/providers/navigation_provider.dart';
import '../../orders/providers/orders_provider.dart';

import '../../favorites/providers/favorites_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final ordersProvider = context.read<OrdersProvider>();
      final addressProvider = context.read<AddressProvider>();

      if (ordersProvider.orders.isEmpty) {
        ordersProvider.loadOrders();
      }

      if (addressProvider.addresses.isEmpty) {
        addressProvider.loadAddresses();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final ordersProvider = context.watch<OrdersProvider>();
    final addressProvider = context.watch<AddressProvider>();
    final favoritesProvider = context.watch<FavoritesProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header gradient
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 20,
                bottom: 32,
                left: 24,
                right: 24,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryLight, AppColors.primaryDark],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  // Avatar
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 16,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        user?.name.isNotEmpty == true
                            ? user!.name.substring(0, 1)
                            : '👤',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user?.name ?? 'المستخدم',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.phone ?? user?.email ?? '',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _StatBadge('${ordersProvider.orders.length}', 'طلب'),
                      const SizedBox(width: 16),
                      _StatBadge(
                        '${addressProvider.addresses.length}',
                        'عناوين',
                      ),
                      const SizedBox(width: 16),
                      _StatBadge('${favoritesProvider.ids.length}', 'مفضلة'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _MenuSection('حسابي', [
                    _MenuItem(
                      Icons.receipt_long_outlined,
                      'طلباتي',
                      AppColors.info,
                      () => context.push(AppRoutes.orders),
                    ),
                    _MenuItem(
                      Icons.favorite_border_rounded,
                      'المفضلة',
                      AppColors.error,
                      () => context.read<NavigationProvider>().changeTab(3),
                    ),
                    _MenuItem(
                      Icons.location_on_outlined,
                      'عناوين التوصيل',
                      AppColors.success,
                      () => context.push(AppRoutes.addresses),
                    ),
                    _MenuItem(
                      Icons.notifications_outlined,
                      'الإشعارات',
                      AppColors.accent,
                      () => context.push(AppRoutes.notifications),
                    ),
                    _MenuItem(
                      Icons.settings_outlined,
                      'الإعدادات',
                      AppColors.textSecondary,
                      () => context.push(AppRoutes.settings),
                    ),
                  ]),

                  const SizedBox(height: 16),

                  _MenuSection('الدعم والمعلومات', [
                    _MenuItem(
                      Icons.info_outline,
                      'من نحن',
                      AppColors.primary,
                      () => context.push(AppRoutes.aboutUs),
                    ),
                    _MenuItem(
                      Icons.phone_outlined,
                      'اتصل بنا',
                      AppColors.info,
                      () => context.push(AppRoutes.contactUs),
                    ),
                    _MenuItem(
                      Icons.help_outline_rounded,
                      'الأسئلة الشائعة',
                      AppColors.accent,
                      () => context.push(AppRoutes.faq),
                    ),
                    _MenuItem(
                      Icons.privacy_tip_outlined,
                      'سياسة الخصوصية',
                      AppColors.textSecondary,
                      () => context.push(AppRoutes.privacyPolicy),
                    ),
                  ]),

                  const SizedBox(height: 16),

                  // Logout
                  GestureDetector(
                    onTap: () => showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        title: const Text('تسجيل الخروج'),
                        content: const Text('هل تريد تسجيل الخروج من حسابك؟'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('إلغاء'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await context.read<AuthProvider>().logout();

                              if (!ctx.mounted) return;

                              Navigator.pop(ctx);
                              context.go(AppRoutes.login);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.error,
                              minimumSize: const Size(80, 40),
                            ),
                            child: const Text('خروج'),
                          ),
                        ],
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.error.withValues(alpha: 0.2),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.logout_rounded, color: AppColors.error),
                          SizedBox(width: 12),
                          Text(
                            'تسجيل الخروج',
                            style: TextStyle(
                              color: AppColors.error,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  const Text(
                    'البيرق هايبر ماركت v1.0.0',
                    style: TextStyle(color: AppColors.textHint, fontSize: 12),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String value, label;
  const _StatBadge(this.value, this.label);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.85),
            fontSize: 11,
          ),
        ),
      ],
    ),
  );
}

class _MenuItem {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  _MenuItem(this.icon, this.label, this.color, this.onTap);
}

class _MenuSection extends StatelessWidget {
  final String title;
  final List<_MenuItem> items;
  const _MenuSection(this.title, this.items);
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(right: 4, bottom: 10),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
          ),
        ),
      ),
      Material(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: items.asMap().entries.map((e) {
              final i = e.key;
              final item = e.value;
              return Column(
                children: [
                  ListTile(
                    onTap: item.onTap,
                    leading: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: item.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(item.icon, color: item.color, size: 20),
                    ),
                    title: Text(
                      item.label,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.chevron_left,
                      color: AppColors.textHint,
                      size: 20,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 2,
                    ),
                  ),
                  if (i < items.length - 1)
                    const Divider(height: 1, indent: 72, endIndent: 16),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    ],
  );
}
