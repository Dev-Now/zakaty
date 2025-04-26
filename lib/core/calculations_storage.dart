import 'dart:io';
import 'dart:convert';

import 'package:zakaty/config.dart';
import 'package:zakaty/models/zakat_calculation.dart';

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
    } catch(e) {
      // !!!TODO... handle error and don't spit out exception details in prod code !!
      throw Exception('Error loading ${calculationFile.path}: $e');
    }
  }
}