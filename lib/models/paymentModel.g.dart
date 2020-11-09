// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paymentModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentModel _$PaymentModelFromJson(Map<String, dynamic> json) {
  return PaymentModel(
    id: json['paymentId'] as String,
    status: json['status'] as String,
    txnId: json['txnId'] as String,
    txnDate: json['txnDate'] == null
        ? null
        : DateTime.parse(json['txnDate'] as String),
    paymentMode: json['paymentMode'] as String,
  );
}

Map<String, dynamic> _$PaymentModelToJson(PaymentModel instance) =>
    <String, dynamic>{
      'paymentId': instance.id,
      'status': instance.status,
      'txnId': instance.txnId,
      'txnDate': instance.txnDate?.toIso8601String(),
      'paymentMode': instance.paymentMode,
    };
