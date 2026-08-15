import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/widgets/app_button.dart';

// ════════════════════════════════════════════════════════════
// EmptyState — لا توجد بيانات (ليس خطأ)
// ════════════════════════════════════════════════════════════

/// يُعرض عندما القائمة/الصفحة فارغة طبيعياً.
/// مثال: "لا توجد طلبات" / "المفضلة فارغة"
/// لا تستخدمه لحالات الخطأ — استخدم [ErrorState] أو [NetworkErrorState].
class EmptyState extends StatelessWidget {
  final String emoji;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.emoji,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ── Icon bubble ──────────────────────────────────────────────
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 42)),
              ),
            ),
            const SizedBox(height: 20),
            // ── Title ────────────────────────────────────────────────────
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            // ── Subtitle ─────────────────────────────────────────────────
            if (subtitle != null && subtitle!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            // ── Action ───────────────────────────────────────────────────
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: 180,
                child: AppButton(
                  text: actionLabel!,
                  onPressed: onAction,
                  height: 44,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
// ErrorState — خطأ عام (يختلف بصرياً عن EmptyState)
// ════════════════════════════════════════════════════════════

/// يُعرض عندما تفشل عملية تحميل البيانات.
/// مثال: "تعذر تحميل المنتجات"
///
/// مميز بصرياً عن [EmptyState]:
/// - خلفية حمراء خفيفة
/// - أيقونة خطأ واضحة
/// - رسالة retry
class ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final String? title;

  const ErrorState({
    super.key,
    required this.message,
    this.onRetry,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ── Error icon bubble (حمراء — مختلفة عن EmptyState) ─────────
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: AppColors.error,
                size: 44,
              ),
            ),
            const SizedBox(height: 20),
            // ── Title ────────────────────────────────────────────────────
            Text(
              title ?? 'تعذر تحميل البيانات',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // ── Message ──────────────────────────────────────────────────
            Text(
              message,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            // ── Retry ────────────────────────────────────────────────────
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: 180,
                child: AppButton(
                  text: 'إعادة المحاولة',
                  onPressed: onRetry,
                  height: 44,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
// NetworkErrorState — خطأ شبكة متخصص
// ════════════════════════════════════════════════════════════

/// يُعرض عند انقطاع الإنترنت أو timeout.
class NetworkErrorState extends StatelessWidget {
  final VoidCallback? onRetry;
  final String? message;

  const NetworkErrorState({super.key, this.onRetry, this.message});

  @override
  Widget build(BuildContext context) {
    return ErrorState(
      title: 'لا يوجد اتصال بالإنترنت',
      message:
          message ?? 'تحقق من اتصالك بالإنترنت وحاول مرة أخرى.',
      onRetry: onRetry,
    );
  }
}
