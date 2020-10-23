import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'index.dart' show Flavor, Token;

class Http {
  static final _baseUrl = Flavor.shared.baseUrl;
  static String _token;

  static Map<String, String> _globalHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  static Future<void> fetchToken() async {
    _token = await Token.read();
  }

  static bool get tokenExists {
    return _token != null;
  }

  static Future<dynamic> get(String url) async {
    final response = await http.get(
      '$_baseUrl$url',
      headers: {..._globalHeaders, 'Authorization': _token},
    );
    return parse(response);
  }

  static Future<dynamic> postAuth(
    String url, {
    Map<String, String> body,
  }) async {
    final response = await http.post(
      '$_baseUrl$url',
      headers: {..._globalHeaders},
      body: json.encode(body),
    );

    if (response.headers['Authorization'] != null) {
      _token = response.headers['Authorization'];
      await Token.write(_token); // save token to persistence storage
    }
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
      headers: {'Authorization': _token, ..._globalHeaders, ..._headers},
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
      headers: {'Authorization': _token, ..._globalHeaders, ..._headers},
      body: json.encode(body),
    );
    return parse(response);
  }

  static Future<dynamic> delete(String url) async {
    final response = await http.delete(
      '$_baseUrl$url',
      headers: {..._globalHeaders, 'Authorization': _token},
    );
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

  static String message(dynamic exception) {
    var msg;
    if (exception is SocketException) {
      msg = 'No Internet Connection';
    } else if (exception is HttpException) {
      msg = exception.message;
    } else if (exception is FormatException) {
      msg = exception.message;
    }
    return msg;
  }
}
