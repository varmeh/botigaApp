import 'package:shared_preferences/shared_preferences.dart';

import './extensions/stringExtension.dart';

const _keyLastApartment = 'apartment';

class KeyStore {
  KeyStore._privateConstructor();
  static final shared = KeyStore._privateConstructor();

  static SharedPreferences _prefs;
  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool get firstRun => lastApartmentId.isNullOrEmpty;

  String get lastApartmentId => _prefs.getStringList(_keyLastApartment)[0];
  String get lastApartmentName => _prefs.getStringList(_keyLastApartment)[1];

  Future<void> setApartment({String apartmentId, String apartmentName}) async {
    await _prefs.setStringList(_keyLastApartment, [apartmentId, apartmentName]);
  }
}
