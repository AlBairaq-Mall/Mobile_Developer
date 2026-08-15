import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

// ════════════════════════════════════════════════════════════
// نوع الرسالة
// ════════════════════════════════════════════════════════════

enum AppMessageType { success, error, warning, info }

// ════════════════════════════════════════════════════════════
// AppMessage — المدخل الوحيد لعرض الرسائل في كامل التطبيق
// ════════════════════════════════════════════════════════════

/// النظام المركزي للرسائل.
///
/// يعرض SnackBar فاخراً مع:
/// - أيقونة ملونة حسب النوع
/// - عنوان + وصف اختياري
/// - Action button اختياري
/// - Animation slide + fade تلقائي
/// - Deduplication: يخفي الرسالة الحالية قبل عرض الجديدة
/// - دعم RTL/LTR كامل
class AppMessage {
  AppMessage._();

  // ── factories ──────────────────────────────────────────────────────────────

  static void success(
    BuildContext context,
    String message, {
    String? title,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(
      context,
      message,
      title: title ?? 'تم بنجاح',
      type: AppMessageType.success,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
    );
  }

  static void error(
    BuildContext context,
    String message, {
    String? title,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
  }) {
    _show(
      context,
      message,
      title: title ?? 'حدث خطأ',
      type: AppMessageType.error,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
    );
  }

  static void warning(
    BuildContext context,
    String message, {
    String? title,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(
      context,
      message,
      title: title ?? 'تنبيه',
      type: AppMessageType.warning,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
    );
  }

  static void info(
    BuildContext context,
    String message, {
    String? title,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(
      context,
      message,
      title: title ?? 'معلومة',
      type: AppMessageType.info,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
    );
  }

  // ── core ───────────────────────────────────────────────────────────────────

  static void _show(
    BuildContext context,
    String message, {
    required String title,
    required AppMessageType type,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
  }) {
    if (!context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);

    // Deduplication: خفي الرسالة الحالية قبل عرض الجديدة
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          elevation: 0,
          margin: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 20),
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.zero,
          duration: duration,
          // SnackBar لا يدعم animation داخلياً — نحتجب بـ AnimatedAppMessage
          content: _AnimatedMessageCard(
            key: UniqueKey(),
            title: title,
            message: message,
            type: type,
            actionLabel: actionLabel,
            onAction: () {
              messenger.hideCurrentSnackBar();
              onAction?.call();
            },
          ),
        ),
      );
  }
}

// ════════════════════════════════════════════════════════════
// الكارد المتحرك
// ════════════════════════════════════════════════════════════

class _AnimatedMessageCard extends StatefulWidget {
  final String title;
  final String message;
  final AppMessageType type;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _AnimatedMessageCard({
    super.key,
    required this.title,
    required this.message,
    required this.type,
    this.actionLabel,
    this.onAction,
  });

  @override
  State<_AnimatedMessageCard> createState() => _AnimatedMessageCardState();
}

class _AnimatedMessageCardState extends State<_AnimatedMessageCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _opacity = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  // ── theme helpers ──────────────────────────────────────────────────────────

  Color get _color {
    switch (widget.type) {
      case AppMessageType.success:
        return AppColors.success;
      case AppMessageType.error:
        return AppColors.error;
      case AppMessageType.warning:
        return AppColors.warning;
      case AppMessageType.info:
        return AppColors.info;
    }
  }

  Color get _lightColor {
    switch (widget.type) {
      case AppMessageType.success:
        return AppColors.successLight;
      case AppMessageType.error:
        return AppColors.errorLight;
      case AppMessageType.warning:
        return AppColors.warningLight;
      case AppMessageType.info:
        return AppColors.infoLight;
    }
  }

  IconData get _icon {
    switch (widget.type) {
      case AppMessageType.success:
        return Icons.check_circle_rounded;
      case AppMessageType.error:
        return Icons.error_rounded;
      case AppMessageType.warning:
        return Icons.warning_rounded;
      case AppMessageType.info:
        return Icons.info_rounded;
    }
  }

  // ── build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: _buildCard(context),
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    final hasAction = widget.actionLabel != null && widget.onAction != null;
    final surface = Theme.of(context).colorScheme.surface;

    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _color.withValues(alpha: 0.20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.09),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Accent bar ──────────────────────────────────────────────────
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: _color,
                borderRadius: const BorderRadiusDirectional.horizontal(
                  start: Radius.circular(16),
                ),
              ),
            ),
            // ── Icon ────────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(12, 14, 0, 14),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _lightColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(_icon, color: _color, size: 20),
              ),
            ),
            // ── Text content ─────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(10, 13, 12, 13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                    ),
                    if (widget.message.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        widget.message,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ],
                    if (hasAction) ...[
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: widget.onAction,
                        child: Text(
                          widget.actionLabel!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: _color,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
