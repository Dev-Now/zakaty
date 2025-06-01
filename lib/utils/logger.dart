import 'dart:io';
import 'package:logging/logging.dart';
import 'package:zakaty/config.dart';

final Logger logger = Logger('Zakaty');

late IOSink _logFileSink;

void setupLogging() {
  Logger.root.level = Level.ALL;

  final logFile = File('${AppConfig.workingDirectory}/zakaty.log');
  _logFileSink = logFile.openWrite(mode: FileMode.append);

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