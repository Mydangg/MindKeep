import 'package:flutter/material.dart';
import 'package:frontend/core/themes/app_colors.dart';
import 'package:frontend/core/uitls/format.dart';
import 'package:frontend/core/widgets/devider.dart';
import 'package:frontend/data/model/dass21_result.dart';
import 'package:frontend/data/model/predictions.dart';
import 'package:frontend/features/detail_prediction/utils/advice_overall.dart';
import 'package:frontend/features/detail_prediction/widget/detail_row.dart';
import 'package:frontend/features/detail_prediction/widget/score_row.dart';
import 'package:frontend/features/detail_prediction/widget/section_title.dart';
import 'package:frontend/features/home/helper/emoji_helper.dart';
import 'package:frontend/routing/page_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailPredictionScreen extends StatelessWidget {
  const DetailPredictionScreen({
    required this.prediction,
    required this.resultTest,
    required this.count,
    super.key,
  });

  final Predictions prediction;
  final Dass21Result resultTest;
  final int count;

  @override
  Widget build(BuildContext context) {
    final backendResult = resultTest.resultTest;

    final conclusionText =
        backendResult?['conclusion']?.toString() ??
        classifyDass21(resultTest, prediction.finalEmotion);

    // final positiveFeedback =
    //     backendResult?['positive_feedback']?.toString() ?? '';

    final List<dynamic> actionPlan = backendResult?['action_plan'] ?? [];

    final recommendationText =
        backendResult?['recommendation']?.toString() ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Kết quả Lần $count'),
        titleTextStyle: const TextStyle(
          color: AppColors.backgroundDart,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        toolbarHeight: 60,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          iconSize: 20,
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: () => context.go(PageRoutes.homePage),
              icon: const Icon(
                Icons.home,
                color: AppColors.greyscale700,
                size: 28,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: getEmojiColor(prediction.finalEmotion),
                    child: Text(
                      getEmoji(prediction.finalEmotion),
                      style: const TextStyle(fontSize: 40),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Cảm xúc dự đoán: ${prediction.finalEmotion}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    formatDateTypeTwo(prediction.createdAt),
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.greyscale400,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const SectionTitle(title: 'Phân tích hình ảnh:'),
            const SizedBox(height: 15),

            DetailRow(
              label: 'Tổng số ảnh:',
              value: '${prediction.emotions.length} Hình ảnh',
            ),
            DetailRow(
              label: 'Tổng số cảm xúc:',
              value: countEmotions(prediction.emotions),
            ),

            const PsychDevider(),

            const SectionTitle(title: 'Số điểm qua bài kiểm tra Dass-21:'),
            const SizedBox(height: 15),

            Table(
              columnWidths: const {
                0: FlexColumnWidth(1.05),
                1: FixedColumnWidth(10),
                2: FlexColumnWidth(1.05),
              },
              children: [
                buildScoreRow('Trầm cảm:', resultTest.depressionScore),
                buildScoreRow('Lo lắng:', resultTest.anxietyScore),
                buildScoreRow('Căng thẳng:', resultTest.stressScore),
              ],
            ),

            const PsychDevider(),

            const SectionTitle(title: 'Gợi ý chăm sóc bản thân:'),
            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                conclusionText,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                  color: Color.fromARGB(255, 174, 50, 8),
                ),
              ),
            ),

            // if (positiveFeedback.isNotEmpty) ...[
            //   const SizedBox(height: 16),
            //   Container(
            //     width: double.infinity,
            //     padding: const EdgeInsets.all(16),
            //     decoration: BoxDecoration(
            //       color: Colors.green.shade50,
            //       borderRadius: BorderRadius.circular(16),
            //     ),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         const Text(
            //           '💪 Điểm tích cực',
            //           style: TextStyle(
            //             fontSize: 18,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //         const SizedBox(height: 10),
            //         Text(
            //           positiveFeedback,
            //           style: const TextStyle(
            //             fontSize: 15.5,
            //             height: 1.5,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ],

            if (actionPlan.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🎯 Gợi ý dành cho bạn',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...actionPlan.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• '),
                            Expanded(
                              child: Text(
                                item.toString(),
                                style: const TextStyle(
                                  fontSize: 15,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            if (recommendationText.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF7FA),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  recommendationText,
                  style: const TextStyle(
                    fontSize: 15.5,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.backgroundDart,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}