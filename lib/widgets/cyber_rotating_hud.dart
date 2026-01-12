import 'dart:math' as math;
import 'package:flutter/material.dart';

class CyberRotatingHUD extends StatefulWidget {
  final Color color;
  final double size;
  const CyberRotatingHUD({
    super.key,
    this.color = Colors.white12,
    this.size = 150,
  });

  @override
  State<CyberRotatingHUD> createState() => _CyberRotatingHUDState();
}

class _CyberRotatingHUDState extends State<CyberRotatingHUD>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _HUDRingPainter(
            progress: _controller.value,
            color: widget.color,
          ),
        );
      },
    );
  }
}

class _HUDRingPainter extends CustomPainter {
  final double progress;
  final Color color;

  _HUDRingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Outer notched ring
    _drawNotchedArc(
      canvas,
      center,
      size.width * 0.45,
      progress * 2 * math.pi,
      4,
      paint,
    );

    // Inner dashed ring
    paint.strokeWidth = 0.5;
    _drawDashedCircle(
      canvas,
      center,
      size.width * 0.35,
      -progress * 4 * math.pi,
      20,
      paint,
    );

    // Degree markers
    _drawDegreeMarkers(canvas, center, size.width * 0.4, paint);
  }

  void _drawNotchedArc(
    Canvas canvas,
    Offset center,
    double radius,
    double angle,
    int count,
    Paint paint,
  ) {
    final rect = Rect.fromCircle(center: center, radius: radius);
    final sweep = (2 * math.pi) / (count * 2);
    for (int i = 0; i < count; i++) {
      canvas.drawArc(rect, angle + i * sweep * 2, sweep, false, paint);
    }
  }

  void _drawDashedCircle(
    Canvas canvas,
    Offset center,
    double radius,
    double angle,
    int dashes,
    Paint paint,
  ) {
    final sweep = (2 * math.pi) / (dashes * 2);
    for (int i = 0; i < dashes; i++) {
      final start = angle + i * sweep * 2;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        sweep,
        false,
        paint,
      );
    }
  }

  void _drawDegreeMarkers(
    Canvas canvas,
    Offset center,
    double radius,
    Paint paint,
  ) {
    for (int i = 0; i < 360; i += 30) {
      final angle = i * math.pi / 180;
      final start = Offset(
        center.dx + math.cos(angle) * (radius - 5),
        center.dy + math.sin(angle) * (radius - 5),
      );
      final end = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );
      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
