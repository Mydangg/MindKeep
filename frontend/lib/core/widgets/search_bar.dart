import 'package:flutter/material.dart';
import 'package:frontend/core/themes/app_colors.dart';
import 'package:frontend/core/widgets/textfield.dart';

class ArticlesSearchBar extends StatelessWidget {
  const ArticlesSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const PredictTextField(
      hint: 'Tìm kiếm...',
      prefixIcon: Icons.search,
      border: 8,
      color: AppColors.greyscale500,
      size: 8,
    );
  }
}
