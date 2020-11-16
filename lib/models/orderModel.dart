import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import './paymentModel.dart';
import './refundModel.dart';

part 'orderModel.g.dart';

@JsonSerializable()
class OrderModel {
  final String id;
  final OrderSellerModel seller;
  final String number;
  final String status;
  final double totalAmount;
  final DateTime orderDate;
  final DateTime expectedDeliveryDate;
  final DateTime completionDate;
  final List<OrderProductModel> products;
  final PaymentModel payment;
  final RefundModel refund;

  OrderModel({
    @required this.id,
    @required this.seller,
    @required this.number,
    @required this.status,
    @required this.totalAmount,
    @required this.orderDate,
    @required this.expectedDeliveryDate,
    @required this.completionDate,
    @required this.products,
    this.payment,
    this.refund,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);

  bool get isOpen => status == 'open';
  bool get isDelayed => status == 'delayed';
  bool get isOutForDelivery => status == 'out';
  bool get isDelivered => status == 'delivered';
  bool get isCancelled => status == 'cancelled';

  String get statusMessage {
    if (isOpen) {
      return 'Order Placed';
    } else if (isOutForDelivery) {
      return 'Out For Delivery';
    } else if (isDelivered) {
      return 'Delivered';
    } else if (isDelayed) {
      return 'Delayed';
    } else if (isCancelled) {
      return 'Cancelled';
    } else {
      return status;
    }
  }

  Color get statusColor {
    if (isDelivered) {
      return Color(0xff179f57);
    } else if (isOpen) {
      return Color(0xffe9a136);
    } else if (isOutForDelivery) {
      return Color(0xff36b9e9);
    } else if (isDelayed) {
      return Color(0xffe95636);
    } else {
      // Cancelled
      return Color(0xff787371);
    }
  }
}

@JsonSerializable()
class OrderSellerModel {
  final String id;
  final String brandName;
  final String phone;
  final String whatsapp;
  final String email;

  OrderSellerModel({
    @required this.id,
    @required this.brandName,
    @required this.phone,
    @required this.whatsapp,
    @required this.email,
  });

  factory OrderSellerModel.fromJson(Map<String, dynamic> json) =>
      _$OrderSellerModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderSellerModelToJson(this);
}

@JsonSerializable()
class OrderProductModel {
  @JsonKey(name: '_id')
  final String id;

  final String name;
  final double price;
  final int quantity;
  final String unitInfo;

  OrderProductModel({
    @required this.id,
    @required this.name,
    @required this.price,
    @required this.quantity,
    @required this.unitInfo,
  });

  factory OrderProductModel.fromJson(Map<String, dynamic> json) =>
      _$OrderProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderProductModelToJson(this);
}
