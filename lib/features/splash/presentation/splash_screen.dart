// import 'dart:async' show Completer;
// import 'dart:math' show pi, sin, Random;
// import 'dart:ui';

// import 'package:bhm_supermarket/app/theme/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../../app/router/app_routes.dart';
// import 'package:provider/provider.dart';
// import '../../auth/providers/auth_provider.dart';
// import '../../auth/models/user_model.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with TickerProviderStateMixin {
//   // ── Controllers ──
//   late final AnimationController _mainController;
//   late final AnimationController _particleController;
//   late final AnimationController _gradientController;
//   late final AnimationController _pulseController;

//   // ── Main Animations ──
//   late final Animation<double> _logoScale;
//   late final Animation<double> _logoOpacity;
//   late final Animation<double> _glowOpacity;
//   late final Animation<double> _glowScale;
//   late final Animation<Offset> _titleOffset;
//   late final Animation<double> _titleOpacity;
//   late final Animation<Offset> _subtitleOffset;
//   late final Animation<double> _subtitleOpacity;
//   late final Animation<double> _loaderOpacity;
//   late final Animation<double> _progressValue;
//   late final Animation<double> _footerOpacity;

//   @override
//   void initState() {
//     super.initState();

//     // Main orchestrator (2200 ms for a more cinematic feel)
//     _mainController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 2200),
//     );

//     // Ambient floating particles
//     _particleController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 12),
//     )..repeat();

//     // Animated gradient background
//     _gradientController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 6),
//     )..repeat(reverse: true);

//     // Breathing glow pulse
//     _pulseController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 2000),
//     )..repeat(reverse: true);

//     // ── Logo ──
//     _logoOpacity = Tween(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _mainController,
//         curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
//       ),
//     );

//     _logoScale = Tween(begin: 0.55, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _mainController,
//         curve: const Interval(0.0, 0.45, curve: Curves.easeOutBack),
//       ),
//     );

//     // ── Glow ──
//     _glowOpacity = Tween(begin: 0.0, end: 0.9).animate(
//       CurvedAnimation(
//         parent: _mainController,
//         curve: const Interval(0.1, 0.5, curve: Curves.easeOut),
//       ),
//     );

//     _glowScale = Tween(begin: 0.8, end: 1.15).animate(
//       CurvedAnimation(
//         parent: _mainController,
//         curve: const Interval(0.1, 0.5, curve: Curves.easeOut),
//       ),
//     );

//     // ── Title ──
//     _titleOpacity = Tween(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _mainController,
//         curve: const Interval(0.30, 0.65, curve: Curves.easeOut),
//       ),
//     );

//     _titleOffset =
//         Tween(begin: const Offset(0, 0.45), end: Offset.zero).animate(
//       CurvedAnimation(
//         parent: _mainController,
//         curve: const Interval(0.30, 0.65, curve: Curves.easeOutCubic),
//       ),
//     );

//     // ── Subtitle ──
//     _subtitleOpacity = Tween(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _mainController,
//         curve: const Interval(0.42, 0.72, curve: Curves.easeOut),
//       ),
//     );

//     _subtitleOffset =
//         Tween(begin: const Offset(0, 0.35), end: Offset.zero).animate(
//       CurvedAnimation(
//         parent: _mainController,
//         curve: const Interval(0.42, 0.72, curve: Curves.easeOutCubic),
//       ),
//     );

//     // ── Loader & Footer ──
//     _loaderOpacity = Tween(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _mainController,
//         curve: const Interval(0.65, 0.90, curve: Curves.easeIn),
//       ),
//     );

//     _progressValue = Tween(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _mainController,
//         curve: const Interval(0.65, 0.95, curve: Curves.easeInOutCubic),
//       ),
//     );

//     _footerOpacity = Tween(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _mainController,
//         curve: const Interval(0.75, 1.0, curve: Curves.easeIn),
//       ),
//     );

//     _start();
//   }

//   // ═══════════════════════════════════════════════════════════
//   //  Navigation Logic — UNCHANGED (SharedPreferences + GoRouter)
//   // ═══════════════════════════════════════════════════════════
//   Future<void> _start() async {
//     await _mainController.forward();

//     final prefs = await SharedPreferences.getInstance();
//     final completed = prefs.getBool('onboarding_completed') ?? false;

//     if (!mounted) return;

//     final auth = context.read<AuthProvider>();

//     // — Replaced busy-wait loop with a zero-CPU Completer —
//     // If auth is already initialised (fast path), we continue immediately.
//     // Otherwise we attach a one-shot listener that fires the completer on
//     // the next notifyListeners() call from AuthProvider (i.e., after
//     // initSession() completes in main.dart's addPostFrameCallback).
//     if (!auth.initialized) {
//       final completer = Completer<void>();

//       void listener() {
//         if (auth.initialized && !completer.isCompleted) {
//           completer.complete();
//         }
//       }

//       auth.addListener(listener);
//       try {
//         await completer.future;
//       } finally {
//         auth.removeListener(listener);
//       }
//     }

//     if (!mounted) return;

