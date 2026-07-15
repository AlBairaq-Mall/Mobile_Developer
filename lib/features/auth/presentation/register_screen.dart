import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../app/router/app_routes.dart';
import '../models/user_model.dart';

/// شاشة إنشاء حساب جديد (متطلب وظيفي رقم 05 في وثيقة المتطلبات).
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_nameController.text.trim().isEmpty ||
        _phoneController.text.trim().length < 9) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال الاسم ورقم هاتف صحيح')),
      );
      return;
    }

    // TODO: ربط هذا الاستدعاء بـ AuthRepository الفعلي عند توفر الـ API.
    context.push(
      AppRoutes.otp,
      extra: {
        "name": _nameController.text.trim(),
        "phone": _phoneController.text.trim(),
        "email": _emailController.text.trim(),
        'contact': _phoneController.text.trim(),
        'method': 'phone',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء حساب جديد')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                hint: 'الاسم الكامل',
                controller: _nameController,
                prefixIcon: const Icon(Icons.person_outline),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                hint: 'رقم الهاتف',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                prefixIcon: const Icon(Icons.phone_outlined),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                hint: 'البريد الإلكتروني (اختياري)',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.email_outlined),
              ),
              const SizedBox(height: 28),
              CustomButton(text: 'متابعة', onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }
}
