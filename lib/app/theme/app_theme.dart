import 'package:bhm_supermarket/app/theme/app_radius.dart';
import 'package:bhm_supermarket/app/theme/app_spacing.dart';
import 'package:bhm_supermarket/app/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: AppTypography.fontFamily,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: AppColors.surface,
      error: AppColors.error,
    ),
    textTheme: GoogleFonts.cairoTextTheme().copyWith(
      displayLarge: AppTypography.displayLarge,
      displayMedium: AppTypography.displayMedium,
      displaySmall: AppTypography.displaySmall,
      headlineLarge: AppTypography.headlineLarge,
      headlineMedium: AppTypography.headlineMedium,
      headlineSmall: AppTypography.headlineSmall,
      titleLarge: AppTypography.titleLarge,
      titleMedium: AppTypography.titleMedium,
      titleSmall: AppTypography.titleSmall,
      bodyLarge: AppTypography.bodyLarge,
      bodyMedium: AppTypography.bodyMedium,
      bodySmall: AppTypography.bodySmall,
      labelLarge: AppTypography.labelLarge,
      labelMedium: AppTypography.labelMedium,
      labelSmall: AppTypography.labelSmall,
    ),
    splashFactory: InkRipple.splashFactory,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
      space: 1,
    ),
    iconTheme: const IconThemeData(color: AppColors.textPrimary, size: 22),
    primaryIconTheme: const IconThemeData(color: AppColors.primary),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.textPrimary,
      titleTextStyle: AppTypography.titleLarge,
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: AppColors.surface,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      margin: EdgeInsets.zero,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        minimumSize: const Size(double.infinity, 54),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        textStyle: AppTypography.button,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 54),
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary, width: 1.3),
        textStyle: AppTypography.labelLarge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: AppTypography.labelLarge,
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        iconSize: 22,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      iconColor: AppColors.primary,
      textColor: AppColors.textPrimary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textHint),
      labelStyle: AppTypography.bodyMedium.copyWith(
        color: AppColors.textSecondary,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.error),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.textPrimary,
      contentTextStyle: AppTypography.bodyMedium.copyWith(color: Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
    ),
    chipTheme: ChipThemeData(
      selectedColor: AppColors.primary.withValues(alpha: .12),
      backgroundColor: AppColors.background,
      side: const BorderSide(color: AppColors.border),
      labelStyle: AppTypography.labelMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    ),
    radioTheme: const RadioThemeData(),
    switchTheme: const SwitchThemeData(),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textHint,
      showUnselectedLabels: true,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.surface,
      elevation: 0,
      indicatorColor: AppColors.primary.withValues(alpha: .12),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppTypography.labelMedium.copyWith(color: AppColors.primary);
        }

        return AppTypography.labelMedium.copyWith(color: AppColors.textHint);
      }),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: AppTypography.fontFamily,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: AppColors.surfaceDark,
      error: AppColors.error,
    ),
    textTheme: GoogleFonts.cairoTextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge: AppTypography.displayLarge.copyWith(color: Colors.white),
      displayMedium: AppTypography.displayMedium.copyWith(color: Colors.white),
      displaySmall: AppTypography.displaySmall.copyWith(color: Colors.white),
      headlineLarge: AppTypography.headlineLarge.copyWith(color: Colors.white),
      headlineMedium: AppTypography.headlineMedium.copyWith(
        color: Colors.white,
      ),
      headlineSmall: AppTypography.headlineSmall.copyWith(color: Colors.white),
      titleLarge: AppTypography.titleLarge.copyWith(color: Colors.white),
      titleMedium: AppTypography.titleMedium.copyWith(color: Colors.white),
      titleSmall: AppTypography.titleSmall.copyWith(color: Colors.white),
      bodyLarge: AppTypography.bodyLarge.copyWith(color: Colors.white),
      bodyMedium: AppTypography.bodyMedium.copyWith(color: Colors.white),
      bodySmall: AppTypography.bodySmall.copyWith(
        color: const Color(0xffB5BCC7),
      ),
      labelLarge: AppTypography.labelLarge.copyWith(color: Colors.white),
      labelMedium: AppTypography.labelMedium.copyWith(
        color: const Color(0xffC5CBD4),
      ),
      labelSmall: AppTypography.labelSmall.copyWith(
        color: const Color(0xff9DA5B4),
      ),
    ),
    splashFactory: InkRipple.splashFactory,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    dividerTheme: const DividerThemeData(
      color: Color(0xff31363F),
      thickness: 1,
    ),
    iconTheme: const IconThemeData(color: Colors.white, size: 22),
    primaryIconTheme: const IconThemeData(color: AppColors.primary),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      titleTextStyle: AppTypography.titleLarge.copyWith(color: Colors.white),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: AppColors.cardDark,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 54),
        textStyle: AppTypography.button,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        minimumSize: const Size(double.infinity, 54),
        side: const BorderSide(color: AppColors.primary),
        textStyle: AppTypography.labelLarge.copyWith(color: AppColors.primary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: AppTypography.labelLarge,
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(foregroundColor: Colors.white),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    listTileTheme: ListTileThemeData(
      iconColor: AppColors.primary,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xff2D333B),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      hintStyle: AppTypography.bodyMedium.copyWith(
        color: const Color(0xffA6AFBE),
      ),
      labelStyle: AppTypography.bodyMedium.copyWith(
        color: const Color(0xffBFC6D2),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: Color(0xff444C56)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: Color(0xff444C56)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.error),
      ),
    ),
    chipTheme: ChipThemeData(
      selectedColor: AppColors.primary.withValues(alpha: .15),
      backgroundColor: const Color(0xff1E232B),
      side: const BorderSide(color: Color(0xff3A404B)),
      labelStyle: AppTypography.labelMedium.copyWith(color: Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    ),
    radioTheme: const RadioThemeData(),
    switchTheme: const SwitchThemeData(),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.surfaceDark,
      indicatorColor: AppColors.primary.withValues(alpha: .18),
      elevation: 0,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppTypography.labelMedium.copyWith(color: AppColors.primary);
        }

        return AppTypography.labelMedium.copyWith(
          color: const Color(0xff9DA5B4),
        );
      }),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.surfaceDark,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Color(0xff9DA5B4),
      showUnselectedLabels: true,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.cardDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.cardDark,
      surfaceTintColor: Colors.transparent,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: const Color(0xff1E232B),
      contentTextStyle: AppTypography.bodyMedium.copyWith(color: Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
    ),
  );
}