//     await Future.delayed(const Duration(milliseconds: 500));

//     if (!mounted) return;

//     if (!completed) {
//       context.go(AppRoutes.onboarding);
//       return;
//     }

//     if (!auth.isLoggedIn) {
//       context.go(AppRoutes.home);
//       return;
//     }

//     switch (auth.user!.role) {
//       case UserRole.admin:
//         context.go(AppRoutes.adminDashboard);
//         break;

//       case UserRole.delivery:
//         context.go(AppRoutes.deliveryHome);
//         break;

//       case UserRole.customer:
//         final redirect = auth.consumePendingRedirect();

//         context.go(redirect);
//         break;
//     }
//   }

//   @override
//   void dispose() {
//     _mainController.dispose();
//     _particleController.dispose();
//     _gradientController.dispose();
//     _pulseController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.sizeOf(context);
//     final logoSize = size.width.clamp(120.0, 170.0);

//     return Scaffold(
//       body: AnimatedBuilder(
//         animation: _gradientController,
//         builder: (context, child) {
//           return Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment(
//                   -1.0 + (_gradientController.value * 0.4),
//                   -1.0,
//                 ),
//                 end: Alignment(1.0, 1.0 - (_gradientController.value * 0.4)),
//                 colors: const [
//                   Color(0xFFFFE530), // Bright gold
//                   Color(0xFFFFB800), // Amber
//                   AppColors.primaryLight, // Theme light
//                   AppColors.primaryDark, // Theme dark
//                 ],
//                 stops: const [0.0, 0.25, 0.6, 1.0],
//               ),
//             ),
//             child: child,
//           );
//         },
//         child: Stack(
//           children: [
//             // ── Ambient floating particles ──
//             ..._buildParticles(size),

//             // ── Decorative glass orbs ──
//             _buildGlassOrb(top: -100, right: -80, size: 260, opacity: 0.06),
//             _buildGlassOrb(bottom: -140, left: -100, size: 340, opacity: 0.05),
//             _buildGlassOrb(
//               top: size.height * 0.15,
//               left: -60,
//               size: 180,
//               opacity: 0.04,
//             ),
//             _buildGlassOrb(
//               bottom: size.height * 0.25,
//               right: -40,
//               size: 120,
//               opacity: 0.03,
//             ),

//             // ── Main content ──
//             SafeArea(
//               child: Center(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 32),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Spacer(flex: 2),

//                       // ═══ Logo with breathing glow ═══
//                       _buildLogoWithGlow(logoSize),

//                       const SizedBox(height: 48),

//                       // ═══ Title ═══
//                       FadeTransition(
//                         opacity: _titleOpacity,
//                         child: SlideTransition(
//                           position: _titleOffset,
//                           child: ShaderMask(
//                             shaderCallback: (bounds) {
//                               return const LinearGradient(
//                                 colors: [
//                                   Colors.white,
//                                   Color(0xFFFFF8E1),
//                                   Colors.white,
//                                 ],
//                               ).createShader(bounds);
//                             },
//                             child: const Text(
//                               "البيرق هايبر ماركت",
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 32,
//                                 fontWeight: FontWeight.w900,
//                                 letterSpacing: 0.6,
//                                 shadows: [
//                                   Shadow(
//                                     color: Color(0x40000000),
//                                     blurRadius: 12,
//                                     offset: Offset(0, 4),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),

//                       const SizedBox(height: 14),

//                       // ═══ Subtitle ═══
//                       FadeTransition(
//                         opacity: _subtitleOpacity,
//                         child: SlideTransition(
//                           position: _subtitleOffset,
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 16,
//                               vertical: 8,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.white.withValues(alpha: 0.08),
//                               borderRadius: BorderRadius.circular(20),
//                               border: Border.all(
//                                 color: Colors.white.withValues(alpha: 0.12),
//                               ),
//                             ),
//                             child: const Text(
//                               "تجربة تسوق أسرع  •  أجود المنتجات  •  توصيل حتى باب منزلك",
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 color: Colors.white70,
//                                 fontSize: 14,
//                                 height: 1.7,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),

//                       const Spacer(flex: 1),

