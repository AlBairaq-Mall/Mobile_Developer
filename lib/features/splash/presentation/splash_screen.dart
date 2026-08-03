// import 'dart:ui';

// import 'package:bhm_supermarket/app/theme/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../../app/router/app_routes.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _controller;

//   late final Animation<double> _logoScale;
//   late final Animation<double> _logoOpacity;
//   late final Animation<double> _glowOpacity;
//   late final Animation<Offset> _titleOffset;
//   late final Animation<double> _titleOpacity;
//   late final Animation<double> _loaderOpacity;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1800),
//     );

//     _logoScale = Tween(
//       begin: .65,
//       end: 1.0,
//     ).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: Curves.easeOutBack,
//       ),
//     );

//     _logoOpacity = Tween(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(
//           0,
//           .45,
//         ),
//       ),
//     );

//     _glowOpacity = Tween(
//       begin: .2,
//       end: .8,
//     ).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: Curves.easeInOut,
//       ),
//     );

//     _titleOpacity = Tween(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(
//           .35,
//           .75,
//         ),
//       ),
//     );

//     _titleOffset = Tween(
//       begin: const Offset(
//         0,
//         .35,
//       ),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: Curves.easeOutCubic,
//       ),
//     );

//     _loaderOpacity = Tween(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(
//           .75,
//           1,
//         ),
//       ),
//     );

//     _start();
//   }

//   Future<void> _start() async {
//     await _controller.forward();

//     final prefs = await SharedPreferences.getInstance();
//     final completed = prefs.getBool('onboarding_completed') ?? false;

//     await Future.delayed(
//       const Duration(milliseconds: 900),
//     );

//     if (!mounted) return;

//     if (completed) {
//       context.go(AppRoutes.home);
//     } else {
//       context.go(AppRoutes.onboarding);
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.sizeOf(context);

//     final logoSize = size.width.clamp(
//       120.0,
//       170.0,
//     );

//     return Scaffold(
//       body: Stack(
//         children: [
//           /// Background
//           Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topRight,
//                 end: Alignment.bottomLeft,
//                 colors: [
//                   Color.fromARGB(255, 255, 224, 48),
//                   AppColors.primaryLight,
//                   AppColors.primaryDark,
//                 ],
//               ),
//             ),
//           ),

//           Positioned(
//             top: -120,
//             right: -90,
//             child: Container(
//               width: 280,
//               height: 280,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.white.withValues(alpha: .08),
//               ),
//             ),
//           ),

//           Positioned(
//             bottom: -150,
//             left: -120,
//             child: Container(
//               width: 330,
//               height: 330,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.white.withValues(alpha: .05),
//               ),
//             ),
//           ),

//           Positioned(
//             top: size.height * .18,
//             left: -80,
//             child: Container(
//               width: 170,
//               height: 170,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.white.withValues(alpha: .04),
//               ),
//             ),
//           ),

