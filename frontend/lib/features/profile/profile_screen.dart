import 'package:flutter/material.dart';
import 'package:frontend/core/constants.dart';
import 'package:frontend/core/themes/app_colors.dart';
import 'package:frontend/features/auth/controller/auth_controller.dart';
import 'package:frontend/features/profile/section/about_screen.dart';
import 'package:frontend/features/profile/section/support_screen.dart';
import 'package:frontend/features/profile/widget/dialog_profile.dart';
import 'package:frontend/features/profile/widget/profile_item.dart';
import 'package:frontend/routing/page_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<AuthController>(context);
    final user = controller.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text('Cá nhân'),
        titleTextStyle: const TextStyle(
          color: AppColors.greyscale800,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
        toolbarHeight: 60,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          iconSize: 22,
          color: AppColors.greyscale800,
          onPressed: () => context.go(PageRoutes.homePage),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () => context.go(PageRoutes.homePage),
              icon: const Icon(
                Icons.home_outlined,
                color: AppColors.greyscale800,
                size: 28,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 35,
                  backgroundColor: Color.fromARGB(255, 240, 240, 240),
                  child: CircleAvatar(
                    radius: 32,
                    backgroundImage: AssetImage('assets/images/user.jpg'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.displayName?? 'Cập nhập...',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Sức khỏe là vàng',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.edit_note,
                    color: primaryColor,
                    size: 30,
                  ),
                  onPressed: () {},
                ),
              ],
            ),

            const SizedBox(height: 30),
            const Text(
              'Hồ Sơ',
              style: TextStyle(
                color: AppColors.greyscale800,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            ProfileItem(
              icon: Icons.info_outline,
              title: 'Giới thiệu',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutScreen()),
                );
              },
            ),
            ProfileItem(
              icon: Icons.bookmark_outline,
              title: 'Đã lưu',
              onTap: () => context.push(PageRoutes.tabSaveAndLike),
            ),
            ProfileItem(
              icon: Icons.notifications_none,
              title: 'Bạn cần giúp đỡ',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SupportScreen(),
                  ),
                );
              },
            ),
            ProfileItem(
              icon: Icons.person_outline,
              title: 'Tài khoản cá nhân',
              onTap: () => context.push(PageRoutes.updateProfile),
            ),
            ProfileItem(
              icon: Icons.help_outline,
              title: 'Gửi phản hồi',
              onTap: () {
                context.push(PageRoutes.feedback);
              },
            ),

            const SizedBox(height: 20),
            Center(
              child: InkWell(
                onTap: () => PredictDialog().showLogoutConfirmation(context),
                borderRadius: BorderRadius.circular(8),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    'Đăng xuất',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
