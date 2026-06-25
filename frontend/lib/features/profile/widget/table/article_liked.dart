import 'package:flutter/widgets.dart';
import 'package:frontend/data/model/article.dart';
import 'package:frontend/features/profile/widget/table/article_grid.dart';

class ArticleLiked extends StatelessWidget {
  const ArticleLiked({
    required this.recentLiked,
    required this.isLoading,
    super.key,
  });

  final List<Article> recentLiked;
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ArticleGrid(
            list: recentLiked,
            shrinkWrap: true,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }
}
