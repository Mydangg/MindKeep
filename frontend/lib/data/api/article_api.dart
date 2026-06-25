import 'package:frontend/data/api/base_api.dart';
import 'package:frontend/routing/routes.dart';

class ArticleApi {
  static final BaseApi _api = BaseApi(() async => authController.getToken());

  Future<Map<String, dynamic>> getAll() async {
    final response = await _api.call(method: 'GET', url: '/articles/');
    return response;
  }

  Future<Map<String, dynamic>> createArticle(Map<String, dynamic> data) async {
    final response = await _api.call(
      method: 'POST',
      url: '/articles/',
      data: data,
    );
    return response;
  }

  Future<Map<String, dynamic>> getByTopicId(int topicId) async {
    final response = await _api.call(method: 'GET', url: '/articles/$topicId/list_by_topic');
    return response;
  }

  Future<Map<String, dynamic>> toggleLike(int articleId)async {
    final response = await _api.call(method: 'POST', url: '/articles/$articleId/toggle_like');
    return response;
  }

  Future<Map<String, dynamic>> topArticle()async {
    final response = await _api.call(method: 'GET', url: '/articles/top_article_like');
    return response;
  }

  Future<Map<String, dynamic>> searchArticle(String text)async {
    final response = await _api.call(method: 'GET', url: '/articles/search?q=$text');
    return response;
  }

  Future<Map<String, dynamic>> proposeArticle(int articleId)async {
    final response = await _api.call(method: 'GET', url: '/articles/$articleId/get_recommended_articles');
    return response;
  }

  Future<Map<String, dynamic>> getArticleLikeByUser()async {
    final response = await _api.call(method: 'GET', url: '/articles/get_articles_like_by_user');
    return response;
  }

  Future<Map<String, dynamic>> getArticleSaveByUser()async {
    final response = await _api.call(method: 'GET', url: '/articles/get_articles_save_by_user');
    return response;
  }

  Future<Map<String, dynamic>> getArticleRecommenderByUser()async {
    final response = await _api.call(method: 'GET', url: '/recommender/recommend');
    return response;
  }
}
