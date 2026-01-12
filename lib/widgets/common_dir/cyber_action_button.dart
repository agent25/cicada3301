import 'package:flutter/material.dart';

class CyberActionButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final Color accentColor;

  const CyberActionButton({
    super.key,
    required this.label,
    required this.onTap,
    this.accentColor = const Color(0xFF7DD3FC), // Soft Sky Cyan
  });

  @override
  State<CyberActionButton> createState() => _CyberActionButtonState();
}

class _CyberActionButtonState extends State<CyberActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: _isHovered
                ? widget.accentColor.withValues(alpha: 0.1)
                : const Color(0xFF1F1F23),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: _isHovered
                  ? widget.accentColor.withValues(alpha: 0.5)
                  : Colors.white.withValues(alpha: 0.05),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label.toUpperCase(),
                style: TextStyle(
                  color: _isHovered ? widget.accentColor : Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  fontFamily: 'monospace',
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.chevron_right,
                size: 14,
                color: _isHovered ? widget.accentColor : Colors.white30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
