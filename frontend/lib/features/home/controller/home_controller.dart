import 'package:flutter/material.dart';
import 'package:frontend/core/exception/api_exception.dart';
import 'package:frontend/core/widgets/alter/loading_overlay.dart';
import 'package:frontend/core/widgets/alter/snack_bar.dart';
import 'package:frontend/data/api/home_api.dart';
import 'package:frontend/data/model/dass21_result.dart';
import 'package:frontend/data/model/predictions.dart';

class HomeController extends ChangeNotifier {
  final HomeApi service = HomeApi();
  Dass21Result resultTest = Dass21Result.empty();
  List<Predictions> listAll = [];
  bool get hasTestResults => listAll.isNotEmpty;
  bool isLoading = false;

  Future<void> getPredictions(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await service.getPredictionByToken();
      final resultList = response['result'] as List;

      listAll = resultList.map((e) => Predictions.fromJson(e)).toList();
      notifyListeners();
    } on ApiException catch (e) {
      PredictSnackBar().showSnackBar(context, e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getResultPrediction(
    BuildContext context,
    String idPrediction,
  ) async {
    final overlay = LoadingOverlay()..showLoading(context);
    try {
      final response = await service.getResultPrediction(idPrediction);
      final result = response['test'];

      resultTest = Dass21Result.fromJson(result);
      notifyListeners();
    } on ApiException catch (e) {
      PredictSnackBar().showSnackBar(context, e.toString());
    } finally {
      overlay.hideLoading(context);
    }
  }
}
