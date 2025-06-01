import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:zakaty/app.dart';
import 'package:zakaty/utils/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupLogging();

  await windowManager.ensureInitialized();
  windowManager.setPreventClose(true);

  runApp(const App());
}
