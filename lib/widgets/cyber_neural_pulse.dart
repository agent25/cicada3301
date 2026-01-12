import 'dart:math' as math;
import 'package:flutter/material.dart';

class CyberNeuralPulse extends StatefulWidget {
  final Color accentColor;
  const CyberNeuralPulse({
    super.key,
    this.accentColor = const Color(0xFF6EE7B7),
  });

  @override
  State<CyberNeuralPulse> createState() => _CyberNeuralPulseState();
}

class _CyberNeuralPulseState extends State<CyberNeuralPulse>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: widget.accentColor.withValues(alpha: 0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              size: Size.infinite,
              painter: _PulsePainter(
                progress: _controller.value,
                color: widget.accentColor,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PulsePainter extends CustomPainter {
  final double progress;
  final Color color;

  _PulsePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path();
    final centerY = size.height / 2;

    for (double x = 0; x <= size.width; x += 1) {
      final normalizedX = x / size.width;
      final wave1 =
          math.sin((normalizedX * 4 * math.pi) + (progress * 2 * math.pi)) * 20;
      final wave2 =
          math.cos((normalizedX * 2 * math.pi) - (progress * 4 * math.pi)) * 10;

      final y = centerY + wave1 + wave2;

      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(
      path,
      paint..maskFilter = const MaskFilter.blur(BlurStyle.solid, 1),
    );

    // Gradient overlay for technical look
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          color.withValues(alpha: 0.1),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      gradientPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
