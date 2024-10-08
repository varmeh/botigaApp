// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orderModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) {
  return OrderModel(
    id: json['id'] as String,
    seller: json['seller'] == null
        ? null
        : OrderSellerModel.fromJson(json['seller'] as Map<String, dynamic>),
    number: json['number'] as String,
    email: json['email'] as String,
    status: json['status'] as String,
    totalAmount: (json['totalAmount'] as num)?.toDouble(),
    discountAmount: (json['discountAmount'] as num)?.toDouble(),
    couponCode: json['couponCode'] as String,
    deliveryFee: json['deliveryFee'] as int,
    orderDate: json['orderDate'] == null
        ? null
        : DateTime.parse(json['orderDate'] as String),
    expectedDeliveryDate: json['expectedDeliveryDate'] == null
        ? null
        : DateTime.parse(json['expectedDeliveryDate'] as String),
    deliverySlot: json['deliverySlot'] as String,
    completionDate: json['completionDate'] == null
        ? null
        : DateTime.parse(json['completionDate'] as String),
    products: (json['products'] as List)
        ?.map((e) => e == null
            ? null
            : OrderProductModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    payment: json['payment'] == null
        ? null
        : PaymentModel.fromJson(json['payment'] as Map<String, dynamic>),
    refund: json['refund'] == null
        ? null
        : RefundModel.fromJson(json['refund'] as Map<String, dynamic>),
    house: json['house'] as String,
    apartment: json['apartment'] as String,
  );
}

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'seller': instance.seller,
      'number': instance.number,
      'email': instance.email,
      'status': instance.status,
      'totalAmount': instance.totalAmount,
      'discountAmount': instance.discountAmount,
      'couponCode': instance.couponCode,
      'deliveryFee': instance.deliveryFee,
      'orderDate': instance.orderDate?.toIso8601String(),
      'expectedDeliveryDate': instance.expectedDeliveryDate?.toIso8601String(),
      'deliverySlot': instance.deliverySlot,
      'completionDate': instance.completionDate?.toIso8601String(),
      'products': instance.products,
      'payment': instance.payment,
      'refund': instance.refund,
      'house': instance.house,
      'apartment': instance.apartment,
    };

OrderSellerModel _$OrderSellerModelFromJson(Map<String, dynamic> json) {
  return OrderSellerModel(
    id: json['id'] as String,
    brandName: json['brandName'] as String,
    phone: json['phone'] as String,
    whatsapp: json['whatsapp'] as String,
    email: json['email'] as String,
  );
}

Map<String, dynamic> _$OrderSellerModelToJson(OrderSellerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'brandName': instance.brandName,
      'phone': instance.phone,
      'whatsapp': instance.whatsapp,
      'email': instance.email,
    };

OrderProductModel _$OrderProductModelFromJson(Map<String, dynamic> json) {
  return OrderProductModel(
    id: json['_id'] as String,
    name: json['name'] as String,
    price: (json['price'] as num)?.toDouble(),
    quantity: json['quantity'] as int,
    unitInfo: json['unitInfo'] as String,
  );
}

Map<String, dynamic> _$OrderProductModelToJson(OrderProductModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'quantity': instance.quantity,
      'unitInfo': instance.unitInfo,
    };
