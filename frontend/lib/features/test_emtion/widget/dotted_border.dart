
import 'package:flutter/widgets.dart';

class DottedBorderContainer extends StatelessWidget {
  const DottedBorderContainer({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DottedBorderPainter(),
      child: Padding(padding: const EdgeInsets.all(8), child: child),
    );
  }
}

class _DottedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          // ignore: deprecated_member_use
          ..color = const Color(0xFF3B5B84).withOpacity(0.5)
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke;

    const double dashWidth = 8;
    const double dashSpace = 4;
    const double radius = 30;

    final rRect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(radius),
    );
    final path = Path()..addRRect(rRect);

    final pathMetrics = path.computeMetrics();
    for (final pathMetric in pathMetrics) {
      double currentLength = 0;
      while (currentLength < pathMetric.length) {
        final end = currentLength + dashWidth;
        final extractPath = pathMetric.extractPath(
          currentLength,
          end.clamp(0.0, pathMetric.length),
        );
        canvas.drawPath(extractPath, paint);
        currentLength = end + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
