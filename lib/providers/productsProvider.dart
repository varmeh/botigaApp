import 'package:flutter/material.dart';

import '../models/index.dart' show StoreProductsModel, CategoryModel;
import '../util/index.dart' show HttpService;

class ProductsProvider with ChangeNotifier {
  Map<String, List<CategoryModel>> _storeProducts = {};

  List<CategoryModel> products(String storeId) {
    return _storeProducts.containsKey(storeId) ? _storeProducts[storeId] : {};
  }

  Future<void> getProducts(String storeId) async {
    if (_storeProducts.containsKey(storeId)) {
      return;
    } else {
      final json = await HttpService().get('/user/products');
      final storeProducts = StoreProductsModel.fromJson(json);

      List<CategoryModel> _storeCategories = [];
      storeProducts.category.forEach(
        (category, products) => _storeCategories.add(
          CategoryModel(
            category: category,
            products: products,
          ),
        ),
      );

      _storeProducts[storeId] = _storeCategories;
    }
  }
}
