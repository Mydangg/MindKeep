import 'package:flutter/material.dart';
import 'package:frontend/core/exception/api_exception.dart';
import 'package:frontend/core/widgets/alter/loading_overlay.dart';
import 'package:frontend/core/widgets/alter/snack_bar.dart';
import 'package:frontend/data/api/test_api.dart';
import 'package:frontend/data/model/dass21_answer.dart';
import 'package:frontend/data/model/dass21_question.dart';
import 'package:frontend/routing/page_routes.dart';
import 'package:go_router/go_router.dart';

class TestDass21Controller extends ChangeNotifier {
  final TestApi service = TestApi();
  List<Dass21Question> questions = [];
  List<Dass21Answer> answers = [];
  List<Map<String, dynamic>> answerDass21 = [];
  Map<int, int?> selectedAnswers = {};
  bool isLoading = false;

  Future<void> getQuesAns(BuildContext context) async {
    final overlay = LoadingOverlay()..showLoading(context);
    try {
      final response = await service.getQuesAns();
      final listQuestion = response['questions'] as List;
      final listAnswer = response['answers'] as List;

      questions = listQuestion.map((e) => Dass21Question.fromJson(e)).toList();
      answers = listAnswer.map((e) => Dass21Answer.fromJson(e)).toList();
      notifyListeners();
    } on ApiException catch (e) {
      PredictSnackBar().showSnackBar(context, e.toString());
    } finally {
      overlay.hideLoading(context);
    }
  }

  Future<void> addAnswer(int questionId, int answerScore) async {
    final index = answerDass21.indexWhere(
      (item) => item['question_id'] == questionId,
    );

    selectedAnswers[questionId] = answerScore;

    if (index != -1) {
      answerDass21[index]['answer_value'] = answerScore;
    } else {
      answerDass21.add({
        'question_id': questionId,
        'answer_value': answerScore,
      });
    }
    notifyListeners();
  }

  Future<void> sendDass21ResultToServer(
    BuildContext context,
    String predictionId,
    String finalEmotion,
  ) async {
    if (answerDass21.length < 21) {
      PredictSnackBar().showSnackBar(
        context,
        'Vui lòn chọn làm hết bài kiểm tra',
      );
    } else {
      try {
        final data = {'prediction_id': predictionId, 'answers': answerDass21};
        final response = await service.submitTestDass21(data);

        context.go(
          PageRoutes.finalResult,
          extra: {'response': response, 'final_emotion': finalEmotion},
        );
      } on ApiException catch (e) {
        PredictSnackBar().showSnackBar(context, e.toString());
      }
    }
  }
}
