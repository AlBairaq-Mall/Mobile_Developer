// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';

// import '../../../app/router/app_routes.dart';
// import '../../../app/theme/app_colors.dart';
// import '../../cart/providers/cart_provider.dart';
// import '../models/user_model.dart';
// import '../providers/auth_provider.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({
//     super.key,
//     this.redirectTo,
//   });

//   final String? redirectTo;

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();

//   String? _error;
//   bool _loading = false;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   Future<void> _submit() async {
//     if (_loading) {
//       return;
//     }

//     final email = _emailController.text.trim();
//     final password = _passwordController.text.trim();

//     if (email.isEmpty) {
//       setState(() => _error = 'البريد الإلكتروني مطلوب');
//       return;
//     }

//     if (!email.contains('@')) {
//       setState(() => _error = 'البريد الإلكتروني غير صحيح');
//       return;
//     }

//     if (password.isEmpty) {
//       setState(() => _error = 'كلمة المرور مطلوبة');
//       return;
//     }

//     setState(() {
//       _error = null;
//       _loading = true;
//     });

//     final auth = context.read<AuthProvider>();

//     final error = await auth.login(
//       email: email,
//       password: password,
//     );

//     if (!mounted) {
//       return;
//     }

//     if (error != null) {
//       setState(() {
//         _loading = false;
//         _error = error;
//       });
//       return;
//     }

//     final role = auth.user?.role;

//     if (role == UserRole.customer) {
//       await context.read<CartProvider>().mergeGuestCart();
//     }

//     if (!mounted) {
//       return;
//     }

//     setState(() {
//       _loading = false;
//     });

//     switch (role) {
//       case UserRole.admin:
//         context.go(AppRoutes.adminDashboard);
//         return;

//       case UserRole.delivery:
//         context.go(AppRoutes.deliveryHome);
//         return;

//       case UserRole.customer:
//       default:
//         final target = widget.redirectTo ?? auth.consumePendingRedirect();

