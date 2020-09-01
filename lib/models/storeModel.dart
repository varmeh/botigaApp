import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/foundation.dart';

part 'storeModel.g.dart';

@JsonSerializable()
class StoreModel {
  final String id;
  final String name;
  final String moto;

  final List<String> segmentList;

  final String phone;
  final String whatsapp;

  StoreModel({
    @required this.id,
    @required this.name,
    @required this.segmentList,
    @required this.moto,
    @required this.phone,
    @required this.whatsapp,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) =>
      _$StoreModelFromJson(json);

  Map<String, dynamic> toJson() => _$StoreModelToJson(this);

  String get segments {
    return segmentList.join(' - ');
  }
}
