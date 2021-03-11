// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sellerFilterModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SellerFilterModel _$SellerFilterModelFromJson(Map<String, dynamic> json) {
  return SellerFilterModel(
    displayName: json['key'] as String,
    value: json['value'] as String,
  );
}

Map<String, dynamic> _$SellerFilterModelToJson(SellerFilterModel instance) =>
    <String, dynamic>{
      'key': instance.displayName,
      'value': instance.value,
    };
