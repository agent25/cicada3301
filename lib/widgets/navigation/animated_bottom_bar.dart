import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

class AnimatedBottomBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AnimatedBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<AnimatedBottomBar> createState() => _AnimatedBottomBarState();
}

class _AnimatedBottomBarState extends State<AnimatedBottomBar>
    with SingleTickerProviderStateMixin {
  final List<String> _icons = [
    'assets/icons/home.svg',
    'assets/icons/categories.svg',
    'assets/icons/cart.svg',
    'assets/icons/profile.svg',
  ];

  final List<String> _labels = ['OS_CORE', 'DIAGS', 'VAULT_X', 'OP_BIO'];

  late AnimationController _controller;
  late AnimationController _flickerController; // New for neon flicker
  late Animation<double> _positionAnimation;
  late Animation<double> _widthAnimation;

  int _lastIndex = 0;

  @override
  void initState() {
    super.initState();
    _lastIndex = widget.currentIndex;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _flickerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _initAnimations();
  }

  void _initAnimations() {
    _positionAnimation =
        Tween<double>(
          begin: _lastIndex.toDouble(),
          end: widget.currentIndex.toDouble(),
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
          ),
        );

    _widthAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 1.5,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 30, // Optimized weight for snappier stretch
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.5,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 70,
      ),
    ]).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant AnimatedBottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _lastIndex = oldWidget.currentIndex;
      _initAnimations();
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _flickerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double paddingBottom = MediaQuery.of(context).padding.bottom;
    const double barHeight = 65.0; // Increased height for tech brackets

    return Container(
      height: barHeight + paddingBottom,
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0B), // Deeper Black
        border: Border(
          top: BorderSide(
            color: const Color(0xFF00FF9D).withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.9),
            blurRadius: 40,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double totalWidth = constraints.maxWidth;
          final double itemWidth = totalWidth / _icons.length;
          final double pillBaseWidth = itemWidth * 0.7;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              // Technical Neon Indicator (Digital Scanline)
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final double pos = _positionAnimation.value;
                  final double widthMult = _widthAnimation.value;
                  final double currentWidth = pillBaseWidth * widthMult;

                  return Positioned(
                    left:
                        (pos * itemWidth) +
                        (itemWidth / 2) -
                        (currentWidth / 2),
                    top: 0,
                    height: 2,
                    width: currentWidth,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF00FF9D),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF00FF9D,
                            ).withValues(alpha: 0.6),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              // Interaction Layer
              Padding(
                padding: EdgeInsets.only(bottom: paddingBottom),
                child: Row(
                  children: List.generate(_icons.length, (index) {
                    final isSelected = widget.currentIndex == index;
                    final color = isSelected
                        ? const Color(0xFF00FF9D)
                        : const Color(0xFF333336);

                    return Expanded(
                      child: GestureDetector(
                        onTap: () => widget.onTap(index),
                        behavior: HitTestBehavior.opaque,
                        child: AnimatedBuilder(
                          animation: _flickerController,
                          builder: (context, child) {
                            final flicker = isSelected
                                ? (0.8 +
                                      0.2 *
                                          math.sin(
                                            _flickerController.value *
                                                2 *
                                                math.pi,
                                          ))
                                : 1.0;

                            return Opacity(
                              opacity: flicker,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Icon with Brackets
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      if (isSelected)
                                        Text(
                                          " [       ] ",
                                          style: TextStyle(
                                            color: color.withValues(alpha: 0.3),
                                            fontSize: 24,
                                            fontWeight: FontWeight.w100,
                                            fontFamily: 'monospace',
                                          ),
                                        ),
                                      AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        padding: EdgeInsets.all(
                                          isSelected ? 2 : 0,
                                        ),
                                        child: SvgPicture.asset(
                                          _icons[index],
                                          width: 18,
                                          height: 18,
                                          colorFilter: ColorFilter.mode(
                                            color,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  // Label
                                  Text(
                                    _labels[index],
                                    style: TextStyle(
                                      color: color,
                                      fontSize: 8,
                                      fontWeight: isSelected
                                          ? FontWeight.w900
                                          : FontWeight.bold,
                                      letterSpacing: 2,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
