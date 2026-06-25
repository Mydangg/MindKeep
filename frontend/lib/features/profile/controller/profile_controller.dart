import 'package:flutter/material.dart';
import 'package:frontend/core/exception/api_exception.dart';
import 'package:frontend/core/uitls/format.dart';
import 'package:frontend/core/widgets/alter/loading_overlay.dart';
import 'package:frontend/core/widgets/alter/snack_bar.dart';
import 'package:frontend/data/api/profile_dart.dart';
import 'package:frontend/data/model/user.dart';
import 'package:frontend/features/auth/controller/auth_controller.dart';
import 'package:frontend/features/profile/widget/dialog_profile.dart';
import 'package:provider/provider.dart';

class ProfileController extends ChangeNotifier {
  final ProfileApi service = ProfileApi();
  final formKey = GlobalKey<FormState>();
  final TextEditingController feedbackController = TextEditingController();
  bool isSending = false;

  Future<void> sendFeedbackEmail(BuildContext context) async {
    if (!validateForm(formKey)) return;
    try {
      isSending = true;
      notifyListeners();

      final data = {'content': feedbackController.text};
      await service.sendFeedback(data);
      PredictDialog().showSucess(context);
    } on ApiException catch (e) {
      PredictSnackBar().showSnackBar(context, e.toString());
    }finally{
      isSending = false;
      feedbackController.clear();
      notifyListeners();
    }
  }

  Future<void> updateProfile(
    BuildContext context,
    String name,
    String email,
    String uid,
    GlobalKey<FormState> formKey, {
    String? emergencyName,
    String? emergencyPhone,
  }) async {
    if (!formKey.currentState!.validate()) return;

    final authController = context.read<AuthController>();
    final overlay = LoadingOverlay()..showLoading(context);

    try {
      final data = {
        'uid': uid,
        'display_name': name.trim(),
        'email': email.trim(),
        'emergency_name': emergencyName?.trim() ?? '',
        'emergency_phone': emergencyPhone?.trim() ?? '',
      };

      final response = await service.updateProfile(data);
      final user = PsychUser.fromJson(response['user']);

      authController.setUser(user);
      PredictSnackBar().showSnackBar(context, response['message']);
    } on ApiException catch (e) {
      PredictSnackBar().showSnackBar(context, e.toString());
    } finally {
      overlay.hideLoading(context);
    }
  }

  Future<void> deleteAccount(BuildContext context, String id) async {
    final authController = context.read<AuthController>();
    final overlay = LoadingOverlay()..showLoading(context);
    try {
      final response = await service.deleteProfile(id);
      PredictSnackBar().showSnackBar(context, response['message']);
      await authController.signOut(context);
    } on ApiException catch (e) {
      PredictSnackBar().showSnackBar(context, e.toString());
    } finally {
      overlay.hideLoading(context);
    }
  }
}
