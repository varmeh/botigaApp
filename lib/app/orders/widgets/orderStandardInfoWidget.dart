import 'package:flutter/material.dart';

import '../../../theme/index.dart';
import '../../../util/index.dart';
import '../../../widgets/index.dart' show ContactPartnerWidget;
import '../../../models/index.dart'
    show DeliveryStatus, DeliveryStatusExtension;

class OrderStandardInfoWidget extends StatelessWidget {
  Widget deliveryStatus(TextTheme textTheme, DeliveryStatus status) {
    return Row(
      children: [
        Text(
          status.message,
          style: textTheme.bodyText2,
        ),
        SizedBox(
          width: 3,
        ),
        Icon(
          status.icon,
          size: 16,
          color: status.color,
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

    return Container(
      padding: Constants.kEdgeInsetsCard,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '24 Mantra',
                      style: _textTheme.subtitle1.w700,
                    ),
                    deliveryStatus(_textTheme, DeliveryStatus.outfordelivery),
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
          ),
          Expanded(
            child: ContactPartnerWidget(
              phone: '+919910057232',
              whatsapp: '+919910057232',
            ),
          ),
        ],
      ),
    );
  }
}
