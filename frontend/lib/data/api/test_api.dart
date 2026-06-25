import 'package:frontend/data/api/base_api.dart';
import 'package:frontend/routing/routes.dart';
import 'package:image_field/image_field.dart';

class TestApi {
  static final BaseApi _api = BaseApi(() async => authController.getToken());

  Future<Map<String, dynamic>> testEmotion(
    Map<String, dynamic> data,
    List<ImageAndCaptionModel> remoteFiles,
  ) async {
    final response = await _api.call(
      method: 'POST',
      url: '/predict/upload_faces',
      data: data,
      files: remoteFiles,
      isMultipart: true,
    );

    return response;
  }

  Future<Map<String, dynamic>> getQuesAns() async {
    final response = await _api.call(method: 'GET', url: '/test/');

    return response;
  }

  Future<Map<String, dynamic>> submitTestDass21(
    Map<String, dynamic> data,
  ) async {
    final response = await _api.call(method: 'POST', url: '/test/', data: data);

    return response;
  }
}