//           SafeArea(
//             child: Center(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 32,
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     AnimatedBuilder(
//                       animation: _controller,
//                       builder: (_, __) {
//                         return Opacity(
//                           opacity: _glowOpacity.value,
//                           child: Container(
//                             width: logoSize + 55,
//                             height: logoSize + 55,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               boxShadow: [
//                                 BoxShadow(
//                                   blurRadius: 55,
//                                   spreadRadius: 15,
//                                   color: Colors.white.withValues(alpha: .18),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                     const SizedBox(height: 12),
//                     FadeTransition(
//                       opacity: _logoOpacity,
//                       child: ScaleTransition(
//                         scale: _logoScale,
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(34),
//                           child: BackdropFilter(
//                             filter: ImageFilter.blur(
//                               sigmaX: 18,
//                               sigmaY: 18,
//                             ),
//                             child: Container(
//                               width: logoSize,
//                               height: logoSize,
//                               padding: const EdgeInsets.all(24),
//                               decoration: BoxDecoration(
//                                 color: Colors.white.withValues(alpha: .16),
//                                 borderRadius: BorderRadius.circular(34),
//                                 border: Border.all(
//                                   color: Colors.white.withValues(alpha: .28),
//                                 ),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     blurRadius: 30,
//                                     color: const Color.fromARGB(255, 0, 0, 0)
//                                         .withValues(alpha: .15),
//                                     offset: const Offset(0, 14),
//                                   ),
//                                 ],
//                               ),
//                               child: Image.asset(
//                                 "assets/images/logos/bhm_logo.png",
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 42),
//                     FadeTransition(
//                       opacity: _titleOpacity,
//                       child: SlideTransition(
//                         position: _titleOffset,
//                         child: const Text(
//                           "البيرق هايبر ماركت",
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 30,
//                             fontWeight: FontWeight.w800,
//                             letterSpacing: .4,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 14),
//                     FadeTransition(
//                       opacity: _titleOpacity,
//                       child: const Text(
//                         "تجربة تسوق أسرع • أجود المنتجات • توصيل حتى باب منزلك",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: Colors.white70,
//                           fontSize: 15,
//                           height: 1.6,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 70),
//                     FadeTransition(
//                       opacity: _loaderOpacity,
//                       child: Column(
//                         children: [
//                           SizedBox(
//                             width: 44,
//                             height: 44,
//                             child: Stack(
//                               alignment: Alignment.center,
//                               children: [
//                                 SizedBox(
//                                   width: 44,
//                                   height: 44,
//                                   child: CircularProgressIndicator(
//                                     strokeWidth: 2.2,
//                                     valueColor:
//                                         const AlwaysStoppedAnimation<Color>(
//                                       Colors.white,
//                                     ),
//                                     backgroundColor:
//                                         Colors.white.withValues(alpha: .18),
//                                   ),
//                                 ),
//                                 Container(
//                                   width: 8,
//                                   height: 8,
//                                   decoration: const BoxDecoration(
//                                     color: Colors.white,
//                                     shape: BoxShape.circle,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(height: 18),
//                           const Text(
//                             "جاري تجهيز تجربة التسوق...",
//                             style: TextStyle(
//                               color: Colors.white70,
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),

//           /// Footer
//           Positioned(
//             left: 24,
//             right: 24,
//             bottom: 28,
//             child: FadeTransition(
//               opacity: _loaderOpacity,
//               child: Column(
//                 children: [
//                   Divider(
//                     color: Colors.white.withValues(alpha: .15),
//                     thickness: .8,
//                   ),
//                   const SizedBox(height: 12),
//                   const Text(
//                     "© 2026 BHM Hyper Market",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: Color.fromARGB(136, 255, 255, 255),
//                       fontSize: 12,
//                       letterSpacing: .3,
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
// }

import 'dart:math' show pi, sin, Random;
import 'dart:ui';

import 'package:bhm_supermarket/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app/router/app_routes.dart';

