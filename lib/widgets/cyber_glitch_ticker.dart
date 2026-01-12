import 'dart:async';
import 'package:flutter/material.dart';

class CyberGlitchTicker extends StatefulWidget {
  const CyberGlitchTicker({super.key});

  @override
  State<CyberGlitchTicker> createState() => _CyberGlitchTickerState();
}

class _CyberGlitchTickerState extends State<CyberGlitchTicker> {
  late ScrollController _scrollController;
  late Timer _timer;
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
    WidgetsBinding.instance.addPostFrameCallback((_) => _startScrolling());
  }

  void _startScrolling() {
    if (!_scrollController.hasClients) return;

    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_scrollController.hasClients) {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final currentScroll = _scrollController.position.pixels;

        if (currentScroll >= maxScroll) {
          _scrollController.jumpTo(0);
        } else {
          _scrollController.animateTo(
            currentScroll + 1,
            duration: const Duration(milliseconds: 50),
            curve: Curves.linear,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
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
            child: Text(
              msg,
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 8,
                fontFamily: 'monospace',
                letterSpacing: 2,
              ),
            ),
          );
        },
      ),
    );
  }
}
