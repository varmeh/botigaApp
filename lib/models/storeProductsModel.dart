import 'package:json_annotation/json_annotation.dart';

// import 'categoryModel.dart';
import 'productModel.dart';

part 'sellerProductsModel.g.dart';

@JsonSerializable()
class SellerProductsModel {
  final Map<String, List<ProductModel>> category;

  SellerProductsModel(this.category);

  factory SellerProductsModel.fromJson(Map<String, dynamic> json) =>
      _$SellerProductsModelFromJson(json);

  Map<String, dynamic> toJson() => _$SellerProductsModelToJson(this);
}
