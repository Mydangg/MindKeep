import 'package:flutter/material.dart';
import 'package:frontend/core/themes/app_colors.dart';
import 'package:frontend/core/uitls/format.dart';
import 'package:frontend/core/widgets/textfield.dart';
import 'package:frontend/features/auth/controller/auth_controller.dart';
import 'package:frontend/features/auth/utils/validators.dart';
import 'package:frontend/features/auth/widget/primary_button.dart';
import 'package:frontend/features/profile/controller/profile_controller.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _fromKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _emergencyName = TextEditingController();
  final _emergencyPhone = TextEditingController();
  String uid = '';

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<AuthController>(context, listen: false);
    final user = userProvider.currentUser;
    _name.text = user?.displayName ?? 'Nhập họ tên';
    _email.text = user?.email ?? 'Nhập email';
    _emergencyName.text = user?.emergencyName ?? '';
    _emergencyPhone.text = user?.emergencyPhone ?? '';
    uid = user?.uid ?? '';
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _emergencyName.dispose();
    _emergencyPhone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ProfileController>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Thông tin tài khoản',
          style: TextStyle(
            color: AppColors.greyscale800,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.greyscale800,
            size: 22,
          ),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _fromKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Quản lý thông tin',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              const Padding(
                padding: EdgeInsets.only(bottom: 10, left: 4),
                child: Text(
                  'Họ và Tên',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: AppColors.greyscale700,
                  ),
                ),
              ),
              PredictTextField(
                hint: 'Họ và Tên',
                color: AppColors.greyscale500,
                controller: _name,
                validator:
                    (value) =>
                        validateText(context, value, 'Vui lòng nhập họ và tên'),
                border: 8,
                size: 16,
                fillColor: AppColors.greyscale30,
              ),

              const SizedBox(height: 22),

              const Padding(
                padding: EdgeInsets.only(bottom: 10, left: 4),
                child: Text(
                  'Email (Đã xác minh)',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: AppColors.greyscale700,
                  ),
                ),
              ),
              PredictTextField(
                hint: 'Nhập email của bạn',
                color: AppColors.greyscale500,
                controller: _email,
                validator: (value) => validateEmail(context, value),
                border: 8,
                size: 16,
                fillColor: AppColors.greyscale30,
              ),
              const SizedBox(height: 22),

              const Padding(
                padding: EdgeInsets.only(bottom: 10, left: 4),
                child: Text(
                  'Tên người thân',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: AppColors.greyscale700,
                  ),
                ),
              ),
              PredictTextField(
                hint: 'Ví dụ: Mẹ, Anh trai, Bạn thân',
                color: AppColors.greyscale500,
                controller: _emergencyName,
                border: 8,
                size: 16,
                fillColor: AppColors.greyscale30,
              ),

              const SizedBox(height: 22),

              const Padding(
                padding: EdgeInsets.only(bottom: 10, left: 4),
                child: Text(
                  'Số điện thoại người thân',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: AppColors.greyscale700,
                  ),
                ),
              ),
              PredictTextField(
                hint: 'Nhập số điện thoại người thân',
                color: AppColors.greyscale500,
                controller: _emergencyPhone,
                border: 8,
                size: 16,
                fillColor: AppColors.greyscale30,
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 42),
              PrimaryButton(
                text: 'CẬP NHẬP',
                onPressed: () => controller.updateProfile(
                  context,
                  _name.text,
                  _email.text,
                  uid,
                  _fromKey,
                  emergencyName: _emergencyName.text,
                  emergencyPhone: _emergencyPhone.text,
                ),
                backgroundColor: AppColors.primary500,
                textColor: AppColors.primary800,
                border: 12,
              ),

              const SizedBox(height: 38),

              Center(
                child: TextButton(
                  onPressed: () => controller.deleteAccount(context,uid),
                  child: const Text(
                    'Xóa tài khoản của tôi',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
