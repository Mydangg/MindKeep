import 'package:flutter/material.dart';
import 'package:frontend/core/uitls/format.dart';
import 'package:frontend/features/articles/controller/article_controller.dart';
import 'package:frontend/features/topic_article/controller/topic_article_controller.dart';
import 'package:frontend/features/topic_article/widget/topic_card.dart';
import 'package:provider/provider.dart';

class TopicSection extends StatelessWidget {
  const TopicSection({super.key});

  @override
  Widget build(BuildContext context) {
    final topicController = Provider.of<TopicArticleController>(context);
    final articleController = Provider.of<ArticleController>(context);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.01,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemCount:
          topicController.listTopic.isNotEmpty
              ? topicController.listTopic.length
              : 0,
      itemBuilder: (context, index) {
        final item = topicController.listTopic[index];
        return TopicCard(
          title: capitalize(item.name),
          postCount: '7 bài viết',
          imageUrl: item.imageUrl,
          onTap: () {
            articleController.getByTopicId(context, item.id, item.name);
          },
        );
      },
    );
  }
}
