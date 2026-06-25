import 'package:flutter/material.dart';
import 'package:frontend/core/exception/api_exception.dart';
import 'package:frontend/core/widgets/alter/loading_overlay.dart';
import 'package:frontend/core/widgets/alter/snack_bar.dart';
import 'package:frontend/data/api/test_api.dart';
import 'package:frontend/data/model/predictions.dart';
import 'package:frontend/data/model/user.dart';
import 'package:frontend/features/test_emtion/widget/initial_result_screen.dart';
import 'package:image_field/image_field.dart';

class TestEmotionController extends ChangeNotifier {
  final TestApi service = TestApi();
  List<ImageAndCaptionModel> remoteFiles = [];
  Predictions ? predictionResult;

  Future<void> loadImage(List<ImageAndCaptionModel>? list) async {
    if (list != null) {
      remoteFiles = (list as List).cast<ImageAndCaptionModel>();
    }
    notifyListeners();
  }

  Future<void> deleteImage(ImageAndCaptionModel image) async {
    remoteFiles.remove(image);
    notifyListeners();
  }

  Future<void> testEmotion(BuildContext context, PsychUser user) async {
    if (remoteFiles.length < 5) return;

    final overlay = LoadingOverlay()..showLoading(context);
    try {
      final data = {'email': user.email, 'user_id': user.uid};

      // final response = await service.testEmotion(data, remoteFiles);
      // final results = response['results']; 
      // predictionResult = Predictions.fromJson(results);
      final response = await service.testEmotion(data, remoteFiles);

      final Map<String, dynamic> results =
          response['results'] is Map<String, dynamic>
              ? response['results']
              : response;

      predictionResult = Predictions.fromJson(results);
      
      overlay.hideLoading(context);
      notifyListeners();
      await InitialResultScreen.show(context, predictionResult);
    } on ApiException catch (e) {
      PredictSnackBar().showSnackBar(context, e.toString());
    }
  }

}
