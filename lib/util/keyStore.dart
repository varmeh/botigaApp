import 'package:shared_preferences/shared_preferences.dart';

class KeyStore {
  static const _keyFirstRun = 'firstRun';
  static SharedPreferences _prefs;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static bool firstRun() {
    return !_prefs.containsKey(_keyFirstRun);
  }

  static Future<void> setFirstRun() async {
    await _prefs.setBool(_keyFirstRun, true);
  }
}
