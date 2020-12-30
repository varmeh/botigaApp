// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paymentModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentModel _$PaymentModelFromJson(Map<String, dynamic> json) {
  return PaymentModel(
    orderId: json['orderId'] as String,
    paymentId: json['paymentId'] as String,
    status: json['status'] as String,
    paymentMode: json['paymentMode'] as String,
  );
}

Map<String, dynamic> _$PaymentModelToJson(PaymentModel instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'paymentId': instance.paymentId,
      'status': instance.status,
      'paymentMode': instance.paymentMode,
    };
