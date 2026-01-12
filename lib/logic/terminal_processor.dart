import 'dart:math' as math;

class TerminalResponse {
  final List<String> logs;
  final bool triggerGlitch;
  final bool clearTerminal;
  final int? categoryDelay;

  TerminalResponse({
    required this.logs,
    this.triggerGlitch = false,
    this.clearTerminal = false,
    this.categoryDelay,
  });
}

class TerminalProcessor {
  final math.Random _random = math.Random();

  TerminalResponse processCommand(
    String command, {
    required Function(int) onGlobalChange,
    required Function(int) onSubChange,
  }) {
    final cmd = command.toLowerCase().trim();

    if (cmd == 'help') {
      return TerminalResponse(
        logs: [
          "> help",
          "[СИСТЕМА] ДОСТУПНЫЕ КОМАНДЫ:",
          "  - help: Вывод этого сообщения",
          "  - clear: Очистка терминала",
          "  - scan: Запуск глубокого сканирования",
          "  - status: Состояние системы",
          "  - vault: Доступ к хранилищу",
          "  - stegan: Инструменты стеганографии",
        ],
      );
    } else if (cmd == 'scan') {
      return TerminalResponse(
        logs: [
          "> scan",
          "[ИНФО] ЗАПУСК СКАНИРОВАНИЯ СЕКТОРОВ 0xAF...0xCC",
          "[ИНФО] ПРОВЕРКА ЦЕЛОСТНОСТИ ДАННЫХ: 88%",
          "[ВНИМ] ОБНАРУЖЕНЫ СКРЫТЫЕ ПАКЕТЫ В lib/core",
        ],
        categoryDelay: 2, // Slight delay simulation
      );
    } else if (cmd == 'status') {
      return TerminalResponse(
        logs: [
          "> status",
          "[СТАТУС] ЦП: 42% | ПАМЯТЬ: 1.2GB/4.0GB",
          "[СТАТУС] КАНАЛ: ЗАЩИЩЕН // AES-256",
          "[СТАТУС] ИНТЕГРИТЕТ: ВЫСОКИЙ (0.91)",
        ],
      );
    } else if (cmd == 'vault') {
      onGlobalChange(2); // Global VAULT_X
      return TerminalResponse(
        logs: ["> vault", "[ИНФО] ПЕРЕХОД В СЕКТОР ХРАНИЛИЩА..."],
      );
    } else if (cmd == 'stegan') {
      onGlobalChange(0); // Back to OS_CORE
      onSubChange(4); // STEGANO category
      return TerminalResponse(
        logs: ["> stegan", "[ИНФО] ЗАПУСК МОДУЛЯ СТЕГАНОГРАФИИ..."],
      );
    } else if (cmd == 'clear') {
      return TerminalResponse(logs: [], clearTerminal: true);
    }

    return TerminalResponse(
      logs: ["> $command", "[ОШИБКА] КОМАНДА НЕ НАЙДЕНА: $cmd"],
      triggerGlitch: true,
    );
  }

  String generateRandomLog() {
    final logs = [
      "ПОТОК_ДАННЫХ: 0x${_random.nextInt(0xFFFFFF).toRadixString(16).toUpperCase()}",
      "СИНХРОНИЗАЦИЯ УЗЛА: OK",
      "ОБНАРУЖЕН ВХОДЯЩИЙ ЗАПРОС: 192.168.0.1",
      "ПРОВЕРКА ФАЙЛА: encrypted_01.dat [DONE]",
      "ШИФРОВАНИЕ ТРАФИКА: АКТИВНО",
    ];
    return "[ЛОГ] ${logs[_random.nextInt(logs.length)]}";
  }
}
