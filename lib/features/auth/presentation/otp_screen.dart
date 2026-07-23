// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';

// import '../../../app/router/app_routes.dart';
// import '../../../app/theme/app_colors.dart';
// import '../providers/auth_provider.dart';

// /// OTP verification screen — email channel by default.
// class OtpScreen extends StatefulWidget {
//   final String name;
//   final String phone;
//   final String email;
//   final String contact;
//   final String method;
//   final String? redirectTo;

//   const OtpScreen({
//     super.key,
//     this.name = '',
//     this.phone = '',
//     this.email = '',
//     this.contact = '',
//     this.method = 'email',
//     this.redirectTo,
//   });

//   @override
//   State<OtpScreen> createState() => _OtpScreenState();
// }

// class _OtpScreenState extends State<OtpScreen> {
//   final _controllers = List.generate(4, (_) => TextEditingController());
//   final _focusNodes = List.generate(4, (_) => FocusNode());
//   Timer? _timer;
//   int _secondsLeft = 60;
//   String? _error;
//   bool _isVerifying = false;

//   bool get _isEmail => widget.method == 'email';

//   @override
//   void initState() {
//     super.initState();
//     _startTimer();
//   }

//   void _startTimer() {
//     _secondsLeft = 60;
//     _timer?.cancel();
//     _timer = Timer.periodic(const Duration(seconds: 1), (t) {
//       if (_secondsLeft == 0) {
//         t.cancel();
//       } else {
//         setState(() => _secondsLeft--);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     for (final c in _controllers) {
//       c.dispose();
//     }
//     for (final f in _focusNodes) {
//       f.dispose();
//     }
//     super.dispose();
//   }

//   String get _otpValue => _controllers.map((c) => c.text).join();

//   Future<void> _verify() async {
//     if (_otpValue.length != 4) {
//       setState(() => _error = 'أدخل الرمز المكون من 4 أرقام');
//       return;
//     }
//     setState(() {
//       _isVerifying = true;
//       _error = null;
//     });

//     final auth = context.read<AuthProvider>();
//     final email = widget.email.isNotEmpty ? widget.email : widget.contact;
//     final verifyError = await auth.verifyOtp(
//       email: email,
//       otp: _otpValue,
//       name: widget.name.isNotEmpty ? widget.name : null,
//       phone: widget.phone.isNotEmpty ? widget.phone : null,
//     );

//     if (!mounted) return;

//     if (verifyError != null) {
//       setState(() {
//         _error = verifyError;
//         _isVerifying = false;
//       });
//       return;
//     }

//     setState(() => _isVerifying = false);

//     final user = auth.user;
//     final redirect = widget.redirectTo ?? auth.pendingRedirect;
//     auth.clearPendingRedirect();

//     if (redirect != null && redirect.isNotEmpty) {
//       context.go(redirect);
//       return;
//     }

//     if (user == null || user.isCustomer) {
//       context.go(AppRoutes.home);
//     } else if (user.isAdmin) {
//       context.go(AppRoutes.adminDashboard);
//     } else if (user.isDelivery) {
//       context.go(AppRoutes.deliveryHome);
//     }
//   }

//   void _onDigitChanged(String val, int index) {
//     if (val.length == 1 && index < 3) {
//       _focusNodes[index + 1].requestFocus();
//     }
//     if (val.isEmpty && index > 0) {
//       _focusNodes[index - 1].requestFocus();
//     }
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(28),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 16),
//               Text(
//                 'رمز التحقق',
//                 style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                       fontWeight: FontWeight.bold,
//                     ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 _isEmail
//                     ? 'تم إرسال رمز التحقق إلى بريدك الإلكتروني\n${widget.contact}'
//                     : 'تم إرسال رمز التحقق إلى الرقم\n${widget.contact}',
//                 style: TextStyle(
//                   color: Theme.of(context).colorScheme.outline,
//                   height: 1.6,
//                 ),
//               ),
//               const SizedBox(height: 36),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: List.generate(4, (i) => _digitBox(i)),
//               ),
//               if (_error != null) ...[
//                 const SizedBox(height: 12),
//                 Center(
//                   child:
//                       Text(_error!, style: const TextStyle(color: Colors.red)),
//                 ),
//               ],
//               const SizedBox(height: 32),
//               Center(
//                 child: _secondsLeft > 0
//                     ? Text(
//                         'يمكنك إعادة الإرسال خلال $_secondsLeft ثانية',
//                         style: const TextStyle(color: Colors.grey),
//                       )
//                     : TextButton(
//                         onPressed: _startTimer,
//                         child: const Text('إعادة إرسال الرمز'),
//                       ),
//               ),
//               const SizedBox(height: 24),
//               _isVerifying
//                   ? const Center(child: CircularProgressIndicator())
//                   : ElevatedButton(
//                       onPressed: _verify,
//                       child: const Text('تأكيد'),
//                     ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _digitBox(int index) {
//     return SizedBox(
//       width: 64,
//       height: 64,
//       child: TextField(
//         controller: _controllers[index],
//         focusNode: _focusNodes[index],
//         keyboardType: TextInputType.number,
//         maxLength: 1,
//         textAlign: TextAlign.center,
//         style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
//         decoration: InputDecoration(
//           counterText: '',
//           contentPadding: EdgeInsets.zero,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(14),
//             borderSide: BorderSide(
//               color: _controllers[index].text.isNotEmpty
//                   ? AppColors.primary
//                   : Colors.grey.shade300,
//               width: 2,
//             ),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(14),
//             borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(14),
//             borderSide: const BorderSide(color: AppColors.primary, width: 2),
//           ),
//         ),
//         onChanged: (val) => _onDigitChanged(val, index),
//       ),
//     );
//   }
// }
