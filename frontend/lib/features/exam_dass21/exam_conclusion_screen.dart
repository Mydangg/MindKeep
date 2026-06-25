import 'package:flutter/material.dart';
import 'package:frontend/core/constants.dart';
import 'package:frontend/features/exam_dass21/widget/info_doctor.dart';
import 'package:frontend/features/exam_dass21/widget/score_label.dart';
import 'package:frontend/features/exam_dass21/widget/score_value.dart';
import 'package:frontend/routing/page_routes.dart';
import 'package:go_router/go_router.dart';

class ExamConclusionScreen extends StatelessWidget {
  const ExamConclusionScreen({
    required this.result,
    required this.finalEmotion,
    super.key,
  });

  final Map<String, dynamic> result;
  final String finalEmotion;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> score =
        result['score'] as Map<String, dynamic>;

    final Map<String, dynamic> conclusion =
        result['result_test'] as Map<String, dynamic>;

    final String ruleName =
        conclusion['rule_name']?.toString() ?? 'Kết quả đánh giá';

    final String conclusionText =
        conclusion['conclusion']?.toString() ?? 'Chưa có kết luận';

    final String reasonText =
        conclusion['reason']?.toString() ?? '';

    final String recommendationText =
        conclusion['recommendation']?.toString() ?? '';

    final String positiveFeedback =
        conclusion['positive_feedback']?.toString() ?? '';

    final List<dynamic> actionPlan =
        conclusion['action_plan'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kết quả Bài test Dass-21'),
        titleTextStyle: const TextStyle(
          color: primaryColor,
          fontSize: 23,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        toolbarHeight: 60,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Image.asset(
                    'assets/images/thanks.gif',
                    width: 150,
                    height: 150,
                  ),
                ),
                const SizedBox(height: 10),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Cảm xúc dự đoán:',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        finalEmotion,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                const Text(
                  'Kết quả bài test:',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),

                Table(
                  columnWidths: const {
                    0: IntrinsicColumnWidth(),
                    1: FixedColumnWidth(10),
                    2: FlexColumnWidth(),
                  },
                  children: <TableRow>[
                    TableRow(
                      children: [
                        const ScoreLabel(label: 'Trầm cảm:'),
                        const SizedBox(),
                        ScoreValue(score: score['depression']),
                      ],
                    ),
                    TableRow(
                      children: [
                        const ScoreLabel(label: 'Lo lắng:'),
                        const SizedBox(),
                        ScoreValue(score: score['anxiety']),
                      ],
                    ),
                    TableRow(
                      children: [
                        const ScoreLabel(label: 'Căng thẳng:'),
                        const SizedBox(),
                        ScoreValue(score: score['stress']),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ruleName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 174, 50, 8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        conclusionText,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                      if (reasonText.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Text(
                          reasonText,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                if (positiveFeedback.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '💪 Điểm tích cực',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          positiveFeedback,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

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
                                const Text(
                                  '• ',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Expanded(
                                  child: Text(
                                    item.toString(),
                                    style: const TextStyle(
                                      fontSize: 15.5,
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
                        fontSize: 16,
                        height: 1.4,
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 22),

                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () => context.go(PageRoutes.homePage),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      child: Text(
                        'Trang chủ -->',
                        style: TextStyle(
                          fontSize: 22,
                          fontStyle: FontStyle.italic,
                          color: primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),

                const InfoDoctor(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}