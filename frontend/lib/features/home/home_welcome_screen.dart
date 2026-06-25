import 'package:flutter/material.dart';
import 'package:frontend/core/constants.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/routing/page_routes.dart';

class HomeWelcomeScreen extends StatelessWidget {
  const HomeWelcomeScreen({super.key});

  void _startFirstTest(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 50,
          bottom: 180,
        ),
        child: Column(
          children: [
            const Align(
              child: Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                  text: 'Chào mừng bạn đến với\n',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    height: 1.4,
                  ),
                  children: [
                    TextSpan(
                      text: 'Mind',
                      style: TextStyle(
                        color: logoColor,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextSpan(
                      text: 'Keep',
                      style: TextStyle(
                        color: Color.fromARGB(255, 2, 124, 39),
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: infoCardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                      'assets/images/Together1.png',
                      width: 50,
                      height: 50,
                    ),
                  ),
                  const SizedBox(width: 15),

                  const Expanded(
                    child: Text(
                      'Hãy cùng chúng tôi lắng nghe và thấu'
                      ' hiểu sức khỏe tinh thần của bạn',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            GestureDetector(
              // onTap: () => _startFirstTest(context),
              onTap: () => context.push(PageRoutes.testPsych),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: buttonColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  children: [
                    Text(
                      'BẮT ĐẦU',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'BÀI KIỂM TRA ĐẦU TIÊN',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Bạn chỉ mất 5 phút để nhận\nđánh giá đầu tiên',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: primaryColor,
                fontSize: 18,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
