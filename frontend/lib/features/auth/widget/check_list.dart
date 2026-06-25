import 'package:flutter/material.dart';
import 'package:frontend/core/themes/app_colors.dart';

class PasswordRequirementChecklist extends StatelessWidget {
  const PasswordRequirementChecklist({required this.password, super.key});
  final String password;

  @override
  Widget build(BuildContext context) {
    final hasUpper = password.contains(RegExp('[A-Z]'));
    final hasLower = password.contains(RegExp('[a-z]'));
    final hasNumber = password.contains(RegExp('[0-9]'));
    final hasSpecial = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    final hasLength = password.length >= 8;

    final hasUpperAndLower = hasUpper && hasLower;
    final hasNumberOrSpecial = hasNumber && hasSpecial;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildItem('Mật khẩu phải có ít nhất 8 ký tự', hasLength),
          _buildItem('Có ít nhất một chữ hoa, chữ thường', hasUpperAndLower),
          _buildItem('Có ít nhất một số và ký tự đặc biệt', hasNumberOrSpecial),
        ],
      ),
    );
  }

  Widget _buildItem(String text, bool valid) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            valid ? Icons.check_circle : Icons.cancel,
            color: valid ? Colors.green : AppColors.error200,
            size: 18,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: AppColors.primary400,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
