// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bannerModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BannerModel _$BannerModelFromJson(Map<String, dynamic> json) {
  return BannerModel(
    id: json['id'] as String,
    url: json['url'] as String,
    sellerId: json['sellerId'] as String,
  );
}

Map<String, dynamic> _$BannerModelToJson(BannerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'sellerId': instance.sellerId,
    };
