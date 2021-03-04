import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'couponModel.g.dart';

@JsonSerializable()
class CouponModel {
  final String couponId;
  final String discountType;
  final int discountValue;
  final DateTime expiryDate;
  final bool visibleToAllCustomers;
  final int minimumOrderValue;
  final int maxDiscountAmount;

  CouponModel({
    @required this.couponId,
    @required this.discountType,
    @required this.discountValue,
    @required this.expiryDate,
    @required this.visibleToAllCustomers,
    this.minimumOrderValue,
    this.maxDiscountAmount,
  });

  bool get isPercentageDiscount => discountType == 'percentage';

  factory CouponModel.fromJson(Map<String, dynamic> json) =>
      _$CouponModelFromJson(json);

  Map<String, dynamic> toJson() => _$CouponModelToJson(this);
}
