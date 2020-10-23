import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'addressModel.g.dart';

@JsonSerializable()
class AddressModel {
  final String id;
  final String house;
  final String apartment;
  final String area;
  final String city;
  final String state;
  final String pincode;

  AddressModel({
    @required this.id,
    @required this.house,
    @required this.apartment,
    @required this.area,
    @required this.city,
    @required this.state,
    @required this.pincode,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddressModelToJson(this);
}
