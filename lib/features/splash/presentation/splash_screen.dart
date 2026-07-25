import 'dart:ui';

import 'package:bhm_supermarket/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app/router/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _glowOpacity;
  late final Animation<Offset> _titleOffset;
  late final Animation<double> _titleOpacity;
  late final Animation<double> _loaderOpacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _logoScale = Tween(
      begin: .65,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _logoOpacity = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0,
          .45,
        ),
      ),
    );

    _glowOpacity = Tween(
      begin: .2,
      end: .8,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _titleOpacity = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          .35,
          .75,
        ),
      ),
    );

    _titleOffset = Tween(
      begin: const Offset(
        0,
        .35,
      ),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _loaderOpacity = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          .75,
          1,
        ),
      ),
    );

    _start();
  }

  // Future<void> _start() async {
  //   await _controller.forward();

  //   final prefs = await SharedPreferences.getInstance();

  //   final completed = prefs.getBool('onboarding_completed') ?? false;

  //   await Future.delayed(
  //     const Duration(milliseconds: 900),
  //   );

  //   if (!mounted) return;

  //   if (completed) {
  //     context.go(AppRoutes.home);
  //   } else {
  //     context.go(AppRoutes.onboarding);
  //   }
  // }

  Future<void> _start() async {
    await _controller.forward();

    final prefs = await SharedPreferences.getInstance();
    final completed = prefs.getBool('onboarding_completed') ?? false;

    await Future.delayed(
      const Duration(milliseconds: 900),
    );

    if (!mounted) return;

    if (completed) {
      context.go(AppRoutes.home);
    } else {
      context.go(AppRoutes.onboarding);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    final logoSize = size.width.clamp(
      120.0,
      170.0,
    );

    return Scaffold(
      body: Stack(
        children: [
          /// Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color.fromARGB(255, 255, 224, 48),
                  AppColors.primaryLight,
                  AppColors.primaryDark,
                ],
              ),
            ),
          ),

          Positioned(
            top: -120,
            right: -90,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(.08),
              ),
            ),
          ),

          Positioned(
            bottom: -150,
            left: -120,
            child: Container(
              width: 330,
              height: 330,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(.05),
              ),
            ),
          ),

          Positioned(
            top: size.height * .18,
            left: -80,
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(.04),
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (_, __) {
                        return Opacity(
                          opacity: _glowOpacity.value,
                          child: Container(
                            width: logoSize + 55,
                            height: logoSize + 55,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 55,
                                  spreadRadius: 15,
                                  color: Colors.white.withOpacity(.18),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    FadeTransition(
                      opacity: _logoOpacity,
                      child: ScaleTransition(
                        scale: _logoScale,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(34),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 18,
                              sigmaY: 18,
                            ),
                            child: Container(
                              width: logoSize,
                              height: logoSize,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.16),
                                borderRadius: BorderRadius.circular(34),
                                border: Border.all(
                                  color: Colors.white.withOpacity(.28),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 30,
                                    color: const Color.fromARGB(255, 0, 0, 0)
                                        .withOpacity(.15),
                                    offset: const Offset(0, 14),
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                "assets/images/logos/bhm_logo.png",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 42),
                    FadeTransition(
                      opacity: _titleOpacity,
                      child: SlideTransition(
                        position: _titleOffset,
                        child: const Text(
                          "البيرق هايبر ماركت",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            letterSpacing: .4,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    FadeTransition(
                      opacity: _titleOpacity,
                      child: const Text(
                        "تجربة تسوق أسرع • أجود المنتجات • توصيل حتى باب منزلك",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                          height: 1.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 70),
                    FadeTransition(
                      opacity: _loaderOpacity,
                      child: Column(
                        children: [
                          SizedBox(
                            width: 44,
                            height: 44,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 44,
                                  height: 44,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.2,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                    backgroundColor:
                                        Colors.white.withOpacity(.18),
                                  ),
                                ),
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                          const Text(
                            "جاري تجهيز تجربة التسوق...",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// Footer
          Positioned(
            left: 24,
            right: 24,
            bottom: 28,
            child: FadeTransition(
              opacity: _loaderOpacity,
              child: Column(
                children: [
                  Divider(
                    color: Colors.white.withOpacity(.15),
                    thickness: .8,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "© 2026 BHM Hyper Market",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromARGB(136, 255, 255, 255),
                      fontSize: 12,
                      letterSpacing: .3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:bhm_supermarket/app/theme/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

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
//   late final Animation<double> _backgroundOpacity;
//   late final Animation<Offset> _titleOffset;
//   late final Animation<Offset> _subtitleOffset;
//   late final Animation<double> _loaderOpacity;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1800),
//     );

//     _backgroundOpacity = CurvedAnimation(
//       parent: _controller,
//       curve: const Interval(
//         0.0,
//         .35,
//         curve: Curves.easeOut,
//       ),
//     );

//     _logoOpacity = CurvedAnimation(
//       parent: _controller,
//       curve: const Interval(
//         .15,
//         .55,
//         curve: Curves.easeOut,
//       ),
//     );

//     _logoScale = Tween<double>(
//       begin: .72,
//       end: 1,
//     ).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: Curves.easeOutBack,
//       ),
//     );

//     _titleOffset = Tween<Offset>(
//       begin: const Offset(0, .45),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(
//           .35,
//           .75,
//           curve: Curves.easeOutCubic,
//         ),
//       ),
//     );

//     _subtitleOffset = Tween<Offset>(
//       begin: const Offset(0, .55),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(
//           .45,
//           .85,
//           curve: Curves.easeOutCubic,
//         ),
//       ),
//     );

//     _loaderOpacity = CurvedAnimation(
//       parent: _controller,
//       curve: const Interval(
//         .70,
//         1,
//         curve: Curves.easeIn,
//       ),
//     );

//     _start();
//   }

//   Future<void> _start() async {
//     await _controller.forward();

//     await Future.delayed(
//       const Duration(milliseconds: 1000),
//     );

//     if (!mounted) return;

//     context.go(AppRoutes.onboarding);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.sizeOf(context);

//     final logoSize = (size.width * 0.33).clamp(
//       120.0,
//       170.0,
//     );

//     return Scaffold(
//       body: FadeTransition(
//         opacity: _backgroundOpacity,
//         child: Container(
//           width: double.infinity,
//           height: double.infinity,
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 Color(0xff39BDF8),
//                 AppColors.primaryLight,
//                 AppColors.primaryDark,
//               ],
//             ),
//           ),
//           child: Stack(
//             children: [
//               /// الخلفية
//               Positioned(
//                 top: -120,
//                 left: -80,
//                 child: Container(
//                   width: 260,
//                   height: 260,
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(.05),
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//               ),

//               Positioned(
//                 right: -120,
//                 bottom: -100,
//                 child: Container(
//                   width: 320,
//                   height: 320,
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(.04),
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//               ),

//               SafeArea(
//                 child: Center(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 28),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         FadeTransition(
//                           opacity: _logoOpacity,
//                           child: ScaleTransition(
//                             scale: _logoScale,
//                             child: Hero(
//                               tag: "app_logo",
//                               child: Container(
//                                 width: logoSize,
//                                 height: logoSize,
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(34),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black.withOpacity(.18),
//                                       blurRadius: 28,
//                                       offset: const Offset(0, 12),
//                                     ),
//                                   ],
//                                 ),
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(20),
//                                   child: Image.asset(
//                                     "assets/images/logos/bhm_logo.png",
//                                     fit: BoxFit.contain,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 34),
//                         SlideTransition(
//                           position: _titleOffset,
//                           child: FadeTransition(
//                             opacity: _logoOpacity,
//                             child: const Text(
//                               "البيرق هايبر ماركت",
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 29,
//                                 fontWeight: FontWeight.w800,
//                                 letterSpacing: .3,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         SlideTransition(
//                           position: _subtitleOffset,
//                           child: FadeTransition(
//                             opacity: _logoOpacity,
//                             child: Text(
//                               "تجربة تسوق ذكية • أسعار منافسة • توصيل سريع",
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 color: Colors.white.withOpacity(.82),
//                                 fontSize: 15,
//                                 height: 1.5,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 70),
//                         FadeTransition(
//                           opacity: _loaderOpacity,
//                           child: const SizedBox(
//                             width: 34,
//                             height: 34,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2.6,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
