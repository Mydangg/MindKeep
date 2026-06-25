import 'package:flutter/material.dart';
import 'package:frontend/core/themes/app_colors.dart';

class PredictTextField extends StatelessWidget {
  const PredictTextField({
    required this.hint,
    this.prefixIcon,
    this.focusNode,
    super.key,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.controller,
    this.color = AppColors.greyscale0,
    this.border = 30,
    this.size,
    this.fillColor = Colors.transparent,
  });
  final String hint;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Color? color;
  final double border;
  final double? size;
  final Color? fillColor;

  InputDecoration _buildDecoration() {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: color,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      prefixIcon:
          prefixIcon == null ? null : Icon(prefixIcon, color: color, size: 22),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: fillColor,
      contentPadding: EdgeInsets.symmetric(
        vertical: size ?? 18,
        horizontal: size ?? 25,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(border),
        borderSide: BorderSide(
          color:
              fillColor != null && fillColor != Colors.transparent
                  ? Colors.transparent
                  : (color ?? AppColors.greyscale0),
          width: 1.5,
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(border),
        borderSide: BorderSide(
          color:
              fillColor != null && fillColor != Colors.transparent
                  ? Colors.transparent
                  : (color ?? AppColors.greyscale0),
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(border),
        borderSide: BorderSide(
          color:
              fillColor != null && fillColor != Colors.transparent
                  ? Colors.transparent
                  : (color ?? const Color.fromARGB(255, 176, 217, 230)),
          width: 1.01,
        ),
      ),

      errorStyle: const TextStyle(
        color: AppColors.error200,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      focusNode: focusNode,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: _buildDecoration(),
    );
  }
}
