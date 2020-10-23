import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Token {
  static final _storage = new FlutterSecureStorage();
  static final _tokenKey = 'authToken';

  static Future<String> read() async {
    return await _storage.read(key: _tokenKey);
  }

  static Future<void> write(String value) async {
    return await _storage.write(key: _tokenKey, value: value);
  }

  static Future<void> delete() async {
    return await _storage.delete(key: _tokenKey);
  }
}
