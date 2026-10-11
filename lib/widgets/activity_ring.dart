import 'dart:math';
import 'package:flutter/material.dart';

class ActivityRingsWidget extends StatelessWidget {
  final double moveProgress;       // 0.0 - 1.0+ (Red)
  final double exerciseProgress;   // 0.0 - 1.0+ (Green)
  final double standProgress;      // 0.0 - 1.0+ (Cyan)
  final double size;

  const ActivityRingsWidget({
    Key? key,
    required this.moveProgress,
    required this.exerciseProgress,
    required this.standProgress,
    this.size = 140,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingsPainter(
          moveProgress: moveProgress,
          exerciseProgress: exerciseProgress,
          standProgress: standProgress,
        ),
      ),
    );
  }
}

class _RingsPainter extends CustomPainter {
  final double moveProgress;
  final double exerciseProgress;
  final double standProgress;

  _RingsPainter({
    required this.moveProgress,
    required this.exerciseProgress,
    required this.standProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final strokeWidth = size.width * 0.095;
    final ringSpacing = size.width * 0.025;

    // Dış Halka: Hareket / Kalori (Kırmızı)
    final r1 = (size.width / 2) - (strokeWidth / 2);
    _drawRing(
      canvas,
      center,
      r1,
      strokeWidth,
      moveProgress,
      const Color(0x33FF2442),
      const Color(0xFFFF2442),
    );

    // Orta Halka: Egzersiz Dakikası (Yeşil)
    final r2 = r1 - strokeWidth - ringSpacing;
    _drawRing(
      canvas,
      center,
      r2,
      strokeWidth,
      exerciseProgress,
      const Color(0x33A6FF00),
      const Color(0xFFA6FF00),
    );

    // İç Halka: Su / Duruş (Cyan)
    final r3 = r2 - strokeWidth - ringSpacing;
    _drawRing(
      canvas,
      center,
      r3,
      strokeWidth,
      standProgress,
      const Color(0x3300E5FF),
      const Color(0xFF00E5FF),
    );
  }

  void _drawRing(
    Canvas canvas,
    Offset center,
    double radius,
    double strokeWidth,
    double progress,
    Color bgTrackColor,
    Color activeColor,
  ) {
    final bgPaint = Paint()
      ..color = bgTrackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, bgPaint);

    final fgPaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    const startAngle = -pi / 2;
    final sweepAngle = 2 * pi * progress.clamp(0.0, 1.5);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingsPainter oldDelegate) {
    return oldDelegate.moveProgress != moveProgress ||
        oldDelegate.exerciseProgress != exerciseProgress ||
        oldDelegate.standProgress != standProgress;
  }
}
