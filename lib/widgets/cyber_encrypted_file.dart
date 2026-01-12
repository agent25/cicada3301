import 'dart:async';
import 'package:flutter/material.dart';

class CyberEncryptedFile extends StatefulWidget {
  final String fileName;
  final String size;
  final int securityLevel;
  final VoidCallback? onOpen;

  const CyberEncryptedFile({
    super.key,
    required this.fileName,
    required this.size,
    required this.securityLevel,
    this.onOpen,
  });

  @override
  State<CyberEncryptedFile> createState() => _CyberEncryptedFileState();
}

class _CyberEncryptedFileState extends State<CyberEncryptedFile> {
  double _progress = 0.0;
  bool _isDecrypting = false;
  bool _isUnlocked = false;

  void _startDecryption() {
    if (_isUnlocked || _isDecrypting) return;
    setState(() => _isDecrypting = true);

    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _progress += 0.02;
        if (_progress >= 1.0) {
          _progress = 1.0;
          _isUnlocked = true;
          _isDecrypting = false;
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = _getSecurityColor();

    return GestureDetector(
      onTap: _isUnlocked ? widget.onOpen : null,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _isUnlocked
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.white.withValues(alpha: 0.02),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: _isUnlocked
                ? const Color(0xFF6EE7B7).withValues(alpha: 0.3)
                : color.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  _isUnlocked ? Icons.lock_open_outlined : Icons.lock_outline,
                  color: _isUnlocked
                      ? const Color(0xFF6EE7B7)
                      : color.withValues(alpha: 0.5),
                  size: 24,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.fileName.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          fontFamily: 'monospace',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _isUnlocked
                            ? "НАТЖМИТЕ, ЧТОБЫ ОТКРЫТЬ ПАКЕТ"
                            : "ПАКЕТ_ДАННЫХ // РАЗМЕР: ${widget.size}",
                        style: TextStyle(
                          color: _isUnlocked
                              ? const Color(0xFF6EE7B7).withValues(alpha: 0.5)
                              : Colors.white.withValues(alpha: 0.2),
                          fontSize: 8,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
                if (!_isUnlocked && !_isDecrypting)
                  _buildActionLabel("ВЗЛОМАТЬ", color, _startDecryption)
                else if (_isDecrypting)
                  _buildActionLabel(
                    "${(_progress * 100).toInt()}%",
                    color,
                    null,
                  )
                else
                  const Icon(Icons.check, color: Color(0xFF6EE7B7), size: 16),
              ],
            ),
            if (_isDecrypting) ...[
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: _progress,
                backgroundColor: Colors.white10,
                valueColor: AlwaysStoppedAnimation(color),
                minHeight: 1,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionLabel(String label, Color color, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: color.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 8,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
          ),
        ),
      ),
    );
  }

  Color _getSecurityColor() {
    if (widget.securityLevel >= 4) return const Color(0xFFF87171); // Red
    if (widget.securityLevel >= 3) return const Color(0xFFC4B5FD); // Purple
    return const Color(0xFF7DD3FC); // Sky
  }
}
