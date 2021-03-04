// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'couponModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CouponModel _$CouponModelFromJson(Map<String, dynamic> json) {
  return CouponModel(
    couponId: json['couponId'] as String,
    couponCode: json['couponCode'] as String,
    discountType: json['discountType'] as String,
    discountValue: json['discountValue'] as int,
    expiryDate: json['expiryDate'] == null
        ? null
        : DateTime.parse(json['expiryDate'] as String),
    visibleToAllCustomers: json['visibleToAllCustomers'] as bool,
    minimumOrderValue: json['minimumOrderValue'] as int,
    maxDiscountAmount: json['maxDiscountAmount'] as int,
  );
}

Map<String, dynamic> _$CouponModelToJson(CouponModel instance) =>
    <String, dynamic>{
      'couponId': instance.couponId,
      'discountType': instance.discountType,
      'discountValue': instance.discountValue,
      'expiryDate': instance.expiryDate?.toIso8601String(),
      'visibleToAllCustomers': instance.visibleToAllCustomers,
      'minimumOrderValue': instance.minimumOrderValue,
      'maxDiscountAmount': instance.maxDiscountAmount,
    };
