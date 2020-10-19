import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'apartmentModel.g.dart';

@JsonSerializable()
class ApartmentModel {
  @JsonKey(name: '_id')
  final String id;

  final String name;
  final String area;
  final String city;
  final String state;
  final String pincode;

  ApartmentModel({
    @required this.id,
    @required this.name,
    @required this.area,
    @required this.city,
    @required this.state,
    @required this.pincode,
  });

  factory ApartmentModel.fromJson(Map<String, dynamic> json) =>
      _$ApartmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApartmentModelToJson(this);
}
