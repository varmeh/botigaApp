import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/index.dart' show CategoryModel;
import '../util/index.dart' show HttpService;

class ProductsProvider with ChangeNotifier {
  Map<String, List<CategoryModel>> _sellerProducts = {};

  List<CategoryModel> products(String sellerId) {
    return _sellerProducts.containsKey(sellerId)
        ? _sellerProducts[sellerId]
        : [];
  }

  Future<void> getProducts(String sellerId) async {
    if (_sellerProducts.containsKey(sellerId)) {
      return;
    } else {
      final response = await http.get(
        HttpService.url('/api/user/products/5f7730a57a8a7aafb139f511'),
      );

      final json = HttpService.parse(response);

      List<CategoryModel> _sellerCategories = json
          .map(
            (item) => CategoryModel.fromJson(item),
          )
          .cast<CategoryModel>()
          .toList();

      _sellerProducts[sellerId] = _sellerCategories;
    }
  }
}
