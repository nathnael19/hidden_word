import 'package:flutter/material.dart';

class RadarScannerWidget extends StatelessWidget {
  final Animation<double> animation;
  const RadarScannerWidget({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return CustomPaint(
          painter: RadarPainter(animation.value),
        );
      },
    );
  }
}

class RadarPainter extends CustomPainter {
  final double progress;
  RadarPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Circles
    canvas.drawCircle(center, radius * 0.4, paint);
    canvas.drawCircle(center, radius * 0.7, paint);
    canvas.drawCircle(center, radius, paint);

    // Crosshairs
    canvas.drawLine(Offset(center.dx - radius, center.dy), Offset(center.dx + radius, center.dy), paint);
    canvas.drawLine(Offset(center.dx, center.dy - radius), Offset(center.dx, center.dy + radius), paint);

    // Sweep
    final sweepPaint = Paint()
      ..shader = SweepGradient(
        center: Alignment.center,
        startAngle: 0.0,
        endAngle: 3.1415926535 * 2,
        colors: [
          Colors.green.withOpacity(0.0),
          Colors.green.withOpacity(0.3),
        ],
        stops: const [0.8, 1.0],
        transform: GradientRotation(progress * 3.1415926535 * 2),
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, sweepPaint..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant RadarPainter oldDelegate) => true;
}
