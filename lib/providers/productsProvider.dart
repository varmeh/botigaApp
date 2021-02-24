import 'package:flutter/material.dart';

import '../models/index.dart' show CategoryModel;
import '../util/index.dart' show Http;

class SellerProvider with ChangeNotifier {
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
      final json = await Http.get('/api/user/products/$sellerId');

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
