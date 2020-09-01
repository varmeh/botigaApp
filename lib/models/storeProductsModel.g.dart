// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storeProductsModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreProductsModel _$StoreProductsModelFromJson(Map<String, dynamic> json) {
  return StoreProductsModel(
    (json['category'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k,
          (e as List)
              ?.map((e) => e == null
                  ? null
                  : ProductModel.fromJson(e as Map<String, dynamic>))
              ?.toList()),
    ),
  );
}

Map<String, dynamic> _$StoreProductsModelToJson(StoreProductsModel instance) =>
    <String, dynamic>{
      'category': instance.category,
    };
