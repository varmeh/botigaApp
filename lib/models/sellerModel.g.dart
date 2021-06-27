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
    deliveryDate: json['deliveryDate'] == null
        ? null
        : DateTime.parse(json['deliveryDate'] as String),
    homeImageUrl: json['homeImageUrl'] as String,
    homeTagline: json['homeTagline'] as String,
    deliverySlot: json['deliverySlot'] as String,
    address: json['address'] as String,
    fssaiLicenseNumber: json['fssaiLicenseNumber'] as String,
    deliveryFee: json['deliveryFee'] as int,
    deliveryMinOrder: json['deliveryMinOrder'] as int,
    filters: (json['filters'] as List)?.map((e) => e as String)?.toList(),
    limitedDelivery: json['limitedDelivery'] as bool,
    overlayTag: json['overlayTag'] as String,
  );
}

Map<String, dynamic> _$SellerModelToJson(SellerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'brandName': instance.brandName,
      'tagline': instance.tagline,
      'businessCategory': instance.businessCategory,
      'brandImageUrl': instance.brandImageUrl,
      'homeImageUrl': instance.homeImageUrl,
      'homeTagline': instance.homeTagline,
      'live': instance.live,
      'phone': instance.phone,
      'whatsapp': instance.whatsapp,
      'deliveryMessage': instance.deliveryMessage,
      'deliveryDate': instance.deliveryDate?.toIso8601String(),
      'deliverySlot': instance.deliverySlot,
      'deliveryFee': instance.deliveryFee,
      'deliveryMinOrder': instance.deliveryMinOrder,
      'limitedDelivery': instance.limitedDelivery,
      'overlayTag': instance.overlayTag,
      'address': instance.address,
      'fssaiLicenseNumber': instance.fssaiLicenseNumber,
      'filters': instance.filters,
    };
