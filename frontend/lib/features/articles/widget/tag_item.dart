import 'package:flutter/widgets.dart';
import 'package:frontend/core/themes/app_colors.dart';

class TagItem extends StatelessWidget {
  const TagItem({required this.tag, super.key});

  final String tag;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.greyscale200),
      ),
      child: Text(
        tag,
        style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
      ),
    );
  }
}
