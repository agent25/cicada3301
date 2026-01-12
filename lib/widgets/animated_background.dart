import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;
  const AnimatedBackground({super.key, required this.child});

  static AnimatedBackgroundState? of(BuildContext context) {
    return context.findAncestorStateOfType<AnimatedBackgroundState>();
  }

  @override
  State<AnimatedBackground> createState() => AnimatedBackgroundState();
}

class AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _glitchController;

  Offset _mousePos = Offset.zero;
  Offset _touchPosition = Offset.zero;
  Offset _targetTouchPosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _glitchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _startGlitchLoop();
  }

  void triggerGlitch() {
    if (mounted) {
      _glitchController.forward(from: 0.0);
    }
  }

  void _startGlitchLoop() async {
    while (mounted) {
      await Future.delayed(Duration(seconds: 3 + math.Random().nextInt(7)));
      if (mounted) {
        triggerGlitch();
      }
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _glitchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0B),
      body: MouseRegion(
        onHover: (event) {
          setState(() {
            _mousePos = Offset(
              (event.localPosition.dx / MediaQuery.of(context).size.width) -
                  0.5,
              (event.localPosition.dy / MediaQuery.of(context).size.height) -
                  0.5,
            );
            _targetTouchPosition = event.localPosition;
          });
        },
        child: Listener(
          onPointerMove: (event) =>
              setState(() => _targetTouchPosition = event.localPosition),
          onPointerDown: (event) =>
              setState(() => _targetTouchPosition = event.localPosition),
          child: Stack(
            children: [
              // --- Parallax Layer 1: Grid ---
              AnimatedBuilder(
                animation: _mainController,
                builder: (context, child) {
                  return Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateX(0.8)
                      ..setTranslationRaw(
                        _mousePos.dx * 20,
                        _mousePos.dy * 20,
                        0,
                      ),
                    alignment: Alignment.center,
                    child: CustomPaint(
                      size: Size.infinite,
                      painter: _GridPainter(progress: _mainController.value),
                    ),
                  );
                },
              ),

              // --- Parallax Layer 2: HUD Data Rain ---
              AnimatedBuilder(
                animation: _mainController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_mousePos.dx * 50, _mousePos.dy * 50),
                    child: CustomPaint(
                      size: Size.infinite,
                      painter: _DataRainPainter(
                        progress: _mainController.value,
                      ),
                    ),
                  );
                },
              ),

              // --- Parallax Layer 3: Main HUD ---
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: Listenable.merge([
                    _mainController,
                    _glitchController,
                  ]),
                  builder: (context, child) {
                    _touchPosition = Offset(
                      lerpDouble(
                            _touchPosition.dx,
                            _targetTouchPosition.dx,
                            0.1,
                          ) ??
                          _touchPosition.dx,
                      lerpDouble(
                            _touchPosition.dy,
                            _targetTouchPosition.dy,
                            0.1,
                          ) ??
                          _touchPosition.dy,
                    );

                    return Transform.translate(
                      offset: Offset(_mousePos.dx * 80, _mousePos.dy * 80),
                      child: CustomPaint(
                        painter: CyberHUDPainter(
                          progress: _mainController.value,
                          glitchProgress: _glitchController.value,
                          touchPosition: _touchPosition,
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Content
              widget.child,

              // Decorative Brackets
              const _HUDFrameDecoration(),
            ],
          ),
        ),
      ),
    );
  }
}

class CyberHUDPainter extends CustomPainter {
  final double progress;
  final double glitchProgress;
  final Offset touchPosition;

