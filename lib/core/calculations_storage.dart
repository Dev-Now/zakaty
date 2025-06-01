import 'dart:io';
import 'dart:convert';

import 'package:zakaty/config.dart';
import 'package:zakaty/models/zakat_calculation.dart';
import 'package:zakaty/utils/logger.dart';

class ZakatCalculationsStorageService {
  static Future<void> saveZakatCalculation(ZakatCalculation zakatCalculation) async {
    final file = File('${AppConfig.workingDirectory}/${zakatCalculation.uid}.json');
    await file.writeAsString(jsonEncode(zakatCalculation.toJson()));
  }

  static Future<ZakatCalculation> loadZakatCalculation(File calculationFile) async {
    try {
      final content = await calculationFile.readAsString();
      final jsonData = jsonDecode(content);
      return ZakatCalculation.fromJson(jsonData);
    } catch(e, stackTrace) {
      logger.severe('Failed to load calculation from ${calculationFile.path}', e, stackTrace);
      throw Exception('Error loading ${calculationFile.path}: $e');
    }
  }

  static Future<void> deleteZakatCalculation(String uid) async {
    final file = File('${AppConfig.workingDirectory}/$uid.json');
    try {
      await file.delete();
    } catch(e, stackTrace) {
      logger.warning('Failed to delete file ${file.path}', e, stackTrace);
    }
  }
}