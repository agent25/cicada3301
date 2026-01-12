import 'package:flutter/material.dart';

class CyberBiometricScanner extends StatefulWidget {
  final VoidCallback onAuthenticated;
  final Color accentColor;

  const CyberBiometricScanner({
    super.key,
    required this.onAuthenticated,
    this.accentColor = const Color(0xFFC4B5FD),
  });

  @override
  State<CyberBiometricScanner> createState() => _CyberBiometricScannerState();
}

class _CyberBiometricScannerState extends State<CyberBiometricScanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isScanning = false;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startScan() {
    setState(() {
      _isScanning = true;
      _isSuccess = false;
    });
    _controller.forward(from: 0).then((_) {
      if (mounted) {
        setState(() {
          _isScanning = false;
          _isSuccess = true;
        });
        widget.onAuthenticated();
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) setState(() => _isSuccess = false);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _startScan(),
      onTapUp: (_) {
        if (_isScanning) {
          _controller.stop();
          setState(() => _isScanning = false);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 120,
            height: 160,
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isSuccess
                    ? Colors.greenAccent.withValues(alpha: 0.5)
                    : widget.accentColor.withValues(alpha: 0.2),
                width: 2,
              ),
              boxShadow: [
                if (_isScanning)
                  BoxShadow(
                    color: widget.accentColor.withValues(alpha: 0.2),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Fingerprint Icon (Static)
                Icon(
                  Icons.fingerprint,
                  size: 80,
                  color: _isSuccess
                      ? Colors.greenAccent
                      : (_isScanning
                            ? widget.accentColor
                            : widget.accentColor.withValues(alpha: 0.2)),
                ),

                // Scanning Laser
                if (_isScanning)
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Positioned(
                        top: _controller.value * 160,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 2,
                          decoration: BoxDecoration(
                            color: widget.accentColor,
                            boxShadow: [
                              BoxShadow(
                                color: widget.accentColor,
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                if (_isSuccess)
                  const Center(
                    child: Icon(
                      Icons.check_circle_outline,
                      color: Colors.greenAccent,
                      size: 40,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _isSuccess
                ? "ДОСТУП РАЗРЕШЕН"
                : (_isScanning ? "СКАНИРОВАНИЕ..." : "БИОМЕТРИЧЕСКИЙ ВХОД"),
            style: TextStyle(
              color: _isSuccess
                  ? Colors.greenAccent
                  : widget.accentColor.withValues(alpha: 0.6),
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
