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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
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
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(24, (index) {
              final h = 5 + _random.nextDouble() * 45;
              return Container(
                width: 4,
                height: h,
                margin: const EdgeInsets.symmetric(horizontal: 1.5),
                decoration: BoxDecoration(
                  color: widget.accentColor.withValues(
                    alpha: index % 3 == 0 ? 0.8 : 0.3,
                  ),
                  borderRadius: BorderRadius.circular(1),
                  boxShadow: [
                    if (index % 6 == 0)
                      BoxShadow(
                        color: widget.accentColor.withValues(alpha: 0.4),
                        blurRadius: 10,
                      ),
                  ],
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
