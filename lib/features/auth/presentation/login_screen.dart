import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.redirectTo});

  final String? redirectTo;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _ctrl = TextEditingController();
  String? _error;
  bool _loading = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final value = _ctrl.text.trim();
    if (value.isEmpty) {
      setState(() => _error = 'هذا الحقل مطلوب');
      return;
    }
    if (!value.contains('@')) {
      setState(() => _error = 'البريد الإلكتروني غير صحيح');
      return;
    }

    setState(() {
      _error = null;
      _loading = true;
    });

    final auth = context.read<AuthProvider>();
    final sendError = await auth.sendOtp(email: value);
    if (!mounted) return;

    if (sendError != null) {
      setState(() {
        _error = sendError;
        _loading = false;
      });
      return;
    }

    setState(() => _loading = false);
    context.push(
      AppRoutes.otp,
      extra: {
        'contact': value,
        'email': value,
        'method': 'email',
        'redirect': widget.redirectTo,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 280,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.storefront_rounded,
                        size: 50, color: AppColors.primary),
                  ),
                  const SizedBox(height: 16),
                  const Text('البيرق هايبر ماركت',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('تسوق ذكي • توصيل سريع',
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 13)),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('تسجيل الدخول',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text('مرحباً بك! سجّل دخولك للمتابعة',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.outline,
                                fontSize: 14)),
                        const SizedBox(height: 24),
                        TextField(
                          controller: _ctrl,
                          keyboardType: TextInputType.emailAddress,
                          textDirection: TextDirection.ltr,
                          decoration: InputDecoration(
                            hintText: 'example@email.com',
                            prefixIcon: const Icon(Icons.email_outlined),
                            errorText: _error,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _loading
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                                onPressed: _submit,
                                child: const Text('متابعة'),
                              ),
                        const SizedBox(height: 16),
                        Center(
                          child: GestureDetector(
                            onTap: () => context.push(AppRoutes.register),
                            child: RichText(
                              text: TextSpan(
                                text: 'ليس لديك حساب؟  ',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                    fontFamily: 'Cairo'),
                                children: const [
                                  TextSpan(
                                      text: 'إنشاء حساب',
                                      style: TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _QuickLink(
                          'لوحة التحكم',
                          Icons.admin_panel_settings_outlined,
                          AppRoutes.adminLogin,
                          context),
                      const SizedBox(width: 12),
                      _QuickLink(
                          'بوابة التوصيل',
                          Icons.delivery_dining_outlined,
                          AppRoutes.deliveryLogin,
                          context),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _QuickLink(
      String label, IconData icon, String route, BuildContext ctx) {
    return GestureDetector(
      onTap: () => ctx.go(route),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
        ),
        child: Row(children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }
}
