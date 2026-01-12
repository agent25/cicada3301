import 'package:flutter/material.dart';
import 'dart:ui';

enum MediaType { text, image, audio }

class CyberMediaViewer extends StatelessWidget {
  final String title;
  final String content;
  final MediaType type;
  final VoidCallback onClose;

  const CyberMediaViewer({
    super.key,
    required this.title,
    required this.content,
    required this.type,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        color: Colors.black.withValues(alpha: 0.8),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ПРОСМОТР_ДАННЫХ // ${type.name.toUpperCase()}",
                      style: TextStyle(
                        color: const Color(0xFF6EE7B7).withValues(alpha: 0.5),
                        fontSize: 8,
                        letterSpacing: 2,
                        fontFamily: 'monospace',
                      ),
                    ),
                    Text(
                      title.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(Icons.close, color: Colors.white24),
                ),
              ],
            ),
            const SizedBox(height: 30),
            // Content
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.white10),
                ),
                child: _buildContent(),
              ),
            ),
            const SizedBox(height: 30),
            // Footer
            const Text(
              "КОНЕЦ_ПЕРЕДАЧИ // СИСТЕМА_ЗАЩИЩЕНА",
              style: TextStyle(
                color: Colors.white12,
                fontSize: 8,
                letterSpacing: 4,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (type) {
      case MediaType.text:
        return SingleChildScrollView(
          child: Text(
            content,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 13,
              fontFamily: 'monospace',
              height: 1.5,
            ),
          ),
        );
      case MediaType.image:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_outlined,
                size: 64,
                color: Colors.white.withValues(alpha: 0.1),
              ),
              const SizedBox(height: 16),
              Text(
                "[ИЗОБРАЖЕНИЕ: $content]",
                style: const TextStyle(
                  color: Colors.white24,
                  fontSize: 10,
                  fontFamily: 'monospace',
                ),
              ),
              const Text(
                "(Тут будет реальное фото в будущем)",
                style: TextStyle(
                  color: Colors.white10,
                  fontSize: 8,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        );
      case MediaType.audio:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.audiotrack_outlined,
                size: 64,
                color: Color(0xFF6EE7B7),
              ),
              const SizedBox(height: 24),
              const Text(
                "АНАЛИЗ_ЧАСТОТЫ...",
                style: TextStyle(
                  color: Color(0xFF6EE7B7),
                  fontSize: 10,
                  fontFamily: 'monospace',
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                backgroundColor: Colors.white10,
                valueColor: AlwaysStoppedAnimation(
                  const Color(0xFF6EE7B7).withValues(alpha: 0.5),
                ),
                minHeight: 1,
              ),
            ],
          ),
        );
    }
  }
}
