// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'productModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) {
  return ProductModel(
    id: json['id'] as String,
    name: json['name'] as String,
    price: (json['price'] as num)?.toDouble(),
    size: json['size'] as String,
    available: json['available'] as bool,
    description: json['description'] as String,
    imageUrl: json['imageUrl'] as String,
  );
}

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'size': instance.size,
      'available': instance.available,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
    };
