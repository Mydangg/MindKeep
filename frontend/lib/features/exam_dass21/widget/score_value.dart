import 'package:flutter/widgets.dart';
import 'package:frontend/core/themes/app_colors.dart';

class ScoreValue extends StatelessWidget {
  const ScoreValue({required this.score, super.key});

  final int score;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        '$score',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.primary800,
        ),
      ),
    );
  }
}
