import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF0A4F6A),
            size: 38,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg5.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          const ForgotPasswordContent(),
        ],
      ),
    );
  }
}

class ForgotPasswordContent extends StatefulWidget {
  const ForgotPasswordContent({super.key});

  @override
  State<ForgotPasswordContent> createState() => _ForgotPasswordContentState();
}

class _ForgotPasswordContentState extends State<ForgotPasswordContent> {
  static const Color primaryTextColor = Color(0xFF0A4F6A);
  static const Color borderColor = Color(0xFFB0D9E6);
  static const Color buttonColor = Color(0xFFB0D9E6);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 130, 24, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Quên Mật Khẩu',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromARGB(255, 16, 95, 133),
                fontSize: 34,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 18),
            
            const Text(
              'Khôi phục mật khẩu tài khoản của bạn',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(255, 255, 255, 1),
                fontWeight: FontWeight.w900,
                fontSize: 18,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 38),

            TextField(
              decoration: _buildInputDecoration(
                hint: 'Nhập Email của bạn',
                prefixIcon: Icons.email_outlined,
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: const BorderSide(
                    //viền
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Tiếp tục',
                style: TextStyle(
                  color: primaryTextColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hint,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      // ignore: lines_longer_than_80_chars
      hintStyle: const TextStyle(
        color: Color.fromARGB(255, 255, 255, 255),
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      // ignore: lines_longer_than_80_chars
      prefixIcon: Icon(
        prefixIcon,
        color: const Color.fromARGB(255, 255, 255, 255),
        size: 26,
      ),
      suffixIcon: suffixIcon,
      filled: true,
      // ignore: deprecated_member_use
      fillColor: Colors.white.withOpacity(0),
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 25),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: borderColor, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Color.fromARGB(255, 253, 253, 253)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        // ignore: lines_longer_than_80_chars
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 176, 217, 230),
          width: 5,
        ),
      ),
    );
  }
}
