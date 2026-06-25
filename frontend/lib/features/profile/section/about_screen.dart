import 'package:flutter/material.dart';
import 'package:frontend/core/constants.dart';
import 'package:frontend/core/themes/app_colors.dart';
import 'package:frontend/features/profile/widget/content_section.dart';
import 'package:frontend/routing/page_routes.dart';
import 'package:go_router/go_router.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Giới thiệu ứng dụng',
          style: TextStyle(
            color: AppColors.greyscale800,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.greyscale800),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: () => context.pop(PageRoutes.homePage),
              icon: const Icon(
                Icons.home_outlined,
                color: AppColors.greyscale800,
                size: 28,
              ),
            ),
          ),
        ],
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ContentSection(
              icon: Icons.flag_outlined,
              title: 'Mục tiêu phát triển',
              content:
                  'Ứng dụng được phát triển nhằm cung cấp '
                  'một giải pháp công nghệ tiên tiến trong việc'
                  ' theo dõi sức khỏe tinh thần. Bằng cách sử'
                  ' dụng trí tuệ nhân tạo để nhận diện cảm xúc qua'
                  ' khuôn mặt và giọng nói, hệ thống giúp người dùng '
                  'hiểu rõ hơn về trạng thái tâm lý hàng ngày của mình.',
            ),
            ContentSection(
              icon: Icons.settings_suggest_outlined,
              title: 'Cơ chế hoạt động',
              content:
                  'Thông qua các thuật toán học máy, ứng dụng phân '
                  'tích các biểu hiện cảm xúc nhỏ nhất, từ đó đưa ra'
                  ' các cảnh báo sớm về các dấu hiệu rối loạn tâm lý như '
                  'trầm cảm, lo âu hay căng thẳng kéo dài.',
            ),
            ContentSection(
              icon: Icons.volunteer_activism_outlined,
              title: 'Ý nghĩa và tầm nhìn',
              content:
                  'Chúng tôi mong muốn tạo ra một người bạn đồng hành số,'
                  ' giúp thu hẹp khoảng cách giữa người dùng và các chuyên gia '
                  'tâm lý, tạo điều kiện để mọi người tiếp cận với sự hỗ trợ'
                  ' tinh thần một cách kịp thời và hiệu quả nhất.',
            ),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Vì một cộng đồng khỏe mạnh về tâm trí ',
                    style: TextStyle(
                      color: greenTextColor,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  Icon(Icons.favorite, color: Color.fromARGB(255, 245, 38, 38)),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