//                       // ═══ Progress Loader ═══
//                       FadeTransition(
//                         opacity: _loaderOpacity,
//                         child: Column(
//                           children: [
//                             // Custom circular loader with dot
//                             SizedBox(
//                               width: 52,
//                               height: 52,
//                               child: Stack(
//                                 alignment: Alignment.center,
//                                 children: [
//                                   // Outer rotating ring
//                                   RotationTransition(
//                                     turns: _particleController,
//                                     child: CustomPaint(
//                                       size: const Size(52, 52),
//                                       painter: _ArcPainter(
//                                         color: Colors.white.withValues(
//                                           alpha: 0.35,
//                                         ),
//                                         strokeWidth: 2.5,
//                                       ),
//                                     ),
//                                   ),
//                                   // Inner progress ring
//                                   AnimatedBuilder(
//                                     animation: _progressValue,
//                                     builder: (_, __) {
//                                       return SizedBox(
//                                         width: 40,
//                                         height: 40,
//                                         child: CircularProgressIndicator(
//                                           value: _progressValue.value,
//                                           strokeWidth: 2.8,
//                                           valueColor:
//                                               const AlwaysStoppedAnimation<
//                                                   Color>(Colors.white),
//                                           backgroundColor: Colors.white
//                                               .withValues(alpha: 0.15),
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                   // Center dot
//                                   AnimatedBuilder(
//                                     animation: _pulseController,
//                                     builder: (_, __) {
//                                       return Container(
//                                         width: 8 + (_pulseController.value * 3),
//                                         height:
//                                             8 + (_pulseController.value * 3),
//                                         decoration: BoxDecoration(
//                                           color: Colors.white,
//                                           shape: BoxShape.circle,
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color: Colors.white.withValues(
//                                                 alpha: 0.4,
//                                               ),
//                                               blurRadius: 8 +
//                                                   (_pulseController.value * 6),
//                                               spreadRadius: 2,
//                                             ),
//                                           ],
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(height: 20),
//                             // Loading text with shimmer
//                             _ShimmerText(
//                               text: "جاري تجهيز تجربة التسوق...",
//                               style: const TextStyle(
//                                 color: Colors.white70,
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w600,
//                                 letterSpacing: 0.3,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                       const SizedBox(height: 40),
//                     ],
//                   ),
//                 ),
//               ),
//             ),

//             // ── Footer ──
//             Positioned(
//               left: 28,
//               right: 28,
//               bottom: 24,
//               child: FadeTransition(
//                 opacity: _footerOpacity,
//                 child: Column(
//                   children: [
//                     Container(
//                       height: 1,
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                             Colors.transparent,
//                             Colors.white.withValues(alpha: 0.2),
//                             Colors.transparent,
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 14),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Container(
//                           width: 6,
//                           height: 6,
//                           decoration: BoxDecoration(
//                             color: Colors.white.withValues(alpha: 0.5),
//                             shape: BoxShape.circle,
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         const Text(
//                           "© 2026 BHM Hyper Market",
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             color: Color.fromARGB(140, 255, 255, 255),
//                             fontSize: 12,
//                             letterSpacing: 0.4,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         Container(
//                           width: 6,
//                           height: 6,
//                           decoration: BoxDecoration(
//                             color: Colors.white.withValues(alpha: 0.5),
//                             shape: BoxShape.circle,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ═══════════════════════════════════════════════════════════
//   //  Widget Builders
//   // ═══════════════════════════════════════════════════════════

//   Widget _buildLogoWithGlow(double logoSize) {
//     return FadeTransition(
//       opacity: _logoOpacity,
//       child: ScaleTransition(
//         scale: _logoScale,
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             // Breathing glow behind logo
//             AnimatedBuilder(
//               animation: Listenable.merge([
//                 _glowOpacity,
//                 _glowScale,
//                 _pulseController,
//               ]),
//               builder: (_, __) {
//                 return Opacity(
//                   opacity:
//                       _glowOpacity.value * (0.7 + _pulseController.value * 0.3),
//                   child: Transform.scale(
//                     scale: _glowScale.value *
//                         (0.95 + _pulseController.value * 0.1),
//                     child: Container(
//                       width: logoSize + 60,
//                       height: logoSize + 60,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         gradient: RadialGradient(
//                           colors: [
//                             Colors.white.withValues(alpha: 0.25),
//                             Colors.white.withValues(alpha: 0.08),
//                             Colors.transparent,
//                           ],
//                           stops: const [0.2, 0.6, 1.0],
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//             // Glassmorphism logo card
//             ClipRRect(
//               borderRadius: BorderRadius.circular(36),
//               child: BackdropFilter(
//                 filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
//                 child: Container(
//                   width: logoSize,
//                   height: logoSize,
//                   padding: const EdgeInsets.all(22),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withValues(alpha: 0.14),
//                     borderRadius: BorderRadius.circular(36),
//                     border: Border.all(
//                       color: Colors.white.withValues(alpha: 0.30),
//                       width: 1.2,
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         blurRadius: 35,
//                         color: const Color.fromARGB(
//                           255,
//                           0,
//                           0,
//                           0,
//                         ).withValues(alpha: 0.12),
//                         offset: const Offset(0, 16),
//                       ),
//                     ],
//                   ),
//                   child: Image.asset(
//                     "assets/images/logos/bhm_logo.png",
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildGlassOrb({
//     double? top,
//     double? bottom,
//     double? left,
//     double? right,
//     required double size,
//     required double opacity,
//   }) {
//     return Positioned(
//       top: top,
//       bottom: bottom,
//       left: left,
//       right: right,
//       child: Container(
//         width: size,
//         height: size,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           gradient: RadialGradient(
//             colors: [
//               Colors.white.withValues(alpha: opacity),
//               Colors.white.withValues(alpha: opacity * 0.3),
//               Colors.transparent,
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   List<Widget> _buildParticles(Size screenSize) {
//     final particles = <Widget>[];
//     final random = Random(42); // deterministic for stability

//     const particleCount = 18;
//     for (int i = 0; i < particleCount; i++) {
//       final size = 3.0 + random.nextDouble() * 5.0;
//       final startX = random.nextDouble() * screenSize.width;
//       final startY = random.nextDouble() * screenSize.height;
//       final duration = 6 + random.nextDouble() * 8;
//       final delay = random.nextDouble() * 6;

//       particles.add(
//         AnimatedBuilder(
//           animation: _particleController,
//           builder: (_, __) {
//             final t =
//                 ((_particleController.value * duration + delay) % duration) /
//                     duration;
//             final y = startY - (t * 120); // float upward
//             final x = startX + sin(t * pi * 2 + i) * 25;
//             final opacity = t < 0.15
//                 ? t / 0.15
//                 : t > 0.85
//                     ? (1 - t) / 0.15
//                     : 1.0;

//             return Positioned(
//               left: x,
//               top: y,
//               child: Opacity(
//                 opacity: opacity * 0.5,
//                 child: Container(
//                   width: size,
//                   height: size,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.white.withValues(alpha: 0.3),
//                         blurRadius: size,
//                         spreadRadius: size * 0.3,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       );
//     }
//     return particles;
//   }
// }

// // ═══════════════════════════════════════════════════════════
// //  Custom Painters & Helpers
// // ═══════════════════════════════════════════════════════════

// /// Draws an animated rotating arc ring.
// class _ArcPainter extends CustomPainter {
//   final Color color;
//   final double strokeWidth;

//   _ArcPainter({required this.color, required this.strokeWidth});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = color
//       ..strokeWidth = strokeWidth
//       ..style = PaintingStyle.stroke
//       ..strokeCap = StrokeCap.round;

//     final center = Offset(size.width / 2, size.height / 2);
//     final radius = (size.width - strokeWidth) / 2;

//     canvas.drawArc(
//       Rect.fromCircle(center: center, radius: radius),
//       -pi / 2,
//       pi * 1.3,
//       false,
//       paint,
//     );
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }

// /// Shimmer text effect for loading labels.
// class _ShimmerText extends StatefulWidget {
//   final String text;
//   final TextStyle style;

//   const _ShimmerText({required this.text, required this.style});

//   @override
//   State<_ShimmerText> createState() => _ShimmerTextState();
// }

// class _ShimmerTextState extends State<_ShimmerText>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _shimmerController;

//   @override
//   void initState() {
//     super.initState();
//     _shimmerController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1800),
//     )..repeat();
//   }

//   @override
//   void dispose() {
//     _shimmerController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _shimmerController,
//       builder: (context, child) {
//         return ShaderMask(
//           shaderCallback: (bounds) {
//             return LinearGradient(
//               begin: Alignment(-1.5 + _shimmerController.value * 3, 0),
//               end: Alignment(-0.5 + _shimmerController.value * 3, 0),
//               colors: const [Colors.white70, Colors.white, Colors.white70],
//               stops: const [0.0, 0.5, 1.0],
//             ).createShader(bounds);
//           },
//           child: Text(
//             widget.text,
//             style: widget.style.copyWith(color: Colors.white),
//           ),
//         );
//       },
//     );
//   }
// }

// import 'dart:async' show Completer;
// import 'dart:math' show pi, sin;

// // import 'package:bhm_supermarket/app/theme/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:provider/provider.dart';

// import '../../../app/router/app_routes.dart';
// import '../../auth/providers/auth_provider.dart';
// import '../../auth/models/user_model.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with TickerProviderStateMixin {
//   // ============================================================
//   // Controllers
//   // ============================================================

//   late final AnimationController _mainController;
//   late final AnimationController _particleController;
//   late final AnimationController _gradientController;
//   late final AnimationController _pulseController;

//   // ============================================================
//   // Animations
//   // ============================================================

//   late final Animation<double> _logoScale;
//   late final Animation<double> _logoOpacity;

//   late final Animation<Offset> _titleOffset;
//   late final Animation<double> _titleOpacity;

//   late final Animation<Offset> _subtitleOffset;
//   late final Animation<double> _subtitleOpacity;

//   late final Animation<double> _loaderOpacity;
//   late final Animation<double> _progressValue;

//   @override
//   void initState() {
//     super.initState();

//     // ------------------------------------------------------------
//     // Main animation
//     // ------------------------------------------------------------

//     _mainController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 2200),
//     );

//     // ------------------------------------------------------------
//     // Kept from the original project so the existing structure
//     // remains safe and compatible.
//     // ------------------------------------------------------------

//     _particleController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 12),
//     )..repeat();

//     _gradientController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 6),
//     )..repeat(reverse: true);

//     _pulseController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 2000),
//     )..repeat(reverse: true);

//     // ============================================================
//     // Logo
//     // ============================================================

//     _logoOpacity = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(
//       CurvedAnimation(
//         parent: _mainController,
//         curve: const Interval(
//           0.0,
//           0.35,
//           curve: Curves.easeOut,
//         ),
//       ),
//     );

//     _logoScale = Tween<double>(
//       begin: 0.82,
//       end: 1.0,
//     ).animate(
//       CurvedAnimation(
//         parent: _mainController,
//         curve: const Interval(
//           0.0,
//           0.45,
//           curve: Curves.easeOutBack,
//         ),
//       ),
//     );

//     // ============================================================
//     // Title
//     // ============================================================

//     _titleOpacity = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(
//       CurvedAnimation(
//         parent: _mainController,
//         curve: const Interval(
//           0.28,
//           0.60,
//           curve: Curves.easeOut,
//         ),
//       ),
//     );

//     _titleOffset = Tween<Offset>(
//       begin: const Offset(0, 0.18),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(
//         parent: _mainController,
//         curve: const Interval(
//           0.28,
//           0.60,
//           curve: Curves.easeOutCubic,
//         ),
//       ),
//     );

//     // ============================================================
//     // Subtitle
//     // ============================================================

//     _subtitleOpacity = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(
//       CurvedAnimation(
//         parent: _mainController,
//         curve: const Interval(
//           0.42,
//           0.72,
//           curve: Curves.easeOut,
//         ),
//       ),
//     );

//     _subtitleOffset = Tween<Offset>(
//       begin: const Offset(0, 0.15),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(
//         parent: _mainController,
//         curve: const Interval(
//           0.42,
//           0.72,
//           curve: Curves.easeOutCubic,
//         ),
//       ),
//     );

//     // ============================================================
//     // Loader
//     // ============================================================

//     _loaderOpacity = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(
//       CurvedAnimation(
//         parent: _mainController,
//         curve: const Interval(
//           0.65,
//           0.90,
//           curve: Curves.easeIn,
//         ),
//       ),
//     );

//     _progressValue = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(
//       CurvedAnimation(
//         parent: _mainController,
//         curve: const Interval(
//           0.65,
//           0.95,
//           curve: Curves.easeInOutCubic,
//         ),
//       ),
//     );

//     // ------------------------------------------------------------
//     // IMPORTANT:
//     // Navigation logic remains unchanged.
//     // ------------------------------------------------------------

//     _start();
//   }

//   // ============================================================
//   // Navigation Logic
//   // ============================================================

//   Future<void> _start() async {
//     await _mainController.forward();

//     final prefs = await SharedPreferences.getInstance();
//     final completed = prefs.getBool('onboarding_completed') ?? false;

//     if (!mounted) return;

//     final auth = context.read<AuthProvider>();

//     if (!auth.initialized) {
//       final completer = Completer<void>();

//       void listener() {
//         if (auth.initialized && !completer.isCompleted) {
//           completer.complete();
//         }
//       }

//       auth.addListener(listener);

//       try {
//         await completer.future;
//       } finally {
//         auth.removeListener(listener);
//       }
//     }

//     if (!mounted) return;

//     await Future.delayed(
//       const Duration(milliseconds: 500),
//     );

//     if (!mounted) return;

//     if (!completed) {
//       context.go(AppRoutes.onboarding);
//       return;
//     }

//     if (!auth.isLoggedIn) {
//       context.go(AppRoutes.home);
//       return;
//     }

//     switch (auth.user!.role) {
//       case UserRole.admin:
//         context.go(AppRoutes.adminDashboard);
//         break;

//       case UserRole.delivery:
//         context.go(AppRoutes.deliveryHome);
//         break;

//       case UserRole.customer:
//         final redirect = auth.consumePendingRedirect();

//         context.go(redirect);
//         break;
//     }
//   }

//   @override
//   void dispose() {
//     _mainController.dispose();
//     _particleController.dispose();
//     _gradientController.dispose();
//     _pulseController.dispose();
//     super.dispose();
//   }

//   // ============================================================
//   // BUILD
//   // ============================================================

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.sizeOf(context);

//     return Scaffold(
//       body: Stack(
//         children: [
//           // ======================================================
//           // Background
//           // ======================================================

//           AnimatedBuilder(
//             animation: _gradientController,
//             builder: (context, child) {
//               final value = _gradientController.value;

//               return Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment(
//                       -0.90 + (value * 0.15),
//                       -1.0,
//                     ),
//                     end: Alignment(
//                       0.90,
//                       1.0 - (value * 0.12),
//                     ),
//                     colors: const [
//                       Color(0xFF32107D),
//                       Color(0xFF4B1C9E),
//                       Color(0xFF5B21B6),
//                       Color(0xFF35107F),
//                     ],
//                     stops: const [
//                       0.0,
//                       0.38,
//                       0.72,
//                       1.0,
//                     ],
//                   ),
//                 ),
//                 child: child,
//               );
//             },
//             child: const SizedBox.expand(),
//           ),

//           // ======================================================
//           // Subtle background glow
//           // ======================================================

//           Positioned(
//             top: -140,
//             right: -110,
//             child: Container(
//               width: 320,
//               height: 320,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 gradient: RadialGradient(
//                   colors: [
//                     Colors.white.withValues(alpha: 0.06),
//                     Colors.transparent,
//                   ],
//                 ),
//               ),
//             ),
//           ),

//           Positioned(
//             top: size.height * 0.20,
//             left: -90,
//             child: Container(
//               width: 210,
//               height: 210,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 gradient: RadialGradient(
//                   colors: [
//                     Colors.white.withValues(alpha: 0.035),
//                     Colors.transparent,
//                   ],
//                 ),
//               ),
//             ),
//           ),

//           // ======================================================
//           // Bottom wave decoration
//           // ======================================================

//           Positioned(
//             left: -70,
//             right: -70,
//             bottom: -95,
//             child: AnimatedBuilder(
//               animation: _gradientController,
//               builder: (context, child) {
//                 final value = _gradientController.value;

//                 return Transform.translate(
//                   offset: Offset(
//                     sin(value * pi * 2) * 18,
//                     0,
//                   ),
//                   child: child,
//                 );
//               },
//               child: Container(
//                 height: 210,
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [
//                       Color(0x553F168C),
//                       Color(0x66310C73),
//                       Color(0x77300C72),
//                     ],
//                   ),
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(180),
//                     topRight: Radius.circular(220),
//                   ),
//                 ),
//               ),
//             ),
//           ),

//           // ======================================================
//           // Main Content
//           // ======================================================

//           SafeArea(
//             child: Center(
//               child: Column(
//                 children: [
//                   const Spacer(
//                     flex: 4,
//                   ),

//                   // ------------------------------------------------
//                   // Logo
//                   // ------------------------------------------------

//                   FadeTransition(
//                     opacity: _logoOpacity,
//                     child: ScaleTransition(
//                       scale: _logoScale,
//                       child: _buildLogo(),
//                     ),
//                   ),

//                   const SizedBox(height: 16),

//                   // ------------------------------------------------
//                   // Brand Name
//                   // ------------------------------------------------

//                   FadeTransition(
//                     opacity: _titleOpacity,
//                     child: SlideTransition(
//                       position: _titleOffset,
//                       child: _buildBrandName(),
//                     ),
//                   ),

//                   const SizedBox(height: 14),

//                   // ------------------------------------------------
//                   // Subtitle
//                   // ------------------------------------------------

//                   FadeTransition(
//                     opacity: _subtitleOpacity,
//                     child: SlideTransition(
//                       position: _subtitleOffset,
//                       child: const Text(
//                         'جودة تستحقها.. أسعار تناسبك',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           // color: Colors.white.withValues(alpha: 0.88),
//                           fontSize: 12,
//                           fontWeight: FontWeight.w500,
//                           letterSpacing: 0.15,
//                         ),
//                       ),
//                     ),
//                   ),

//                   const Spacer(
//                     flex: 5,
//                   ),

//                   // ------------------------------------------------
//                   // Bottom Loader
//                   // ------------------------------------------------

//                   FadeTransition(
//                     opacity: _loaderOpacity,
//                     child: Padding(
//                       padding: const EdgeInsets.only(
//                         bottom: 20,
//                       ),
//                       child: _buildBottomLoader(),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ============================================================
//   // Logo
//   // ============================================================

//   Widget _buildLogo() {
//     return SizedBox(
//       width: 82,
//       height: 82,
//       child: Image.asset(
//         'assets/images/logos/bhm_logo.png',
//         fit: BoxFit.contain,
//       ),
//     );
//   }

//   // ============================================================
//   // Brand Name
//   // ============================================================

//   Widget _buildBrandName() {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         const Text(
//           'بيرق',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 34,
//             height: 0.95,
//             fontWeight: FontWeight.w900,
//             letterSpacing: 0.2,
//           ),
//         ),
//         const SizedBox(height: 5),
//         const Text(
//           'هايبر ماركت',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 13,
//             height: 1.0,
//             fontWeight: FontWeight.w700,
//             letterSpacing: 0.5,
//           ),
//         ),
//       ],
//     );
//   }

//   // ============================================================
//   // Bottom Loader
//   // ============================================================

//   Widget _buildBottomLoader() {
//     return AnimatedBuilder(
//       animation: _progressValue,
//       builder: (context, child) {
//         return Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             SizedBox(
//               width: 62,
//               height: 3,
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(10),
//                 child: Stack(
//                   children: [
//                     Container(
//                       width: double.infinity,
//                       height: 3,
//                       color: Colors.white.withValues(
//                         alpha: 0.18,
//                       ),
//                     ),
//                     FractionallySizedBox(
//                       widthFactor: _progressValue.value,
//                       child: Container(
//                         height: 3,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(10),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.white.withValues(
//                                 alpha: 0.22,
//                               ),
//                               blurRadius: 5,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

import 'dart:async' show Completer;
import 'dart:math' show pi, sin;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../../../app/router/app_routes.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/models/user_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // ============================================================
  // Controllers
  // ============================================================

  late final AnimationController _mainController;
  late final AnimationController _particleController;
  late final AnimationController _gradientController;
  late final AnimationController _pulseController;

  // ============================================================
  // Animations
  // ============================================================

  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;

  late final Animation<Offset> _titleOffset;
  late final Animation<double> _titleOpacity;

  late final Animation<Offset> _subtitleOffset;
  late final Animation<double> _subtitleOpacity;

  late final Animation<double> _loaderOpacity;
  late final Animation<double> _progressValue;

  @override
  void initState() {
    super.initState();

    // ------------------------------------------------------------
    // Main controller
    // ------------------------------------------------------------

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    // ------------------------------------------------------------
    // Kept for project compatibility
    // ------------------------------------------------------------

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    // ============================================================
    // Logo animation
    // ============================================================

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.00, 0.30, curve: Curves.easeOut),
      ),
    );

    _logoScale = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.00, 0.38, curve: Curves.easeOutCubic),
      ),
    );

    // ============================================================
    // Title animation
    // ============================================================

    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.20, 0.48, curve: Curves.easeOut),
      ),
    );

    _titleOffset =
        Tween<Offset>(begin: const Offset(0.0, 0.08), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.20, 0.48, curve: Curves.easeOutCubic),
      ),
    );

    // ============================================================
    // Subtitle animation
    // ============================================================

    _subtitleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.35, 0.58, curve: Curves.easeOut),
      ),
    );

    _subtitleOffset =
        Tween<Offset>(begin: const Offset(0.0, 0.08), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.35, 0.58, curve: Curves.easeOutCubic),
      ),
    );

    // ============================================================
    // Loader animation
    // ============================================================

    _loaderOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.55, 0.80, curve: Curves.easeOut),
      ),
    );

    _progressValue = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.58, 1.0, curve: Curves.easeInOutCubic),
      ),
    );

    // ============================================================
    // Navigation logic — KEEP AS IS
    // ============================================================

    _start();
  }

  // ============================================================
  // Navigation Logic
  // ============================================================

  Future<void> _start() async {
    await _mainController.forward();

    final prefs = await SharedPreferences.getInstance();
    final completed = prefs.getBool('onboarding_completed') ?? false;

    if (!mounted) return;

    final auth = context.read<AuthProvider>();

    if (!auth.initialized) {
      final completer = Completer<void>();

      void listener() {
        if (auth.initialized && !completer.isCompleted) {
          completer.complete();
        }
      }

      auth.addListener(listener);

      try {
        await completer.future;
      } finally {
        auth.removeListener(listener);
      }
    }

    if (!mounted) return;

    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    if (!completed) {
      context.go(AppRoutes.onboarding);
      return;
    }

    if (!auth.isLoggedIn) {
      context.go(AppRoutes.home);
      return;
    }

    switch (auth.user!.role) {
      case UserRole.admin:
        context.go(AppRoutes.adminDashboard);
        break;

      case UserRole.delivery:
        context.go(AppRoutes.deliveryHome);
        break;

      case UserRole.customer:
        final redirect = auth.consumePendingRedirect();
        context.go(redirect);
        break;
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _particleController.dispose();
    _gradientController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Color.fromARGB(255, 26, 17, 0),
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 56, 41, 0),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;

            return Stack(
              fit: StackFit.expand,
              children: [
                // =================================================
                // Main background
                // =================================================
                _buildBackground(),

                // =================================================
                // Very subtle background texture
                // =================================================
                _buildSubtleTexture(),

                // =================================================
                // Bottom waves
                // =================================================
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: height * 0.19,
                  child: AnimatedBuilder(
                    animation: _gradientController,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: _BottomWavePainter(
                          animationValue: _gradientController.value,
                        ),
                        child: const SizedBox.expand(),
                      );
                    },
                  ),
                ),

                // =================================================
                // Main content
                // =================================================
                SafeArea(
                  child: Stack(
                    children: [
                      // ------------------------------------------------
                      // Logo
                      // ------------------------------------------------
                      Positioned(
                        top: height * 0.285,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: FadeTransition(
                            opacity: _logoOpacity,
                            child: ScaleTransition(
                              scale: _logoScale,
                              child: _buildLogo(width: width * 0.35),
                            ),
                          ),
                        ),
                      ),

                      // ------------------------------------------------
                      // Brand
                      // ------------------------------------------------
                      Positioned(
                        top: height * 0.458,
                        left: 0,
                        right: 0,
                        child: FadeTransition(
                          opacity: _titleOpacity,
                          child: SlideTransition(
                            position: _titleOffset,
                            // child: _buildBrand(),
                          ),
                        ),
                      ),

                      // ------------------------------------------------
                      // Subtitle
                      // ------------------------------------------------
                      Positioned(
                        top: height * 0.628,
                        left: 18,
                        right: 18,
                        child: FadeTransition(
                          opacity: _subtitleOpacity,
                          child: SlideTransition(
                            position: _subtitleOffset,
                            child: const Text(
                              'جودة تستحقها.. أسعار تناسبك',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFFEFE8FF),
                                fontSize: 10.5,
                                fontWeight: FontWeight.w500,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // ------------------------------------------------
                      // Bottom progress indicator
                      // ------------------------------------------------
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: height * 0.055,
                        child: FadeTransition(
                          opacity: _loaderOpacity,
                          child: Center(child: _buildProgressBar()),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // Background
  // ============================================================

  Widget _buildBackground() {
    return AnimatedBuilder(
      animation: _gradientController,
      builder: (context, child) {
        final t = _gradientController.value;

        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: const Alignment(-0.85, -1.0),
              end: const Alignment(0.9, 1.0),
              colors: [
                Color.lerp(
                  const Color.fromARGB(255, 197, 161, 0),
                  const Color.fromARGB(255, 151, 121, 23),
                  t,
                )!,
                Color.lerp(
                  const Color.fromARGB(255, 145, 123, 23),
                  const Color.fromARGB(255, 167, 118, 26),
                  t,
                )!,
                Color.lerp(
                  const Color.fromARGB(255, 145, 133, 23),
                  const Color.fromARGB(255, 151, 149, 23),
                  t,
                )!,
              ],
              stops: const [0.0, 0.52, 1.0],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // Very subtle decorative texture
  // ============================================================

  Widget _buildSubtleTexture() {
    return IgnorePointer(
      child: CustomPaint(
        painter: _TexturePainter(),
        child: const SizedBox.expand(),
      ),
    );
  }

  // ============================================================
  // Logo
  // ============================================================

  Widget _buildLogo({required double width}) {
    return Image.asset(
      'assets/images/logos/logo2.png',
      width: width,
      fit: BoxFit.contain,
    );
  }

  // ============================================================
  // Brand
  // ============================================================

  // Widget _buildBrand() {
  //   return const Column(
  //     mainAxisSize: MainAxisSize.min,
  //     children: [
  //       Text(
  //         'بيرق',
  //         textAlign: TextAlign.center,
  //         style: TextStyle(
  //           color: Colors.white,
  //           fontSize: 28,
  //           height: 0.95,
  //           fontWeight: FontWeight.w900,
  //           letterSpacing: 0.0,
  //         ),
  //       ),
  //       SizedBox(height: 2),
  //       Text(
  //         // 'هايبر ماركت',
  //         textAlign: TextAlign.center,
  //         style: TextStyle(
  //           color: Colors.white,
  //           fontSize: 11.5,
  //           height: 1.0,
  //           fontWeight: FontWeight.w700,
  //           letterSpacing: 0.1,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // ============================================================
  // Progress bar
  // ============================================================

  Widget _buildProgressBar() {
    return AnimatedBuilder(
      animation: _progressValue,
      builder: (context, child) {
        return SizedBox(
          width: 62,
          height: 4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // Track
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.20),
                    ),
                  ),
                ),

                // Progress
                Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: _progressValue.value,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ================================================================
// Bottom Wave Painter
// ================================================================

class _BottomWavePainter extends CustomPainter {
  final double animationValue;

  const _BottomWavePainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final shift = sin(animationValue * pi * 2) * 3;

    // ------------------------------------------------------------
    // Back wave
    // ------------------------------------------------------------

    final backPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color.fromARGB(82, 189, 129, 0);

    final backPath = Path();

    backPath.moveTo(0, size.height * 0.56);

    backPath.cubicTo(
      size.width * 0.14,
      size.height * 0.39 + shift,
      size.width * 0.27,
      size.height * 0.48,
      size.width * 0.39,
      size.height * 0.59,
    );

    backPath.cubicTo(
      size.width * 0.56,
      size.height * 0.73,
      size.width * 0.71,
      size.height * 0.54,
      size.width * 0.83,
      size.height * 0.47,
    );

    backPath.cubicTo(
      size.width * 0.92,
      size.height * 0.42,
      size.width * 0.97,
      size.height * 0.49,
      size.width,
      size.height * 0.46,
    );

    backPath.lineTo(size.width, size.height);

    backPath.lineTo(0, size.height);

    backPath.close();

    canvas.drawPath(backPath, backPaint);

    // ------------------------------------------------------------
    // Front wave
    // ------------------------------------------------------------

    final frontPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color.fromARGB(82, 255, 217, 0);

    final frontPath = Path();

    frontPath.moveTo(0, size.height * 0.73);

    frontPath.cubicTo(
      size.width * 0.16,
      size.height * 0.56,
      size.width * 0.29,
      size.height * 0.72,
      size.width * 0.44,
      size.height * 0.75,
    );

    frontPath.cubicTo(
      size.width * 0.58,
      size.height * 0.79,
      size.width * 0.72,
      size.height * 0.64,
      size.width * 0.84,
      size.height * 0.61,
    );

    frontPath.cubicTo(
      size.width * 0.92,
      size.height * 0.58,
      size.width * 0.97,
      size.height * 0.61,
      size.width,
      size.height * 0.58,
    );

    frontPath.lineTo(size.width, size.height);

    frontPath.lineTo(0, size.height);

    frontPath.close();

    canvas.drawPath(frontPath, frontPaint);
  }

  @override
  bool shouldRepaint(covariant _BottomWavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

// ================================================================
// Subtle Texture Painter
// ================================================================

class _TexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white.withValues(alpha: 0.018);

    const dotSize = 1.2;

    for (double y = 20; y < size.height * 0.72; y += 24) {
      for (double x = 18; x < size.width; x += 24) {
        canvas.drawCircle(Offset(x, y), dotSize, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
