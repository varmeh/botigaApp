import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'productModel.g.dart';

@JsonSerializable()
class ProductModel {
  final String id;
  final String name;
  final double price;
  final double mrp;
  final String size;
  final bool available;
  final String description;
  final String imageUrl;
  final String tag;
  final String imageUrlLarge;
  List<String> secondaryImageUrls;

  ProductModel({
    @required this.id,
    @required this.name,
    @required this.price,
    @required this.size,
    @required this.available,
    this.mrp,
    this.tag,
    this.description,
    this.imageUrl,
    this.imageUrlLarge,
    this.secondaryImageUrls,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}
