import 'package:flutter/material.dart';
import 'package:frontend/core/themes/app_colors.dart';

TableRow buildScoreRow(String label, double score) {
  return TableRow(
    children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
      ),
      const SizedBox(),
      Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          '$score',
          style: const TextStyle(
            fontSize: 18,
            color: AppColors.greyscale400,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    ],
  );
}
