import 'package:json_annotation/json_annotation.dart';

part 'refundModel.g.dart';

@JsonSerializable()
class RefundModel {
  final String id;
  final String amount;
  final String status;
  final DateTime date;

  RefundModel({
    this.id,
    this.amount,
    this.status,
    this.date,
  });

  bool get isInitiated => status == 'initiated';
  bool get isPending => status == 'pending';
  bool get isSuccess => status == 'success';
  bool get isFailure => status == 'failure';

  factory RefundModel.fromJson(Map<String, dynamic> json) =>
      _$RefundModelFromJson(json);

  Map<String, dynamic> toJson() => _$RefundModelToJson(this);
}
