import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/core/themes/app_colors.dart';
import 'package:frontend/core/widgets/textfield.dart';
import 'package:frontend/data/model/article.dart';
import 'package:frontend/features/articles/controller/article_controller.dart';
import 'package:frontend/features/articles/widget/article_card.dart';
import 'package:frontend/routing/page_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class TopicScreen extends StatefulWidget {
  const TopicScreen({
    required this.topic,
    required this.listArticles,
    super.key,
  });
  final String topic;
  final List<Article> listArticles;

  @override
  State<TopicScreen> createState() => _TopicScreenState();
}

class _TopicScreenState extends State<TopicScreen> {
  final search = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

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
    final controllerArticle = Provider.of<ArticleController>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic),
        titleTextStyle: const TextStyle(
          color: AppColors.greyscale600,
          fontSize: 23,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
        backgroundColor: AppColors.greyscale0,
        toolbarHeight: 60,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          iconSize: 26,
          color: AppColors.greyscale600,
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: () => context.push(PageRoutes.homePage),
              icon: const Icon(
                Icons.home_outlined,
                color: AppColors.greyscale600,
                size: 28,
              ),
            ),
          ),
        ],
      ),

      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            PredictTextField(
              hint: 'Tìm kiếm...',
              prefixIcon: Icons.search,
              border: 8,
              color: AppColors.greyscale500,
              controller: search,
              size: 8,
            ),
            const SizedBox(height: 16),

            if (controllerArticle.isLoading)
              const CircularProgressIndicator()
            else
              controllerArticle.listArticleSearched.isNotEmpty
                  ? ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controllerArticle.listArticleSearched.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 20),
                    itemBuilder: (context, index) {
                      final article =
                          controllerArticle.listArticleSearched[index];
                      return ArticleCard(article: article);
                    },
                  )
                  : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.listArticles.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 20),
                    itemBuilder: (context, index) {
                      final article = widget.listArticles[index];
                      return ArticleCard(article: article);
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
