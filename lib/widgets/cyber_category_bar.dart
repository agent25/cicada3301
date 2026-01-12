import 'package:flutter/material.dart';

class CyberCategoryBar extends StatefulWidget {
  final List<String> categories;
  final Function(int) onSelected;

  const CyberCategoryBar({
    super.key,
    required this.categories,
    required this.onSelected,
  });

  @override
  State<CyberCategoryBar> createState() => _CyberCategoryBarState();
}

class _CyberCategoryBarState extends State<CyberCategoryBar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: widget.categories.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedIndex = index);
              widget.onSelected(index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF6EE7B7).withValues(alpha: 0.1)
                    : Colors.white.withValues(alpha: 0.02),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF6EE7B7).withValues(alpha: 0.4)
                      : Colors.white.withValues(alpha: 0.05),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.categories[index].toUpperCase(),
                    style: TextStyle(
                      color: isSelected
                          ? const Color(0xFF6EE7B7)
                          : Colors.white24,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      fontFamily: 'monospace',
                    ),
                  ),
                  if (isSelected)
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      width: 20,
                      height: 1,
                      color: const Color(0xFF6EE7B7),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
