import 'package:flutter/material.dart';
import 'package:frontend/core/themes/app_colors.dart';
import 'package:frontend/features/auth/controller/auth_controller.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PredictDialog {
  void showLogoutConfirmation(BuildContext context) {
    final controller = Provider.of<AuthController>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 32,
          ),
          content: SizedBox(
            width: 320,
            height: 210,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.help_outline,
                  color: AppColors.primary800,
                  size: 50,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Bạn đã chắc chắn?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Bạn có muốn đăng xuất không?',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () => controller.signOut(context),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red.shade400,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Đăng xuất',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary800,
                        backgroundColor: Colors.grey.shade200,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Hủy', style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showSucess(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 60,
            ),
            content: const Text(
              'Bạn đã gửi thành công!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            actions: [
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Đóng',
                    style: TextStyle(fontSize: 16, color: AppColors.primary800),
                  ),
                ),
              ),
            ],
          ),
    );
  }

  // void showGuidance(BuildContext context, String number) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         backgroundColor: Colors.white,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(16),
  //         ),
  //         contentPadding: const EdgeInsets.symmetric(
  //           horizontal: 20,
  //           vertical: 16,
  //         ),
  //         content: ConstrainedBox(
  //           constraints: const BoxConstraints(maxWidth: 350, maxHeight: 300),
  //           child: SingleChildScrollView(
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 const Icon(
  //                   Icons.notification_add_outlined,
  //                   color: Color.fromARGB(255, 255, 226, 11),
  //                   size: 50,
  //                 ),
  //                 const SizedBox(height: 16),
  //                 const Text(
  //                   'Thông báo hỗ trợ',
  //                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //                   textAlign: TextAlign.center,
  //                 ),
  //                 const SizedBox(height: 10),
  //                 Text(
  //                   // ignore: lines_longer_than_80_chars
  //                   'Trong tình huống nguy cấp hoặc cần hỗ trợ, vui lòng tự bấm số $number trên điện thoại của bạn để được kết nối ngay lập tức.',
  //                   style: const TextStyle(
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.w500,
  //                   ),
  //                   textAlign: TextAlign.center,
  //                 ),
  //                 const SizedBox(height: 24),
  //                 Wrap(
  //                   spacing: 12,
  //                   runSpacing: 12,
  //                   alignment: WrapAlignment.center,
  //                   children: [
  //                     TextButton(
  //                       onPressed: () => Navigator.of(context).pop(),
  //                       style: TextButton.styleFrom(
  //                         foregroundColor: Colors.white,
  //                         backgroundColor: const Color.fromARGB(
  //                           255,
  //                           39,
  //                           195,
  //                           0,
  //                         ),
  //                         padding: const EdgeInsets.symmetric(
  //                           horizontal: 24,
  //                           vertical: 12,
  //                         ),
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(8),
  //                         ),
  //                       ),
  //                       child: const Text(
  //                         'Đã hiểu',
  //                         style: TextStyle(fontSize: 18),
  //                       ),
  //                     ),
  //                     const SizedBox(width: 8),
  //                     TextButton(
  //                       onPressed: () => Navigator.of(context).pop(),
  //                       style: TextButton.styleFrom(
  //                         foregroundColor: Colors.white,
  //                         backgroundColor: AppColors.greyscale0,
  //                         padding: const EdgeInsets.symmetric(
  //                           horizontal: 24,
  //                           vertical: 12,
  //                         ),
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(8),
  //                         ),
  //                       ),
  //                       child: const Text(
  //                         'Đóng',
  //                         style: TextStyle(fontSize: 18),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
  void showGuidance(BuildContext context, String number) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 26, 24, 20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red,
                  size: 46,
                ),
              ),
              const SizedBox(height: 18),

              const Text(
                'Hỗ trợ khẩn cấp',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.greyscale800,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'Nếu bạn hoặc người thân đang trong tình trạng nguy hiểm, '
                'khủng hoảng nghiêm trọng hoặc cần hỗ trợ ngay lập tức, '
                'hãy liên hệ số $number.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15.5,
                  height: 1.45,
                  color: AppColors.greyscale600,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.greyscale700,
                        side: BorderSide(color: Colors.grey.shade300),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Hủy',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        Navigator.of(context).pop();

                        final uri = Uri.parse('tel:$number');
                        await launchUrl(uri);
                      },
                      icon: const Icon(Icons.call, size: 20),
                      label: Text(
                        'Gọi $number',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
