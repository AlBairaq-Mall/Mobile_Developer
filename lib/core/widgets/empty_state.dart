import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/widgets/app_button.dart';

/// حالة الفراغ مع رسالة وزر "إعادة المحاولة" أو "اتخاذ إجراء".
class EmptyState extends StatelessWidget {
  final String   emoji;
  final String   title;
  final String?  subtitle;
  final String?  actionLabel;
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
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 110, height: 110,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Center(child: Text(emoji, style: const TextStyle(fontSize: 52))),
            ),
            const SizedBox(height: 20),
            Text(title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(subtitle!, style: const TextStyle(color: AppColors.textSecondary), textAlign: TextAlign.center),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 28),
              SizedBox(
                width: 180,
                child: AppButton(text: actionLabel!, onPressed: onAction, height: 46),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// حالة خطأ مع "إعادة المحاولة"
class ErrorState extends StatelessWidget {
  final String   message;
  final VoidCallback? onRetry;

  const ErrorState({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) => EmptyState(
    emoji: '⚠️',
    title: 'حدث خطأ',
    subtitle: message,
    actionLabel: onRetry != null ? 'إعادة المحاولة' : null,
    onAction: onRetry,
  );
}
