import 'package:flutter/material.dart';
import 'package:frontend/core/constants.dart';
import 'package:frontend/core/themes/app_colors.dart';
import 'package:frontend/data/model/article.dart';
import 'package:frontend/features/articles/controller/article_controller.dart';
import 'package:frontend/features/profile/widget/table/article_grid.dart';
import 'package:frontend/features/profile/widget/table/article_liked.dart';
import 'package:provider/provider.dart';

class SavedArticlesScreen extends StatefulWidget {
  const SavedArticlesScreen({super.key});

  @override
  State<SavedArticlesScreen> createState() => _SavedArticlesScreenState();
}

class _SavedArticlesScreenState extends State<SavedArticlesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<Article> articleObjects;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final _ = Provider.of<ArticleController>(context, listen: false)
        ..getSavedAndLikedArticles(context);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ArticleController>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.greyscale800,
            size: 22,
          ),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'Lịch Sử',
          style: TextStyle(
            color: AppColors.greyscale800,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: primaryColor,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          tabs: const [Tab(text: 'Yêu Thích'), Tab(text: 'Đã Lưu')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ArticleGrid(
            list: controller.listLikedArticles,
            isLoading: controller.isLoading,
          ),
          ArticleGrid(
            list: controller.listSavedArticles,
            isLoading: controller.isLoading,
          ),
        ],
      ),
    );
  }
}
