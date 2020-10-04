import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'productModel.dart';

part 'categoryModel.g.dart';

@JsonSerializable()
class CategoryModel {
  final String categoryId;
  final String name;
  final List<ProductModel> products;

  CategoryModel({
    @required this.categoryId,
    @required this.name,
    @required this.products,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}
