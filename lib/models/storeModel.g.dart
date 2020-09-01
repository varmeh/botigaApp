// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storeModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreModel _$StoreModelFromJson(Map<String, dynamic> json) {
  return StoreModel(
    id: json['id'] as String,
    name: json['name'] as String,
    segmentList:
        (json['categoryList'] as List)?.map((e) => e as String)?.toList(),
    moto: json['moto'] as String,
    phone: json['phone'] as String,
    whatsapp: json['whatsapp'] as String,
  );
}

Map<String, dynamic> _$StoreModelToJson(StoreModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'moto': instance.moto,
      'categoryList': instance.segmentList,
      'phone': instance.phone,
      'whatsapp': instance.whatsapp,
    };
