import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:zakaty/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();
  windowManager.setPreventClose(true);

  runApp(const App());
}
