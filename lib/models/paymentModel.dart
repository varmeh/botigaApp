import 'package:json_annotation/json_annotation.dart';

part 'paymentModel.g.dart';

@JsonSerializable()
class PaymentModel {
  @JsonKey(name: 'paymentId')
  final String id;
  String status;
  final String txnId;
  final DateTime txnDate;
  String paymentMode;

  PaymentModel({
    this.id,
    this.status,
    this.txnId,
    this.txnDate,
    this.paymentMode,
  });

  bool get isInitiated => status == 'initiated';
  bool get isPending => status == 'pending';
  bool get isSuccess => status == 'success';
  bool get isFailure => status == 'failure';

  factory PaymentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentModelToJson(this);
}
