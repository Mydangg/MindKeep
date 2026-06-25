import 'package:flutter/material.dart';
import 'package:frontend/core/uitls/format.dart';

String? validateEmail(BuildContext context, String? value) {
  final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  final result = validateText(context, value, 'Email không được để trống');
  if (result == null || result.isEmpty) {
    if (!emailRegExp.hasMatch(value ?? '')) {
      return 'Định dạng email không hợp lệ';
    }
  }
  return result;
}

// validator for password
String? validatePassword(BuildContext context, String? value) {
  final passwordRegExp = RegExp(
    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
  );

  final result = validateText(context, value, 'Mật khẩu không được để trống');
  if (result == null || result.isEmpty) {
    if (!passwordRegExp.hasMatch(value ?? '')) {
      return 'Mật khẩu không đúng định dạng';
    }
  }
  return result;
}

String? validateConfirmPassword(
  BuildContext context,
  String? password,
  String? confirmPassword,
) {
  final result = validateText(
    context,
    confirmPassword,
    'Xác nhận mật khẩu không được để trống',
  );
  if (result == null || result.isEmpty) {
    if (password != confirmPassword) {
      return 'Mật khẩu xác nhận không khớp';
    }
  }
  return result;
}
