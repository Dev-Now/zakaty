import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'default_config.dart';

class UserConfig {
  static Map<String, dynamic> _userConfig = {};
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      final appDir = await getApplicationSupportDirectory();
      final configFile = File(path.join(appDir.path, 'config.json'));
      
      if (await configFile.exists()) {
        final contents = await configFile.readAsString();
        _userConfig = json.decode(contents);
      } else {
        // Initialize with default values
        _userConfig = {
          'currencyOptions': DefaultConfig.currencyOptions,
          'workingDirectory': path.join(
            Platform.environment['USERPROFILE'] ?? Platform.environment['HOME'] ?? '',
            'Documents',
            'Zakaty'
          ),
          'maxNbOfSavedLogs': DefaultConfig.maxNbOfSavedLogs
        };
        // Save the default config
        await saveConfig();
      }
      
      _initialized = true;
    } catch (e) {
      // Use defaults if config loading fails
      _initialized = true;
    }
  }

  static Future<void> saveConfig() async {
    try {
      final appDir = await getApplicationSupportDirectory();
      final configFile = File(path.join(appDir.path, 'config.json'));
      
      // Create directory if it doesn't exist
      if (!await configFile.parent.exists()) {
        await configFile.parent.create(recursive: true);
      }

      await configFile.writeAsString(json.encode(_userConfig));
    } catch (e) {
      // Handle saving errors
    }
  }

  static Future<void> setValue(String key, dynamic value) async {
    _userConfig[key] = value;
    await saveConfig();
  }

  static dynamic getValue(String key) {
    return _userConfig[key];
  }
}
