// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categoryModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) {
  return CategoryModel(
    categoryId: json['categoryId'] as String,
    name: json['name'] as String,
    products: (json['products'] as List)
        ?.map((e) =>
            e == null ? null : ProductModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$CategoryModelToJson(CategoryModel instance) =>
    <String, dynamic>{
      'categoryId': instance.categoryId,
      'name': instance.name,
      'products': instance.products,
    };
