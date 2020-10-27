import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/sellerModel.dart';
import '../../providers/index.dart'
    show SellersProvider, UserProvider, CartProvider;

import '../../widgets/index.dart'
    show
        BrandingTile,
        InviteTile,
        Loader,
        HttpServiceExceptionWidget,
        CircleNetworkAvatar;
import '../../theme/index.dart';
import 'products/productListScreen.dart';

import '../tabbar.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userProvider = Provider.of<UserProvider>(context);

    return _userProvider.apartmentId.isNotEmpty
        ? Consumer<SellersProvider>(
            builder: (context, provider, child) {
              return FutureBuilder(
                future: provider.getSellers(_userProvider.apartmentId),
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
                    if (snapshot.connectionState == ConnectionState.done) {
                      final _provider =
                          Provider.of<CartProvider>(context, listen: false);
                      if (_provider.isEmpty) {
                        _provider.loadCartFromServer();
                      }
                    }

                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: provider.sellerList.length + 3,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return appBar(
                            context,
                            _userProvider.firstName,
                            '${provider.sellerList.length} merchants delivering',
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
                  }
                },
              );
            },
          )
        : _noApartmentSelected(context, _userProvider.firstName);
  }

  Widget appBar(BuildContext context, String name, String message) {
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
                'Hi $name',
                style: AppTheme.textStyle.w700
                    .size(22.0)
                    .lineHeight(1.2)
                    .colored(AppTheme.backgroundColor),
              ),
              SizedBox(height: 4.0),
              Text(
                message,
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
            CircleNetworkAvatar(
              imageUrl: seller.brandImageUrl,
              radius: 28.0,
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

  Widget _noApartmentSelected(BuildContext context, String name) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        appBar(context, name, 'Apartment not selected'),
        BrandingTile(
          'Select your apartment in your profile',
          'Do it now & buy amazing products from Botiga merchants serving in your community',
        ),
      ],
    );
  }
}
