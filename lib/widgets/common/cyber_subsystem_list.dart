import 'package:flutter/material.dart';

class CyberSubsystemList extends StatelessWidget {
  final Map<String, double> subsystems;
  final Function(String) onToggle;

  const CyberSubsystemList({
    super.key,
    required this.subsystems,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: subsystems.entries.map((entry) {
        final health = entry.value;
        final isWarning = health < 0.6;
        final color = isWarning
            ? const Color(0xFFFBBF24)
            : const Color(0xFF6EE7B7);

        return GestureDetector(
          onTap: () => onToggle(entry.key),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.02),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: color.withValues(alpha: 0.05)),
            ),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.key.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          fontFamily: 'monospace',
                        ),
                      ),
                      const SizedBox(height: 2),
                      LinearProgressIndicator(
                        value: health,
                        backgroundColor: Colors.white12,
                        valueColor: AlwaysStoppedAnimation(
                          color.withValues(alpha: 0.6),
                        ),
                        minHeight: 2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  "${(health * 100).toInt()}%",
                  style: TextStyle(
                    color: color.withValues(alpha: 0.9),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
