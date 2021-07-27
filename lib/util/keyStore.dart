import 'package:shared_preferences/shared_preferences.dart';

const _keyLastApartment = 'apartment';
const _keyPushTokenRegistered = 'pushTokenRegisterd';
const _tokenResetCounter = 50;

class KeyStore {
  KeyStore._privateConstructor();
  static final shared = KeyStore._privateConstructor();

  static SharedPreferences _prefs;
  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool get firstRun => !_prefs.containsKey(_keyLastApartment);

  Future<bool> resetToken() async {
    bool _resetToken = true;
    if (_prefs.containsKey(_keyPushTokenRegistered)) {
      int value = _prefs.getInt(_keyPushTokenRegistered);
      if (value > 0) {
        value--;
        _resetToken = false;
      } else {
        value = _tokenResetCounter;
      }
      await _prefs.setInt(_keyPushTokenRegistered, value);
    } else {
      // Initialize token counter
      await _prefs.setInt(_keyPushTokenRegistered, _tokenResetCounter);
    }
    return _resetToken;
  }

  String get lastApartmentId => _prefs.getStringList(_keyLastApartment)[0];
  String get lastApartmentName => _prefs.getStringList(_keyLastApartment)[1];

  Future<void> setApartment({
    String apartmentId,
    String apartmentName,
  }) async {
    await _prefs.setStringList(_keyLastApartment, [apartmentId, apartmentName]);
  }
}
