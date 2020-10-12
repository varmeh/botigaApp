import 'dart:convert';
import 'package:http/http.dart' as http;

import '../flavor.dart';

class HttpService {
  static String url(String url) {
    return '${Flavor.shared.baseUrl}$url';
  }

  static dynamic parse(http.Response response) {
    if (response.statusCode >= 500) {
      throw Exception('Server Error');
    } else {
      return json.decode(response.body);
    }
  }
}
