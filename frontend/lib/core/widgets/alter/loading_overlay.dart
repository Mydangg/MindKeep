import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoadingOverlay {
  void showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  void hideLoading(BuildContext context) {
    context.pop();
  }
}
