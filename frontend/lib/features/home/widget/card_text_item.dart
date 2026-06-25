import 'package:flutter/material.dart';
import 'package:frontend/core/themes/app_colors.dart';
import 'package:frontend/core/uitls/format.dart';
import 'package:frontend/data/model/predictions.dart';
import 'package:frontend/features/home/controller/home_controller.dart';
import 'package:frontend/features/home/helper/emoji_helper.dart';
import 'package:frontend/routing/page_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CardTextItem extends StatelessWidget {
  const CardTextItem({
    required this.prediction,
    required this.count,
    super.key,
  });

  final Predictions prediction;
  final int count;

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<HomeController>(context, listen: false);

    return Card(
      color: Colors.transparent,
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.only(left: 8, right: 12),
        decoration: BoxDecoration(
          color: AppColors.greyscale0,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.greyscale200, width: 1.1),
        ),
        child: InkWell(
          onTap: () async {
            await controller.getResultPrediction(context, prediction.id);
            await context.push(
              PageRoutes.detailPrediction,
              extra: {
                'prediction': prediction,
                'resultTest': controller.resultTest,
                'count': count,
              },
            );
          },
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 25,
                  backgroundColor: getEmojiColor(prediction.finalEmotion),
                  child: Text(
                    getEmoji(prediction.finalEmotion),
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Lần $count',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Cảm xúc : ${prediction.finalEmotion}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: AppColors.greyscale500,
                        ),
                      ),
                    ],
                  ),
                ),

                Text(
                  formatDateTypeOne(prediction.createdAt),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.greyscale500,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
