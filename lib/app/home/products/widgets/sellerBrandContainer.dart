import 'package:flutter/material.dart';

import '../../../../models/index.dart' show SellerModel;
import '../../../../theme/botigaIcons.dart';
import '../../../../theme/textTheme.dart';

class SellerBrandContainer extends StatelessWidget {
  final SellerModel seller;

  SellerBrandContainer(this.seller);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 0, 32, 0),
      child: Column(
        children: [
          _brandInfo(context),
          _iconInfo(context, BotigaIcons.shop, seller.businessCategory),
          SizedBox(height: 8.0),
          _iconInfo(context, BotigaIcons.pin, seller.deliveryMessage),
        ],
      ),
    );
  }

  Widget _brandInfo(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                seller.brandName,
                style: TextStyles.fontFamily.w700.color100.size(17),
              ),
              Text(
                seller.businessCategory,
                style: TextStyles.fontFamily.w500.color50.size(13),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 12,
        ),
        CircleAvatar(
          radius: 32,
          backgroundColor: Theme.of(context).disabledColor,
          backgroundImage: NetworkImage(
            'https://www.spendwithpennies.com/wp-content/uploads/2015/10/Chocolate-Ganache-22.jpg',
          ),
        ),
      ],
    );
  }

  Widget _iconInfo(BuildContext context, IconData iconData, String info) {
    return Row(
      children: [
        Icon(iconData),
        SizedBox(width: 6.0),
        Text(
          info,
          style: TextStyles.fontFamily.w500.color100.size(13),
        ),
      ],
    );
  }
}
