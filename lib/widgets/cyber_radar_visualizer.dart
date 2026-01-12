import 'dart:math' as math;
import 'package:flutter/material.dart';

class CyberRadarVisualizer extends StatefulWidget {
  final Color accentColor;
  const CyberRadarVisualizer({
    super.key,
    this.accentColor = const Color(0xFF7DD3FC),
  });

  @override
  State<CyberRadarVisualizer> createState() => _CyberRadarVisualizerState();
}

class _CyberRadarVisualizerState extends State<CyberRadarVisualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Offset> _blips = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _generateBlips();
  }

  void _generateBlips() {
    for (int i = 0; i < 5; i++) {
      double angle = _random.nextDouble() * 2 * math.pi;
      double dist = 0.2 + _random.nextDouble() * 0.7;
      _blips.add(Offset(math.cos(angle) * dist, math.sin(angle) * dist));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 200,
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black26,
        border: Border.all(color: widget.accentColor.withValues(alpha: 0.1)),
      ),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _RadarPainter(
              angle: _controller.value * 2 * math.pi,
              blips: _blips,
              color: widget.accentColor,
            ),
          );
        },
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  final double angle;
  final List<Offset> blips;
  final Color color;

  _RadarPainter({
    required this.angle,
    required this.blips,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint = Paint()
      ..color = color.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Rings
    canvas.drawCircle(center, radius * 0.3, paint);
    canvas.drawCircle(center, radius * 0.6, paint);
    canvas.drawCircle(center, radius * 0.9, paint);

    // Crosshair
    canvas.drawLine(
      Offset(center.dx - radius, center.dy),
      Offset(center.dx + radius, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - radius),
      Offset(center.dx, center.dy + radius),
      paint,
    );

    // Sweep
    final sweepPaint = Paint()
      ..shader = SweepGradient(
        center: Alignment.center,
        startAngle: angle - 0.5,
        endAngle: angle,
        colors: [Colors.transparent, color.withValues(alpha: 0.4)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawCircle(center, radius, sweepPaint);

    // Blips
    for (var blip in blips) {
      final blipPos = Offset(
        center.dx + blip.dx * radius,
        center.dy + blip.dy * radius,
      );

      // Calculate angle of blip
      double blipAngle = math.atan2(blip.dy, blip.dx);
      if (blipAngle < 0) blipAngle += 2 * math.pi;

      double diff = (angle - blipAngle).abs();
      if (diff < 0.2 || diff > 2 * math.pi - 0.2) {
        canvas.drawCircle(
          blipPos,
          3,
          Paint()
            ..color = color
            ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 2),
        );
      } else {
        canvas.drawCircle(
          blipPos,
          2,
          Paint()..color = color.withValues(alpha: 0.1),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
