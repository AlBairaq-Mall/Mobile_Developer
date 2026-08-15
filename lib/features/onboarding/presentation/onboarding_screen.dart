// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../../app/localization/language_provider.dart';
// import '../../../app/router/app_routes.dart';
// import '../../../app/theme/app_colors.dart';

// class OnboardingScreen extends StatefulWidget {
//   const OnboardingScreen({super.key});

//   @override
//   State<OnboardingScreen> createState() => _OnboardingScreenState();
// }

// class _OnboardingScreenState extends State<OnboardingScreen>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _animationController;
//   late final Animation<double> _fadeAnimation;
//   late final Animation<Offset> _slideAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1000),
//     );
//     _fadeAnimation = CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeOut,
//     );
//     _slideAnimation =
//         Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: Curves.easeOutCubic,
//       ),
//     );

//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   Future<void> _completeOnboarding(String targetRoute) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('onboarding_completed', true);
//     if (mounted) {
//       context.go(targetRoute);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.sizeOf(context);
//     final langProvider = Provider.of<LanguageProvider>(context);
//     final isArabic = langProvider.isArabic;

//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Color(0xff0C6CF2),
//               AppColors.primaryDark,
//               Color(0xff083A7A),
//             ],
//           ),
//         ),
//         child: Stack(
//           children: [
//             // Decorative background shapes
//             Positioned(
//               top: -80,
//               right: -70,
//               child: Container(
//                 width: 230,
//                 height: 230,
//                 decoration: BoxDecoration(
//                   color: Colors.white.withValues(alpha: .05),
//                   shape: BoxShape.circle,
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: -100,
//               left: -80,
//               child: Container(
//                 width: 280,
//                 height: 280,
//                 decoration: BoxDecoration(
//                   color: Colors.white.withValues(alpha: .04),
//                   shape: BoxShape.circle,
//                 ),
//               ),
//             ),

