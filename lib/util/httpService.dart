import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'flavor.dart';

class HttpService {
  final _baseUrl = Flavor.shared.baseUrl;

  Future<Map<String, dynamic>> get(String url) async {
    try {
      var response = await http.get('$_baseUrl$url');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print(response.statusCode);
        throw Exception('Failed to Load Stores');
      }
    } on SocketException {
      throw Exception('No Internet connection 😑');
    } on HttpException {
      throw Exception("Couldn't find the post 😱");
    } on FormatException {
      throw Exception("Bad response format 👎");
    }
  }
}
