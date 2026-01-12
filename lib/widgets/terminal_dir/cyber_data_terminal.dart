import 'package:flutter/material.dart';

class CyberDataTerminal extends StatefulWidget {
  final List<String> logs;
  final Function(String)? onCommand;

  const CyberDataTerminal({super.key, required this.logs, this.onCommand});

  @override
  State<CyberDataTerminal> createState() => _CyberDataTerminalState();
}

class _CyberDataTerminalState extends State<CyberDataTerminal> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSubmit(String value) {
    if (value.trim().isEmpty) return;
    widget.onCommand?.call(value);
    _controller.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220, // Slightly taller to fit input
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF121214),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6EE7B7).withValues(alpha: 0.05),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      color: const Color(0xFF6EE7B7),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        "СИСТЕМНЫЙ ТЕРМИНАЛ // ВВОД_АКТИВЕН",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white24,
                          fontSize: 9,
                          letterSpacing: 2,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "УЗЕЛ: 0x8F",
                style: TextStyle(
                  color: Colors.white10,
                  fontSize: 8,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white10, height: 20),
          Expanded(
            child: ListView.builder(
              reverse: false, // New logs appear at the bottom
              physics: const BouncingScrollPhysics(),
              itemCount: widget.logs.length,
              itemBuilder: (context, index) {
                final log = widget.logs[index];
                final isWarning =
                    log.contains("[WARN]") || log.contains("[ВНИМ]");
                final isCritical =
                    log.contains("[CRIT]") || log.contains("[КРИТ]");
                final isInput = log.startsWith("> ");

                Color textColor = Colors.white.withValues(alpha: 0.5);
                if (isWarning) {
                  textColor = const Color(0xFFFBBF24).withValues(alpha: 0.7);
                }
                if (isCritical) {
                  textColor = const Color(0xFFF87171).withValues(alpha: 0.7);
                }
                if (isInput) {
                  textColor = const Color(0xFF6EE7B7).withValues(alpha: 0.9);
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  child: Text(
                    log,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 10,
                      fontFamily: 'monospace',
                      height: 1.2,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Row(
              children: [
                const Text(
                  "> ",
                  style: TextStyle(
                    color: Color(0xFF6EE7B7),
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    onSubmitted: _handleSubmit,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontFamily: 'monospace',
                    ),
                    cursorColor: const Color(0xFF6EE7B7),
                    decoration: const InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: "ОЖИДАНИЕ КОМАНДЫ...",
                      hintStyle: TextStyle(color: Colors.white10, fontSize: 10),
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
