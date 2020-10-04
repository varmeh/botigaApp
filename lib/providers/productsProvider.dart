import 'package:flutter/material.dart';

import '../models/index.dart' show SellerProductsModel, CategoryModel;
import '../util/index.dart' show HttpService;

class ProductsProvider with ChangeNotifier {
  Map<String, List<CategoryModel>> _sellerProducts = {};

  List<CategoryModel> products(String sellerId) {
    return _sellerProducts.containsKey(sellerId)
        ? _sellerProducts[sellerId]
        : {};
  }

  Future<void> getProducts(String sellerId) async {
    if (_sellerProducts.containsKey(sellerId)) {
      return;
    } else {
      final json = await HttpService()
          .get('/api/user/products/5f7730a57a8a7aafb139f511');
      final sellerProducts = SellerProductsModel.fromJson(json);

      List<CategoryModel> _sellerCategories = [];
      sellerProducts.category.forEach(
        (category, products) => _sellerCategories.add(
          CategoryModel(
            category: category,
            products: products,
          ),
        ),
      );

      _sellerProducts[sellerId] = _sellerCategories;
    }
  }
}
