import 'package:flutter/material.dart';

class CyberSecureKeypad extends StatefulWidget {
  final Function(String) onComplete;

  const CyberSecureKeypad({super.key, required this.onComplete});

  @override
  State<CyberSecureKeypad> createState() => _CyberSecureKeypadState();
}

class _CyberSecureKeypadState extends State<CyberSecureKeypad> {
  String _enteredPin = "";
  bool _isSuccess = false;

  void _handleKeyPress(String key) {
    if (_isSuccess) return;

    setState(() {
      if (key == "X") {
        if (_enteredPin.isNotEmpty) {
          _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
        }
      } else if (key == "#") {
        // Optional submit logic
      } else {
        if (_enteredPin.length < 4) {
          _enteredPin += key;
        }
      }

      if (_enteredPin.length == 4) {
        if (_enteredPin == "1234") {
          _isSuccess = true;
          widget.onComplete(_enteredPin);
        } else {
          // Reset on error after brief pause
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              setState(() => _enteredPin = "");
            }
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F11),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _isSuccess
              ? const Color(0xFF6EE7B7).withValues(alpha: 0.3)
              : Colors.white.withValues(alpha: 0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [_buildDisplay(), const SizedBox(height: 20), _buildGrid()],
      ),
    );
  }

  Widget _buildDisplay() {
    return Container(
      height: 40,
      width: double.infinity,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: _isSuccess
              ? const Color(0xFF6EE7B7).withValues(alpha: 0.5)
              : const Color(0xFF6EE7B7).withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        mainAxisAlignment: _isSuccess
            ? MainAxisAlignment.center
            : MainAxisAlignment.end,
        children: _isSuccess
            ? [
                const Text(
                  "ДОСТУП РАЗРЕШЕН",
                  style: TextStyle(
                    color: Color(0xFF6EE7B7),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    fontFamily: 'monospace',
                  ),
                ),
              ]
            : List.generate(
                4,
                (index) => Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: index < _enteredPin.length
                          ? const Color(0xFF6EE7B7)
                          : Colors.white10,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildGrid() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: List.generate(12, (index) {
        String label = (index + 1).toString();
        if (index == 9) label = "X";
        if (index == 10) label = "0";
        if (index == 11) label = "#";

        return _buildKey(label);
      }),
    );
  }

  Widget _buildKey(String label) {
    return GestureDetector(
      onTap: () => _handleKeyPress(label),
      child: Container(
        width: 50,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1C),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
          ),
        ),
      ),
    );
  }
}
