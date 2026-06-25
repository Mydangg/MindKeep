import 'package:flutter/material.dart';
import 'package:frontend/data/model/article.dart';
import 'package:frontend/routing/page_routes.dart';
import 'package:go_router/go_router.dart';

class CardArticlesSugesstion extends StatelessWidget {
  const CardArticlesSugesstion({required this.article, super.key});

  final Article article;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(PageRoutes.detailArticle, extra: article),
      child: SizedBox(
        width: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                article.imageUrl,
                height: 80,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              article.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
