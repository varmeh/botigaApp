import 'package:flutter/material.dart';

import '../../../util/index.dart' show Constants;

enum _DeliveryStatus { pending, outfordelivery, delivered, cancelled }

class _DeliveryData {
  final String message;
  final IconData iconData;
  final Color iconColor;

  _DeliveryData(this.message, this.iconData, this.iconColor);
}

class OrderStandardInfoWidget extends StatelessWidget {
  static Map<_DeliveryStatus, _DeliveryData> _deliveryInfo = {
    _DeliveryStatus.pending:
        _DeliveryData('Pending', Icons.hourglass_empty, Colors.orange),
    _DeliveryStatus.outfordelivery:
        _DeliveryData('Out For Delivery', Icons.directions_bike, Colors.green),
    _DeliveryStatus.cancelled:
        _DeliveryData('Cancelled', Icons.highlight_off, Colors.red),
    _DeliveryStatus.delivered:
        _DeliveryData('Delivered', Icons.check_circle, Colors.green),
  };

  Widget _deliveryStatus(TextTheme textTheme, _DeliveryStatus status) {
    return Row(
      children: [
        Text(
          _deliveryInfo[status].message,
          style: textTheme.bodyText2,
        ),
        SizedBox(
          width: 3,
        ),
        Icon(
          _deliveryInfo[status].iconData,
          size: 16,
          color: _deliveryInfo[status].iconColor,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final _textTheme = Theme.of(context).textTheme;
    final _sizedBox = SizedBox(
      height: 15,
    );

    return Padding(
      padding: const EdgeInsets.only(
          top: 25.0, left: 15.0, right: 15.0, bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '24 Mantra',
                style: _textTheme.subtitle1
                    .merge(Constants.kTextStyleFontWeight700),
              ),
              _deliveryStatus(_textTheme, _DeliveryStatus.outfordelivery),
            ],
          ),
          _sizedBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Aug 26, 2020', style: _textTheme.bodyText2),
              Text('₹300', style: _textTheme.bodyText2),
            ],
          ),
        ],
      ),
    );
  }
}
