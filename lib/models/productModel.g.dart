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
    mrp: (json['mrp'] as num)?.toDouble(),
    tag: json['tag'] as String,
    description: json['description'] as String,
    imageUrl: json['imageUrl'] as String,
    imageUrlLarge: json['imageUrlLarge'] as String,
    secondaryImageUrls:
        (json['secondaryImageUrls'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'mrp': instance.mrp,
      'size': instance.size,
      'available': instance.available,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'tag': instance.tag,
      'imageUrlLarge': instance.imageUrlLarge,
      'secondaryImageUrls': instance.secondaryImageUrls,
    };
