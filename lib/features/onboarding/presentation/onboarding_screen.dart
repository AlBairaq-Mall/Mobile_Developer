import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/localization/language_provider.dart';
import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding(String targetRoute) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    if (mounted) {
      context.go(targetRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final langProvider = Provider.of<LanguageProvider>(context);
    final isArabic = langProvider.isArabic;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff0C6CF2),
              AppColors.primaryDark,
              Color(0xff083A7A),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Decorative background shapes
            Positioned(
              top: -80,
              right: -70,
              child: Container(
                width: 230,
                height: 230,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .05),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              left: -80,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .04),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Top Header: Language Selection
            SafeArea(
              child: Align(
                alignment: isArabic ? Alignment.topLeft : Alignment.topRight,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextButton.icon(
                    onPressed: () {
                      langProvider.toggle();
                    },
                    icon: const Icon(Icons.language_rounded,
                        color: Colors.white, size: 20),
                    label: Text(
                      isArabic ? "English" : "العربية",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.12),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.15)),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Main Content Area
            SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      children: [
                        const Spacer(),

                        // Graphic Section (Child with shopping cart/products)
                        SizedBox(
                          height: size.height * 0.38,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 270,
                                height: 270,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: .05),
                                ),
                              ),
                              Container(
                                width: 210,
                                height: 210,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: .08),
                                ),
                              ),

                              // Main Illustration (Child with shopping cart)
                              Image.asset(
                                "assets/images/onboarding_child.png",
                                width: 240,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  // Premium vector/icon fallback if file does not exist yet
                                  return Container(
                                    width: 170,
                                    height: 170,
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.white.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(38),
                                      border: Border.all(
                                          color: Colors.white
                                              .withValues(alpha: 0.2)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.1),
                                          blurRadius: 20,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Positioned(
                                          top: 25,
                                          child: Icon(
                                            Icons.face_rounded,
                                            size: 60,
                                            color: Colors.white
                                                .withValues(alpha: 0.9),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 25,
                                          child: Icon(
                                            Icons.shopping_cart_rounded,
                                            size: 55,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 35),

                        // App Titles & Subtitles
                        Text(
                          isArabic
                              ? "مرحباً بك في\nالبيرق هايبر ماركت"
                              : "Welcome to\nAl-Bairaq Hypermarket",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            height: 1.3,
                          ),
                        ),

                        const SizedBox(height: 18),

                        Text(
                          isArabic
                              ? "تسوق كل ما يحتاجه منزلك من البقالة، الخضروات الطازجة، والمنظفات بأفضل الأسعار وتوصيل سريع لباب بيتك."
                              : "Shop all your home needs from groceries, fresh vegetables, and detergents at the best prices with fast delivery to your door.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 16,
                            height: 1.7,
                          ),
                        ),

                        const Spacer(),

                        // Action Buttons at Bottom
                        Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 58,
                              child: ElevatedButton(
                                onPressed: () =>
                                    _completeOnboarding(AppRoutes.home),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppColors.primaryDark,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      isArabic ? "ابدأ الآن" : "Get Started",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.rocket_launch_rounded,
                                        size: 20),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: OutlinedButton(
                                onPressed: () =>
                                    _completeOnboarding(AppRoutes.login),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: BorderSide(
                                    color: Colors.white.withValues(alpha: .25),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                                child: Text(
                                  isArabic
                                      ? "لدي حساب بالفعل"
                                      : "I already have an account",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 25),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
