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
        HttpServiceExceptionWidget,
        BannerCarosuel,
        TapBannerModel,
        ShimmerWidget,
        NetworkCachedImage;
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
const double _heightDelta = 104;

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
      final width = (MediaQuery.of(context).size.width -
              _horizontalPadding * 2 -
              _crossAxisSpacing) /
          _gridColumns;
      final height = width + _heightDelta;

      final provider = Provider.of<ApartmentProvider>(context);
      return ListView(
        padding: EdgeInsets.zero,
        children: [
          appBar(context, provider),
          _banners(context, provider),
          _closingSellersGrid(provider, width, height),
          _filter(provider),
          _availableSellersGrid(provider, width, height),
          _notAvailableSellersGrid(provider, width, height),
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

  Widget _closingSellersGrid(
      ApartmentProvider provider, double width, double height) {
    final color = AppTheme.backgroundColor;
    return provider.hasSellersClosingToday
        ? Container(
            padding: const EdgeInsets.only(bottom: 48, left: 20),
            color: color,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _showLastDayOrderInfo(),
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
                SizedBox(height: 24),
                _horizontalGrid(provider.sellersClosingToday, width, height),
              ],
            ),
          )
        : Container();
  }

  Widget _horizontalGrid(
      List<SellerModel> sellers, double width, double height) {
    final _height = height + 14;
    return Container(
      height: _height,
      child: GridView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(
            bottom: _crossAxisSpacing, right: _crossAxisSpacing),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: _height / width,
          mainAxisSpacing: _crossAxisSpacing,
        ),
        itemCount: sellers.length,
        itemBuilder: (context, index) => _sellersGridTile(
          sellers[index],
          AppTheme.backgroundColor,
          width,
          height,
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

  Widget _availableSellersGrid(
      ApartmentProvider provider, double width, double height) {
    final color = AppTheme.backgroundColor;

    return !provider.hasAvailableSellers
        ? Container()
        : Container(
            padding: const EdgeInsets.only(
              // top: 32,
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
                provider.sellers[index],
                color,
                width,
                height,
              ),
            ),
          );
  }

  Widget _notAvailableSellersGrid(
      ApartmentProvider provider, double width, double height) {
    final color = Color(0xfff7f7f7);

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
                    height,
                  ),
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

    final _sizedBox8 = SizedBox(height: 8);

    const _borderRadius = BorderRadius.all(Radius.circular(8.0));
    return Container(
      decoration: BoxDecoration(
        borderRadius: _borderRadius,
        border: Border.all(color: AppTheme.color05, width: 0.5),
        boxShadow: [
          BoxShadow(
            offset: Offset(0.0, 4.0),
            blurRadius: 3.0,
            color: AppTheme.shadowColor,
          ),
        ],
      ),
      child: OpenContainer(
        closedElevation: 0.0,
        closedShape: RoundedRectangleBorder(borderRadius: _borderRadius),
        transitionDuration: Duration(milliseconds: 300),
        closedColor: color,
        closedBuilder: (context, openContainer) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              NetworkCachedImage(
                imageUrl: seller.brandUrl,
                width: width,
                height: width,
                isColored: seller.live,
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
                      maxLines: 1,
                    ),
                    _sizedBox8,
                    Text(
                      seller.brandTagline,
                      style: AppTheme.textStyle.color100.w700
                          .size(13)
                          .lineHeight(1.2),
                      maxLines: 2,
                      overflow: TextOverflow.fade,
                    ),
                    _sizedBox8,
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
              )
            ],
          );
        },
        openBuilder: (_, __) => ProductListScreen(seller),
      ),
    );
  }

  Widget _shimmerWidget() {
    final width = (MediaQuery.of(context).size.width -
            _horizontalPadding * 2 -
            _crossAxisSpacing) /
        _gridColumns;
    final height = width + _heightDelta;

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
            childAspectRatio: width / height,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(bottom: _crossAxisSpacing),
            children: List.generate(
              4,
              (_) => ShimmerWidget(
                child: OpenContainer(
                  closedElevation: 2.0,
                  closedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  tappable: false,
                  closedColor: AppTheme.backgroundColor,
                  closedBuilder: (context, openContainer) {
                    return SizedBox(
                      width: width,
                      height: height,
                    );
                  },
                  openBuilder: (_, __) => Container(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
