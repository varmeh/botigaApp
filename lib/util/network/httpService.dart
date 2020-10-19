import 'dart:convert';
import 'package:http/http.dart' as http;

import '../flavor.dart';

Map<String, String> _globalHeaders = {
  'Content-type': 'application/json',
  'Accept': 'application/json',
};

class Http {
  static final _baseUrl = Flavor.shared.baseUrl;

  static Future<dynamic> get(String url) async {
    final response = await http.get('$_baseUrl$url');
    return toJson(response);
  }

  static Future<dynamic> post(
    String url, {
    Map<String, String> headers,
    Map<String, String> body,
  }) async {
    final response = await http.post(
      '$_baseUrl$url',
      headers: {..._globalHeaders, ...headers},
      body: json.encode(body),
    );
    return toJson(response);
  }

  static Future<dynamic> patch(
    String url, {
    Map<String, String> headers,
    Map<String, String> body,
  }) async {
    final response = await http.post(
      '$_baseUrl$url',
      headers: {..._globalHeaders, ...headers},
      body: json.encode(body),
    );
    return toJson(response);
  }

  static Future<dynamic> delete(String url) async {
    final response =
        await http.delete('$_baseUrl$url', headers: _globalHeaders);
    return toJson(response);
  }

  static dynamic toJson(http.Response response) {
    final decode = json.decode(response.body);
    if (response.statusCode >= 500) {
      return Future.error(decode['message']);
    } else {
      return decode;
    }
  }
}
