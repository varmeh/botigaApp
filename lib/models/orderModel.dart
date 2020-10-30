import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

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
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);

  String get statusMessage {
    if (status == 'open') {
      return 'Order Placed';
    } else if (status == 'out') {
      return 'Out For Delivery';
    } else if (status == 'delivered') {
      return 'Delivered';
    } else if (status == 'delay') {
      return 'Delayed';
    } else if (status == 'canceled') {
      return 'Canceled';
    } else {
      return status;
    }
  }

  Color get statusColor {
    if (status == 'open' || status == 'delay') {
      return Color.fromRGBO(233, 161, 54, 1);
    } else if (status == 'out' || status == 'delivered') {
      return Color.fromRGBO(23, 159, 87, 1);
    } else {
      return Color.fromRGBO(233, 86, 54, 1);
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
