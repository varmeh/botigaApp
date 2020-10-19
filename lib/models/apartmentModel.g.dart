// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apartmentModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApartmentModel _$ApartmentModelFromJson(Map<String, dynamic> json) {
  return ApartmentModel(
    id: json['_id'] as String,
    name: json['name'] as String,
    area: json['area'] as String,
    city: json['city'] as String,
    state: json['state'] as String,
    pincode: json['pincode'] as String,
  );
}

Map<String, dynamic> _$ApartmentModelToJson(ApartmentModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'area': instance.area,
      'city': instance.city,
      'state': instance.state,
      'pincode': instance.pincode,
    };
