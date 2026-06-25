import 'package:flutter/material.dart';
import 'package:frontend/features/articles/widget/skeleton.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class VerticalSkeletonCard extends StatelessWidget {
  const VerticalSkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: const Duration(seconds: 4),
      interval: const Duration(seconds: 5),
      colorOpacity: 1,
      child: Row(children: [for (var i = 0; i < 4; i++) const Skeleton()]),
    );
  }
}
