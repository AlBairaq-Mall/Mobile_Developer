import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _ctrl = PageController();
  int _page = 0;

  final _pages = const [
    _OnboardPage(
        '🛒',
        'تسوق بسهولة',
        'آلاف المنتجات من بقالة، خضار، ومنظفات كلها في مكان واحد',
        [Color(0xFF00BF6F), Color(0xFF0099CC)]),
    _OnboardPage(
        '🚚',
        'توصيل سريع',
        'توصيل لباب بيتك في وقت قياسي تتبع طلبك لحظة بلحظة',
        [Color(0xFFFF6B35), Color(0xFFFF4081)]),
    _OnboardPage(
        '💳',
        'دفع آمن',
        'ادفع كاشاً أو بالتحويل البنكي بأمان وسهولة تامة',
        [Color(0xFF7B2FF7), Color(0xFF00C9FF)]),
  ];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _ctrl,
            onPageChanged: (i) => setState(() => _page = i),
            itemCount: _pages.length,
            itemBuilder: (_, i) => _PageView(page: _pages[i]),
          ),

          // Skip button
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 20,
            child: TextButton(
              onPressed: () => context.go(AppRoutes.login),
              child: const Text('تخطي',
                  style: TextStyle(color: Colors.white70, fontSize: 15)),
            ),
          ),

          // Bottom controls
          Positioned(
            bottom: 48,
            left: 28,
            right: 28,
            child: Column(
              children: [
                // Dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                      _pages.length,
                      (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _page == i ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _page == i ? Colors.white : Colors.white38,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          )),
                ),
                const SizedBox(height: 28),

                _page == _pages.length - 1
                    ? ElevatedButton(
                        onPressed: () => context.go(AppRoutes.login),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: _pages[_page].colors[0],
                          minimumSize: const Size(double.infinity, 54),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text('ابدأ التسوق',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => context.go(AppRoutes.login),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white54),
                                minimumSize: const Size(0, 52),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                              ),
                              child: const Text('تسجيل الدخول'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _ctrl.nextPage(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeOut),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: _pages[_page].colors[0],
                                minimumSize: const Size(0, 52),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('التالي',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(width: 6),
                                  Icon(Icons.arrow_back_ios_rounded, size: 16),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardPage {
  final String emoji, title, desc;
  final List<Color> colors;
  const _OnboardPage(this.emoji, this.title, this.desc, this.colors);
}

class _PageView extends StatelessWidget {
  final _OnboardPage page;
  const _PageView({required this.page});
  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: page.colors,
              begin: Alignment.topRight,
              end: Alignment.bottomLeft),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                    child:
                        Text(page.emoji, style: const TextStyle(fontSize: 90))),
              ),
              const SizedBox(height: 48),
              Text(page.title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Text(page.desc,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.88),
                        fontSize: 16,
                        height: 1.6)),
              ),
              const SizedBox(height: 120),
            ],
          ),
        ),
      );
}
