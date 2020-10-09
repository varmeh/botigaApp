import 'dart:convert';
import 'package:http/http.dart' as http;

import '../flavor.dart';
import 'httpExceptions.dart';

class HttpService {
  static String url(String url) {
    return '${Flavor.shared.baseUrl}$url';
  }

  static dynamic parse(http.Response response) {
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

      case 422:
        return json.decode(response.body);

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
