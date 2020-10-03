import 'package:flutter/material.dart';
import '../../../models/index.dart' show SellerModel;
import '../../../util/index.dart' show Constants;
import '../../../widgets/index.dart' show ContactPartnerWidget;

class SellerBrandCard extends StatelessWidget {
  final SellerModel seller;

  SellerBrandCard(this.seller);

  @override
  Widget build(BuildContext context) {
    final _themeData = Theme.of(context);
    final _subtitle1 =
        _themeData.textTheme.subtitle1.merge(Constants.kTextStyleFontWeight300);
    final _sizedBox = SizedBox(height: 15.0);

    return Card(
      color: _themeData.accentColor,
      child: Padding(
        padding: Constants.kEdgeInsetsCard,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    seller.tagline,
                    style: _themeData.textTheme.headline6,
                  ),
                  _sizedBox,
                  Text(
                    seller.businessCategory,
                    style: _subtitle1,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ContactPartnerWidget(
                phone: seller.phone,
                whatsapp: seller.whatsapp,
                phoneIconColor: _themeData.textTheme.headline6.color,
                whatsappIconColor: _themeData.textTheme.headline6.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
