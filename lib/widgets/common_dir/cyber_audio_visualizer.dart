import 'dart:math' as math;
import 'package:flutter/material.dart';

class CyberAudioVisualizer extends StatefulWidget {
  final Color accentColor;
  const CyberAudioVisualizer({
    super.key,
    this.accentColor = const Color(0xFFFBBF24),
  });

  @override
  State<CyberAudioVisualizer> createState() => _CyberAudioVisualizerState();
}

class _CyberAudioVisualizerState extends State<CyberAudioVisualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final math.Random _random = math.Random();
  final List<double> _barHeights = List.generate(24, (_) => 5.0);

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 100),
          )
          ..addListener(() {
            setState(() {
              for (int i = 0; i < _barHeights.length; i++) {
                _barHeights[i] = 5 + _random.nextDouble() * 45;
              }
            });
          })
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CustomPaint(
        painter: _VisualizerPainter(
          heights: _barHeights,
          color: widget.accentColor,
        ),
      ),
    );
  }
}

class _VisualizerPainter extends CustomPainter {
  final List<double> heights;
  final Color color;

  _VisualizerPainter({required this.heights, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final double barWidth = 4.0;
    final double spacing = 3.0;
    final double totalBarWidth = barWidth + spacing;
    final double startX = (size.width - (heights.length * totalBarWidth)) / 2;

    for (int i = 0; i < heights.length; i++) {
      final double x = startX + i * totalBarWidth;
      final double h = heights[i];

      // Main bar
      paint.color = color.withValues(alpha: i % 3 == 0 ? 0.8 : 0.3);
      final RRect rrect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, size.height - h, barWidth, h),
        const Radius.circular(1),
      );
      canvas.drawRRect(rrect, paint);

      // Glow effect for some bars
      if (i % 6 == 0) {
        final glowPaint = Paint()
          ..color = color.withValues(alpha: 0.2)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
        canvas.drawRRect(rrect, glowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _VisualizerPainter oldDelegate) => true;
}
