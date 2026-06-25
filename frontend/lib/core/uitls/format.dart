import 'package:flutter/material.dart';

bool validateForm(GlobalKey<FormState> formKey) {
  if (!formKey.currentState!.validate()) {
    return false;
  }

  return true;
}

String? validateText(BuildContext context, String? value, String errorMessage) {
  if (value == null || value.isEmpty) {
    return errorMessage;
  }
  return null;
}


String formatDateTypeOne(DateTime date) {
  final year = date.year.toString();
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');

  return '$day-$month\n$year';
}

String formatDateTypeTwo(DateTime date) {
  final year = date.year.toString();
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');

  return '$day-$month-$year';
}

String capitalize(String s){
  if (s.isEmpty) return s;
  return s[0].toUpperCase() + s.substring(1);
}
