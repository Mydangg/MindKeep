import 'package:flutter/material.dart';
import 'package:frontend/core/constants.dart';
import 'package:frontend/core/themes/app_colors.dart';
import 'package:frontend/core/widgets/devider.dart';
import 'package:frontend/features/exam_dass21/controller/exam_dass21_controller.dart';
import 'package:provider/provider.dart';

class Dass21TestScreen extends StatefulWidget {
  const Dass21TestScreen({
    required this.predictionId,
    super.key,
    this.finalEmotion,
  });
  final String predictionId;
  final String? finalEmotion;

  @override
  State<Dass21TestScreen> createState() => _Dass21TestScreenState();
}

class _Dass21TestScreenState extends State<Dass21TestScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final _ = Provider.of<TestDass21Controller>(context, listen: false)
        ..getQuesAns(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<TestDass21Controller>(context);

    return Scaffold(
      backgroundColor: AppColors.greyscale0,
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: 12),
          child: Text('Bài kiểm tra DASS 21'),
        ),
        titleTextStyle: const TextStyle(
          color: primaryColor,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        centerTitle: true,
        backgroundColor: AppColors.greyscale0,
        toolbarHeight: 60,
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.questions.length,
        itemBuilder: (context, index) {
          final question = controller.questions[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 3,
            color: AppColors.greyscale0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Câu ${index + 1}: ${question.content}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.primary800,
                    ),
                  ),
                  const PsychDevider(),
                  ...controller.answers.map((answer) {
                    return RadioListTile<int>(
                      title: Text(
                        answer.text,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      value: answer.score,
                      groupValue: controller.selectedAnswers[question.order],
                      onChanged: (value) {
                        controller.addAnswer(question.order, value ?? 0);
                      },

                      activeColor: const Color(0xFF3B5B84),
                      contentPadding: EdgeInsets.zero,
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            controller.sendDass21ResultToServer(context, widget.predictionId, widget.finalEmotion ?? '');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3B5B84),
            foregroundColor: AppColors.greyscale0,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Hoàn Thành',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
