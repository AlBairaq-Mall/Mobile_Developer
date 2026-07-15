import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

/// زر موحد يدعم Loading State لمنع الضغط المزدوج وإرسال الطلب مرتين.
class AppButton extends StatelessWidget {
  final String    text;
  final VoidCallback? onPressed;
  final bool      isLoading;
  final bool      isOutlined;
  final Color?    color;
  final IconData? icon;
  final double    height;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading  = false,
    this.isOutlined = false,
    this.color,
    this.icon,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    final bg = color ?? AppColors.primary;

    if (isOutlined) {
      return SizedBox(
        width: double.infinity,
        height: height,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: bg, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: _child(bg),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: _child(Colors.white),
      ),
    );
  }

  Widget _child(Color color) {
    if (isLoading) {
      return SizedBox(
        width: 22, height: 22,
        child: CircularProgressIndicator(
          color: color, strokeWidth: 2.5,
        ),
      );
    }
    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        ],
      );
    }
    return Text(text, style: TextStyle(fontWeight: FontWeight.bold, color: color));
  }
}
