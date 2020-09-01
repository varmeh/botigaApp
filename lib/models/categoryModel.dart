import 'package:flutter/foundation.dart';

import 'productModel.dart';

class CategoryModel {
  final String category;
  final List<ProductModel> products;

  CategoryModel({
    @required this.category,
    @required this.products,
  });
}
