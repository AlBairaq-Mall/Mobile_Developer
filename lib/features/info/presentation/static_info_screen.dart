import 'package:flutter/material.dart';

/// صفحة نصية عامة تُستخدم لعرض: من نحن، اتصل بنا، الأسئلة الشائعة،
/// سياسة الخصوصية، شروط الاستخدام. هذه الصفحات مذكورة في الوثيقة
/// ("صفحات إضافية مهمة") ولم تكن موجودة في المشروع إطلاقاً.
class StaticInfoScreen extends StatelessWidget {
  final String title;
  final String content;

  const StaticInfoScreen({
    super.key,
    required this.title,
    required this.content,
  });

  /// نسخة جاهزة لصفحة "اتصل بنا" تحتوي على وسائل تواصل بدل النص فقط.
  static Widget contactUs() => const _ContactUsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Text(content, style: const TextStyle(height: 1.8, fontSize: 15)),
      ),
    );
  }
}

class _ContactUsScreen extends StatelessWidget {
  const _ContactUsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('اتصل بنا')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          ListTile(
            leading: Icon(Icons.phone_outlined),
            title: Text('اتصل بنا'),
            subtitle: Text('+966 5X XXX XXXX'),
          ),
          ListTile(
            leading: Icon(Icons.email_outlined),
            title: Text('البريد الإلكتروني'),
            subtitle: Text('support@bhmmall.com'),
          ),
          ListTile(
            leading: Icon(Icons.location_on_outlined),
            title: Text('العنوان'),
            subtitle: Text('المملكة العربية السعودية'),
          ),
          ListTile(
            leading: Icon(Icons.chat_outlined),
            title: Text('واتساب خدمة العملاء'),
            subtitle: Text('+966 5X XXX XXXX'),
          ),
        ],
      ),
    );
  }
}
