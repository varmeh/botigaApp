import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/sellerModel.dart';
import '../../providers/index.dart' show SellersProvider, UserProvider;
import '../../theme/index.dart';
import '../../widgets/index.dart'
    show
        BrandingTile,
        InviteTile,
        Loader,
        HttpServiceExceptionWidget,
        CircleNetworkAvatar;
import '../location/index.dart'
    show SelectApartmenWhenNoUserLoggedInScreen, SavedAddressesSelectionModal;
import '../tabbar.dart';
import 'products/productListScreen.dart';
import '../../util/index.dart' show DateExtension;

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userProvider = Provider.of<UserProvider>(context);

    return Consumer<SellersProvider>(
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
              return ListView(
                padding: EdgeInsets.zero,
                children: [
                  appBar(context, provider),
                  _availableSellers(context, provider),
                  Container(
                    color: AppTheme.backgroundColor,
                    padding: const EdgeInsets.only(top: 24.0, bottom: 24.0),
                    child: InviteTile(),
                  ),
                  _notAvailableSellers(context, provider),
                  BrandingTile(
                    'Thriving communities, empowering people',
                    'Made by awesome team of Botiga',
                  ),
                ],
              );
            }
          },
        );
      },
    );
  }

  Widget appBar(BuildContext context, SellersProvider sellersProvider) {
    return Material(
      child: Container(
        width: double.infinity,
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
          padding: const EdgeInsets.only(
            left: 20.0,
            top: 60.0,
            right: 20.0,
            bottom: 32.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(child: _selectApartment(context)),
              Padding(
                padding: const EdgeInsets.only(
                  top: 4.0,
                  left: 6.0,
                ),
                child: Text(
                  '${sellersProvider.availableSellers} merchants delivering',
                  style: AppTheme.textStyle.w700
                      .size(13.0)
                      .lineHeight(1.5)
                      .colored(AppTheme.backgroundColor),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectApartment(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (userProvider.isLoggedIn) {
          SavedAddressesSelectionModal().show(context);
        } else {
          Navigator.pushNamed(
            context,
            SelectApartmenWhenNoUserLoggedInScreen.route,
          );
        }
      },
      child: Row(
        children: [
          Image.asset(
            'assets/images/pinFilled.png',
            color: AppTheme.backgroundColor,
          ),
          SizedBox(width: 9),
          Flexible(
            child: AutoSizeText(
              userProvider.isLoggedIn
                  ? userProvider.house
                  : userProvider.apartmentName,
              style: AppTheme.textStyle.w700
                  .size(20.0)
                  .lineHeight(1.4)
                  .colored(AppTheme.backgroundColor),
              minFontSize: 17.0,
              maxFontSize: 20.0,
              maxLines: 2,
            ),
          ),
          SizedBox(width: 4),
          Icon(
            Icons.expand_more_sharp,
            size: 25,
            color: AppTheme.backgroundColor,
          ),
        ],
      ),
    );
  }

  Widget _availableSellers(BuildContext context, SellersProvider provider) {
    final color = AppTheme.backgroundColor;
    return !provider.hasAvailableSellers
        ? Container()
        : Container(
            color: color,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...List.generate(
                  provider.availableSellers,
                  (index) => _sellersTile(
                    context,
                    provider.sellerList[index],
                    color,
                  ),
                )
              ],
            ),
          );
  }

  Widget _notAvailableSellers(BuildContext context, SellersProvider provider) {
    final color = Color(0xfff7f7f7);
    return !provider.hasNotAvailableSellers
        ? Container()
        : Container(
            padding: const EdgeInsets.only(top: 24.0, bottom: 24.0),
            color: color,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Not accepting orders',
                    style: AppTheme.textStyle.w700.color100
                        .size(20.0)
                        .lineHeight(1.2),
                  ),
                ),
                ...List.generate(
                  provider.notAvailableSellers,
                  (index) => _sellersTile(
                    context,
                    provider.sellerList[provider.availableSellers + index],
                    color,
                  ),
                )
              ],
            ),
          );
  }

  Widget _sellersTile(BuildContext context, SellerModel seller, Color color) {
    return OpenContainer(
      closedElevation: 0.0,
      transitionDuration: Duration(milliseconds: 300),
      closedBuilder: (context, openContainer) {
        return Container(
          padding: EdgeInsets.only(
            left: 20,
            top: 24,
          ),
          color: color,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleNetworkAvatar(
                imageUrl: seller.brandImageUrl,
                radius: 28.0,
                isColored: seller.live,
              ),
              SizedBox(width: 12),
              Expanded(
                flex: 4,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppTheme.dividerColor),
                    ),
                  ),
                  padding: const EdgeInsets.only(
                    left: 2.0,
                    top: 12.0,
                    bottom: 20.0,
                    right: 20.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        seller.brandName,
                        style: AppTheme.textStyle.color100.w600
                            .size(15)
                            .lineHeight(1.3),
                      ),
                      Text(
                        seller.businessCategory,
                        style: AppTheme.textStyle.color50.w500
                            .size(13)
                            .lineHeight(1.5),
                      ),
                      (seller.deliveryDate != null &&
                              seller.deliveryDate
                                      .difference(DateTime.now())
                                      .inDays >=
                                  1)
                          ? Text(
                              'Delivery by ${seller.deliveryDate.dateFormatCompleteWeekDayMonthDay}',
                              style: AppTheme.textStyle.color100.w500
                                  .size(13)
                                  .lineHeight(1.5),
                            )
                          : Text(
                              "Delivery Tomorrow",
                              style: AppTheme.textStyle.color100.w500
                                  .size(13)
                                  .lineHeight(1.5),
                            )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      openBuilder: (_, __) => ProductListScreen(seller),
    );
  }
}
