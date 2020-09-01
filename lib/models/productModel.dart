import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'productModel.g.dart';

@JsonSerializable()
class ProductModel {
  final String id;
  final String name;
  final double price;
  final String quantity;
  final String description;
  final String imageUrl;

  ProductModel({
    @required this.name,
    @required this.id,
    @required this.price,
    @required this.quantity,
    this.description,
    this.imageUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}
