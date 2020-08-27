import 'package:flutter/material.dart';

enum DeliveryStatus { pending, outfordelivery, delivered, cancelled }

extension DeliveryStatusExtension on DeliveryStatus {
  String get message {
    switch (this) {
      case DeliveryStatus.delivered:
        return 'Delivered';
      case DeliveryStatus.outfordelivery:
        return 'Out For Delivery';
      case DeliveryStatus.cancelled:
        return 'Cancelled';
      default:
        return 'Pending';
    }
  }

  IconData get icon {
    switch (this) {
      case DeliveryStatus.delivered:
        return Icons.hourglass_empty;
      case DeliveryStatus.outfordelivery:
        return Icons.directions_bike;
      case DeliveryStatus.cancelled:
        return Icons.highlight_off;
      default:
        return Icons.hourglass_empty;
    }
  }

  Color get color {
    switch (this) {
      case DeliveryStatus.delivered:
        return Colors.green;
      case DeliveryStatus.outfordelivery:
        return Colors.green;
      case DeliveryStatus.cancelled:
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}
