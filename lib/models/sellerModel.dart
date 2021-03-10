import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sellerModel.g.dart';

@JsonSerializable()
class SellerModel {
  final String id;
  final String brandName;
  final String tagline;

  final String businessCategory;

  final String brandImageUrl;

  final bool live;

  final String phone;
  final String whatsapp;

  final String deliveryMessage;
  final DateTime deliveryDate;
  final String deliverySlot;
  final int deliveryFee;
  final int deliveryMinOrder;

  final String address;
  final String fssaiLicenseNumber;

  SellerModel({
    @required this.id,
    @required this.brandName,
    @required this.tagline,
    @required this.businessCategory,
    @required this.brandImageUrl,
    @required this.live,
    @required this.phone,
    @required this.whatsapp,
    @required this.deliveryMessage,
    @required this.deliveryDate,
    this.deliverySlot,
    this.address,
    this.fssaiLicenseNumber,
    this.deliveryFee = 0,
    this.deliveryMinOrder = 0,
  });

  factory SellerModel.fromJson(Map<String, dynamic> json) =>
      _$SellerModelFromJson(json);

  Map<String, dynamic> toJson() => _$SellerModelToJson(this);
}
