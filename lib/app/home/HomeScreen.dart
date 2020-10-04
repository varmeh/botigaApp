import 'package:botiga/models/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/index.dart' show SellersProvider;

import 'products/productListScreen.dart';
import '../../util/index.dart' show HttpServiceExceptionWidget;
import '../../widgets/index.dart' show BrandingTile;
import '../../theme/index.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<SellersProvider>(context, listen: false).getSellers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ),
          );
        } else if (snapshot.hasError) {
          return HttpServiceExceptionWidget(snapshot.error);
        } else {
          return Consumer<SellersProvider>(
            builder: (context, provider, child) {
              return ListView.builder(
                itemCount: provider.sellerList.length + 1,
                itemBuilder: (context, index) {
                  return index < provider.sellerList.length
                      ? _sellersTile(context, provider.sellerList[index])
                      : BrandingTile(
                          'Thriving communities, empowering people',
                          'Made by awesome team of Botiga',
                        );
                },
              );
            },
          );
        }
      },
    );
  }

  Widget _sellersTile(BuildContext context, SellerModel seller) {
    final _themeData = Theme.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          ProductListScreen.route,
          arguments: seller,
        );
      },
      child: Container(
        height: 96,
        padding: EdgeInsets.fromLTRB(10, 24, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: _themeData.disabledColor,
              backgroundImage: NetworkImage(
                'https://www.spendwithpennies.com/wp-content/uploads/2015/10/Chocolate-Ganache-22.jpg',
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: _themeData.dividerColor),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(2.0, 12.0, 0.0, 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      seller.brandName,
                      style: AppTheme.textStyle.color100.w600.size(15),
                    ),
                    Text(
                      seller.businessCategory,
                      style: AppTheme.textStyle.color50.w500.size(13),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
