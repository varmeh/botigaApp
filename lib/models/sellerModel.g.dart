// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sellerModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SellerModel _$SellerModelFromJson(Map<String, dynamic> json) {
  return SellerModel(
    id: json['id'] as String,
    brandName: json['brandName'] as String,
    tagline: json['tagline'] as String,
    businessCategory: json['businessCategory'] as String,
    brandImageUrl: json['brandImageUrl'] as String,
    live: json['live'] as bool,
    phone: json['phone'] as String,
    whatsapp: json['whatsapp'] as String,
    deliveryMessage: json['deliveryMessage'] as String,
    deliveryDate: json['deliveryDate'] as String,
  );
}

Map<String, dynamic> _$SellerModelToJson(SellerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'brandName': instance.brandName,
      'tagline': instance.tagline,
      'businessCategory': instance.businessCategory,
      'brandImageUrl': instance.brandImageUrl,
      'live': instance.live,
      'phone': instance.phone,
      'whatsapp': instance.whatsapp,
      'deliveryMessage': instance.deliveryMessage,
      'deliveryDate': instance.deliveryDate,
    };
