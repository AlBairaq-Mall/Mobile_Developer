import 'package:flutter/material.dart';

import '../../../app/widgets/app_back_button.dart';

class NotificationModel {
  final String title;
  final String body;
  final DateTime date;
  final bool read;

  const NotificationModel({
    required this.title,
    required this.body,
    required this.date,
    this.read = false,
  });
}

/// شاشة الإشعارات: العروض والتنبيهات (الصفحة رقم 15 في الوثيقة).
/// حالياً تعرض بيانات تجريبية إلى حين توفر API الإشعارات.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = <NotificationModel>[
      NotificationModel(
        title: 'عرض خاص اليوم!',
        body: 'خصم 20% على جميع منتجات الألبان حتى نهاية اليوم.',
        date: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      NotificationModel(
        title: 'تم شحن طلبك',
        body: 'طلبك رقم #1042 خرج للتوصيل الآن.',
        date: DateTime.now().subtract(const Duration(days: 1)),
        read: true,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('الإشعارات'),
      ),
      body: notifications.isEmpty
          ? const Center(child: Text('لا توجد إشعارات حالياً'))
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final n = notifications[index];
                return Card(
                  child: Material(
                    color: n.read ? null : Colors.green.withValues(alpha: 0.06),
                    child: ListTile(
                      leading: const Icon(Icons.notifications_outlined),
                      title: Text(
                        n.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(n.body),
                      trailing: !n.read
                          ? const Icon(Icons.circle,
                              size: 10, color: Colors.green)
                          : null,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