// ============================================================
//  BHM Supermarket — Creative Splash Screen
//  Enhanced with animated particles, shimmer text, breathing glow,
//  animated gradient mesh, and staggered typography.
//  All navigation / backend logic is preserved.
// ============================================================

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // ── Controllers ──
  late final AnimationController _mainController;
  late final AnimationController _particleController;
  late final AnimationController _gradientController;
  late final AnimationController _pulseController;

  // ── Main Animations ──
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _glowOpacity;
  late final Animation<double> _glowScale;
  late final Animation<Offset> _titleOffset;
  late final Animation<double> _titleOpacity;
  late final Animation<Offset> _subtitleOffset;
  late final Animation<double> _subtitleOpacity;
  late final Animation<double> _loaderOpacity;
  late final Animation<double> _progressValue;
  late final Animation<double> _footerOpacity;

  @override
  void initState() {
    super.initState();

    // Main orchestrator (2200 ms for a more cinematic feel)
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    // Ambient floating particles
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    // Animated gradient background
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    // Breathing glow pulse
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    // ── Logo ──
    _logoOpacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
      ),
    );

    _logoScale = Tween(begin: 0.55, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOutBack),
      ),
    );

    // ── Glow ──
    _glowOpacity = Tween(begin: 0.0, end: 0.9).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.1, 0.5, curve: Curves.easeOut),
      ),
    );

    _glowScale = Tween(begin: 0.8, end: 1.15).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.1, 0.5, curve: Curves.easeOut),
      ),
    );

    // ── Title ──
    _titleOpacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.30, 0.65, curve: Curves.easeOut),
      ),
    );

    _titleOffset = Tween(
      begin: const Offset(0, 0.45),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.30, 0.65, curve: Curves.easeOutCubic),
      ),
    );

    // ── Subtitle ──
    _subtitleOpacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.42, 0.72, curve: Curves.easeOut),
      ),
    );

    _subtitleOffset = Tween(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.42, 0.72, curve: Curves.easeOutCubic),
      ),
    );

    // ── Loader & Footer ──
    _loaderOpacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.65, 0.90, curve: Curves.easeIn),
      ),
    );

    _progressValue = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.65, 0.95, curve: Curves.easeInOutCubic),
      ),
    );

    _footerOpacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.75, 1.0, curve: Curves.easeIn),
      ),
    );

    _start();
  }

  // ═══════════════════════════════════════════════════════════
  //  Navigation Logic — UNCHANGED (SharedPreferences + GoRouter)
  // ═══════════════════════════════════════════════════════════
  Future<void> _start() async {
    await _mainController.forward();

    final prefs = await SharedPreferences.getInstance();
    final completed = prefs.getBool('onboarding_completed') ?? false;

    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;

    if (completed) {
      context.go(AppRoutes.home);
    } else {
      context.go(AppRoutes.onboarding);
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final logoSize = size.width.clamp(120.0, 170.0);

    return Scaffold(
      body: AnimatedBuilder(
        animation: _gradientController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(
                  -1.0 + (_gradientController.value * 0.4),
                  -1.0,
                ),
                end: Alignment(
                  1.0,
                  1.0 - (_gradientController.value * 0.4),
                ),
                colors: const [
                  Color(0xFFFFE530), // Bright gold
                  Color(0xFFFFB800), // Amber
                  AppColors.primaryLight, // Theme light
                  AppColors.primaryDark, // Theme dark
                ],
                stops: const [0.0, 0.25, 0.6, 1.0],
              ),
            ),
            child: child,
          );
        },
        child: Stack(
          children: [
            // ── Ambient floating particles ──
            ..._buildParticles(size),

            // ── Decorative glass orbs ──
            _buildGlassOrb(top: -100, right: -80, size: 260, opacity: 0.06),
            _buildGlassOrb(bottom: -140, left: -100, size: 340, opacity: 0.05),
            _buildGlassOrb(
                top: size.height * 0.15, left: -60, size: 180, opacity: 0.04),
            _buildGlassOrb(
                bottom: size.height * 0.25,
                right: -40,
                size: 120,
                opacity: 0.03),

            // ── Main content ──
            SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(flex: 2),

                      // ═══ Logo with breathing glow ═══
                      _buildLogoWithGlow(logoSize),

                      const SizedBox(height: 48),

                      // ═══ Title ═══
                      FadeTransition(
                        opacity: _titleOpacity,
                        child: SlideTransition(
                          position: _titleOffset,
                          child: ShaderMask(
                            shaderCallback: (bounds) {
                              return const LinearGradient(
                                colors: [
                                  Colors.white,
                                  Color(0xFFFFF8E1),
                                  Colors.white,
                                ],
                              ).createShader(bounds);
                            },
                            child: const Text(
                              "البيرق هايبر ماركت",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.6,
                                shadows: [
                                  Shadow(
                                    color: Color(0x40000000),
                                    blurRadius: 12,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // ═══ Subtitle ═══
                      FadeTransition(
                        opacity: _subtitleOpacity,
                        child: SlideTransition(
                          position: _subtitleOffset,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.12),
                              ),
                            ),
                            child: const Text(
                              "تجربة تسوق أسرع  •  أجود المنتجات  •  توصيل حتى باب منزلك",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                height: 1.7,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const Spacer(flex: 1),

                      // ═══ Progress Loader ═══
                      FadeTransition(
                        opacity: _loaderOpacity,
                        child: Column(
                          children: [
                            // Custom circular loader with dot
                            SizedBox(
                              width: 52,
                              height: 52,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Outer rotating ring
                                  RotationTransition(
                                    turns: _particleController,
                                    child: CustomPaint(
                                      size: const Size(52, 52),
                                      painter: _ArcPainter(
                                        color: Colors.white
                                            .withValues(alpha: 0.35),
                                        strokeWidth: 2.5,
                                      ),
                                    ),
                                  ),
                                  // Inner progress ring
                                  AnimatedBuilder(
                                    animation: _progressValue,
                                    builder: (_, __) {
                                      return SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: CircularProgressIndicator(
                                          value: _progressValue.value,
                                          strokeWidth: 2.8,
                                          valueColor:
                                              const AlwaysStoppedAnimation<
                                                  Color>(
                                            Colors.white,
                                          ),
                                          backgroundColor: Colors.white
                                              .withValues(alpha: 0.15),
                                        ),
                                      );
                                    },
                                  ),
                                  // Center dot
                                  AnimatedBuilder(
                                    animation: _pulseController,
                                    builder: (_, __) {
                                      return Container(
                                        width: 8 + (_pulseController.value * 3),
                                        height:
                                            8 + (_pulseController.value * 3),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.white
                                                  .withValues(alpha: 0.4),
                                              blurRadius: 8 +
                                                  (_pulseController.value * 6),
                                              spreadRadius: 2,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Loading text with shimmer
                            _ShimmerText(
                              text: "جاري تجهيز تجربة التسوق...",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),

            // ── Footer ──
            Positioned(
              left: 28,
              right: 28,
              bottom: 24,
              child: FadeTransition(
                opacity: _footerOpacity,
                child: Column(
                  children: [
                    Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.white.withValues(alpha: 0.2),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "© 2026 BHM Hyper Market",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromARGB(140, 255, 255, 255),
                            fontSize: 12,
                            letterSpacing: 0.4,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  Widget Builders
  // ═══════════════════════════════════════════════════════════

  Widget _buildLogoWithGlow(double logoSize) {
    return FadeTransition(
      opacity: _logoOpacity,
      child: ScaleTransition(
        scale: _logoScale,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Breathing glow behind logo
            AnimatedBuilder(
              animation: Listenable.merge(
                  [_glowOpacity, _glowScale, _pulseController]),
              builder: (_, __) {
                return Opacity(
                  opacity:
                      _glowOpacity.value * (0.7 + _pulseController.value * 0.3),
                  child: Transform.scale(
                    scale: _glowScale.value *
                        (0.95 + _pulseController.value * 0.1),
                    child: Container(
                      width: logoSize + 60,
                      height: logoSize + 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0.25),
                            Colors.white.withValues(alpha: 0.08),
                            Colors.transparent,
                          ],
                          stops: const [0.2, 0.6, 1.0],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            // Glassmorphism logo card
            ClipRRect(
              borderRadius: BorderRadius.circular(36),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  width: logoSize,
                  height: logoSize,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(36),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.30),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 35,
                        color: const Color.fromARGB(255, 0, 0, 0)
                            .withValues(alpha: 0.12),
                        offset: const Offset(0, 16),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    "assets/images/logos/bhm_logo.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassOrb({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double size,
    required double opacity,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              Colors.white.withValues(alpha: opacity),
              Colors.white.withValues(alpha: opacity * 0.3),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildParticles(Size screenSize) {
    final particles = <Widget>[];
    final random = Random(42); // deterministic for stability

    const particleCount = 18;
    for (int i = 0; i < particleCount; i++) {
      final size = 3.0 + random.nextDouble() * 5.0;
      final startX = random.nextDouble() * screenSize.width;
      final startY = random.nextDouble() * screenSize.height;
      final duration = 6 + random.nextDouble() * 8;
      final delay = random.nextDouble() * 6;

      particles.add(
        AnimatedBuilder(
          animation: _particleController,
          builder: (_, __) {
            final t =
                ((_particleController.value * duration + delay) % duration) /
                    duration;
            final y = startY - (t * 120); // float upward
            final x = startX + sin(t * pi * 2 + i) * 25;
            final opacity = t < 0.15
                ? t / 0.15
                : t > 0.85
                    ? (1 - t) / 0.15
                    : 1.0;

            return Positioned(
              left: x,
              top: y,
              child: Opacity(
                opacity: opacity * 0.5,
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.3),
                        blurRadius: size,
                        spreadRadius: size * 0.3,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
    return particles;
  }
}

// ═══════════════════════════════════════════════════════════
//  Custom Painters & Helpers
// ═══════════════════════════════════════════════════════════

/// Draws an animated rotating arc ring.
class _ArcPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _ArcPainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      pi * 1.3,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Shimmer text effect for loading labels.
class _ShimmerText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const _ShimmerText({required this.text, required this.style});

  @override
  State<_ShimmerText> createState() => _ShimmerTextState();
}

class _ShimmerTextState extends State<_ShimmerText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(-1.5 + _shimmerController.value * 3, 0),
              end: Alignment(-0.5 + _shimmerController.value * 3, 0),
              colors: const [
                Colors.white70,
                Colors.white,
                Colors.white70,
              ],
              stops: const [0.0, 0.5, 1.0],
            ).createShader(bounds);
          },
          child: Text(
            widget.text,
            style: widget.style.copyWith(color: Colors.white),
          ),
        );
      },
    );
  }
}
