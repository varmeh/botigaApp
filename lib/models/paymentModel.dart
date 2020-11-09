import 'package:json_annotation/json_annotation.dart';

part 'paymentModel.g.dart';

@JsonSerializable()
class PaymentModel {
  @JsonKey(name: 'paymentId')
  final String id;
  final String status;
  final String txnId;
  final DateTime txnDate;
  final String paymentMode;

  PaymentModel({
    this.id,
    this.status,
    this.txnId,
    this.txnDate,
    this.paymentMode,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentModelToJson(this);
}
