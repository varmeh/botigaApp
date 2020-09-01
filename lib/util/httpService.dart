import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'flavor.dart';
import '../models/index.dart' show StoreModel;

class HttpService {
  final baseUrl = Flavor.shared.baseUrl;

  Future<List<StoreModel>> getStoreList() async {
    try {
      var response = await http.get('$baseUrl/user/stores');

      if (response.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(response.body);
        var storeList = body['stores'].map(
          (item) => StoreModel.fromJson(item),
        );

        // Iterable returned above is of type of dynamic
        // Below method is used to convert supertype list to subtype list
        return List<StoreModel>.from(storeList);
      } else {
        print(response.statusCode);
        throw Exception('Failed to Load Stores');
      }
    } on SocketException {
      print('No Internet connection 😑');
    } on HttpException {
      print("Couldn't find the post 😱");
    } on FormatException {
      print("Bad response format 👎");
    }
  }
}
