import 'package:flutter/material.dart';
import 'package:frontend/core/models/test_result_model.dart';
import 'package:frontend/features/auth/controller/auth_controller.dart';
import 'package:frontend/features/home/controller/home_controller.dart';
import 'package:frontend/features/home/home_main_screen.dart';
import 'package:frontend/features/home/home_welcome_screen.dart';
import 'package:frontend/features/home/widget/header_bar.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final mockResult = TestResult(
    predictedEmotion: 'Bình thường',
    depressionScore: 0,
    anxietyScore: 0,
    stressScore: 0,
    conclusion: 'Chào mừng! Bắt đầu bài test đầu tiên của bạn.',
  );

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final _ = Provider.of<HomeController>(context, listen: false)
        ..getPredictions(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeController = Provider.of<HomeController>(context);
    final controller = Provider.of<AuthController>(context);
    final user = controller.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: HeaderBar(username: user?.displayName, avatarUrl: user?.photoUrl),

      body:
          homeController.isLoading
              ? const Center(child: CircularProgressIndicator())
              : homeController.hasTestResults
              ? HomeMainScreen(testResults: homeController.listAll)
              : const HomeWelcomeScreen(),
    );
  }
}
