// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sellerModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SellerModel _$SellerModelFromJson(Map<String, dynamic> json) {
  return SellerModel(
    id: json['id'] as String,
    name: json['name'] as String,
    segmentList:
        (json['segmentList'] as List)?.map((e) => e as String)?.toList(),
    moto: json['moto'] as String,
    phone: json['phone'] as String,
    whatsapp: json['whatsapp'] as String,
  );
}

Map<String, dynamic> _$SellerModelToJson(SellerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'moto': instance.moto,
      'segmentList': instance.segmentList,
      'phone': instance.phone,
      'whatsapp': instance.whatsapp,
    };
