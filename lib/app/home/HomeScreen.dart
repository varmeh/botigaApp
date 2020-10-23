import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/sellerModel.dart';
import '../../providers/index.dart' show SellersProvider, UserProvider;

import '../../widgets/index.dart'
    show BrandingTile, InviteTile, Loader, HttpServiceExceptionWidget;
import '../../theme/index.dart';
import 'products/productListScreen.dart';

import '../tabbar.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userProvider = Provider.of<UserProvider>(context);

    return FutureBuilder(
      future: Provider.of<SellersProvider>(context, listen: false)
          .getSellers(_userProvider.apartmentId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loader();
        } else if (snapshot.hasError) {
          return HttpServiceExceptionWidget(
            exception: snapshot.error,
            onTap: () {
              // Rebuild screen
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => Tabbar(index: 0),
                  transitionDuration: Duration.zero,
                ),
              );
            },
          );
        } else {
          return Consumer<SellersProvider>(
            builder: (context, provider, child) {
              return ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: provider.sellerList.length + 3,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return appBar(
                      context,
                      _userProvider.firstName,
                      provider.sellerList.length,
                    );
                  } else if (index <= provider.sellerList.length) {
                    return _sellersTile(
                      context,
                      provider.sellerList[index - 1],
                    );
                  } else if (index == provider.sellerList.length + 1) {
                    return Container(
                      color: AppTheme.backgroundColor,
                      padding: const EdgeInsets.only(top: 24.0),
                      child: InviteTile(),
                    );
                  } else {
                    return BrandingTile(
                      'Thriving communities, empowering people',
                      'Made by awesome team of Botiga',
                    );
                  }
                },
              );
            },
          );
        }
      },
    );
  }

  Widget appBar(BuildContext context, String name, int numberOfMerchants) {
    return Material(
      child: Container(
        width: double.infinity,
        height: 145,
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.only(
              bottomLeft: const Radius.circular(16.0),
              bottomRight: const Radius.circular(16.0),
            ),
            image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          padding: EdgeInsets.fromLTRB(20.0, 60.0, 20.0, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi $name', //TODO: remove name hard coding
                style: AppTheme.textStyle.w700
                    .size(22.0)
                    .lineHeight(1.2)
                    .colored(AppTheme.backgroundColor),
              ),
              SizedBox(height: 4.0),
              Text(
                '$numberOfMerchants merchants delivering',
                style: AppTheme.textStyle.w700
                    .size(13.0)
                    .lineHeight(1.5)
                    .colored(AppTheme.backgroundColor),
              )
            ],
          ),
        ),
      ),
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
        color: AppTheme.backgroundColor,
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
            ),
          ],
        ),
      ),
    );
  }
}
