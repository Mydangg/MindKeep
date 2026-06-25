import 'package:flutter/material.dart';
import 'package:frontend/core/themes/app_colors.dart';

Color getEmojiColor(String emoji) {
  switch (emoji) {
    case 'Vui vẻ':
      return AppColors.sucess200;
    case 'Buồn':
      return AppColors.greyscale500;
    case 'Lo lắng':
      return const Color(0xFF85CACA);
    case 'Bình thường':
      return Colors.orange.shade400;
    case 'Tức giận':
      return Colors.red.shade400;
    default:
      return Colors.blue.shade400.withValues(alpha: 0.8);
  }
}

String getEmoji(String emoji) {
  switch (emoji) {
    case 'Vui vẻ':
      return '😀';
    case 'Buồn':
      return '🥹';
    case 'Lo lắng':
      return '😱';
    case 'Bình thường':
      return '😑';
    case 'Tức giận':
      return '😡';
    default:
      return '😮';
  }
}

String countEmotions(List<dynamic> emotions) {
  final counts = <String, int>{};

  for (final dynamic item in emotions) {
    final mapItem = item as Map<String, dynamic>; 

    final emotion = mapItem['emotion'] as String; 
    counts[emotion] = (counts[emotion] ?? 0) + 1;
  }

  final text = counts.entries.map((e) => ' ${e.value} ${e.key}').join('\n');

  return text;
}
