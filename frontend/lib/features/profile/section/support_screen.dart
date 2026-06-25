import 'package:flutter/material.dart';
import 'package:frontend/core/constants.dart';
import 'package:frontend/features/auth/helper/local_storage_helper.dart';
import 'package:frontend/features/profile/data/data_hotline.dart';
import 'package:frontend/features/profile/widget/action_button.dart';
import 'package:frontend/features/profile/widget/dialog_profile.dart';
import 'package:frontend/features/profile/widget/hotline.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/routing/page_routes.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  Future<void> callRelative(BuildContext context) async {
    final user = await LocalStorageHelper.getUser();
    print("EMERGENCY NAME: ${user?.emergencyName}");
    print("EMERGENCY PHONE: ${user?.emergencyPhone}");
    final phone = user?.emergencyPhone;

    if (phone == null || phone.trim().isEmpty) {
      if (!context.mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.family_restroom,
                color: Colors.orange,
              ),
              SizedBox(width: 10),
              Text("Chưa có liên hệ"),
            ],
          ),
          content: const Text(
            "Bạn chưa thêm số điện thoại người thân.\n\n"
            "Vui lòng cập nhật thông tin liên hệ khẩn cấp trong hồ sơ cá nhân.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Đóng"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                // Chuyển sang màn cập nhật hồ sơ
                context.push(PageRoutes.updateProfile);
              },
              child: const Text("Thêm ngay"),
            ),
          ],
        ),
      );

      return;
    }

    final uri = Uri.parse('tel:${phone.trim()}');
    await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Hỗ trợ khẩn cấp',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: primaryColor, size: 28),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
                size: 60,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Bạn đang gặp khó khăn?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Nếu bạn hoặc người thân đang trong tình'
              ' trạng khủng hoảng hoặc gặp áp lực tâm lý'
              ' quá lớn, hãy tìm kiếm sự giúp đỡ ngay lập tức.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40),

            ActionButton(
              icon: Icons.family_restroom,
              label: 'Gọi người thân',
              color: Colors.orange,
              onTap: () => callRelative(context),
            ),
            const SizedBox(height: 16),

            ActionButton(
              icon: Icons.phone_in_talk,
              label: 'Số điện thoại hỗ trợ tâm lý',
              color: primaryColor,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Vui lòng tham khảo danh sách số điện thoại phía dưới.',
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            ActionButton(
              icon: Icons.emergency,
              label: 'Gọi cấp cứu (115)',
              color: Colors.red,
              onTap: () => PredictDialog().showGuidance(context, '115'),
            ),

            const SizedBox(height: 40),
            const Divider(),
            const SizedBox(height: 20),
            Hotline(title: 'VIỆT NAM', hotlines: hotline),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:frontend/core/constants.dart';
// import 'package:frontend/features/profile/data/data_hotline.dart';
// import 'package:frontend/features/profile/widget/action_button.dart';
// import 'package:frontend/features/profile/widget/dialog_profile.dart';
// import 'package:frontend/features/profile/widget/hotline.dart';

// class SupportScreen extends StatelessWidget {
//   const SupportScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         title: const Text(
//           'Hỗ trợ khẩn cấp',
//           style: TextStyle(
//             color: primaryColor,
//             fontWeight: FontWeight.bold,
//             fontSize: 22,
//           ),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.close, color: primaryColor, size: 28),
//           onPressed: () => Navigator.maybePop(context),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.red.shade50,
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.warning_amber_rounded,
//                 color: Colors.red,
//                 size: 60,
//               ),
//             ),
//             const SizedBox(height: 24),
//             const Text(
//               'Bạn đang gặp khó khăn?',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 26,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'Nếu bạn hoặc người thân đang trong tình'
//               ' trạng khủng hoảng hoặc gặp áp lực tâm lý'
//               ' quá lớn, hãy tìm kiếm sự giúp đỡ ngay lập tức.',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.black54,
//                 fontWeight: FontWeight.w500,
//                 height: 1.5,
//               ),
//             ),
//             const SizedBox(height: 40),
//             ActionButton(
//               icon: Icons.phone_in_talk,
//               label: 'Số điện thoại hỗ trợ tâm lý',
//               color: primaryColor,
//               onTap: () {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text(
//                       'Vui lòng tham khảo danh sách số điện thoại phía dưới.',
//                     ),
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(height: 16),
//             ActionButton(
//               icon: Icons.emergency,
//               label: 'Gọi cấp cứu (115)',
//               color: Colors.red,
//               onTap: () => PredictDialog().showGuidance(context, '115'),
//             ),
//             const SizedBox(height: 40),
//             const Divider(),
//             const SizedBox(height: 20),
//             Hotline(title: 'VIỆT NAM', hotlines: hotline),
//           ],
//         ),
//       ),
//     );
//   }
// }
