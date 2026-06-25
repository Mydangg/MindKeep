import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/core/themes/app_colors.dart';
import 'package:frontend/core/widgets/textfield.dart';
import 'package:frontend/features/articles/controller/article_controller.dart';
import 'package:frontend/features/articles/widget/article_card.dart';
import 'package:frontend/features/articles/widget/highlight/highlight_card.dart';
import 'package:frontend/features/articles/widget/highlight/small_highlight_card.dart';
import 'package:frontend/features/articles/widget/skeleton.dart';
import 'package:frontend/features/topic_article/controller/topic_article_controller.dart';
import 'package:frontend/features/topic_article/widget/topic_section.dart';
import 'package:frontend/routing/page_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ArticlesScreen extends StatefulWidget {
  const ArticlesScreen({super.key});

  @override
  State<ArticlesScreen> createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  final search = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ArticleController>().getTopArticle(context);
      context.read<TopicArticleController>().getTopics(context);
      context.read<ArticleController>().getRecommenderArticles(context);
    });

    search.addListener(() {
      final text = search.text.trim();
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        if (text.isEmpty) {
          context.read<ArticleController>().clearSearch();
        }
        context.read<ArticleController>().search(context, search.text);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final articleController = Provider.of<ArticleController>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Tin Tức Sức Khỏe'),
        titleTextStyle: const TextStyle(
          color: AppColors.greyscale800,
          fontSize: 23,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
        toolbarHeight: 60,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          iconSize: 26,
          color: AppColors.greyscale800,
          onPressed: () => context.go(PageRoutes.homePage),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: () => context.go(PageRoutes.homePage),
              icon: const Icon(
                Icons.home_outlined,
                color: AppColors.greyscale800,
                size: 28,
              ),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PredictTextField(
              hint: 'Tìm kiếm...',
              prefixIcon: Icons.search,
              border: 8,
              color: AppColors.greyscale500,
              controller: search,
              size: 8,
            ),
            const SizedBox(height: 15),

            if (articleController.isLoading)
              const Center(child: CircularProgressIndicator())
            else
              articleController.listArticleSearched.isEmpty
                  ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Nổi bật',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Đề xuất',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (articleController.articlePropose.isNotEmpty)
                            ...articleController.articlePropose.map((e) {
                              return Expanded(
                                flex: 2,
                                child: HighlightCard(
                                  title: e.title,
                                  imageUrl: e.imageUrl,
                                  onTap:
                                      () => context.push(
                                        PageRoutes.detailArticle,
                                        extra: e,
                                      ),
                                ),
                              );
                            })
                          else
                            Shimmer(
                              duration: const Duration(seconds: 4),
                              interval: const Duration(seconds: 5),
                              colorOpacity: 1,
                              child: const SizedBox(
                                height: 100,
                                child: Skeleton(),
                              ),
                            ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                if (articleController
                                    .listRecommender
                                    .isNotEmpty)
                                  ...articleController.listRecommender.map((e) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 16,
                                      ),
                                      child: SmallHighlightCard(
                                        title: e.title,
                                        tag:
                                            e.tags.isNotEmpty
                                                ? e.tags[0]
                                                : 'Khác',
                                        imageUrl: e.imageUrl,
                                        onTap:
                                            () => context.push(
                                              PageRoutes.detailArticle,
                                              extra: e,
                                            ),
                                      ),
                                    );
                                  })
                                else
                                  Shimmer(
                                    duration: const Duration(seconds: 4),
                                    interval: const Duration(seconds: 5),
                                    colorOpacity: 1,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: 3,
                                      itemBuilder: (context, index) {
                                        return const Padding(
                                          padding: EdgeInsets.only(bottom: 16),
                                          child: SizedBox(
                                            height: 80,
                                            child: Skeleton(),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        'Theo chủ đề',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 10),

                      const TopicSection(),
                    ],
                  )
                  : Column(
                    children: [
                      ...articleController.articlePropose.map((e) {
                        return ArticleCard(article: e);
                      }),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
