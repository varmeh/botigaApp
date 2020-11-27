import 'package:shared_preferences/shared_preferences.dart';

const _keyLastApartment = 'apartment';
const _keyPushTokenRegistered = 'pushTokenRegisterd';

class KeyStore {
  KeyStore._privateConstructor();
  static final shared = KeyStore._privateConstructor();

  static SharedPreferences _prefs;
  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool get firstRun => !_prefs.containsKey(_keyLastApartment);

  bool get isPushTokenRegistered =>
      !_prefs.containsKey(_keyPushTokenRegistered);
  Future<void> registerPushToken() async {
    await _prefs.setBool(_keyPushTokenRegistered, true);
  }

  String get lastApartmentId => _prefs.getStringList(_keyLastApartment)[0];
  String get lastApartmentName => _prefs.getStringList(_keyLastApartment)[1];
  String get lastAddressId => _prefs.getStringList(_keyLastApartment)[2];

  Future<void> setApartment({
    String apartmentId,
    String apartmentName,
    String addressId,
  }) async {
    await _prefs.setStringList(
        _keyLastApartment, [apartmentId, apartmentName, addressId]);
  }
}
