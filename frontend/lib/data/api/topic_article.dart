import 'package:frontend/data/api/base_api.dart';
import 'package:frontend/routing/routes.dart';

class TopicArticleApi {
  static final BaseApi _api = BaseApi(() async => authController.getToken());

  Future<Map<String, dynamic>> getTopics() async {
    final response = await _api.call(method: 'GET', url: '/topics/');
    return response;
  }
}
