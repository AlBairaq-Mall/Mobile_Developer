import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

// ════════════════════════════════════════════════════════════
// AppLoadingType Enum
// ════════════════════════════════════════════════════════════

enum AppLoadingType {
  ring,
  dots,
  pulse,
  bars,
}

// ════════════════════════════════════════════════════════════
// Central AppLoading Widget
// ════════════════════════════════════════════════════════════

class AppLoading extends StatelessWidget {
  final AppLoadingType type;
  final double size;
  final Color? color;
  final String? message;
  final EdgeInsetsGeometry? padding;

  const AppLoading({
    super.key,
    this.type = AppLoadingType.ring,
    this.size = 36,
    this.color,
    this.message,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator;
    final activeColor = color ?? AppColors.primary;

    switch (type) {
      case AppLoadingType.ring:
        loadingIndicator = SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: math.max(2.0, size / 12.0),
            color: activeColor,
          ),
        );
        break;
      case AppLoadingType.dots:
        loadingIndicator = _DotsLoading(size: size, color: activeColor);
        break;
      case AppLoadingType.pulse:
        loadingIndicator = _PulseLoading(size: size, color: activeColor);
        break;
      case AppLoadingType.bars:
        loadingIndicator = _BarsLoading(size: size, color: activeColor);
        break;
    }

    if (message == null) {
      return padding != null
          ? Padding(padding: padding!, child: loadingIndicator)
          : loadingIndicator;
    }

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        loadingIndicator,
        const SizedBox(height: 14),
        Text(
          message!,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );

    return padding != null
        ? Padding(padding: padding!, child: content)
        : content;
  }
}

// ════════════════════════════════════════════════════════════
// Specific Animation Implementations
// ════════════════════════════════════════════════════════════

class _DotsLoading extends StatefulWidget {
  final double size;
  final Color color;
  const _DotsLoading({required this.size, required this.color});

  @override
  State<_DotsLoading> createState() => _DotsLoadingState();
}

class _DotsLoadingState extends State<_DotsLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dotSize = widget.size / 4;
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final delay = index * 0.2;
              var value = _controller.value - delay;
              if (value < 0) value += 1.0;
              final scale = 0.5 + 0.5 * math.sin(value * math.pi * 2);

              return Transform.scale(
                scale: scale.clamp(0.0, 1.0),
                child: child,
              );
            },
            child: Container(
              width: dotSize,
              height: dotSize,
              decoration: BoxDecoration(
                color: widget.color,
                shape: BoxShape.circle,
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _PulseLoading extends StatefulWidget {
  final double size;
  final Color color;
  const _PulseLoading({required this.size, required this.color});

  @override
  State<_PulseLoading> createState() => _PulseLoadingState();
}

class _PulseLoadingState extends State<_PulseLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _opacityAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: child,
          ),
        );
      },
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _BarsLoading extends StatefulWidget {
  final double size;
  final Color color;
  const _BarsLoading({required this.size, required this.color});

  @override
  State<_BarsLoading> createState() => _BarsLoadingState();
}

class _BarsLoadingState extends State<_BarsLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final barWidth = widget.size / 5;
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final delay = index * 0.2;
              var value = _controller.value - delay;
              if (value < 0) value += 1.0;
              final scaleY = 0.4 + 0.6 * math.sin(value * math.pi);

              return Transform.scale(
                scaleY: scaleY.clamp(0.0, 1.0),
                child: child,
              );
            },
            child: Container(
              width: barWidth,
              height: widget.size,
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(barWidth / 2),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
// Legacy APIs - Maintained for backward compatibility
// ════════════════════════════════════════════════════════════

// LoadingWidget — Page loading
/// يُستخدم لتحميل صفحة كاملة أو قسم كبير.
class LoadingWidget extends StatelessWidget {
  final String? message;
  const LoadingWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppLoading(
        type: AppLoadingType.ring,
        message: message,
      ),
    );
  }
}

// InlineLoadingWidget — Loading صغير داخل صف أو بطاقة
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
    return AppLoading(
      type: AppLoadingType.dots,
      size: size,
      color: color ?? AppColors.primary,
    );
  }
}

// AppLoadingButton — زر بداخله loading indicator
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
    // using withValues(alpha: 0.7) for disabled color as per original code if flutter is recent enough,
    // but the previous code had withValues(alpha: 0.7). I will use it.
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
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: isLoading
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const AppLoading(
                      type: AppLoadingType.bars,
                      size: 20,
                      color: Colors.white,
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
