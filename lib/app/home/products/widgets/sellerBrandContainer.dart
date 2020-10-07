import 'package:flutter/material.dart';

import '../../../../models/index.dart' show SellerModel;
import '../../../../theme/index.dart';
import '../../../../widgets/contactPartnerWidget.dart';

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
          SizedBox(height: 10.0),
          _iconInfo(context, 'assets/images/shop.png', seller.businessCategory),
          SizedBox(height: 10.0),
          _iconInfo(context, 'assets/images/pin.png', seller.deliveryMessage),
          SizedBox(height: 10.0),
          ContactPartnerWidget(
            phone: seller.phone,
            whatsapp: seller.whatsapp,
          )
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
                style: AppTheme.textStyle.w700.color100.size(17),
              ),
              Text(
                seller.businessCategory, //TODO: change to tagline
                style: AppTheme.textStyle.w500.color50.size(13),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 12,
        ),
        CircleAvatar(
          radius: 32,
          backgroundColor: AppTheme.dividerColor,
          backgroundImage: NetworkImage(
            'https://www.spendwithpennies.com/wp-content/uploads/2015/10/Chocolate-Ganache-22.jpg',
          ),
        ),
      ],
    );
  }

  Widget _iconInfo(BuildContext context, String image, String info) {
    return Row(
      children: [
        Image.asset(image),
        SizedBox(width: 6.0),
        Text(
          info,
          style: AppTheme.textStyle.w500.color100.size(14),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }
}