  CyberHUDPainter({
    required this.progress,
    required this.glitchProgress,
    required this.touchPosition,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint gridPaint = Paint()
      ..color = const Color(0xFF1A1A1C)
      ..strokeWidth = 1.0;

    final Paint accentPaint = Paint()
      ..color = const Color(0xFF00FF9D).withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // --- 1. Perspective Grid ---
    _drawPerspectiveGrid(canvas, size, gridPaint);

    // --- 2. Floating Technical Frames ---
    _drawHUDFrames(canvas, size, accentPaint);

    // --- 3. Scanning Line ---
    _drawScanLines(canvas, size);

    // --- 4. Glitch Overlay ---
    if (glitchProgress > 0 && glitchProgress < 1) {
      _drawGlitchEffect(canvas, size);
    }

    // --- 5. Interactive Cursor HUD ---
    _drawCursorHUD(canvas, touchPosition, accentPaint);
  }

  void _drawPerspectiveGrid(Canvas canvas, Size size, Paint paint) {
    final double midX = size.width / 2;
    final double horizonY = size.height * 0.4;
    final int lines = 12;

    // Vertical lines with perspective
    for (int i = 0; i <= lines; i++) {
      final double xOffset = (i / lines - 0.5) * size.width * 2.5;
      canvas.drawLine(
        Offset(midX + xOffset, size.height),
        Offset(midX + xOffset * 0.1, horizonY),
        paint..color = const Color(0xFF1A1A1C).withValues(alpha: 0.5),
      );
    }

    // Horizontal moving lines
    final double gridProgress = (progress * 5) % 1.0;
    for (int i = 0; i < 10; i++) {
      final double yPos =
          horizonY +
          (size.height - horizonY) * math.pow((i + gridProgress) / 10, 2);
      final double opacity = math.pow((i + gridProgress) / 10, 2).toDouble();
      canvas.drawLine(
        Offset(0, yPos),
        Offset(size.width, yPos),
        paint..color = const Color(0xFF1A1A1C).withValues(alpha: 0.8 * opacity),
      );
    }
  }

  void _drawHUDFrames(Canvas canvas, Size size, Paint paint) {
    final double t = progress * 2 * math.pi;

    // Static Brackets in corners
    const double margin = 40;
    const double len = 20;

    void drawBracket(Offset p, bool top, bool left) {
      final double dx = left ? 1 : -1;
      final double dy = top ? 1 : -1;
      canvas.drawLine(p, p + Offset(len * dx, 0), paint);
      canvas.drawLine(p, p + Offset(0, len * dy), paint);
    }

    drawBracket(const Offset(margin, margin), true, true);
    drawBracket(Offset(size.width - margin, margin), true, false);
    drawBracket(Offset(margin, size.height - 120), false, true);
    drawBracket(Offset(size.width - margin, size.height - 120), false, false);

    // Floating technical circles
    final circlePaint = Paint()
      ..color = const Color(0xFF00FF9D).withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.5),
      200 + 20 * math.sin(t),
      circlePaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.5),
      180 - 10 * math.cos(t * 0.5),
      circlePaint,
    );
  }

  void _drawScanLines(Canvas canvas, Size size) {
    final double scanY = (progress * 3 * size.height) % size.height;
    final scanPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          const Color(0xFF00FF9D).withValues(alpha: 0.05),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, scanY - 50, size.width, 100));

    canvas.drawRect(Rect.fromLTWH(0, scanY - 50, size.width, 100), scanPaint);
  }

  void _drawGlitchEffect(Canvas canvas, Size size) {
    final rand = math.Random((glitchProgress * 10).floor());
    final glitchPaint = Paint()
      ..color = const Color(0xFFFF006B).withValues(alpha: 0.2);

    for (int i = 0; i < 5; i++) {
      final double h = rand.nextDouble() * 20 + 2;
      final double y = rand.nextDouble() * size.height;
      final double x = rand.nextDouble() * 40 - 20;
      canvas.drawRect(Rect.fromLTWH(x, y, size.width, h), glitchPaint);
    }
  }

  void _drawCursorHUD(Canvas canvas, Offset p, Paint paint) {
    final dashPaint = Paint()
      ..color = const Color(0xFF00FF9D).withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawCircle(p, 30, dashPaint);
    canvas.drawLine(
      p - const Offset(40, 0),
      p - const Offset(10, 0),
      dashPaint,
    );
    canvas.drawLine(
      p + const Offset(10, 0),
      p + const Offset(40, 0),
      dashPaint,
    );
    canvas.drawLine(
      p - const Offset(0, 40),
      p - const Offset(0, 10),
      dashPaint,
    );
    canvas.drawLine(
      p + const Offset(0, 10),
      p + const Offset(0, 40),
      dashPaint,
    );
  }

  @override
  bool shouldRepaint(CyberHUDPainter oldDelegate) => true;
}

class _DataRainPainter extends CustomPainter {
  final double progress;
  _DataRainPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final rand = math.Random(42);
    final paint = Paint()
      ..color = const Color(0xFF6EE7B7).withValues(alpha: 0.03);

    for (int i = 0; i < 30; i++) {
      final x = rand.nextDouble() * size.width;
      final yBase =
          (rand.nextDouble() * size.height + progress * 500) % size.height;

      for (int j = 0; j < 5; j++) {
        final y = (yBase + j * 15) % size.height;
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _HUDFrameDecoration extends StatelessWidget {
  const _HUDFrameDecoration();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          _buildBracket(Alignment.topLeft),
          _buildBracket(Alignment.topRight),
          _buildBracket(Alignment.bottomLeft),
          _buildBracket(Alignment.bottomRight),
        ],
      ),
    );
  }

  Widget _buildBracket(Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Container(
        width: 60,
        height: 60,
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border(
            top: alignment.y < 0
                ? const BorderSide(color: Colors.white10, width: 1.5)
                : BorderSide.none,
            bottom: alignment.y > 0
                ? const BorderSide(color: Colors.white10, width: 1.5)
                : BorderSide.none,
            left: alignment.x < 0
                ? const BorderSide(color: Colors.white10, width: 1.5)
                : BorderSide.none,
            right: alignment.x > 0
                ? const BorderSide(color: Colors.white10, width: 1.5)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  final double progress;
  _GridPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF6EE7B7).withValues(alpha: 0.05)
      ..strokeWidth = 0.5;

    final double spacing = 40;
    for (double i = -size.width; i < size.width * 2; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = -size.height; i < size.height * 2; i += spacing) {
      canvas.drawLine(Offset(-size.width, i), Offset(size.width * 2, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
