import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

// ════════════════════════════════════════════════════════════
// LoadingWidget — Page loading
// ════════════════════════════════════════════════════════════

/// يُستخدم لتحميل صفحة كاملة أو قسم كبير.
class LoadingWidget extends StatelessWidget {
  final String? message;
  const LoadingWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 36,
            height: 36,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: AppColors.primary,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 14),
            Text(
              message!,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
// InlineLoadingWidget — Loading صغير داخل صف أو بطاقة
// ════════════════════════════════════════════════════════════

class InlineLoadingWidget extends StatelessWidget {
  final double size;
  final Color? color;

  const InlineLoadingWidget({
    super.key,
    this.size = 18,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: color ?? AppColors.primary,
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
// AppLoadingButton — زر بداخله loading indicator
// ════════════════════════════════════════════════════════════

/// استخدم هذا بدلاً من تعطيل الزر فقط.
/// يُبدّل نص الزر بـ loading indicator أثناء العملية.
class AppLoadingButton extends StatelessWidget {
  final String label;
  final String? loadingLabel;
  final bool isLoading;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double height;
  final double? width;
  final EdgeInsetsGeometry? padding;

  const AppLoadingButton({
    super.key,
    required this.label,
    required this.isLoading,
    this.onPressed,
    this.loadingLabel,
    this.backgroundColor,
    this.foregroundColor,
    this.height = 50,
    this.width,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width ?? double.infinity,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          foregroundColor: foregroundColor ?? Colors.white,
          disabledBackgroundColor:
              (backgroundColor ?? AppColors.primary).withValues(alpha: 0.7),
          disabledForegroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding:
              padding ?? const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: isLoading
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                    if (loadingLabel != null) ...[
                      const SizedBox(width: 10),
                      Text(
                        loadingLabel!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                )
              : Text(
                  label,
                  key: const ValueKey('label'),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
        ),
      ),
    );
  }
}
