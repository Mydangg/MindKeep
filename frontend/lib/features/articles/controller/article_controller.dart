import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/core/exception/api_exception.dart';
import 'package:frontend/core/uitls/format.dart';
import 'package:frontend/core/widgets/alter/loading_overlay.dart';
import 'package:frontend/core/widgets/alter/snack_bar.dart';
import 'package:frontend/data/api/article_api.dart';
import 'package:frontend/data/model/article.dart';
import 'package:frontend/routing/page_routes.dart';
import 'package:go_router/go_router.dart';

class ArticleController extends ChangeNotifier {
  final ArticleApi service = ArticleApi();
  final textSearch = TextEditingController();
  List<Article> listArticle = [];
  List<Article> listRecommender = [];
  List<Article> articlePropose = [];
  List<Article> listArticleSearched = [];
  List<Article> listSavedArticles = [];
  List<Article> listLikedArticles = [];
  bool isLoading = false;
  String _lastSearch = '';

  Future<void> toggleLike(BuildContext context, Article article) async {
    final previous = article.liked;

    article.liked = !previous;
    notifyListeners();
    try {
      final response = await service.toggleLike(article.id);
      article.liked = response['liked'] as bool;
    } on ApiException catch (e) {
      article.liked = previous;
      notifyListeners();
      PredictSnackBar().showSnackBar(context, e.toString());
    }
  }

  Future<void> toggleBookmarked(BuildContext context, Article article) async {
    final previous = article.saved;

    article.saved = !previous;
    notifyListeners();
    try {
      final response = await service.toggleLike(article.id);
      article.saved = response['save'] as bool;
    } on ApiException catch (e) {
      article.saved = previous;
      notifyListeners();
      PredictSnackBar().showSnackBar(context, e.toString());
    }
  }

  Future<void> getByTopicId(
    BuildContext context,
    int topicId,
    String nameTopic,
  ) async {
    final overlay = LoadingOverlay()..showLoading(context);
    try {
      final response = await service.getByTopicId(topicId);
      final resultList = response['result'] as List;

      if (resultList.isEmpty) {
        PredictSnackBar().showSnackBar(
          context,
          'Không có bài báo nào liên quan',
        );
        return;
      }

      listArticle = resultList.map((e) => Article.fromJson(e)).toList();
      notifyListeners();
      await context.push(
        PageRoutes.listArticles,
        extra: {'nameTopic': capitalize(nameTopic), 'articles': listArticle},
      );
    } on ApiException catch (e) {
      PredictSnackBar().showSnackBar(context, e.toString());
    } finally {
      overlay.hideLoading(context);
    }
  }

  Future<void> getTopArticle(BuildContext context) async {
    try {
      final response = await service.topArticle();
      final resultList = response['result'] as List;
      articlePropose = resultList.map((e) => Article.fromJson(e)).toList();
      notifyListeners();
    } on ApiException catch (e) {
      PredictSnackBar().showSnackBar(context, e.toString());
    }
  }

  void clearSearch() {
    listArticleSearched = [];
    _lastSearch = '';
    notifyListeners();
  }

  Future<void> search(BuildContext context, String text) async {
    if (text == _lastSearch) return;
    _lastSearch = text;
    try {
      isLoading = true;
      notifyListeners();
      final response = await service.searchArticle(text);
      final resultList = (response['result'] ?? []) as List;
      listArticleSearched = resultList.map((e) => Article.fromJson(e)).toList();
      notifyListeners();

      if (listArticleSearched.isEmpty) {
        PredictSnackBar().showSnackBar(context, 'Không tìm thấy bài báo nào');
      }
    } on ApiException catch (e) {
      PredictSnackBar().showSnackBar(context, e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getProposeArticle(BuildContext context, int articleId) async {
    try {
      final response = await service.proposeArticle(articleId);
      final resultList = response['result'] as List;
      articlePropose = resultList.map((e) => Article.fromJson(e)).toList();
      notifyListeners();
    } on ApiException catch (e) {
      PredictSnackBar().showSnackBar(context, e.toString());
    }
  }

  Future<void> getSavedAndLikedArticles(BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await service.getArticleLikeByUser();
      final resultList = response['result'] as List;
      listLikedArticles = resultList.map((e) => Article.fromJson(e)).toList();

      final response2 = await service.getArticleSaveByUser();
      final resultList2 = response2['result'] as List;
      listSavedArticles = resultList2.map((e) => Article.fromJson(e)).toList();
      isLoading = false;
      notifyListeners();
    } on ApiException catch (e) {
      PredictSnackBar().showSnackBar(context, e.toString());
    }
  }

  Future<void> getRecommenderArticles(BuildContext context) async {
    try {
      final response = await service.getArticleRecommenderByUser();
      final resultList = response['recommendations'] as List;

      if (resultList.isEmpty) {
        final response = await service.getAll();
        final allList = response['result'] as List;
        final top3List = allList.take(3).toList();
        
        listRecommender = top3List.map((e) => Article.fromJson(e)).toList();
      }else{
        listRecommender = resultList.map((e) => Article.fromJson(e)).toList();
      }
      notifyListeners();
    } on ApiException catch (e) {
      PredictSnackBar().showSnackBar(context, e.toString());
    }
  }
}
