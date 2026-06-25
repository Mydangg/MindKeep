import 'package:flutter/material.dart';
import 'package:frontend/core/themes/app_colors.dart';
import 'package:frontend/core/uitls/format.dart';
import 'package:frontend/core/widgets/textfield.dart';
import 'package:frontend/features/auth/controller/auth_controller.dart';
import 'package:frontend/features/auth/utils/validators.dart';
import 'package:frontend/features/auth/widget/check_list.dart';
import 'package:frontend/routing/page_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
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
          const SignUpContent(),
        ],
      ),
    );
  }
}

class SignUpContent extends StatefulWidget {
  const SignUpContent({super.key});

  @override
  State<SignUpContent> createState() => _SignUpContentState();
}

class _SignUpContentState extends State<SignUpContent> {
  final formKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Đăng Ký',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromARGB(255, 16, 95, 133),
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),

                Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      'Mind Keep',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        foreground:
                            Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 5
                              ..color = const Color(0xFFF38B61),
                      ),
                    ),

                    const Text(
                      'Mind Keep',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 203, 226, 247),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                PredictTextField(
                  controller: authController.name,
                  hint: 'Tên',
                  validator:
                      (v) => validateText(
                        context,
                        v,
                        'Không được để trống tên người dùng',
                      ),
                  prefixIcon: Icons.person_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 30),

                PredictTextField(
                  controller: authController.email,
                  hint: 'Email',
                  validator: (v) => validateEmail(context, v),
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 28),
                PredictTextField(
                  controller: authController.password,
                  obscureText: !authController.isPasswordVisible,
                  hint: 'Mật khẩu',
                  validator: (v) => validatePassword(context, v),
                  focusNode: authController.passwordFocusNode,
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: IconButton(
                    icon: Icon(
                      !authController.isPasswordVisible
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
                const SizedBox(height: 30),

                ElevatedButton(
                  onPressed: () => authController.signUp(context, formKey),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary300,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: const BorderSide(color: Colors.white, width: 2),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Đăng Ký',
                    style: TextStyle(
                      color: AppColors.primary800,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Bạn đã có tài khoản? ',
                      style: TextStyle(
                        color: Color.fromRGBO(252, 252, 252, 1),
                        fontSize: 16,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.go(PageRoutes.signIn),
                      child: const Text(
                        'Đăng nhập',
                        style: TextStyle(
                          color: Color(0xFFEC9D53),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                const Text.rich(
                  TextSpan(
                    style: TextStyle(
                      color: Color.fromARGB(255, 236, 234, 234),
                      fontSize: 18,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
