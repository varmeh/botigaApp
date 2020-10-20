import 'dart:io';
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
    return parse(response);
  }

  static Future<dynamic> post(
    String url, {
    Map<String, String> headers,
    Map<String, String> body,
  }) async {
    final _headers = headers == null ? {} : headers;
    final response = await http.post(
      '$_baseUrl$url',
      headers: {..._globalHeaders, ..._headers},
      body: json.encode(body),
    );
    return parse(response);
  }

  static Future<dynamic> patch(
    String url, {
    Map<String, String> headers,
    Map<String, String> body,
  }) async {
    final _headers = headers == null ? {} : headers;
    final response = await http.patch(
      '$_baseUrl$url',
      headers: {..._globalHeaders, ..._headers},
      body: json.encode(body),
    );
    return parse(response);
  }

  static Future<dynamic> delete(String url) async {
    final response =
        await http.delete('$_baseUrl$url', headers: _globalHeaders);
    return parse(response);
  }

  static dynamic parse(http.Response response) {
    if (response.statusCode >= 500) {
      throw HttpException('Something went wrong');
    } else if (response.statusCode >= 400) {
      //  400 =< statusCode < 500
      final data = json.decode(response.body);
      throw FormatException(data['message']);
    } else {
      return json.decode(response.body);
    }
  }
}
