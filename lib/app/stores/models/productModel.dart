import 'package:flutter/foundation.dart';

class ProductModel {
  final String name;
  final String description;
  final String id;
  final String price;
  final String quantity;
  final String imageUrl;
  final List<String> ingredientList;

  ProductModel({
    @required this.name,
    @required this.id,
    @required this.price,
    @required this.quantity,
    this.description,
    this.ingredientList,
    this.imageUrl,
  });

  String get ingredients => ingredientList.join(' - ');
}
