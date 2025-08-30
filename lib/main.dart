import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:zakaty/app.dart';
import 'package:zakaty/config.dart';
import 'package:zakaty/core/conversion_rates.dart';
import 'package:zakaty/core/user_config.dart';
import 'package:zakaty/utils/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize user config
  await UserConfig.initialize();
  await AppConfig.ensureWorkingDirectory();
  
  await setupLogging();

  await windowManager.ensureInitialized();
  windowManager.setPreventClose(true);

  await ConversionRatesService.loadCachedConversionRates();

  runApp(const App());
}
