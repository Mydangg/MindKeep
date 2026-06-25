import 'package:frontend/data/api/base_api.dart';
import 'package:frontend/routing/routes.dart';

class HomeApi {
  static final BaseApi _api = BaseApi(() async => authController.getToken());

  Future<Map<String, dynamic>> getPredictionByToken() async {
    final response = await _api.call(method: 'GET', url: '/predict/');
    return response;
  }

  Future<Map<String, dynamic>> getResultPrediction(String idPrediction) async {
    final response = await _api.call(method: 'GET', url: '/test/$idPrediction');
    return response;
  }
}
