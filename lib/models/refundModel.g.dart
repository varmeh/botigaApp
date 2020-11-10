// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refundModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RefundModel _$RefundModelFromJson(Map<String, dynamic> json) {
  return RefundModel(
    id: json['id'] as String,
    amount: json['amount'] as String,
    status: json['status'] as String,
    date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
  );
}

Map<String, dynamic> _$RefundModelToJson(RefundModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'status': instance.status,
      'date': instance.date?.toIso8601String(),
    };
