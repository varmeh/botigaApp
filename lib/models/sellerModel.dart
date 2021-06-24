import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import '../util/index.dart' show StringExtensions;

part 'sellerModel.g.dart';

@JsonSerializable()
class SellerModel {
  final String id;
  final String brandName;
  final String tagline;

  final String businessCategory;

  final String brandImageUrl;
  final String homeImageUrl;
  final String homeTagline;

  final bool live;

  final String phone;
  final String whatsapp;

  final String deliveryMessage;
  final DateTime deliveryDate;
  final String deliverySlot;
  final int deliveryFee;
  final int deliveryMinOrder;

  final bool limitedDelivery;
  final bool newlyLaunched;

  final String address;
  final String fssaiLicenseNumber;

  List<String> filters;

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
    this.homeImageUrl,
    this.homeTagline,
    this.deliverySlot,
    this.address,
    this.fssaiLicenseNumber,
    this.deliveryFee = 0,
    this.deliveryMinOrder = 0,
    this.filters,
    this.limitedDelivery = true, //TODO: change default to false
    this.newlyLaunched = true, //TODO: change default to false
  });

  bool get hasDeliveryFee => deliveryFee > 0;

  String get brandTagline =>
      homeTagline.isNotNullAndEmpty ? homeTagline : tagline;

  String get brandUrl =>
      homeImageUrl.isNotNullAndEmpty ? homeImageUrl : brandImageUrl;

  factory SellerModel.fromJson(Map<String, dynamic> json) =>
      _$SellerModelFromJson(json);

  Map<String, dynamic> toJson() => _$SellerModelToJson(this);
}
