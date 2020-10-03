import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'selleModel.g.dart';

@JsonSerializable()
class SellerModel {
  final String id;
  final String name;
  final String moto;

  final List<String> segmentList;

  final String phone;
  final String whatsapp;

  SellerModel({
    @required this.id,
    @required this.name,
    @required this.segmentList,
    @required this.moto,
    @required this.phone,
    @required this.whatsapp,
  });

  factory SellerModel.fromJson(Map<String, dynamic> json) =>
      _$SellerModelFromJson(json);

  Map<String, dynamic> toJson() => _$SellerModelToJson(this);

  String get segments {
    return segmentList.join(' - ');
  }
}
