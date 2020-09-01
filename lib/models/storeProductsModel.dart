import 'package:json_annotation/json_annotation.dart';

// import 'categoryModel.dart';
import 'productModel.dart';

part 'storeProductsModel.g.dart';

@JsonSerializable()
class StoreProductsModel {
  final Map<String, List<ProductModel>> category;

  StoreProductsModel(this.category);

  factory StoreProductsModel.fromJson(Map<String, dynamic> json) =>
      _$StoreProductsModelFromJson(json);

  Map<String, dynamic> toJson() => _$StoreProductsModelToJson(this);
}
