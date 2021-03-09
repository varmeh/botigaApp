import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/index.dart' show SellerModel, CategoryModel;
import '../../../providers/index.dart' show SellerProvider;
import '../../../theme/index.dart';
import '../../../widgets/index.dart'
    show
        HttpServiceExceptionWidget,
        MerchantContactWidget,
        FssaiTile,
        BotigaAppBar,
        BannerCarosuel,
        ShimmerWidget;
import '../../cart/cartBottomModal.dart';
import 'widgets/categoryList.dart';
import 'widgets/sellerBrandContainer.dart';
import './productSearchScreen.dart';

class ProductListScreen extends StatefulWidget {
  static String route = 'productsScreen';

  final SellerModel seller;

  ProductListScreen([this.seller]);

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  bool _isLoading = false;
  Exception _error;

  final _divider = Divider(
    thickness: 4.0,
    color: AppTheme.dividerColor,
  );

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 100), () => _getProducts());
  }

  SellerModel _getSeller() {
    return widget.seller != null
        ? widget.seller
        : ModalRoute.of(context).settings.arguments;
  }

  @override
  Widget build(BuildContext context) {
    final seller = _getSeller();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: _appBar(context),
      body: SafeArea(
        child: _isLoading
            ? _shimmerWidget()
            : _error != null
                ? HttpServiceExceptionWidget(
                    exception: _error,
                    onTap: () {
                      _getProducts();
                    },
                  )
                : Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      ListView.builder(
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return SellerBrandContainer(seller);
                          } else if (index == 1) {
                            return Column(
                              children: [
                                _divider,
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                    vertical: 16.0,
                                  ),
                                  child: MerchantContactWidget(
                                      phone: seller.phone,
                                      whatsapp: seller.whatsapp),
                                ),
                                _divider
                              ],
                            );
                          } else if (index == 2) {
                            return _bannerCarosuel();
                          } else if (index == 3) {
                            return _categoryList(context, seller);
                          } else {
                            return Column(
                              children: [
                                Divider(
                                  thickness: 5.0,
                                  color: AppTheme.dividerColor,
                                ),
                                FssaiTile(seller),
                                SizedBox(height: 60.0),
                              ],
                            );
                          }
                        },
                      ),
                      CartBottomModal()
                    ],
                  ),
      ),
    );
  }

  BotigaAppBar _appBar(BuildContext context) {
    return BotigaAppBar(
      '',
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 10.0),
          child: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: Image.asset(
              'assets/images/search.png',
              color: AppTheme.color100,
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (builder) {
                  return Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.90,
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16.0),
                        topRight: const Radius.circular(16.0),
                      ),
                    ),
                    child: ProductSearchScreen(
                      _getSeller(),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _bannerCarosuel() {
    final provider = Provider.of<SellerProvider>(context, listen: false);

    return provider.hasBanners(widget.seller.id)
        ? Container(
            color: AppTheme.backgroundColor,
            padding: const EdgeInsets.only(top: 24.0),
            child: BannerCarosuel(provider.banners(widget.seller.id)),
          )
        : Container();
  }

  Future<void> _getProducts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      await Provider.of<SellerProvider>(context, listen: false)
          .getProducts(_getSeller().id);
    } catch (error) {
      _error = error;
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _categoryList(BuildContext context, SellerModel seller) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Categories',
            style: AppTheme.textStyle.w700.color100.size(17),
          ),
          SizedBox(height: 20),
          _productList(context, seller),
        ],
      ),
    );
  }

  Widget _productList(BuildContext context, SellerModel seller) {
    return Consumer<SellerProvider>(
      builder: (context, provider, child) {
        final categoryList = provider
            .products(seller.id)
            .where((category) => category.showCategory)
            .toList();

        return Column(
          children: [
            ...categoryList.asMap().entries.map((entry) {
              int idx = entry.key;
              CategoryModel category = entry.value;
              bool isLast = idx == categoryList.length - 1;
              return CategoryList(
                category: category,
                seller: seller,
                isLast: isLast,
              );
            })
          ],
        );
      },
    );
  }

  Widget _shimmerWidget() {
    final seller = _getSeller();

    return ListView(
      children: [
        SellerBrandContainer(seller),
        Column(
          children: [
            _divider,
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 16.0,
              ),
              child: MerchantContactWidget(
                  phone: seller.phone, whatsapp: seller.whatsapp),
            ),
            _divider
          ],
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
              3,
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
        Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: ShimmerWidget(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Categories',
                  style: AppTheme.textStyle.w700.color100.size(17),
                ),
                SizedBox(height: 20),
                ...List<Widget>.generate(
                  10,
                  (index) => Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppTheme.color50),
                      ),
                    ),
                    padding: const EdgeInsets.only(
                      top: 24.0,
                      bottom: 24.0,
                    ),
                    child: Row(
                      children: [
                        Text(
                          '00',
                          style: AppTheme.textStyle.w600.color100.size(12),
                        ),
                        SizedBox(width: 18),
                        Expanded(
                          child: Container(
                            height: 14,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 24),
                        Icon(Icons.expand_more, color: AppTheme.color100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
