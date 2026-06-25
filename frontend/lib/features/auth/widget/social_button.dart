import 'package:flutter/material.dart';

class SocialButton extends StatefulWidget {
  const SocialButton({required this.imagePath, super.key, this.onTap});
  final String imagePath;
  final VoidCallback? onTap;

  @override
  State<SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<SocialButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.5),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Image.asset(widget.imagePath, width: 30, height: 30),
      ),
    );
  }
}
