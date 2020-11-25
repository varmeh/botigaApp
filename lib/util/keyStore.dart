import 'package:shared_preferences/shared_preferences.dart';

const _keyFirstRun = 'firstRun';
const _keyLastApartment = 'apartment';

class KeyStore {
  KeyStore._privateConstructor();
  static final shared = KeyStore._privateConstructor();

  static SharedPreferences _prefs;
  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool get firstRun => !_prefs.containsKey(_keyFirstRun);
  set firstRun(bool value) {
    _prefs.setBool(_keyFirstRun, value).then((_) {}).catchError((_) {});
  }

  String get lastApartmentId => _prefs.getStringList(_keyLastApartment)[0];
  String get lastApartmentName => _prefs.getStringList(_keyLastApartment)[1];

  Future<void> setApartment({String apartmentId, String apartmentName}) async {
    await _prefs.setStringList(_keyLastApartment, [apartmentId, apartmentName]);
  }
}
