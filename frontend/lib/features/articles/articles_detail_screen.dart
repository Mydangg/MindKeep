import 'package:flutter/material.dart';
import 'package:frontend/core/themes/app_colors.dart';
import 'package:frontend/core/uitls/format.dart';
import 'package:frontend/data/model/article.dart';
import 'package:frontend/features/articles/controller/article_controller.dart';
import 'package:frontend/features/articles/widget/card_articles_sugesstion.dart';
import 'package:frontend/features/articles/widget/skeleton.dart';
import 'package:frontend/features/articles/widget/tag_item.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ArticlesDetailScreen extends StatefulWidget {
  const ArticlesDetailScreen({required this.article, super.key});
  final Article article;

  @override
  State<ArticlesDetailScreen> createState() => _ArticlesDetailScreenState();
}

class _ArticlesDetailScreenState extends State<ArticlesDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ArticleController>(context);
    final article = widget.article;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết bài báo'),
        centerTitle: true,
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(
          color: AppColors.greyscale600,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.greyscale600),
          onPressed: () => context.pop(),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Text(
              '${article.author}  •  ${article.source}  '
              '•  ${formatDateTypeTwo(article.publishedAt)}',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  article.imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 180,
                      width: double.infinity,
                      color: Colors.grey.shade300,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 45,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                GestureDetector(
                  onTap: () => controller.toggleLike(context, article),
                  child: Icon(
                    article.liked ? Icons.favorite : Icons.favorite_border,
                    color: article.liked ? Colors.red : Colors.black,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Thích',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: article.liked ? Colors.red : AppColors.greyscale700,
                  ),
                ),

                const SizedBox(width: 20),

                GestureDetector(
                  onTap: () => controller.toggleBookmarked(context, article),
                  child: Icon(
                    article.saved ? Icons.bookmark : Icons.bookmark_border,
                    color: article.saved ? Colors.amber : Colors.black,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Đánh dấu',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color:
                        article.saved ? Colors.amber : AppColors.greyscale700,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    article.tags.map((tag) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: TagItem(tag: capitalize(tag)),
                      );
                    }).toList(),
              ),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                article.description,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.greyscale500,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                article.content,
                style: const TextStyle(fontSize: 17, height: 1.5),
              ),
            ),
            const SizedBox(height: 15),

            const Text(
              'Đề xuất',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            SizedBox(
              height: 140,
              child: VisibilityDetector(
                key: Key('propose-articles-${article.id}'),
                onVisibilityChanged: (info) {
                  if (info.visibleFraction > 0 && mounted) {
                    controller.getProposeArticle(context, article.id);
                  }
                },
                child:
                    controller.articlePropose.isNotEmpty
                        ? ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            ...List.generate(controller.articlePropose.length, (
                              index,
                            ) {
                              final a = controller.articlePropose[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: CardArticlesSugesstion(article: a),
                              );
                            }),
                          ],
                        )
                        : Shimmer(
                          duration: const Duration(seconds: 4),
                          interval: const Duration(seconds: 5),
                          colorOpacity: 1,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              for (var i = 0; i < 4; i++) const Skeleton(),
                            ],
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
