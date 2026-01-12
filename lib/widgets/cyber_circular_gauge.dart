import 'dart:math' as math;
import 'package:flutter/material.dart';

class CyberCircularGauge extends StatelessWidget {
  final double value; // 0.0 to 1.0
  final String label;
  final Color accentColor;

  const CyberCircularGauge({
    super.key,
    required this.value,
    required this.label,
    this.accentColor = const Color(0xFF6EE7B7),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 140,
      padding: const EdgeInsets.all(10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(120, 120),
            painter: _GaugePainter(value: value, accentColor: accentColor),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${(value * 100).toInt()}%",
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'monospace',
                ),
              ),
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.3),
                  fontSize: 8,
                  letterSpacing: 1,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double value;
  final Color accentColor;

  _GaugePainter({required this.value, required this.accentColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final bgPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final activePaint = Paint()
      ..color = accentColor.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.square;

    final tickPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..strokeWidth = 1;

    // Background track
    canvas.drawCircle(center, radius, bgPaint);

    // Active track
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * value,
      false,
      activePaint..maskFilter = MaskFilter.blur(BlurStyle.solid, 2),
    );

    // Precise Tick Marks
    for (int i = 0; i < 60; i++) {
      final angle = (i * 6 * math.pi / 180) - math.pi / 2;
      final isMajor = i % 5 == 0;
      final startRadius = radius + (isMajor ? 8 : 4);
      final endRadius = radius + 2;

      final startPos =
          center +
          Offset(math.cos(angle) * startRadius, math.sin(angle) * startRadius);
      final endPos =
          center +
          Offset(math.cos(angle) * endRadius, math.sin(angle) * endRadius);

      canvas.drawLine(
        startPos,
        endPos,
        tickPaint
          ..color = isMajor
              ? Colors.white.withValues(alpha: 0.2)
              : Colors.white.withValues(alpha: 0.05),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
