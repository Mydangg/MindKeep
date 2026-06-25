import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.text,
    required this.onPressed,
    required this.backgroundColor,
    required this.textColor,
    super.key,
    this.icon,
    this.imageIconPath,
    this.border,
  });
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;
  final String? imageIconPath;
  final double? border;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        side: BorderSide(
          color:
              border != null
                  ? const Color.fromARGB(255, 59, 160, 197)
                  : Colors.white.withValues(alpha: 0.5),
          width: 1.01,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(border ?? 30),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, color: textColor),
            const SizedBox(width: 10),
          ] else if (imageIconPath != null) ...[
            Image.asset(imageIconPath!, width: 24, height: 24),
            const SizedBox(width: 10),
          ],
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
