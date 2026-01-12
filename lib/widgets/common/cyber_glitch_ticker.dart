import 'package:flutter/material.dart';

class CyberGlitchTicker extends StatefulWidget {
  const CyberGlitchTicker({super.key});

  @override
  State<CyberGlitchTicker> createState() => _CyberGlitchTickerState();
}

class _CyberGlitchTickerState extends State<CyberGlitchTicker>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;
  final List<String> _messages = [
    "СИНХРОНИЗАЦИЯ ЯДРА: [OK]",
    "ВХОДЯЩИЙ ТРАФИК: 454.2 KB/S",
    "ОБНАРУЖЕНА НЕЙРО-ШТОРМ: 14%",
    "ШИФРОВАНИЕ: AES-256-GCM",
    "КАНАЛ: #E_NODE_99",
    "СТАТУС: СИСТЕМА СТАБИЛЬНА",
    "ВНИМАНИЕ: ДОСТУП ОГРАНИЧЕН",
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 20))
          ..addListener(() {
            if (_scrollController.hasClients) {
              final maxScroll = _scrollController.position.maxScrollExtent;
              _scrollController.jumpTo(_animationController.value * maxScroll);
            }
          })
          ..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: double.infinity,
      color: Colors.white.withValues(alpha: 0.03),
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 100, // Pseudo-infinite
        itemBuilder: (context, index) {
          final msg = _messages[index % _messages.length];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Text(
                msg,
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 8,
                  fontFamily: 'monospace',
                  letterSpacing: 2,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
