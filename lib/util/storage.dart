import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  static final _storage = new FlutterSecureStorage();

  static Future<String> read(String key) async {
    return await _storage.read(key: key);
  }

  static Future<Map<String, String>> readAll() async {
    return await _storage.readAll();
  }

  static Future<void> write(String key, String value) async {
    return _storage.write(key: key, value: value);
  }

  static Future<void> delete(String key) async {
    return await _storage.delete(key: key);
  }
}
