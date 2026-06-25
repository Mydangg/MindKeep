import 'package:flutter/material.dart';
import 'package:frontend/core/themes/app_colors.dart';
import 'package:frontend/core/widgets/textfield.dart';
import 'package:frontend/features/auth/controller/auth_controller.dart';
import 'package:frontend/features/auth/utils/validators.dart';
import 'package:frontend/features/auth/widget/check_list.dart';
import 'package:frontend/features/auth/widget/social_button.dart';
import 'package:frontend/routing/page_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF0A4F6A),
            size: 28,
          ),
          onPressed: () => context.go(PageRoutes.auth),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset('assets/images/bg5.png', fit: BoxFit.cover),
          ),
          const SignInContent(),
        ],
      ),
    );
  }
}

class SignInContent extends StatefulWidget {
  const SignInContent({super.key});

  @override
  State<SignInContent> createState() => _SignInContentState();
}

class _SignInContentState extends State<SignInContent> {
   final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 2, 24, 20),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Đăng Nhập',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.primary800,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
          
                const Text.rich(
                  TextSpan(
                    style: TextStyle(
                      color: AppColors.greyscale0,
                      fontSize: 18,
                      height: 1.5,
                      fontWeight: FontWeight.w700,
                    ),
                    children: [
                      TextSpan(text: 'Mỗi '),
                      TextSpan(
                        text: 'cảm xúc ',
                        style: TextStyle(
                          color: Color.fromARGB(255, 40, 151, 55),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      TextSpan(text: 'được nhận diện,\nmột bước'),
                      TextSpan(
                        text: ' nhẹ nhàng ',
                        style: TextStyle(
                          color: Color.fromARGB(255, 40, 151, 55),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      TextSpan(text: 'chữa lành.'),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                PredictTextField(
                  hint: 'Email',
                  controller: authController.email,
                  validator: (v) => validateEmail(context, v),
                  prefixIcon: Icons.email_outlined,
                ),
                const SizedBox(height: 20),
                PredictTextField(
                  hint: 'Mật khẩu',
                  controller: authController.password,
                  validator: (v) => validatePassword(context, v),
                  focusNode: authController.passwordFocusNode,
                  obscureText: authController.isPasswordVisible,
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: IconButton(
                    icon: Icon(
                      authController.isPasswordVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                    onPressed: authController.togglePassword,
                  ),
                ),
                if (authController.showPasswordChecklist)
                  PasswordRequirementChecklist(
                    password: authController.password.text,
                  ),
                const SizedBox(height: 15),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Quên mật khẩu?',
                    style: TextStyle(
                      color: Color(0xFFCEFFFF),
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
          
                ElevatedButton(
                  onPressed: () => authController.signIn(context, formKey),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary300,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: const BorderSide(
                        color: Colors.white, // Màu của viền
                        width: 2, // Độ dày của viền
                      ),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Đăng nhập',
                    style: TextStyle(
                      color: AppColors.primary800,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
          
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Bạn không có tài khoản? ',
                      style: TextStyle(
                        color: Color.fromRGBO(252, 252, 252, 1),
                        fontSize: 16,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.push(PageRoutes.signUp),
                      child: const Text(
                        'Đăng ký',
                        style: TextStyle(
                          color: Color(0xFFEC9D53),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                const Row(
                  children: [
                    Expanded(
                      child: Divider(color: AppColors.primary300, thickness: 1),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Hoặc',
                        style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: AppColors.primary300, thickness: 1),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SocialButton(imagePath: 'assets/images/Google.png'),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: SocialButton(
                        imagePath: 'assets/images/Facebook.png',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const Text.rich(
                  TextSpan(
                    style: TextStyle(
                      color: Color.fromARGB(255, 236, 234, 234),
                      fontSize: 16,
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(
                        text:
                            'Bằng cách tiếp tục, bạn cho biết'
                            ' rằng bạn đã đọc và đồng ý với ',
                      ),
                      TextSpan(
                        text: 'Điều khoản dịch vụ',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: ' và '),
                      TextSpan(
                        text: 'Chính sách bảo mật',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: ' của chúng tôi'),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
