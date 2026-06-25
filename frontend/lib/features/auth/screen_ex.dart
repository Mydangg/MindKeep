import 'package:flutter/material.dart';

class ScreenEx extends StatelessWidget {
  const ScreenEx({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'ScreenEx',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
