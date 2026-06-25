import 'package:flutter/material.dart';
import 'package:frontend/core/constants.dart';
import 'package:frontend/core/themes/app_colors.dart';
import 'package:frontend/features/auth/controller/auth_controller.dart';
import 'package:frontend/features/test_emtion/controller/test_emotion_controller.dart';
import 'package:frontend/features/test_emtion/widget/border_upload_image.dart';
import 'package:frontend/routing/page_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class TestEmotionScreen extends StatefulWidget {
  const TestEmotionScreen({super.key});

  @override
  State<TestEmotionScreen> createState() => _TestEmotionScreenState();
}

class _TestEmotionScreenState extends State<TestEmotionScreen> {

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<TestEmotionController>(context);
    final authController = Provider.of<AuthController>(context, listen: false);
    final user = authController.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Kiểm tra Tâm lý'),
        titleTextStyle: const TextStyle(
          color: primaryColor,
          fontSize: 24,
          fontWeight: FontWeight.w500,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        toolbarHeight: 60,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          iconSize: 20,
          onPressed: () {
            Navigator.of(context).pop();
          },
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
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: BorderUploadImage(),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
        child: ElevatedButton(
          onPressed:() => controller.testEmotion(context, user!),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3B5B84),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Xong',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
