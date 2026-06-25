import 'package:flutter/material.dart';
import 'package:frontend/core/constants.dart';
import 'package:frontend/data/model/predictions.dart';
import 'package:frontend/features/home/widget/card_text_item.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/core/themes/app_colors.dart';
import 'package:frontend/routing/page_routes.dart';
import 'package:go_router/go_router.dart';

class HomeMainScreen extends StatelessWidget {
  const HomeMainScreen({required this.testResults, super.key});

  final List<Predictions> testResults;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(19, 24, 19, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: infoCardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(
                    'assets/images/heart_1.png',
                    width: 30,
                    height: 30,
                  ),
                ),
                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    'Chúng tôi ở đây, để lắng nghe trái tim bạn',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF7FA),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.psychology,
                  size: 40,
                  color: AppColors.primary700,
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Kiểm tra tâm lý",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Theo dõi cảm xúc hiện tại của bạn",
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // ElevatedButton(
                //   onPressed: () {
                //     context.push(PageRoutes.testPsych);
                //   },
                //   child: const Text("Bắt đầu"),
                // ),
                // ElevatedButton(
                //   onPressed: () {
                //     context.push(PageRoutes.testPsych);
                //   },
                //   style: ElevatedButton.styleFrom(
                //     // backgroundColor: AppColors.primary700,
                //     // foregroundColor: Colors.white,
                //     backgroundColor: Colors.white,
                //     foregroundColor: AppColors.primary700,
                //     side: BorderSide(
                //       color: AppColors.primary700,
                //       width: 1.5,
                //     ),
                //     padding: const EdgeInsets.symmetric(
                //       horizontal: 24,
                //       vertical: 14,
                //     ),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(12),
                //     ),
                //   ),
                //   child: const Text(
                //     "Bắt đầu",
                //     style: TextStyle(
                //       fontSize: 18,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
                ElevatedButton(
                  onPressed: () {
                    context.push(PageRoutes.testPsych);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary700,
                    elevation: 0,

                    side: BorderSide(
                      color: AppColors.primary700.withOpacity(0.5),
                      width: 1,
                    ),

                    minimumSize: const Size(90, 42),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Bắt đầu",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Các bài kiểm tra',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 15),

          ...testResults.map((result) {
            return CardTextItem(
              prediction: result,
              count: testResults.indexOf(result) + 1,
            );
          }),
        ],
      ),
    );
  }
}