//         context.go(target);
//         return;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             height: 280,
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   AppColors.primary,
//                   AppColors.primaryDark,
//                 ],
//               ),
//             ),
//           ),
//           SafeArea(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 24,
//               ),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 60),
//                   Container(
//                     width: 90,
//                     height: 90,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(24),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withValues(
//                             alpha: 0.1,
//                           ),
//                           blurRadius: 20,
//                         ),
//                       ],
//                     ),
//                     child: const Icon(
//                       Icons.storefront_rounded,
//                       size: 50,
//                       color: AppColors.primary,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   const Text(
//                     'البيرق هايبر ماركت',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     'تسوق ذكي • توصيل سريع',
//                     style: TextStyle(
//                       color: Colors.white.withValues(
//                         alpha: 0.8,
//                       ),
//                       fontSize: 13,
//                     ),
//                   ),
//                   const SizedBox(height: 40),
//                   Container(
//                     padding: const EdgeInsets.all(24),
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).colorScheme.surface,
//                       borderRadius: BorderRadius.circular(24),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withValues(
//                             alpha: 0.08,
//                           ),
//                           blurRadius: 24,
//                           offset: const Offset(0, 8),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         Text(
//                           'تسجيل الدخول',
//                           style: Theme.of(context)
//                               .textTheme
//                               .headlineSmall
//                               ?.copyWith(
//                                 fontWeight: FontWeight.bold,
//                               ),
//                         ),
//                         const SizedBox(height: 6),
//                         Text(
//                           'مرحباً بك! سجّل دخولك للمتابعة',
//                           style: TextStyle(
//                             color: Theme.of(context).colorScheme.outline,
//                             fontSize: 14,
//                           ),
//                         ),
//                         const SizedBox(height: 24),
//                         TextField(
//                           controller: _emailController,
//                           keyboardType: TextInputType.emailAddress,
//                           textDirection: TextDirection.ltr,
//                           enabled: !_loading,
//                           decoration: const InputDecoration(
//                             labelText: 'البريد الإلكتروني',
//                             prefixIcon: Icon(Icons.email_outlined),
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         TextField(
//                           controller: _passwordController,
//                           obscureText: true,
//                           enabled: !_loading,
//                           decoration: const InputDecoration(
//                             labelText: 'كلمة المرور',
//                             prefixIcon: Icon(Icons.lock_outline),
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         if (_error != null) ...[
//                           Text(
//                             _error!,
//                             style: const TextStyle(
//                               color: AppColors.error,
//                               fontSize: 13,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                           const SizedBox(height: 8),
//                         ],
//                         SizedBox(
//                           height: 48,
//                           child: _loading
//                               ? const Center(
//                                   child: CircularProgressIndicator(),
//                                 )
//                               : ElevatedButton(
//                                   onPressed: _submit,
//                                   child: const Text(
//                                     'تسجيل الدخول',
//                                   ),
//                                 ),
//                         ),
//                         const SizedBox(height: 16),
//                         Center(
//                           child: GestureDetector(
//                             onTap: _loading
//                                 ? null
//                                 : () {
//                                     context.push(
//                                       AppRoutes.register,
//                                     );
//                                   },
//                             child: RichText(
//                               text: TextSpan(
//                                 text: 'ليس لديك حساب؟  ',
//                                 style: TextStyle(
//                                   color: Theme.of(context).colorScheme.outline,
//                                   fontFamily: 'Cairo',
//                                 ),
//                                 children: const [
//                                   TextSpan(
//                                     text: 'إنشاء حساب',
//                                     style: TextStyle(
//                                       color: AppColors.primary,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:bhm_supermarket/core/widgets/app_message.dart';
import 'package:flutter/material.dart';
import '../../../core/widgets/loading_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../cart/providers/cart_provider.dart';
import '../models/user_model.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    this.redirectTo,
  });

  final String? redirectTo;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // منع الضغط المتكرر أثناء الطلب.
    if (_loading) {
      return;
    }

    final email = _emailController.text.trim();

    // مهم:
    // لا نستخدم trim() مع كلمة المرور.
    // كلمة المرور يجب إرسالها كما كتبها المستخدم بالضبط.
    final password = _passwordController.text;

    // ─────────────────────────────────────────────────────────────
    // التحقق من البريد الإلكتروني
    // ─────────────────────────────────────────────────────────────

    final emailError = Validators.email(email);

    if (emailError != null) {
      AppMessage.error(
        context,
        emailError,
      );
      return;
    }

    // ─────────────────────────────────────────────────────────────
    // التحقق من كلمة المرور
    // ─────────────────────────────────────────────────────────────

    if (password.isEmpty) {
      AppMessage.error(
        context,
        'كلمة المرور مطلوبة',
      );
      return;
    }

    // ─────────────────────────────────────────────────────────────
    // بدء تسجيل الدخول
    // ─────────────────────────────────────────────────────────────

    setState(() {
      _loading = true;
    });

    final auth = context.read<AuthProvider>();

    final error = await auth.login(
      email: email,
      password: password,
    );

    if (!mounted) {
      return;
    }

    // ─────────────────────────────────────────────────────────────
    // فشل تسجيل الدخول
    // ─────────────────────────────────────────────────────────────

    if (error != null) {
      setState(() {
        _loading = false;
      });

      AppMessage.error(
        context,
        error,
      );

      return;
    }

    // ─────────────────────────────────────────────────────────────
    // نجاح تسجيل الدخول
    // ─────────────────────────────────────────────────────────────

    final role = auth.user?.role;

    // إذا كان Customer:
    // ندمج سلة Guest المحلية مع سلة الحساب.
    if (role == UserRole.customer) {
      await context.read<CartProvider>().mergeGuestCart();
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _loading = false;
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
        final target = widget.redirectTo ?? auth.consumePendingRedirect();

        context.go(target);
        return;
    }
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
                colors: [
                  AppColors.primary,
                  AppColors.primaryDark,
                ],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 60),

                  // ─────────────────────────────────────────────────
                  // Logo
                  // ─────────────────────────────────────────────────

                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: 0.1,
                          ),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.storefront_rounded,
                      size: 50,
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'البيرق هايبر ماركت',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    'تسوق ذكي • توصيل سريع',
                    style: TextStyle(
                      color: Colors.white.withValues(
                        alpha: 0.8,
                      ),
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // ─────────────────────────────────────────────────
                  // Login Card
                  // ─────────────────────────────────────────────────

                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: 0.08,
                          ),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'تسجيل الدخول',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          'مرحباً بك! سجّل دخولك للمتابعة',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.outline,
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ───────────────────────────────────────────
                        // Email
                        // ───────────────────────────────────────────

                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textDirection: TextDirection.ltr,
                          enabled: !_loading,
                          autofillHints: const [
                            AutofillHints.username,
                            AutofillHints.email,
                          ],
                          decoration: const InputDecoration(
                            labelText: 'البريد الإلكتروني',
                            prefixIcon: Icon(
                              Icons.email_outlined,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ───────────────────────────────────────────
                        // Password
                        // ───────────────────────────────────────────

                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          enabled: !_loading,
                          textDirection: TextDirection.ltr,
                          autofillHints: const [
                            AutofillHints.password,
                          ],
                          decoration: InputDecoration(
                            labelText: 'كلمة المرور',
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                            ),
                            suffixIcon: IconButton(
                              tooltip: _obscurePassword
                                  ? 'إظهار كلمة المرور'
                                  : 'إخفاء كلمة المرور',
                              onPressed: _loading
                                  ? null
                                  : () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                        // ───────────────────────────────────────────
                        // Submit
                        // ───────────────────────────────────────────

                        SizedBox(
                          height: 48,
                          child: _loading
                              ? const Center(
                                  child: AppLoading(
                                    type: AppLoadingType.bars,
                                    size: 24,
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: _submit,
                                  child: const Text(
                                    'تسجيل الدخول',
                                  ),
                                ),
                        ),

                        const SizedBox(height: 16),

                        // ───────────────────────────────────────────
                        // Register
                        // ───────────────────────────────────────────

                        Center(
                          child: GestureDetector(
                            onTap: _loading
                                ? null
                                : () {
                                    context.push(
                                      AppRoutes.register,
                                    );
                                  },
                            child: RichText(
                              text: TextSpan(
                                text: 'ليس لديك حساب؟  ',
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.outline,
                                  fontFamily: 'Cairo',
                                ),
                                children: const [
                                  TextSpan(
                                    text: 'إنشاء حساب',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
