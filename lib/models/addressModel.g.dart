// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addressModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressModel _$AddressModelFromJson(Map<String, dynamic> json) {
  return AddressModel(
    id: json['id'] as String,
    house: json['house'] as String,
    apartment: json['apartment'] as String,
    area: json['area'] as String,
    city: json['city'] as String,
    state: json['state'] as String,
    pincode: json['pincode'] as String,
  );
}

Map<String, dynamic> _$AddressModelToJson(AddressModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'house': instance.house,
      'apartment': instance.apartment,
      'area': instance.area,
      'city': instance.city,
      'state': instance.state,
      'pincode': instance.pincode,
    };
