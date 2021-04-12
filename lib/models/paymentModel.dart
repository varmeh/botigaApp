import 'package:json_annotation/json_annotation.dart';

part 'paymentModel.g.dart';

@JsonSerializable()
class PaymentModel {
  final String orderId;
  final String paymentId;
  String status;
  String paymentMode;
  String description;

  PaymentModel({
    this.orderId,
    this.paymentId,
    this.status,
    this.paymentMode,
    this.description,
  });

  bool get isInitiated => status == 'initiated';
  bool get isSuccess => status == 'success';
  bool get isFailure => status == 'failure';

  factory PaymentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentModelToJson(this);
}
