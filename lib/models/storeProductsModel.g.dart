// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sellerProductsModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SellerProductsModel _$SellerProductsModelFromJson(Map<String, dynamic> json) {
  return SellerProductsModel(
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

Map<String, dynamic> _$SellerProductsModelToJson(
        SellerProductsModel instance) =>
    <String, dynamic>{
      'category': instance.category,
    };
