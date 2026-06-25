
import 'package:flutter/material.dart';
import 'package:frontend/core/themes/app_colors.dart';

class PsychDevider extends StatelessWidget {
  const PsychDevider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 2,
      decoration: BoxDecoration(
        color: AppColors.greyscale400, 
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
