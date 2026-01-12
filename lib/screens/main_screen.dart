import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../widgets/animated_bottom_bar.dart';
import '../widgets/animated_background.dart';
import '../widgets/cyber_data_card.dart';
import '../widgets/cyber_action_button.dart';
import '../widgets/cyber_metric_gauge.dart';
import '../widgets/cyber_circular_gauge.dart';
import '../widgets/cyber_data_terminal.dart';
import '../widgets/cyber_status_node.dart';
import '../widgets/cyber_line_graph.dart';
import '../widgets/cyber_subsystem_list.dart';
import '../widgets/cyber_secure_keypad.dart';
import '../widgets/cyber_encrypted_file.dart';
import '../widgets/cyber_operator_card.dart';
import '../widgets/cyber_category_bar.dart';
import '../widgets/cyber_neural_pulse.dart';
import '../widgets/cyber_radar_visualizer.dart';
import '../widgets/cyber_system_map.dart';
import '../widgets/cyber_audio_visualizer.dart';
import '../widgets/cyber_glitch_ticker.dart';
import '../widgets/cyber_biometric_scanner.dart';
import '../widgets/cyber_rotating_hud.dart';
import '../widgets/cyber_media_viewer.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  int _selectedCategoryIndex = 0;
  bool _isDeepScanning = false;
  Timer? _simulationTimer;
  final math.Random _random = math.Random();

  // --- Media Viewer State ---
  String? _viewerTitle;
  String? _viewerContent;
  MediaType? _viewerType;

  // --- System State ---
  double _syncValue = 0.74;
  double _bandwidthValue = 0.42;
  double _integrityValue = 0.91;
  double _packetFlow = 0.88;

  final List<String> _terminalLogs = [
    "[ИНФО] ИНИЦИАЛИЗАЦИЯ НЕЙРО-СВЯЗИ...",
    "[ИНФО] СОЕДИНЕНИЕ УСТАНОВЛЕНО // УЗЕЛ_01",
    "[ИНФО] СИСТЕМА ОПТИМАЛЬНА",
  ];

  final Map<String, double> _subsystems = {
    "Зрительный_Процессор": 0.94,
    "Логический_Буфер": 0.82,
    "Контроллер_Ввода": 0.54,
    "Сервис_Памяти": 0.72,
  };

  final List<double> _graphData = [
    0.2,
    0.5,
    0.4,
    0.8,
    0.7,
    0.9,
    0.6,
    0.85,
    0.8,
  ];

  @override
  void initState() {
    super.initState();
    _startSimulation();
  }

  @override
  void dispose() {
    _simulationTimer?.cancel();
    super.dispose();
  }

  void _startSimulation() {
    _simulationTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!mounted) return;
      setState(() {
        // Fluctuating values
        _syncValue = (_syncValue + (_random.nextDouble() * 0.04 - 0.02)).clamp(
          0.0,
          1.0,
        );
        _bandwidthValue =
            (_bandwidthValue + (_random.nextDouble() * 0.1 - 0.05)).clamp(
              0.0,
              1.0,
            );
        _integrityValue =
            (_integrityValue + (_random.nextDouble() * 0.02 - 0.01)).clamp(
              0.0,
              1.0,
            );
        _packetFlow = (_packetFlow + (_random.nextDouble() * 0.08 - 0.04))
            .clamp(0.0, 1.0);

        // Update Subsystems health slightly
        _subsystems.forEach((key, value) {
          _subsystems[key] = (value + (_random.nextDouble() * 0.02 - 0.01))
              .clamp(0.1, 1.0);
        });

        // Update Graph
        _graphData.removeAt(0);
        _graphData.add(
          (_graphData.last + (_random.nextDouble() * 0.2 - 0.1)).clamp(
            0.1,
            1.0,
          ),
        );

        // Occasional logs
        if (_random.nextDouble() > 0.8) {
          _addLog(_generateRandomLog());
        }
      });
    });
  }

  void _addLog(String log) {
    setState(() {
      _terminalLogs.add(log);
      if (_terminalLogs.length > 20) _terminalLogs.removeAt(0);
    });
  }

  String _generateRandomLog() {
    final events = [
      "[ИНФО] ПАКЕТ ДАННЫХ ОТПРАВЛЕН // УЗЕЛ_01",
      "[ИНФО] ШИФРОВАНИЕ ОБНОВЛЕНО",
      "[ВНИМ] ЗАДЕРЖКА СЕТИ // СЕКТОР_B",
      "[ИНФО] БУФЕР ОЧИЩЕН",
      "[ИНФО] СЕССИЯ ПЕРЕЗАПУЩЕНА",
    ];
    return events[_random.nextInt(events.length)];
  }

  void _handlePurge() {
    setState(() {
      _terminalLogs.clear();
      _terminalLogs.add("[ИНФО] КЭШ ОЧИЩЕН // СИСТЕМА ЧИСТА");
    });
  }

  void _handleSync() {
    _addLog("[ИНФО] ЗАПРОС РУЧНОЙ СИНХРОНИЗАЦИИ...");
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) _addLog("[ИНФО] СИНХРОНИЗАЦИЯ ЗАВЕРШЕНА");
    });
  }

  void _handleReboot() {
    AnimatedBackground.of(context)?.triggerGlitch();
    _addLog("[КРИТ] ЗАПУСК ПЕРЕЗАГРУЗКИ УЗЛА...");
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) _addLog("[ИНФО] СИСТЕМА ПЕРЕЗАПУЩЕНА // УЗЛЫ СБРОШЕНЫ");
    });
  }

  void _handleTerminalCommand(String cmd) {
    _addLog("> $cmd");
    final command = cmd.toLowerCase().trim();

    if (command == "help" || command == "помощь") {
      _addLog("[ИНФО] ДОСТУПНЫЕ КОМАНДЫ: HELP, CLEAR, REBOOT, SCAN, STATUS");
    } else if (command == "clear" || command == "очистить") {
      _handlePurge();
    } else if (command == "reboot" || command == "перезагрузка") {
      _handleReboot();
    } else if (command == "scan" || command == "сканировать") {
      _handleSync();
      setState(() => _isDeepScanning = true);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _isDeepScanning = false);
      });
    } else if (command == "status" || command == "статус") {
      _addLog(
        "[ИНФО] СИСТЕМА: СТАБИЛЬНА // СИНХРО: ${(_syncValue * 100).toInt()}%",
      );
    } else {
      _addLog("[ОШИБКА] КОМАНДА НЕ РАСПОЗНАНА: $command");
    }
  }

  void _openFile(String name, String content, MediaType type) {
    setState(() {
      _viewerTitle = name;
      _viewerContent = content;
      _viewerType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const CyberGlitchTicker(),
              // --- Premium Matte Status Bar ---
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: _buildStatusItem(
                        "УЗЕЛ_01 // АКТИВЕН",
                        const Color(0xFF6EE7B7),
                      ),
                    ),
                    Flexible(
                      child: _buildStatusItem(
                        "ЗАГРУЗКА // ${(100 - _integrityValue * 100).toInt()}%",
                        const Color(0xFF7DD3FC),
                      ),
                    ),
                    Flexible(
                      child: _buildStatusItem(
                        "КАНАЛ // ЗАЩИЩЕН",
                        const Color(0xFFC4B5FD),
                      ),
                    ),
                  ],
                ),
              ),
              Container(height: 1, color: Colors.white.withValues(alpha: 0.05)),

              Expanded(
                child: Stack(
                  children: [
                    IndexedStack(
                      index: _currentIndex,
                      children: [
                        _buildMasterControl(),
                        _buildDiagnostics(),
                        _buildVault(),
                        _buildProfile(),
                      ],
                    ),
                    // Rotating HUD Decorations (Background level)
                    const Positioned(
                      top: -40,
                      right: -40,
                      child: Opacity(
                        opacity: 0.2,
                        child: CyberRotatingHUD(size: 180),
                      ),
                    ),
                    const Positioned(
                      bottom: 40,
                      left: -30,
                      child: Opacity(
                        opacity: 0.15,
                        child: CyberRotatingHUD(size: 140),
                      ),
                    ),
                    // Deep Scan Overlay
                    if (_isDeepScanning)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              colors: [
                                const Color(0xFFC4B5FD).withValues(alpha: 0.05),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              "ГЛУБОКОЕ_СКАН_АКТИВИРОВАНО",
                              style: TextStyle(
                                color: Color(0xFFC4B5FD),
                                fontSize: 10,
                                letterSpacing: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    // Media Viewer Overlay
                    if (_viewerTitle != null)
                      Positioned.fill(
                        child: CyberMediaViewer(
                          title: _viewerTitle!,
                          content: _viewerContent ?? "",
                          type: _viewerType ?? MediaType.text,
                          onClose: () => setState(() => _viewerTitle = null),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: AnimatedBottomBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }

  Widget _buildStatusItem(String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 3,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            boxShadow: [
              BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 4),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: 8,
              fontFamily: 'monospace',
              letterSpacing: 1.2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMasterControl() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 10, bottom: 120),
      children: [
        CyberCategoryBar(
          categories: const ["Главная", "Память", "Процессор", "Сеть"],
          onSelected: (index) {
            setState(() {
              _selectedCategoryIndex = index;
              _addLog(
                "[ИНФО] ПЕРЕКЛЮЧЕНИЕ СЕКТОРА: ${["ГЛАВНАЯ", "ПАМЯТЬ", "ПРОЦЕССОР", "СЕТЬ"][index]}",
              );
            });
          },
        ),
        // --- System Health Nodes ---
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              CyberStatusNode(label: "Спутник", isActive: true),
              CyberStatusNode(
                label: "Шифрование",
                isActive: true,
                color: Color(0xFFC4B5FD),
              ),
              CyberStatusNode(
                label: "Ядро_ИИ",
                isActive: true,
                color: Color(0xFF7DD3FC),
              ),
              CyberStatusNode(
                label: "Фаервол",
                isActive: false,
                color: Color(0xFFFCA5A5),
              ),
            ],
          ),
        ),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(
            "СТАТУС НЕЙРО-СВЯЗИ",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 4,
              color: Colors.white24,
            ),
          ),
        ),

        // --- Radial Gauges Area ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                CyberCircularGauge(
                  value: _syncValue,
                  label: "Синхро",
                  accentColor: const Color(0xFF6EE7B7),
                ),
                CyberCircularGauge(
                  value: _bandwidthValue,
                  label: "Канал",
                  accentColor: const Color(0xFF7DD3FC),
                ),
                CyberCircularGauge(
                  value: _integrityValue,
                  label: "Целостность",
                  accentColor: const Color(0xFFC4B5FD),
                ),
              ],
            ),
          ),
        ),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(
            "РАСПРЕДЕЛЕНИЕ РЕСУРСОВ",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 3,
              color: Colors.white24,
            ),
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.05, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: KeyedSubtree(
            key: ValueKey(_selectedCategoryIndex),
            child: Column(
              children: [
                if (_selectedCategoryIndex == 0) ...[
                  const CyberDataCard(
                    label: "Центр Памяти",
                    value: "ВЫДЕЛЕНО // 85%",
                    icon: Icons.memory,
                    accentColor: Color(0xFF7DD3FC),
                  ),
                ] else if (_selectedCategoryIndex == 1) ...[
                  const CyberDataCard(
                    label: "Лог Памяти",
                    value: "АКТИВНО // 1.2 ГБ",
                    icon: Icons.storage,
                    accentColor: Color(0xFFC4B5FD),
                  ),
                ] else if (_selectedCategoryIndex == 2) ...[
                  const CyberDataCard(
                    label: "Тактовая Частота",
                    value: "4.2 ГГЦ // ТУРБО",
                    icon: Icons.speed,
                    accentColor: Color(0xFF6EE7B7),
                  ),
                ] else ...[
                  const CyberDataCard(
                    label: "Трафик Сети",
                    value: "ВХОД // 454 КБ/С",
                    icon: Icons.network_check,
                    accentColor: Color(0xFFFBBF24),
                  ),
                ],
              ],
            ),
          ),
        ),

        const CyberAudioVisualizer(),
        const SizedBox(height: 20),
        // --- Metrics Row ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: CyberMetricGauge(
                  label: "Поток Пакетов",
                  value: _packetFlow,
                  accentColor: const Color(0xFF6EE7B7),
                ),
              ),
              Expanded(
                child: CyberMetricGauge(
                  label: "Очистка Кэша",
                  value: 0.12,
                  accentColor: const Color(0xFFFCA5A5),
                ),
              ),
            ],
          ),
        ),

        // -- Terminal Feed --
        CyberDataTerminal(
          logs: _terminalLogs,
          onCommand: _handleTerminalCommand,
        ),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            "ПРЯМЫЕ КОМАНДЫ",
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: Colors.white12,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              CyberActionButton(
                label: "Синхронизация",
                onTap: _handleSync,
                accentColor: const Color(0xFF6EE7B7),
              ),
              CyberActionButton(
                label: "Очистить Кэш",
                onTap: _handlePurge,
                accentColor: const Color(0xFFC4B5FD),
              ),
              CyberActionButton(
                label: "Перезагрузка",
                onTap: _handleReboot,
                accentColor: const Color(0xFFFCA5A5),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDiagnostics() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 20, bottom: 120),
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "ДИАГНОСТИКА ЯДРА",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 4,
              color: Colors.white24,
            ),
          ),
        ),
        const CyberNeuralPulse(),
        CyberLineGraph(data: _graphData, label: "Стабильность Нейро-Стрим"),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Text(
            "РАДАР ОБНАРУЖЕНИЯ",
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: Colors.white12,
            ),
          ),
        ),
        const Center(child: CyberRadarVisualizer()),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Text(
            "СОСТОЯНИЕ ПОДСИСТЕМ",
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: Colors.white12,
            ),
          ),
        ),
        CyberSubsystemList(
          subsystems: _subsystems,
          onToggle: (label) {
            _addLog("[ИНФО] ПРОВЕРКА_${label.toUpperCase()} запущена");
            setState(() {
              _subsystems[label] = (_subsystems[label]! + 0.1).clamp(0.0, 1.0);
            });
          },
        ),
      ],
    );
  }

  Widget _buildVault() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 20, bottom: 120),
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Text(
            "ТРЕБУЕТСЯ АВТОРИЗАЦИЯ",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 4,
              color: Colors.white24,
            ),
          ),
        ),
        const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              "АВТОРИЗАЦИЯ",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 4,
                color: Colors.white24,
              ),
            ),
          ),
        ),
        Center(
          child: CyberBiometricScanner(
            onAuthenticated: () {
              _addLog("[УСПЕХ] БИОМЕТРИЯ ПРОЙДЕНА // СЕКТОР РАЗБЛОКИРОВАН");
              setState(() {
                _isDeepScanning = true;
              });
              Future.delayed(const Duration(seconds: 3), () {
                if (mounted) setState(() => _isDeepScanning = false);
              });
            },
          ),
        ),
        const SizedBox(height: 30),
        Center(
          child: CyberSecureKeypad(
            onComplete: (pin) {
              _addLog("[ИНФО] АВТОРИЗАЦИЯ // ПИН ПОДТВЕРЖДЕН");
            },
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Text(
            "ЗАШИФРОВАННЫЕ ПАКЕТЫ",
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: Colors.white12,
            ),
          ),
        ),
        CyberEncryptedFile(
          fileName: "ПРОЕКТ_ПРИЗРАК_B",
          size: "1.2 МБ",
          securityLevel: 4,
          onOpen: () => _openFile(
            "ПРОЕКТ_ПРИЗРАК_B",
            "ДАННЫЕ ЗАШИФРОВАНЫ. \n\nТРЕБУЕТСЯ КЛЮЧ: 'CICADA_3301'. \n\nЛОКАЦИЯ: СЕКТОР 7.",
            MediaType.text,
          ),
        ),
        CyberEncryptedFile(
          fileName: "ЛОГИ_ДОСТУПА_X",
          size: "44 КБ",
          securityLevel: 2,
          onOpen: () =>
              _openFile("ЛОГИ_ДОСТУПА_X", "access_log_01.img", MediaType.image),
        ),
        CyberEncryptedFile(
          fileName: "ПОТОК_ПАМЯТИ_D",
          size: "128 МБ",
          securityLevel: 5,
          onOpen: () =>
              _openFile("ПОТОК_ПАМЯТИ_D", "memory_stream.mp3", MediaType.audio),
        ),
      ],
    );
  }

  Widget _buildProfile() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 20, bottom: 120),
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Text(
            "ПРОФИЛЬ ОПЕРАТОРА",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 4,
              color: Colors.white24,
            ),
          ),
        ),
        const CyberOperatorCard(),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Text(
            "КАРТА НЕЙРО-СЕТИ",
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: Colors.white12,
            ),
          ),
        ),
        const CyberSystemMap(),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Text(
            "РАЗРЕШЕННЫЕ МОДУЛИ",
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: Colors.white12,
            ),
          ),
        ),
        _buildPermissionItem("Обход_Ядра", true),
        _buildPermissionItem("Расшифровка_Хранилища", true),
        _buildPermissionItem("Спутниковый_Ретранслятор", false),
      ],
    );
  }

  Widget _buildPermissionItem(String label, bool granted) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 10,
              fontFamily: 'monospace',
            ),
          ),
          Icon(
            granted ? Icons.check_circle_outline : Icons.cancel_outlined,
            size: 16,
            color: granted
                ? const Color(0xFF6EE7B7).withValues(alpha: 0.6)
                : Colors.white10,
          ),
        ],
      ),
    );
  }
}
