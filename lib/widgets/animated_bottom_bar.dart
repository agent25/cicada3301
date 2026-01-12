import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

  final List<String> _labels = ['Home', 'Menu', 'Cart', 'User'];

  late AnimationController _controller;
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double paddingBottom = MediaQuery.of(context).padding.bottom;
    const double barHeight = 56.0; // More compact height

    return Container(
      height: barHeight + paddingBottom,
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F11), // Matte Carbon Black
        border: Border(
          top: BorderSide(
            color: const Color(
              0xFF00FF9D,
            ).withValues(alpha: 0.2), // Cyber Green Edge
            width: 1.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.8),
            blurRadius: 30,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double totalWidth = constraints.maxWidth;
          final double itemWidth = totalWidth / _icons.length;
          final double pillBaseWidth = itemWidth * 0.8;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              // Technical Neon Indicator
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
                    bottom: paddingBottom + 2.0, // Fixed at bottom
                    height: 4.0, // Sharp line indicator
                    width: currentWidth,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF00FF9D), // Neon Green
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF00FF9D,
                            ).withValues(alpha: 0.8),
                            blurRadius: 15,
                            spreadRadius: 2,
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
                        : const Color(0xFF4A4A4C);

                    return Expanded(
                      child: GestureDetector(
                        onTap: () => widget.onTap(index),
                        behavior: HitTestBehavior.opaque,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: EdgeInsets.all(isSelected ? 4 : 0),
                              child: SvgPicture.asset(
                                _icons[index],
                                width: 20,
                                height: 20,
                                colorFilter: ColorFilter.mode(
                                  color,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 300),
                              style: TextStyle(
                                color: color,
                                fontSize: 9,
                                fontWeight: isSelected
                                    ? FontWeight.w900
                                    : FontWeight.normal,
                                letterSpacing: 1.5,
                                fontFamily: 'monospace',
                              ),
                              child: Text(_labels[index].toUpperCase()),
                            ),
                          ],
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
