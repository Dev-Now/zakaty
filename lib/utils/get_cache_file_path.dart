import 'package:path_provider/path_provider.dart';

Future<String> getCacheFilePath() async {
  final dir = await getApplicationCacheDirectory();
  return '${dir.path}/zakaty_cached_conv_rates.json';
}