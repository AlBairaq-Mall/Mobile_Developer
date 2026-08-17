// import 'package:bhm_supermarket/app/router/app_routes.dart';
// import 'package:bhm_supermarket/core/widgets/app_page_header.dart';
// import 'package:bhm_supermarket/features/auth/models/user_model.dart';
// import 'package:bhm_supermarket/features/auth/providers/auth_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';
// import '../../../core/widgets/custom_button.dart';
// import '../../../core/widgets/custom_text_field.dart';

// /// شاشة إنشاء حساب جديد (متطلب وظيفي رقم 05 في وثيقة المتطلبات).
// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final _nameController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();

//   bool _isLoading = false;

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _phoneController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   Future<void> _submit() async {
//     if (_isLoading) return; // prevent double submit

//     if (_nameController.text.trim().isEmpty ||
//         _phoneController.text.trim().length < 9) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('الرجاء إدخال الاسم ورقم هاتف صحيح')),
//       );
//       return;
//     }

//     if (_passwordController.text != _confirmPasswordController.text) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("كلمتا المرور غير متطابقتين")),
//       );
//       return;
//     }

//     setState(() => _isLoading = true);

//     final auth = context.read<AuthProvider>();

//     final error = await auth.register(
//       name: _nameController.text.trim(),
//       phone: _phoneController.text.trim(),
//       email: _emailController.text.trim(),
//       password: _passwordController.text.trim(),
//       passwordConfirmation: _confirmPasswordController.text.trim(),
//     );

//     if (!mounted) return;

//     setState(() => _isLoading = false);

//     if (error != null) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text(error)));
//       return;
//     }

//     switch (auth.user?.role) {
//       case UserRole.admin:
//         context.go(AppRoutes.adminDashboard);
//         break;

//       case UserRole.delivery:
//         context.go(AppRoutes.deliveryHome);
//         break;

//       case UserRole.customer:
//       default:
//         context.go(auth.consumePendingRedirect());
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const AppPageHeader(title: 'إنشاء حساب جديد'),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CustomTextField(
//                 hint: 'الاسم الكامل',
//                 controller: _nameController,
//                 prefixIcon: const Icon(Icons.person_outline),
//               ),
//               const SizedBox(height: 16),
//               CustomTextField(
//                 hint: 'رقم الهاتف',
//                 controller: _phoneController,
//                 keyboardType: TextInputType.phone,
//                 prefixIcon: const Icon(Icons.phone_outlined),
//               ),
//               const SizedBox(height: 16),
//               CustomTextField(
//                 hint: 'البريد الإلكتروني',
//                 controller: _emailController,
//                 keyboardType: TextInputType.emailAddress,
//                 prefixIcon: const Icon(Icons.email_outlined),
//               ),
//               const SizedBox(height: 16),
//               CustomTextField(
//                 hint: 'كلمة المرور',
//                 controller: _passwordController,
//                 obscureText: true,
//                 prefixIcon: const Icon(Icons.lock_outline),
//               ),
//               const SizedBox(height: 16),
//               CustomTextField(
//                 hint: 'تأكيد كلمة المرور',
//                 controller: _confirmPasswordController,
//                 obscureText: true,
//                 prefixIcon: const Icon(Icons.lock_reset_outlined),
//               ),
//               const SizedBox(height: 28),
//               _isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : CustomButton(text: 'إنشاء حساب', onPressed: _submit),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/widgets/app_page_header.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../cart/providers/cart_provider.dart';
import '../models/user_model.dart';
import '../providers/auth_provider.dart';

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
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (name.isEmpty || phone.length < 9) {
      _showMessage(
        'الرجاء إدخال الاسم ورقم هاتف صحيح',
      );
      return;
    }

    if (email.isEmpty || !email.contains('@')) {
      _showMessage(
        'الرجاء إدخال بريد إلكتروني صحيح',
      );
      return;
    }

    if (password.isEmpty) {
      _showMessage(
        'كلمة المرور مطلوبة',
      );
      return;
    }

    if (password != confirmPassword) {
      _showMessage(
        'كلمتا المرور غير متطابقتين',
      );
      return;
    }

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

    if (error != null) {
      setState(() {
        _isLoading = false;
      });

      _showMessage(error);
      return;
    }

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

    switch (role) {
      case UserRole.admin:
        context.go(AppRoutes.adminDashboard);
        break;

      case UserRole.delivery:
        context.go(AppRoutes.deliveryHome);
        break;

      case UserRole.customer:
      default:
        context.go(
          auth.consumePendingRedirect(),
        );
        break;
    }
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
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
                        child: CircularProgressIndicator(),
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
