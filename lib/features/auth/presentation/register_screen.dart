import 'package:flutter/material.dart';
import '../../../core/widgets/loading_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../app/router/app_routes.dart';
import '../../../core/widgets/app_page_header.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../cart/providers/cart_provider.dart';
import '../models/user_model.dart';
import '../providers/auth_provider.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_message.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isLoading) {
      return;
    }

    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();

    // لا نستخدم trim() مع كلمات المرور.
    // يجب إرسالها كما كتبها المستخدم.
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // ─────────────────────────────────────────────────────────────
    // الاسم
    // ─────────────────────────────────────────────────────────────

    final nameError = Validators.required(
      name,
      'الاسم الكامل',
    );

    if (nameError != null) {
      _showMessage(nameError);
      return;
    }

    // ─────────────────────────────────────────────────────────────
    // رقم الهاتف
    // ─────────────────────────────────────────────────────────────

    final phoneError = Validators.phone(phone);

    if (phoneError != null) {
      _showMessage(phoneError);
      return;
    }

    // ─────────────────────────────────────────────────────────────
    // البريد الإلكتروني
    // ─────────────────────────────────────────────────────────────

    final emailError = Validators.email(email);

    if (emailError != null) {
      _showMessage(emailError);
      return;
    }

    // ─────────────────────────────────────────────────────────────
    // كلمة المرور
    // ─────────────────────────────────────────────────────────────

    if (password.isEmpty) {
      _showMessage('كلمة المرور مطلوبة');
      return;
    }

    // ─────────────────────────────────────────────────────────────
    // تأكيد كلمة المرور
    // ─────────────────────────────────────────────────────────────

    if (confirmPassword.isEmpty) {
      _showMessage('تأكيد كلمة المرور مطلوب');
      return;
    }

    if (password != confirmPassword) {
      _showMessage('كلمتا المرور غير متطابقتين');
      return;
    }

    // ─────────────────────────────────────────────────────────────
    // بدء التسجيل
    // ─────────────────────────────────────────────────────────────

    setState(() {
      _isLoading = true;
    });

    final auth = context.read<AuthProvider>();

    final error = await auth.register(
      name: name,
      phone: phone,
      email: email,
      password: password,
      passwordConfirmation: confirmPassword,
    );

    if (!mounted) {
      return;
    }

    // ─────────────────────────────────────────────────────────────
    // فشل التسجيل
    // ─────────────────────────────────────────────────────────────

    if (error != null) {
      setState(() {
        _isLoading = false;
      });

      _showMessage(error);
      return;
    }

    // ─────────────────────────────────────────────────────────────
    // نجاح التسجيل
    // ─────────────────────────────────────────────────────────────

    final role = auth.user?.role;

    if (role == UserRole.customer) {
      await context.read<CartProvider>().mergeGuestCart();
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = false;
    });

    // ─────────────────────────────────────────────────────────────
    // التوجيه حسب Role
    // ─────────────────────────────────────────────────────────────

    switch (role) {
      case UserRole.admin:
        context.go(AppRoutes.adminDashboard);
        return;

      case UserRole.delivery:
        context.go(AppRoutes.deliveryHome);
        return;

      case UserRole.customer:
      default:
        context.go(
          auth.consumePendingRedirect(),
        );
        return;
    }
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }

    AppMessage.error(
      context,
      message,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppPageHeader(
        title: 'إنشاء حساب جديد',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                hint: 'الاسم الكامل',
                controller: _nameController,
                prefixIcon: const Icon(
                  Icons.person_outline,
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                hint: 'رقم الهاتف',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                prefixIcon: const Icon(
                  Icons.phone_outlined,
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                hint: 'البريد الإلكتروني',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(
                  Icons.email_outlined,
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                hint: 'كلمة المرور',
                controller: _passwordController,
                obscureText: true,
                prefixIcon: const Icon(
                  Icons.lock_outline,
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                hint: 'تأكيد كلمة المرور',
                controller: _confirmPasswordController,
                obscureText: true,
                prefixIcon: const Icon(
                  Icons.lock_reset_outlined,
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: _isLoading
                    ? const Center(
                        child: AppLoading(
                          type: AppLoadingType.bars,
                          size: 24,
                        ),
                      )
                    : CustomButton(
                        text: 'إنشاء حساب',
                        onPressed: _submit,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
