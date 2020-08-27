import 'package:flutter/material.dart';
import '../models/index.dart' show StoreModel;
import '../../../util/index.dart' show Constants;
import '../../../widgets/index.dart' show ContactPartnerWidget;

class StoreBrandCard extends StatelessWidget {
  final StoreModel store;

  StoreBrandCard(this.store);

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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    store.moto,
                    style: _themeData.textTheme.headline6,
                  ),
                  _sizedBox,
                  Text(
                    store.category,
                    style: _subtitle1,
                  ),
                  _sizedBox,
                  Text(
                    store.combinedTag,
                    style: _subtitle1,
                  ),
                ],
              ),
            ),
            ContactPartnerWidget(
              phone: '+919910057232',
              whatsapp: '+919910057232',
              phoneIconColor: _themeData.textTheme.headline6.color,
              whatsappIconColor: _themeData.textTheme.headline6.color,
            ),
          ],
        ),
      ),
    );
  }
}
