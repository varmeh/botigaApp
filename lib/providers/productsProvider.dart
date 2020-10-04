import 'package:flutter/material.dart';

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
      final json = await HttpService()
          .get('/api/user/products/5f7730a57a8a7aafb139f511');
      // List<CategoryModel> _sellerCategoryList = [];
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