//             // Top Header: Language Selection
//             SafeArea(
//               child: Align(
//                 alignment: isArabic ? Alignment.topLeft : Alignment.topRight,
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 20,
//                     vertical: 10,
//                   ),
//                   child: TextButton.icon(
//                     onPressed: () {
//                       langProvider.toggle();
//                     },
//                     icon: const Icon(
//                       Icons.language_rounded,
//                       color: Colors.white,
//                       size: 20,
//                     ),
//                     label: Text(
//                       isArabic ? "English" : "العربية",
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     style: TextButton.styleFrom(
//                       backgroundColor: Colors.white.withValues(alpha: 0.12),
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 14,
//                         vertical: 8,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16),
//                         side: BorderSide(
//                           color: Colors.white.withValues(alpha: 0.15),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             // Main Content Area
//             SafeArea(
//               child: FadeTransition(
//                 opacity: _fadeAnimation,
//                 child: SlideTransition(
//                   position: _slideAnimation,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 28),
//                     child: Column(
//                       children: [
//                         const Spacer(),

//                         // Graphic Section (Child with shopping cart/products)
//                         SizedBox(
//                           height: size.height * 0.38,
//                           child: Stack(
//                             alignment: Alignment.center,
//                             children: [
//                               Container(
//                                 width: 270,
//                                 height: 270,
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: Colors.white.withValues(alpha: .05),
//                                 ),
//                               ),
//                               Container(
//                                 width: 210,
//                                 height: 210,
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: Colors.white.withValues(alpha: .08),
//                                 ),
//                               ),

//                               // Main Illustration (Child with shopping cart)
//                               Image.asset(
//                                 "assets/images/onboarding_child.png",
//                                 width: 240,
//                                 fit: BoxFit.contain,
//                                 errorBuilder: (context, error, stackTrace) {
//                                   // Premium vector/icon fallback if file does not exist yet
//                                   return Container(
//                                     width: 170,
//                                     height: 170,
//                                     decoration: BoxDecoration(
//                                       color: Colors.white.withValues(
//                                         alpha: 0.12,
//                                       ),
//                                       borderRadius: BorderRadius.circular(38),
//                                       border: Border.all(
//                                         color: Colors.white.withValues(
//                                           alpha: 0.2,
//                                         ),
//                                       ),
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: Colors.black.withValues(
//                                             alpha: 0.1,
//                                           ),
//                                           blurRadius: 20,
//                                           offset: const Offset(0, 10),
//                                         ),
//                                       ],
//                                     ),
//                                     child: Stack(
//                                       alignment: Alignment.center,
//                                       children: [
//                                         Positioned(
//                                           top: 25,
//                                           child: Icon(
//                                             Icons.face_rounded,
//                                             size: 60,
//                                             color: Colors.white.withValues(
//                                               alpha: 0.9,
//                                             ),
//                                           ),
//                                         ),
//                                         Positioned(
//                                           bottom: 25,
//                                           child: Icon(
//                                             Icons.shopping_cart_rounded,
//                                             size: 55,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),

//                         const SizedBox(height: 35),

//                         // App Titles & Subtitles
//                         Text(
//                           isArabic
//                               ? "مرحباً بك في\nالبيرق هايبر ماركت"
//                               : "Welcome to\nAl-Bairaq Hypermarket",
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 30,
//                             fontWeight: FontWeight.w800,
//                             height: 1.3,
//                           ),
//                         ),

//                         const SizedBox(height: 18),

//                         Text(
//                           isArabic
//                               ? "تسوق كل ما يحتاجه منزلك من البقالة، الخضروات الطازجة، والمنظفات بأفضل الأسعار وتوصيل سريع لباب بيتك."
//                               : "Shop all your home needs from groceries, fresh vegetables, and detergents at the best prices with fast delivery to your door.",
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             color: Colors.white.withValues(alpha: 0.85),
//                             fontSize: 16,
//                             height: 1.7,
//                           ),
//                         ),

//                         const Spacer(),

//                         // Action Buttons at Bottom
//                         Column(
//                           children: [
//                             SizedBox(
//                               width: double.infinity,
//                               height: 58,
//                               child: ElevatedButton(
//                                 onPressed: () =>
//                                     _completeOnboarding(AppRoutes.home),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.white,
//                                   foregroundColor: AppColors.primaryDark,
//                                   elevation: 0,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(18),
//                                   ),
//                                 ),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       isArabic ? "ابدأ الآن" : "Get Started",
//                                       style: const TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     const SizedBox(width: 8),
//                                     const Icon(
//                                       Icons.rocket_launch_rounded,
//                                       size: 20,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 14),
//                             SizedBox(
//                               width: double.infinity,
//                               height: 56,
//                               child: OutlinedButton(
//                                 onPressed: () =>
//                                     _completeOnboarding(AppRoutes.login),
//                                 style: OutlinedButton.styleFrom(
//                                   foregroundColor: Colors.white,
//                                   side: BorderSide(
//                                     color: Colors.white.withValues(alpha: .25),
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(18),
//                                   ),
//                                 ),
//                                 child: Text(
//                                   isArabic
//                                       ? "لدي حساب بالفعل"
//                                       : "I already have an account",
//                                   style: const TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 25),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/localization/language_provider.dart';
import '../../../app/router/app_routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  // ============================================================
  // Page Controller
  // ============================================================

  late final PageController _pageController;

  // ============================================================
  // Existing animation structure
  // ============================================================

  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  // ============================================================
  // Current page
  // ============================================================

  int _currentPage = 0;

  // ============================================================
  // Onboarding data
  // ============================================================

  final List<OnboardingItem> _pages = const [
    OnboardingItem(
      image: 'assets/images/logos/onpo1.png',
      titleAr: 'تسوق كل ما تحتاجه',
      titleEn: 'Shop Everything You Need',
      descriptionAr:
          'آلاف المنتجات بجودة عالية واختيارات تناسب احتياجاتك اليومية.',
      descriptionEn:
          'Thousands of quality products and choices for all your daily needs.',
    ),
    OnboardingItem(
      image: 'assets/images/logos/onpo2.png',
      titleAr: 'توصيل سريع وآمن',
      titleEn: 'Fast & Secure Delivery',
      descriptionAr:
          'نصل إليك أينما كنت وفي الوقت الذي يناسبك، بكل سرعة وأمان.',
      descriptionEn:
          'We deliver wherever you are, whenever you need it, quickly and safely.',
    ),
    OnboardingItem(
      image: 'assets/images/logos/onpo3.png',
      titleAr: 'طرق دفع متعددة وآمنة',
      titleEn: 'Multiple & Secure Payments',
      descriptionAr:
          'اختر طريقة الدفع التي تناسبك وتمتع بتجربة تسوق آمنة وموثوقة.',
      descriptionEn:
          'Choose the payment method that suits you for a secure shopping experience.',
    ),
    OnboardingItem(
      image: 'assets/images/logos/onpo4.png',
      titleAr: 'تجربة تسوق مميزة',
      titleEn: 'A Better Shopping Experience',
      descriptionAr:
          'نحن هنا لنجعل حياتك أسهل ونوفر لك كل ما تحتاجه في مكان واحد.',
      descriptionEn:
          'We are here to make your life easier with everything you need in one place.',
    ),
  ];

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    // ------------------------------------------------------------
    // Existing animation controller retained
    // ------------------------------------------------------------

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.0, 0.08), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // ============================================================
  // Complete onboarding
  // ============================================================

  Future<void> _completeOnboarding(String targetRoute) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('onboarding_completed', true);

    if (!mounted) return;

    context.go(targetRoute);
  }

  // ============================================================
  // Next page
  // ============================================================

  // Future<void> _nextPage() async {
  //   if (_currentPage < _pages.length - 1) {
  //     await _pageController.nextPage(
  //       duration: const Duration(milliseconds: 420),
  //       curve: Curves.easeOutCubic,
  //     );
  //   } else {
  //     await _completeOnboarding(AppRoutes.home);
  //   }
  // }

  Future<void> _nextPage() async {
    if (_currentPage >= _pages.length - 1) {
      return;
    }

    await _pageController.nextPage(
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
    );
  }

  // ============================================================
  // Start shopping
  // ============================================================

  Future<void> _startShopping() async {
    await _completeOnboarding(AppRoutes.home);
  }

  // ============================================================
  // Skip onboarding
  // ============================================================

  Future<void> _skipOnboarding() async {
    await _completeOnboarding(AppRoutes.home);
  }

  // ============================================================
  // Page changed
  // ============================================================

  void _onPageChanged(int page) {
    if (!mounted) return;

    setState(() {
      _currentPage = page;
    });

    // Restart page animation
    _animationController.reset();
    _animationController.forward();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final langProvider = Provider.of<LanguageProvider>(context);
    final isArabic = langProvider.isArabic;

    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ======================================================
            // TOP BAR
            // ======================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ------------------------------------------------
                  // Language
                  // ------------------------------------------------
                  _buildLanguageButton(langProvider, isArabic),

                  // ------------------------------------------------
                  // Skip
                  // ------------------------------------------------
                  TextButton(
                    onPressed: _skipOnboarding,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      isArabic ? 'تخطي' : 'Skip',
                      style: const TextStyle(
                        color: Color(0xFF777777),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ======================================================
            // PAGE VIEW
            // ======================================================
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: _onPageChanged,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final item = _pages[index];

                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: _buildPage(
                        item: item,
                        isArabic: isArabic,
                        size: size,
                      ),
                    ),
                  );
                },
              ),
            ),

            // ======================================================
            // BOTTOM NAVIGATION
            // ======================================================
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 22),
              child: Column(
                children: [
                  // ------------------------------------------------
                  // Page indicators
                  // ------------------------------------------------
                  _buildPageIndicator(),

                  const SizedBox(height: 22),

                  // ------------------------------------------------
                  // Navigation
                  // ------------------------------------------------
                  _buildBottomNavigation(isArabic: isArabic),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // PAGE
  // ============================================================

  Widget _buildPage({
    required OnboardingItem item,
    required bool isArabic,
    required Size size,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 28,
      ),
      child: Column(
        children: [
          // ======================================================
          // IMAGE AREA
          // ======================================================

          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: Image.asset(
                  item.image,
                  width: size.width * 0.68,
                  height: size.height * 0.34,
                  fit: BoxFit.contain,
                  errorBuilder: (
                    context,
                    error,
                    stackTrace,
                  ) {
                    return _buildImageError();
                  },
                ),
              ),
            ),
          ),

          // ======================================================
          // TEXT AREA
          // ======================================================

          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // --------------------------------------------------
              // TITLE
              // --------------------------------------------------

              Text(
                isArabic ? item.titleAr : item.titleEn,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF172B4D),
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  height: 1.25,
                ),
              ),

              // --------------------------------------------------
              // SPACE BETWEEN TITLE AND DESCRIPTION
              // --------------------------------------------------

              const SizedBox(
                height: 18,
              ),

              // --------------------------------------------------
              // DESCRIPTION
              // --------------------------------------------------

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                child: Text(
                  isArabic ? item.descriptionAr : item.descriptionEn,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF777777),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.7,
                  ),
                ),
              ),
            ],
          ),

          // ======================================================
          // SPACE BEFORE BOTTOM NAVIGATION
          // ======================================================

          const SizedBox(
            height: 28,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LANGUAGE BUTTON
  // ============================================================

  Widget _buildLanguageButton(LanguageProvider langProvider, bool isArabic) {
    return TextButton(
      onPressed: () {
        langProvider.toggle();
      },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.language_rounded,
            size: 18,
            color: Color(0xFF777777),
          ),
          const SizedBox(width: 5),
          Text(
            isArabic ? 'English' : 'العربية',
            style: const TextStyle(
              color: Color(0xFF777777),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PAGE INDICATOR
  // ============================================================

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_pages.length, (index) {
        final isActive = index == _currentPage;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 22 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFFFB51B) : const Color(0xFFD9D9D9),
            borderRadius: BorderRadius.circular(20),
          ),
        );
      }),
    );
  }

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

  // Widget _buildBottomNavigation({required bool isArabic}) {
  //   final isLastPage = _currentPage == _pages.length - 1;

  //   return SizedBox(
  //     height: 52,
  //     child: Row(
  //       children: [
  //         // ======================================================
  //         // NEXT / START SHOPPING
  //         // ======================================================
  //         TextButton(
  //           onPressed: _nextPage,
  //           style: TextButton.styleFrom(
  //             padding: const EdgeInsets.symmetric(horizontal: 4),
  //           ),
  //           child: Text(
  //             isLastPage
  //                 ? (isArabic ? 'ابدأ بالتسوق الآن' : 'Start Shopping')
  //                 : (isArabic ? 'التالي' : 'Next'),
  //             style: const TextStyle(
  //               color: Color(0xFFFFA900),
  //               fontSize: 14,
  //               fontWeight: FontWeight.w700,
  //             ),
  //           ),
  //         ),

  //         const Spacer(),

  //         // ======================================================
  //         // LAST PAGE CTA
  //         // ======================================================
  //         if (isLastPage)
  //           ElevatedButton(
  //             onPressed: () {
  //               _completeOnboarding(AppRoutes.home);
  //             },
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: const Color(0xFF102B50),
  //               foregroundColor: Colors.white,
  //               elevation: 0,
  //               padding: const EdgeInsets.symmetric(
  //                 horizontal: 22,
  //                 vertical: 12,
  //               ),
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(24),
  //               ),
  //             ),
  //             child: Text(
  //               isArabic ? 'ابدأ التسوق الآن' : 'Start Shopping Now',
  //               style: const TextStyle(
  //                 fontSize: 13,
  //                 fontWeight: FontWeight.w700,
  //               ),
  //             ),
  //           ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildBottomNavigation({
    required bool isArabic,
  }) {
    final isLastPage = _currentPage == _pages.length - 1;

    return SizedBox(
      height: 52,
      child: Row(
        children: [
          if (!isLastPage)
            TextButton(
              onPressed: _nextPage,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                ),
              ),
              child: Text(
                isArabic ? 'التالي' : 'Next',
                style: const TextStyle(
                  color: Color(0xFFFFA900),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          if (isLastPage)
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: _startShopping,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF102B50),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    isArabic ? 'ابدأ بالتسوق الآن' : 'Start Shopping Now',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ============================================================
  // IMAGE ERROR
  // ============================================================

  Widget _buildImageError() {
    return const Center(
      child: Icon(
        Icons.image_not_supported_outlined,
        color: Color(0xFFD0D0D0),
        size: 48,
      ),
    );
  }
}

// ================================================================
// ONBOARDING ITEM MODEL
// ================================================================

class OnboardingItem {
  final String image;

  final String titleAr;
  final String titleEn;

  final String descriptionAr;
  final String descriptionEn;

  const OnboardingItem({
    required this.image,
    required this.titleAr,
    required this.titleEn,
    required this.descriptionAr,
    required this.descriptionEn,
  });
}
