import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/stegano_format.dart';

class CyberSteganoTool extends StatefulWidget {
  const CyberSteganoTool({super.key});

  @override
  State<CyberSteganoTool> createState() => _CyberSteganoToolState();
}

class _CyberSteganoToolState extends State<CyberSteganoTool> {
  final TextEditingController _inputController = TextEditingController();
  SteganoFormat _sourceFormat = SteganoFormat.text;
  SteganoFormat _targetFormat = SteganoFormat.base64;
  String _output = "";
  String _error = "";

  void _convert() {
    setState(() {
      _error = "";
      try {
        String input = _inputController.text;
        if (input.isEmpty) {
          _output = "";
          return;
        }

        // 1. Convert Source to Plain Text
        String plainText = "";
        switch (_sourceFormat) {
          case SteganoFormat.text:
            plainText = input;
            break;
          case SteganoFormat.base64:
            plainText = utf8.decode(base64.decode(input.trim()));
            break;
          case SteganoFormat.hex:
            plainText = _hexToText(input.replaceAll(" ", ""));
            break;
          case SteganoFormat.decimal:
            plainText = _decToText(input);
            break;
          case SteganoFormat.binary:
            plainText = _binToText(input.replaceAll(" ", ""));
            break;
          case SteganoFormat.rot13:
            plainText = _applyRot13(input);
            break;
        }

        // 2. Convert Plain Text to Target
        switch (_targetFormat) {
          case SteganoFormat.text:
            _output = plainText;
            break;
          case SteganoFormat.base64:
            _output = base64.encode(utf8.encode(plainText));
            break;
          case SteganoFormat.hex:
            _output = _textToHex(plainText);
            break;
          case SteganoFormat.decimal:
            _output = _textToDec(plainText);
            break;
          case SteganoFormat.binary:
            _output = _textToBin(plainText);
            break;
          case SteganoFormat.rot13:
            _output = _applyRot13(plainText);
            break;
        }
      } catch (e) {
        _error = "[ОШИБКА ДЕКОДИРОВАНИЯ]: ПРОВЕРЬТЕ ФОРМАТ ВВОДА";
        _output = "";
      }
    });
  }

  String _hexToText(String hex) {
    List<int> bytes = [];
    for (int i = 0; i < hex.length; i += 2) {
      bytes.add(int.parse(hex.substring(i, i + 2), radix: 16));
    }
    return utf8.decode(bytes);
  }

  String _textToHex(String text) {
    return utf8
        .encode(text)
        .map((e) => e.toRadixString(16).padLeft(2, '0'))
        .join(' ');
  }

  String _decToText(String dec) {
    return String.fromCharCodes(
      dec.split(RegExp(r'[\s,]+')).map((e) => int.parse(e)),
    );
  }

  String _textToDec(String text) {
    return text.runes.join(' ');
  }

  String _binToText(String bin) {
    List<int> bytes = [];
    for (int i = 0; i < bin.length; i += 8) {
      bytes.add(int.parse(bin.substring(i, i + 8), radix: 2));
    }
    return utf8.decode(bytes);
  }

  String _textToBin(String text) {
    return utf8
        .encode(text)
        .map((e) => e.toRadixString(2).padLeft(8, '0'))
        .join(' ');
  }

  String _applyRot13(String input) {
    var buffer = StringBuffer();
    for (var i = 0; i < input.length; i++) {
      var char = input.codeUnitAt(i);
      if (char >= 65 && char <= 90) {
        char = (char - 65 + 13) % 26 + 65;
      } else if (char >= 97 && char <= 122) {
        char = (char - 97 + 13) % 26 + 97;
      }
      buffer.writeCharCode(char);
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "ИНСТРУМЕНТ СТЕГАНОГРАФИИ // v1.0",
            style: TextStyle(
              color: Color(0xFFC4B5FD),
              fontSize: 10,
              letterSpacing: 2,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 16),
          // Format Selectors
          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  "ИЗ",
                  _sourceFormat,
                  (v) => setState(() => _sourceFormat = v!),
                ),
              ),
              const Icon(Icons.arrow_forward, color: Colors.white24, size: 16),
              Expanded(
                child: _buildDropdown(
                  "В",
                  _targetFormat,
                  (v) => setState(() => _targetFormat = v!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Input
          TextField(
            controller: _inputController,
            onChanged: (_) => _convert(),
            maxLines: 3,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontFamily: 'monospace',
            ),
            decoration: InputDecoration(
              hintText: "ВВЕДИТЕ ДАННЫЕ ДЛЯ ПРЕОБРАЗОВАНИЯ...",
              hintStyle: const TextStyle(color: Colors.white10),
              filled: true,
              fillColor: Colors.black26,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          if (_error.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              _error,
              style: const TextStyle(
                color: Color(0xFFF87171),
                fontSize: 10,
                fontFamily: 'monospace',
              ),
            ),
          ],
          const SizedBox(height: 20),
          // Output
          const Text(
            "РЕЗУЛЬТАТ:",
            style: TextStyle(
              color: Colors.white24,
              fontSize: 9,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(2),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: SelectableText(
              _output.isEmpty ? "..." : _output,
              style: TextStyle(
                color: _output.isEmpty
                    ? Colors.white10
                    : const Color(0xFF6EE7B7),
                fontSize: 14,
                fontFamily: 'monospace',
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Actions
          Row(
            children: [
              _buildActionButton("КОПИРОВАТЬ", () {
                Clipboard.setData(ClipboardData(text: _output));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("СКОПИРОВАНО В БУФЕР"),
                    duration: Duration(seconds: 1),
                  ),
                );
              }),
              const SizedBox(width: 8),
              _buildActionButton("СБРОС", () {
                _inputController.clear();
                setState(() => _output = "");
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    SteganoFormat current,
    Function(SteganoFormat?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white24, fontSize: 8)),
        DropdownButton<SteganoFormat>(
          value: current,
          isExpanded: true,
          dropdownColor: const Color(0xFF1E1E22),
          underline: Container(),
          icon: const Icon(Icons.unfold_more, color: Colors.white24, size: 14),
          items: SteganoFormat.values.map((f) {
            return DropdownMenuItem(
              value: f,
              child: Text(
                f.name.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontFamily: 'monospace',
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildActionButton(String label, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white10),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 10,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
