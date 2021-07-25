import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/sellerModel.dart';
import '../../providers/index.dart' show ApartmentProvider, UserProvider;
import '../../theme/index.dart';
import '../../widgets/index.dart'
    show
        BrandingTile,
        HttpServiceExceptionWidget,
        BannerCarosuel,
        TapBannerModel,
        ShimmerWidget,
        NetworkCachedImage,
        Ribbon;
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
const double _aspectRatioVertical = 0.6;

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
        screenName: 'Home',
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
      final width = (MediaQuery.of(context).size.width -
              _horizontalPadding * 2 -
              _crossAxisSpacing) /
          _gridColumns;

      final provider = Provider.of<ApartmentProvider>(context);
      return ListView(
        padding: EdgeInsets.zero,
        children: [
          appBar(context, provider),
          _banners(context, provider),
          _closingSellersGrid(provider, width),
          _filter(provider),
          _availableSellersGrid(provider, width),
          _notAvailableSellersGrid(provider, width),
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
    final userProvider = Provider.of<UserProvider>(context);
    return SafeArea(
      child: Padding(
        padding:
            const EdgeInsets.only(top: 24, left: 20, right: 20, bottom: 48),
        child: GestureDetector(
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
          child: Stack(
            children: [
              Card(
                elevation: 4,
                margin: const EdgeInsets.only(
                    top: 14), // Required to display deliverying bar
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/images/pinGreen.png'),
                      SizedBox(width: 9),
                      Expanded(
                        child: AutoSizeText(
                          userProvider.isLoggedIn
                              ? userProvider.house
                              : userProvider.apartmentName,
                          style: AppTheme.textStyle.w700.color100
                              .size(20.0)
                              .lineHeight(1.4),
                          minFontSize: 17.0,
                          maxFontSize: 20.0,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.expand_more_sharp,
                        size: 25,
                        color: AppTheme.color100,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 16,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
                  child: Text(
                    '${apartmentProvider.availableSellers}  MERCHANTS  DELIVERING',
                    style: AppTheme.textStyle.w600
                        .size(11.0)
                        .colored(AppTheme.backgroundColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _closingSellersGrid(ApartmentProvider provider, double width) {
    return provider.hasSellersClosingToday
        ? Container(
            padding: const EdgeInsets.only(bottom: 48),
            color: AppTheme.backgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _showLastDayOrderInfo(),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Row(
                      children: [
                        Text(
                          'Last Day to Order',
                          style: AppTheme.textStyle.w700.color100
                              .size(20.0)
                              .lineHeight(1.2),
                        ),
                        SizedBox(width: 8),
                        Image.asset(
                          'assets/images/info.png',
                          width: 16,
                          height: 16,
                          color: AppTheme.color100,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),
                _horizontalGrid(provider.sellersClosingToday, width),
              ],
            ),
          )
        : Container();
  }

  Widget _horizontalGrid(List<SellerModel> sellers, double width) {
    double _width = 160.0;
    double _childAspectRatio = 1.65;

    // Changing Width & Aspect Ratio for smaller devices
    if (width < _width) {
      _width = width;
      _childAspectRatio = 1.75;
    }

    return Container(
      height: _width + 132,
      child: GridView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(
          bottom: _crossAxisSpacing,
          right: _crossAxisSpacing,
          left: 20,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: _childAspectRatio,
          mainAxisSpacing: 8,
        ),
        itemCount: sellers.length,
        itemBuilder: (context, index) => _sellersGridTile(
          sellers[index],
          AppTheme.backgroundColor,
          _width,
        ),
      ),
    );
  }

  void _showLastDayOrderInfo() {
    Dialog dialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 24, left: 30, right: 30, bottom: 16),
            child: Text(
              'These merchants deliver only once or twice a week, so quickly order before Midnight 12 AM and get them delivered tomorrow',
              style: AppTheme.textStyle.w500.color100.size(15).lineHeight(1.3),
              textAlign: TextAlign.center,
            ),
          ),
          Divider(
            thickness: 1,
            color: AppTheme.dividerColor,
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 8),
            child: FlatButton(
              child: Text(
                'Okay, Got it!',
                style: AppTheme.textStyle.w600
                    .size(15)
                    // .lineHeight(1.3)
                    .colored(AppTheme.primaryColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );

    showDialog(context: context, builder: (context) => dialog);
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
        padding: const EdgeInsets.only(bottom: 48.0),
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
            padding: const EdgeInsets.only(left: 20, bottom: 36),
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

  Widget _availableSellersGrid(ApartmentProvider provider, double width) {
    final color = AppTheme.backgroundColor;

    return !provider.hasAvailableSellers
        ? Container()
        : Container(
            padding: const EdgeInsets.only(bottom: 20),
            color: color,
            child: GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(
                bottom: _crossAxisSpacing,
                left: _horizontalPadding,
                right: _horizontalPadding,
              ),
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: _aspectRatioVertical,
                mainAxisSpacing: _crossAxisSpacing * 2,
                crossAxisSpacing: _crossAxisSpacing,
              ),
              itemCount: provider.availableSellers,
              itemBuilder: (context, index) => _sellersGridTile(
                provider.sellers[index],
                color,
                width,
              ),
            ),
          );
  }

  Widget _notAvailableSellersGrid(ApartmentProvider provider, double width) {
    final color = Color(0xfff7f7f7);

    return !provider.hasNotAvailableSellers
        ? Container()
        : Container(
            padding: const EdgeInsets.only(
              top: 24,
              bottom: 20,
            ),
            color: color,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    'Not accepting orders',
                    style: AppTheme.textStyle.w700.color100
                        .size(20.0)
                        .lineHeight(1.2),
                  ),
                ),
                SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(
                    bottom: _crossAxisSpacing,
                    left: _horizontalPadding,
                    right: _horizontalPadding,
                  ),
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: _aspectRatioVertical,
                    mainAxisSpacing: _crossAxisSpacing * 2,
                    crossAxisSpacing: _crossAxisSpacing,
                  ),
                  itemCount: provider.notAvailableSellers,
                  itemBuilder: (context, index) => _sellersGridTile(
                    provider.sellers[provider.availableSellers + index],
                    color,
                    width,
                  ),
                ),
              ],
            ));
  }

  Widget _sellersGridTile(SellerModel seller, Color color, double width) {
    final deliveryDay = seller.deliveryDate != null &&
            seller.deliveryDate.difference(DateTime.now()).inDays >= 1
        ? '${seller.deliveryDate.dateFormatDayMonthWeekday}'
        : 'Tomorrow';

    const _radius = Radius.circular(8.0);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ProductListScreen(seller)),
      ),
      child: Card(
        elevation: 3.0,
        shadowColor: AppTheme.color25,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: AppTheme.color05, width: 0.5),
        ),
        child: Stack(
          overflow: Overflow.visible,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.only(topLeft: _radius, topRight: _radius),
                  ),
                  child: NetworkCachedImage(
                    imageUrl: seller.brandUrl,
                    width: width,
                    height: width,
                    isColored: seller.live,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          seller.brandName,
                          style: AppTheme.textStyle.color50.w500
                              .size(11)
                              .lineHeight(1.5)
                              .letterSpace(0.2),
                          maxLines: 1,
                        ),
                        Text(
                          seller.brandTagline,
                          style: AppTheme.textStyle.color100.w700
                              .size(13)
                              .lineHeight(1.2),
                          maxLines: 2,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/truck.png',
                              width: 16,
                              height: 16,
                              color: AppTheme.color50,
                            ),
                            SizedBox(width: 6),
                            Text(
                              deliveryDay,
                              maxLines: 1,
                              style: AppTheme.textStyle.color50.w500
                                  .size(11)
                                  .lineHeight(1.1),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8)
              ],
            ),
            _ribbon(seller),
          ],
        ),
      ),
    );
  }

  Widget _ribbon(SellerModel seller) {
    if (seller.newlyLaunched) {
      return Positioned(
        top: 12,
        left: -7,
        child: Ribbon(
          text: 'New',
          ribbonColor: Color(0xfffa7b09),
          ribbonBackColor: Color(0xff8d4504),
          isColored: seller.live,
        ),
      );
    } else if (seller.overlayTag.isNotNullAndEmpty) {
      return Positioned(
        top: 12,
        left: -7,
        child: Ribbon(
          text: seller.overlayTag,
          ribbonColor: AppTheme.color100,
          ribbonBackColor: Color(0xff3e3b3b),
          isColored: seller.live,
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _shimmerWidget() {
    return ListView(
      padding: const EdgeInsets.all(0),
      children: [
        SafeArea(
          child: ShimmerWidget(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 24, left: 20, right: 20, bottom: 48),
              child: Stack(
                children: [
                  Card(
                    elevation: 4,
                    margin: const EdgeInsets.only(top: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset('assets/images/pinGreen.png'),
                          SizedBox(width: 9),
                          Expanded(
                            child: Text(
                              '         ',
                              maxLines: 1,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.expand_more_sharp,
                            size: 25,
                            color: AppTheme.color100,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        ShimmerWidget(
          child: Container(
            width: double.infinity,
            height: 136,
            margin: const EdgeInsets.only(left: 32, right: 32, bottom: 8),
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
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Container(
            height: 28,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(
                6,
                (index) => ShimmerWidget(
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.dividerColor),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      color: AppTheme.backgroundColor,
                    ),
                    child: Center(
                      child: Text(
                        '     ' * (index + 1),
                        textAlign: TextAlign.center,
                        style:
                            AppTheme.textStyle.w500.size(12).letterSpace(0.2),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(
            top: 32,
            left: _horizontalPadding,
            right: _horizontalPadding,
            bottom: 20,
          ),
          color: AppTheme.backgroundColor,
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            mainAxisSpacing: _crossAxisSpacing * 2,
            crossAxisSpacing: _crossAxisSpacing,
            childAspectRatio: 0.7,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(bottom: _crossAxisSpacing),
            children: List.generate(
              4,
              (_) => ShimmerWidget(
                child: Card(
                  elevation: 3.0,
                  shadowColor: AppTheme.color25,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: AppTheme.color05, width: 0.5),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
