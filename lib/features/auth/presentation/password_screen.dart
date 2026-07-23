// import 'package:flutter/material.dart';

// class PasswordScreen extends StatefulWidget {
//   const PasswordScreen({
//     super.key,
//     required this.email,
//   });

//   final String email;

//   @override
//   State<PasswordScreen> createState() => _PasswordScreenState();
// }

// class _PasswordScreenState extends State<PasswordScreen> {
//   final _passwordController = TextEditingController();

//   bool _loading = false;
//   String? _error;
//   bool _obscure = true;

//   @override
//   void dispose() {
//     _passwordController.dispose();
//     super.dispose();
//   }

//   Future<void> _login() async {
//     final password = _passwordController.text.trim();

//     if (password.isEmpty) {
//       setState(() {
//         _error = "أدخل كلمة المرور";
//       });
//       return;
//     }

//     setState(() {
//       _loading = true;
//       _error = null;
//     });

//     // سنربطها مع AuthProvider في الخطوة القادمة

//     await Future.delayed(const Duration(seconds: 1));

//     if (!mounted) return;

//     setState(() {
//       _loading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("تسجيل الدخول"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           children: [
//             Text(
//               widget.email,
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 30),
//             TextField(
//               controller: _passwordController,
//               obscureText: _obscure,
//               decoration: InputDecoration(
//                 labelText: "كلمة المرور",
//                 errorText: _error,
//                 prefixIcon: const Icon(Icons.lock_outline),
//                 suffixIcon: IconButton(
//                   icon: Icon(
//                     _obscure ? Icons.visibility : Icons.visibility_off,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       _obscure = !_obscure;
//                     });
//                   },
//                 ),
//               ),
//             ),
//             const SizedBox(height: 30),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: _loading ? null : _login,
//                 child: _loading
//                     ? const CircularProgressIndicator()
//                     : const Text("دخول"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
