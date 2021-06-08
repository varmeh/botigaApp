import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Token {
  static final _storage = new FlutterSecureStorage();
  static Map<String, String> _allKeys;
  static final _tokenKey = 'authToken';

  static Future<String> read() async {
    try {
      _allKeys = await _storage.readAll();
      return _allKeys[_tokenKey];
    } catch (exception) {
      return null;
    }
  }

  static Future<void> write(String value) async {
    return await _storage.write(key: _tokenKey, value: value);
  }

  static Future<void> delete() async {
    return await _storage.delete(key: _tokenKey);
  }
}
