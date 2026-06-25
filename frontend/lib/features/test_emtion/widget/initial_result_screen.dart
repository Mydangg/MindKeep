import 'package:flutter/material.dart';
import 'package:frontend/core/themes/app_colors.dart';
import 'package:frontend/data/model/predictions.dart';
import 'package:frontend/features/test_emtion/widget/result_prediction.dart';
import 'package:frontend/routing/page_routes.dart';
import 'package:go_router/go_router.dart';

class InitialResultScreen extends StatelessWidget {
  const InitialResultScreen({super.key, this.predictionResult});

  final Predictions? predictionResult;

  static Future<void> show(
    BuildContext context,
    Predictions? predictionResult,
  ) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return InitialResultScreen(predictionResult: predictionResult);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      backgroundColor: Colors.white,
      title: const Center(
        child: Text(
          'Dự đoán ban đầu',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
      ),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            resultPrediction(predictionResult?.finalEmotion ?? 'Chưa xác định'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              color: AppColors.greyscale500,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Chọn tiếp tục để kiểm tra thêm',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.backgroundDart,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),

      actionsPadding: const EdgeInsets.only(left: 70, right: 70, bottom: 24),
      actions: <Widget>[
        ElevatedButton(
          onPressed:
              () => context.go(
                PageRoutes.examDass21,
                extra: {
                  'id': predictionResult?.id ?? '',
                  'final_emotion':
                      predictionResult?.finalEmotion ?? 'Chưa xác định',
                },
              ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3B5B84),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Tiếp tục',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
