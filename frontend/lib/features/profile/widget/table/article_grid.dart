// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/widgets.dart';
import 'package:frontend/data/model/article.dart';
import 'package:frontend/features/articles/widget/article_card.dart';
import 'package:frontend/features/articles/widget/skeleton.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ArticleGrid extends StatelessWidget {
  const ArticleGrid({
    required this.list,
    super.key,
    this.shrinkWrap = false,
    this.isLoading = false,
  });
  final List<Article> list;
  final bool shrinkWrap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return GridView.builder(
        padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.75,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Shimmer(
            duration: const Duration(seconds: 2),
            child: const Skeleton(),
          );
        },
      );
    }

    if (list.isEmpty) {
      return const Center(child: Text('Không có dữ liệu'));
    }
    
    return GridView.builder(
      padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.45,
      ),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return ArticleCard(article: list[index]);
      },
    );
  }
}
