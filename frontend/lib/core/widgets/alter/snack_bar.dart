import 'package:flutter/material.dart';

class PredictSnackBar {
  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(top: 8, left: 16, right: 16),
        action: SnackBarAction(label: 'OK', onPressed: () {}),
      ),
    );
  }
}
