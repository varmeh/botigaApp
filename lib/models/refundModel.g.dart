// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refundModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RefundModel _$RefundModelFromJson(Map<String, dynamic> json) {
  return RefundModel(
    id: json['redundId'] as String,
    status: json['status'] as String,
    refundDate: json['refundDate'] == null
        ? null
        : DateTime.parse(json['refundDate'] as String),
  );
}

Map<String, dynamic> _$RefundModelToJson(RefundModel instance) =>
    <String, dynamic>{
      'redundId': instance.id,
      'status': instance.status,
      'refundDate': instance.refundDate?.toIso8601String(),
    };
