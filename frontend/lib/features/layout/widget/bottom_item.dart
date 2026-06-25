import 'package:flutter/material.dart';
import 'package:frontend/core/themes/app_colors.dart';

class BottomItem extends StatelessWidget {
  const BottomItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.isSelected,
    super.key,
  });

  final IconData icon;
  final String label;
  final int index;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary800 : AppColors.greyscale600,
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color:
                    isSelected ? AppColors.primary800 : AppColors.greyscale600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
