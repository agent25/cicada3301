import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';

enum MediaType { text, image, audio }

class CyberMediaViewer extends StatefulWidget {
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
  State<CyberMediaViewer> createState() => _CyberMediaViewerState();
}

class _CyberMediaViewerState extends State<CyberMediaViewer>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isScanning = false;
  double _scanProgress = 0.0;
  bool _showXRay = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.type == MediaType.image ? 2 : 1,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _startScan() {
    setState(() {
      _isScanning = true;
      _scanProgress = 0.0;
    });
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _scanProgress += 0.02;
        if (_scanProgress >= 1.0) {
          _scanProgress = 1.0;
          _isScanning = false;
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
      child: Container(
        color: Colors.black.withValues(alpha: 0.9),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
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
                      "ПРОСМОТР_ДАННЫХ // ${widget.type.name.toUpperCase()}",
                      style: TextStyle(
                        color: const Color(0xFF6EE7B7).withValues(alpha: 0.5),
                        fontSize: 8,
                        letterSpacing: 2,
                        fontFamily: 'monospace',
                      ),
                    ),
                    Text(
                      widget.title.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: widget.onClose,
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white24,
                    size: 28,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Tabs for Images
            if (widget.type == MediaType.image)
              Container(
                alignment: Alignment.centerLeft,
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: const Color(0xFF6EE7B7),
                  unselectedLabelColor: Colors.white24,
                  indicatorColor: const Color(0xFF6EE7B7),
                  indicatorSize: TabBarIndicatorSize.label,
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: "ПРОСМОТР"),
                    Tab(text: "АНАЛИЗ_EXIF"),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            // Content
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.02),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.white10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildMainContent(),
                      if (widget.type == MediaType.image)
                        _buildAnalysisContent(),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
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

  Widget _buildMainContent() {
    switch (widget.type) {
      case MediaType.text:
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Text(
            widget.content,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14,
              fontFamily: 'monospace',
              height: 1.6,
            ),
          ),
        );
      case MediaType.image:
        return Stack(
          children: [
            Center(
              child: ColorFiltered(
                colorFilter: _showXRay
                    ? const ColorFilter.matrix([
                        -1,
                        0,
                        0,
                        0,
                        255,
                        0,
                        -1,
                        0,
                        0,
                        255,
                        0,
                        0,
                        -1,
                        0,
                        255,
                        0,
                        0,
                        0,
                        1,
                        0,
                      ])
                    : const ColorFilter.mode(
                        Colors.transparent,
                        BlendMode.multiply,
                      ),
                child: Opacity(
                  opacity: 0.8,
                  child: Icon(
                    Icons.image_search_outlined,
                    size: 120,
                    color: _showXRay ? Colors.blue : Colors.white12,
                  ),
                ),
              ),
            ),
            if (_isScanning)
              Positioned(
                top: _scanProgress * 400, // Simulated height
                left: 0,
                right: 0,
                child: Container(
                  height: 2,
                  decoration: const BoxDecoration(
                    color: Color(0xFF6EE7B7),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF6EE7B7),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            Positioned(
              bottom: 20,
              right: 20,
              child: Column(
                children: [
                  _buildToolButton(
                    _showXRay ? Icons.visibility : Icons.visibility_off,
                    "X-RAY",
                    () => setState(() => _showXRay = !_showXRay),
                  ),
                  const SizedBox(height: 10),
                  _buildToolButton(Icons.sync_alt, "SCAN", _startScan),
                ],
              ),
            ),
          ],
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
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: LinearProgressIndicator(
                  backgroundColor: Colors.white10,
                  valueColor: AlwaysStoppedAnimation(
                    const Color(0xFF6EE7B7).withValues(alpha: 0.5),
                  ),
                  minHeight: 1,
                ),
              ),
            ],
          ),
        );
    }
  }

  Widget _buildAnalysisContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "МЕТАДАННЫЕ ИЗОБРАЖЕНИЯ (EXIF)",
            style: TextStyle(
              color: Color(0xFF6EE7B7),
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 20),
          _buildMetaRow("КМЕРА", "G-Nexus Cypher 9"),
          _buildMetaRow("ДАТА", "20.01.2026 // 03:44:12"),
          _buildMetaRow("КООРДИНАТЫ", "52.234, -1.4320"),
          _buildMetaRow("АВТОР", "UNKNOWN_OPERATOR_0x23"),
          _buildMetaRow("КОММЕНТАРИЙ", "Follow the white butterfly."),
          const SizedBox(height: 30),
          const Divider(color: Colors.white10),
          const SizedBox(height: 10),
          const Text(
            "АНАЛИЗ ПИКСЕЛЕЙ:",
            style: TextStyle(color: Colors.white24, fontSize: 9),
          ),
          const SizedBox(height: 10),
          const Text(
            "[ВНИМАНИЕ] Обнаружена аномалия в цветовом канале G. \nВозможно наличие скрытых водяных знаков LSB.",
            style: TextStyle(
              color: Color(0xFFFBBF24),
              fontSize: 11,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white24,
              fontSize: 10,
              fontFamily: 'monospace',
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.black45,
          border: Border.all(color: Colors.white10),
          shape: BoxShape.circle,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white54, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.white24, fontSize: 8),
            ),
          ],
        ),
      ),
    );
  }
}
