import 'dart:io';
import 'package:logging/logging.dart';
import 'package:zakaty/config.dart';

final Logger logger = Logger('Zakaty');

late IOSink _logFileSink;
late File _logFile;

Future<void> setupLogging() async {
  _logFile = File('${AppConfig.workingDirectory}/zakaty.log');

  // Trim logs at initialization
  await _trimLogFile(AppConfig.maxNbOfSavedLogs);

  // Start logging
  _logFileSink = _logFile.openWrite(mode: FileMode.append);
  Logger.root.level = Level.ALL;

  Logger.root.onRecord.listen((record) {
    final logEntry =
      '${record.time.toIso8601String()} [${record.level.name}] ${record.loggerName}: ${record.message}';
    _logFileSink.writeln(logEntry);
  });
}

Future<void> disposeLogging() async {
  await _logFileSink.flush();
  await _logFileSink.close();
}

Future<void> _trimLogFile(int maxLogs) async {
  if (!await _logFile.exists()) return;

  final lines = await _logFile.readAsLines();
  if (lines.length <= maxLogs) return;

  final trimmedLines = lines.sublist(lines.length - maxLogs);

  await _logFile.writeAsString('${trimmedLines.join('\n')}\n');
}