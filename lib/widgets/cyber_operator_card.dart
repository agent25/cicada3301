import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:math' as math;

class CyberOperatorCard extends StatefulWidget {
  const CyberOperatorCard({super.key});

  @override
  State<CyberOperatorCard> createState() => _CyberOperatorCardState();
}

class _CyberOperatorCardState extends State<CyberOperatorCard> {
  Timer? _pulseTimer;
  int _pulse = 72;
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _pulseTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _pulse = 70 + _random.nextInt(6); // 70-75 BPM
        });
      }
    });
  }

  @override
  void dispose() {
    _pulseTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF141416),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          // Header / ID Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.02),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "ID_ОПЕРАТОРА // A-992-X",
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 10,
                    letterSpacing: 2,
                    fontFamily: 'monospace',
                  ),
                ),
                _buildStatusDot(),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar Placeholder
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.03),
                    border: Border.all(
                      color: const Color(0xFF7DD3FC).withValues(alpha: 0.2),
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    Icons.person_outline,
                    size: 40,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "GHOST_PROTOCOL",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "ДОСТУП: УРОВЕНЬ_05 / ПЕРЕХВАТ",
                        style: TextStyle(
                          color: const Color(0xFFC4B5FD).withValues(alpha: 0.8),
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildBiometricRow("ПУЛЬС", "$_pulse УВМ"),
                      _buildBiometricRow("СТРЕСС", "НОРМА"),
                      _buildBiometricRow("НЕЙРО", "СТАБИЛЬНО"),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(color: Colors.white10),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat("СЕССИИ", "142"),
                _buildStat("КАНАЛЫ", "12k"),
                _buildStat("ВЗЛОМЫ", "0"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusDot() {
    return Container(
      width: 12,
      height: 12,
      decoration: const BoxDecoration(
        color: Color(0xFF6EE7B7),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildBiometricRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white24,
              fontSize: 8,
              fontFamily: 'monospace',
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 8,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white24,
            fontSize: 8,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}
