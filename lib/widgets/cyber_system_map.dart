import 'dart:math' as math;
import 'package:flutter/material.dart';

class CyberSystemMap extends StatefulWidget {
  final Color accentColor;
  const CyberSystemMap({super.key, this.accentColor = const Color(0xFFC4B5FD)});

  @override
  State<CyberSystemMap> createState() => _CyberSystemMapState();
}

class _CyberSystemMapState extends State<CyberSystemMap>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Offset> _nodes = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _generateNodes();
  }

  void _generateNodes() {
    for (int i = 0; i < 8; i++) {
      _nodes.add(Offset(_random.nextDouble(), _random.nextDouble()));
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
      height: 250,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.01),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: widget.accentColor.withValues(alpha: 0.05)),
      ),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            size: Size.infinite,
            painter: _MapPainter(
              nodes: _nodes,
              progress: _controller.value,
              color: widget.accentColor,
            ),
          );
        },
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  final List<Offset> nodes;
  final double progress;
  final Color color;

  _MapPainter({
    required this.nodes,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paintNode = Paint()..color = color;
    final paintLine = Paint()
      ..color = color.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    // Draw lines first (back)
    for (int i = 0; i < nodes.length; i++) {
      for (int j = i + 1; j < nodes.length; j++) {
        final dist = (nodes[i] - nodes[j]).distance;
        if (dist < 0.4) {
          canvas.drawLine(
            Offset(nodes[i].dx * size.width, nodes[i].dy * size.height),
            Offset(nodes[j].dx * size.width, nodes[j].dy * size.height),
            paintLine..color = color.withValues(alpha: 0.15 * (1 - dist / 0.4)),
          );
        }
      }
    }

    // Draw nodes
    for (var node in nodes) {
      final pos = Offset(node.dx * size.width, node.dy * size.height);
      final pulseRadius = 4 + (progress * 6);

      canvas.drawCircle(
        pos,
        pulseRadius,
        Paint()..color = color.withValues(alpha: 0.1 * (1 - progress)),
      );
      canvas.drawCircle(pos, 2, paintNode);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
