import 'dart:convert';
import 'package:http/http.dart' as http;

import '../flavor.dart';
import 'httpExceptions.dart';

class HttpService {
  final _baseUrl = Flavor.shared.baseUrl;

  Future<dynamic> get(String url) async {
    // Propogate errors to parent for effective UI management
    final response = await http.get(_baseUrl + url);
    return _returnResponse(response);
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
      case 204:
        return json.decode(response.body);

      case 400:
        throw BadRequestException();

      case 401:
      case 403:
        throw UanuthorizedException();

      case 500:
      case 503:
      case 504:
        throw ServerErrorException();

      default:
        throw HttpServiceException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
