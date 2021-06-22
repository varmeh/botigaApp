import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/sellerModel.dart';
import '../../providers/index.dart' show ApartmentProvider, UserProvider;
import '../../theme/index.dart';
import '../../widgets/index.dart'
    show
        BrandingTile,
        InviteTile,
        HttpServiceExceptionWidget,
        CircleNetworkAvatar,
        BannerCarosuel,
        TapBannerModel,
        ShimmerWidget;
import '../location/index.dart'
    show SelectApartmenWhenNoUserLoggedInScreen, SavedAddressesSelectionModal;
import '../tabbar.dart';
import 'products/productListScreen.dart';
import '../../util/index.dart' show DateExtension, StringExtensions;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

const double _horizontalPadding = 20;
const double _crossAxisSpacing = 16;
const int _gridColumns = 2;
const double _heightDelta = 82;

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  bool _isLoading = false;
  Exception _error;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    Future.delayed(Duration(milliseconds: 0), () => _getApartmentData());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // This ensures transition to product list screen if resumed by a notification
      _getApartmentData();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _shimmerWidget();
    } else if (_error != null) {
      return HttpServiceExceptionWidget(
        exception: _error,
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
      final provider = Provider.of<ApartmentProvider>(context);
      return ListView(
        padding: EdgeInsets.zero,
        children: [
          appBar(context, provider),
          _banners(context, provider),
          provider.hasBanners ? SizedBox(height: 12) : SizedBox(height: 24),
          _filter(provider),
          _availableSellersGrid(provider),
          InviteTile(),
          _notAvailableSellersGrid(provider),
          BrandingTile(
            'Thriving communities, empowering people',
            'Made by awesome team of Botiga',
          ),
        ],
      );
    }
  }

  void _getApartmentData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final apartmentProvider =
        Provider.of<ApartmentProvider>(context, listen: false);
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      final apartmentId = userProvider.apartmentId;
      await apartmentProvider.getApartmentData(apartmentId);
    } catch (error) {
      _error = error;
    } finally {
      setState(() => _isLoading = false);
    }

    // See if a notification has been processed
    if (userProvider.notificationSellerId.isNotNullAndEmpty) {
      final seller =
          apartmentProvider.seller(userProvider.notificationSellerId);
      userProvider.notificationSellerId = '';
      if (seller != null) {
        Future.delayed(
          Duration(seconds: 1),
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ProductListScreen(seller)),
          ),
        );
      }
    }
  }

  Widget appBar(BuildContext context, ApartmentProvider apartmentProvider) {
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
                  '${apartmentProvider.availableSellers} merchants delivering',
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

  Widget _banners(BuildContext context, ApartmentProvider provider) {
    if (provider.hasBanners) {
      final tapBannerList = provider.banners
          .map((banner) => TapBannerModel(
                url: banner.url,
                onTap: () {
                  final seller = provider.seller(banner.sellerId);
                  if (seller != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductListScreen(seller),
                      ),
                    );
                  }
                },
              ))
          .cast<TapBannerModel>()
          .toList();

      return Container(
        color: AppTheme.backgroundColor,
        padding: const EdgeInsets.only(top: 24.0),
        child: BannerCarosuel(tapBannerList),
      );
    }
    return Container();
  }

  Widget _filter(ApartmentProvider provider) {
    final _style = AppTheme.textStyle.color50.w500.size(12).letterSpace(0.2);
    final _selectedFilterColor = AppTheme.primaryColor.withOpacity(0.15);

    return provider.hasFilters
        ? Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Container(
              height: 28,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ...provider.filters.map(
                    (filter) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () =>
                            setState(() => provider.selectFilter(filter)),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: provider.selectedFilter == filter
                                  ? Colors.transparent
                                  : AppTheme.dividerColor,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            color: provider.selectedFilter == filter
                                ? _selectedFilterColor
                                : AppTheme.backgroundColor,
                          ),
                          child: Center(
                            child: Text(
                              filter.displayName,
                              textAlign: TextAlign.center,
                              style: provider.selectedFilter == filter
                                  ? _style.colored(AppTheme.primaryColor)
                                  : _style,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container();
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

  Widget _availableSellersGrid(ApartmentProvider provider) {
    final color = AppTheme.backgroundColor;
    final width = (MediaQuery.of(context).size.width -
            _horizontalPadding * 2 -
            _crossAxisSpacing) /
        _gridColumns;
    final height = width + _heightDelta;

    return !provider.hasAvailableSellers
        ? Container()
        : Container(
            padding: const EdgeInsets.only(
              top: 32,
              left: _horizontalPadding,
              right: _horizontalPadding,
              bottom: 20,
            ),
            color: color,
            child: GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(bottom: _crossAxisSpacing),
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: width / height,
                mainAxisSpacing: _crossAxisSpacing * 2,
                crossAxisSpacing: _crossAxisSpacing,
              ),
              itemCount: provider.availableSellers,
              itemBuilder: (context, index) => _sellersGridTile(
                  provider.sellers[index], color, width, height),
            ),
          );
  }

  Widget _notAvailableSellersGrid(ApartmentProvider provider) {
    final color = Color(0xfff7f7f7);

    final width = (MediaQuery.of(context).size.width -
            _horizontalPadding * 2 -
            _crossAxisSpacing) /
        _gridColumns;
    final height = width + 82;

    return !provider.hasNotAvailableSellers
        ? Container()
        : Container(
            padding: const EdgeInsets.only(
              top: 24,
              left: _horizontalPadding,
              right: _horizontalPadding,
              bottom: 20,
            ),
            color: color,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Not accepting orders',
                  style: AppTheme.textStyle.w700.color100
                      .size(20.0)
                      .lineHeight(1.2),
                ),
                SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(bottom: _crossAxisSpacing),
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: width / height,
                    mainAxisSpacing: _crossAxisSpacing * 2,
                    crossAxisSpacing: _crossAxisSpacing,
                  ),
                  itemCount: provider.notAvailableSellers,
                  itemBuilder: (context, index) => _sellersGridTile(
                      provider.sellers[provider.availableSellers + index],
                      color,
                      width,
                      height),
                ),
              ],
            ));
  }

  Widget _sellersGridTile(
      SellerModel seller, Color color, double width, double height) {
    final deliveryDay = seller.deliveryDate != null &&
            seller.deliveryDate.difference(DateTime.now()).inDays >= 1
        ? '${seller.deliveryDate.dateFormatDayMonthWeekday}'
        : 'Tomorrow';

    return OpenContainer(
      closedElevation: 3.0,
      closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      transitionDuration: Duration(milliseconds: 300),
      closedColor: color,
      closedBuilder: (context, openContainer) {
        return Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(
                  'https://s3.ap-south-1.amazonaws.com/products.image.dev/home1_tiny.png',
                  width: width,
                  height: width,
                ),
                SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        seller.brandName,
                        style: AppTheme.textStyle.color50.w500
                            .size(11)
                            .lineHeight(1.5)
                            .letterSpace(0.2),
                      ),
                      SizedBox(height: 6),
                      AutoSizeText(
                        seller.tagline,
                        style: AppTheme.textStyle.color100.w700
                            .size(13)
                            .lineHeight(1.2),
                        minFontSize: 11.0,
                        maxFontSize: 13.0,
                        maxLines: 1,
                      ),
                    ],
                  ),
                )
              ],
            ),
            Positioned(
              bottom: 14,
              left: 12,
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/truck.png',
                    width: 18,
                    height: 18,
                    color: AppTheme.color50,
                  ),
                  SizedBox(width: 6),
                  Text(
                    deliveryDay,
                    maxLines: 1,
                    style: AppTheme.textStyle.color50.w500
                        .size(11)
                        .lineHeight(1.1),
                  ),
                ],
              ),
            )
          ],
        );
      },
      openBuilder: (_, __) => ProductListScreen(seller),
    );
  }

  Widget _shimmerWidget() {
    return ListView(
      padding: const EdgeInsets.all(0),
      children: [
        ShimmerWidget(
          child: Container(
            width: double.infinity,
            height: 125,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: const Radius.circular(16.0),
                bottomRight: const Radius.circular(16.0),
              ),
            ),
          ),
        ),
        ShimmerWidget(
          child: Container(
            width: double.infinity,
            height: 136,
            margin:
                const EdgeInsets.only(left: 32, right: 32, top: 24, bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List<Widget>.generate(
              5,
              (index) => Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.only(left: 4.0, right: 4.0, bottom: 24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.color25,
                ),
              ),
            ),
          ],
        ),
        Column(
          children: [
            ...List<Widget>.generate(
              10,
              (index) => ShimmerWidget(
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    top: 24.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(radius: 28),
                      SizedBox(width: 12),
                      Expanded(
                        flex: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: AppTheme.color05),
                            ),
                          ),
                          padding: const EdgeInsets.only(
                            left: 2.0,
                            top: 12.0,
                            bottom: 20.0,
                            right: 20.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 15.0,
                                color: Colors.white,
                              ),
                              SizedBox(height: 8),
                              Container(
                                width: 200,
                                height: 13.0,
                                color: Colors.white,
                              ),
                              SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                height: 13.0,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
