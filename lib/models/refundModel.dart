import 'package:json_annotation/json_annotation.dart';

part 'refundModel.g.dart';

@JsonSerializable()
class RefundModel {
  @JsonKey(name: 'redundId')
  final String id;
  final String status;
  final DateTime refundDate;

  RefundModel({
    this.id,
    this.status,
    this.refundDate,
  });

  factory RefundModel.fromJson(Map<String, dynamic> json) =>
      _$RefundModelFromJson(json);

  Map<String, dynamic> toJson() => _$RefundModelToJson(this);
}
