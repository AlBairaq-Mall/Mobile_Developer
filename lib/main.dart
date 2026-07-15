import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'app/di/dependency_injection.dart';
import 'app/providers/app_providers.dart';
import 'app/router/app_router.dart';
import 'app/theme/app_theme.dart';
import 'app/theme/theme_provider.dart';
import 'app/localization/language_provider.dart';
import 'features/auth/providers/auth_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthProvider _authProvider;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authProvider = AuthProvider(DependencyInjection.authRepository);
    _router = AppRouter.create(_authProvider);
    _authProvider.initSession();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders.build(_authProvider),
      child: Consumer2<ThemeProvider, LanguageProvider>(
        builder: (context, themeProvider, langProvider, _) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'البيرق هايبر ماركت',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.mode,
            routerConfig: _router,
            locale: langProvider.locale,
            supportedLocales: const [Locale('ar'), Locale('en')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            builder: (context, child) {
              final isRtl = langProvider.isArabic;
              return Directionality(
                textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}
