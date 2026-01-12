import 'package:flutter/material.dart';

class CyberTheme {
  // Primary Palette
  static const Color neonGreen = Color(0xFF00FF9D);
  static const Color matrixGreen = Color(0xFF6EE7B7);
  static const Color skyCyan = Color(0xFF7DD3FC);
  static const Color neuralPurple = Color(0xFFC4B5FD);
  static const Color warningAmber = Color(0xFFFBBF24);
  static const Color alertRed = Color(0xFFF87171);

  // Backgrounds
  static const Color darkBackground = Color(0xFF0A0A0B);
  static const Color terminalBackground = Color(0xFF121214);
  static const Color surfaceOverlay = Colors.white10;

  // Text Styles
  static const TextStyle monospaceLabel = TextStyle(
    fontFamily: 'monospace',
    letterSpacing: 2,
    fontSize: 10,
  );

  static const TextStyle glitchTitle = TextStyle(
    fontFamily: 'monospace',
    letterSpacing: 4,
    fontWeight: FontWeight.w900,
  );
}
