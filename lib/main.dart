import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:zakaty/app.dart';
import 'package:zakaty/core/conversion_rates.dart';
import 'package:zakaty/utils/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupLogging();

  await windowManager.ensureInitialized();
  windowManager.setPreventClose(true);

  await ConversionRatesService.loadCachedConversionRates();

  runApp(const App());
}
