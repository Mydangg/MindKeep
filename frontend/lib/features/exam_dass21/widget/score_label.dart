import 'package:flutter/widgets.dart';

class ScoreLabel extends StatelessWidget {
  const ScoreLabel({required this.label, super.key,});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
      ),
    );
  }
}
