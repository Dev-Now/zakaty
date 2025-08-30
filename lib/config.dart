import 'dart:io';
import 'package:path/path.dart' as path;
import 'core/default_config.dart';
import 'core/user_config.dart';

class AppConfig {
  static List<String> get currencyOptions {
    final userOptions = UserConfig.getValue('currencyOptions');
    return userOptions != null ? List<String>.from(userOptions) : DefaultConfig.currencyOptions;
  }

  static Future<void> setCurrencyOptions(List<String> options) async {
    await UserConfig.setValue('currencyOptions', options);
  }
  
  static String get fawazAhmedCurrencyApiProvider => 
      DefaultConfig.fawazAhmedCurrencyApiProvider;
  
  static String get fawazAhmedCurrencyFallbackApiProvider =>
      DefaultConfig.fawazAhmedCurrencyFallbackApiProvider;
  
  static String get openERCurrencyApiProvider =>
      DefaultConfig.openERCurrencyApiProvider;
  
  static int get maxNbOfSavedLogs {
    final userValue = UserConfig.getValue('maxNbOfSavedLogs');
    return userValue ?? DefaultConfig.maxNbOfSavedLogs;
  }

  static Future<void> setMaxNbOfSavedLogs(int value) async {
    await UserConfig.setValue('maxNbOfSavedLogs', value);
  }

  /// Gets the working directory, with fallback to default location if not set
  static String get workingDirectory {
    final userDir = UserConfig.getValue('workingDirectory');
    if (userDir != null) return userDir;
    
    // Default to Documents/Zakaty
    final defaultDir = path.join(
      Platform.environment['USERPROFILE'] ?? Platform.environment['HOME'] ?? '',
      'Documents',
      'Zakaty'
    );
    
    return defaultDir;
  }

  /// Sets and saves the working directory
  static Future<void> setWorkingDirectory(String dir) async {
    await UserConfig.setValue('workingDirectory', dir);
  }

  /// Ensures the working directory exists
  static Future<void> ensureWorkingDirectory() async {
    final dir = Directory(workingDirectory);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
  }
}