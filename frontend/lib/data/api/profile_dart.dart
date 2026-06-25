import 'package:frontend/data/api/base_api.dart';
import 'package:frontend/routing/routes.dart';

class ProfileApi {
  static final BaseApi _api = BaseApi(() async => authController.getToken());

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    final id = data['uid'];
    final response = await _api.call(
      method: 'POST',
      url: '/profile/$id/update_profile',
      data: data,
    );
    return response;
  }

  Future<Map<String, dynamic>> deleteProfile(String id) async {
    final response = await _api.call(
      method: 'POST',
      url: '/profile/$id/delete_profile',
    );
    return response;
  }

  Future<Map<String, dynamic>> sendFeedback(Map<String, dynamic> data) async {
    final response = await _api.call(
      method: 'POST',
      url: '/profile/send_feedback',
      data: data,
    );
    return response;
  }
}
