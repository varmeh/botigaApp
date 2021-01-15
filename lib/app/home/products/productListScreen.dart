import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/index.dart' show SellerModel, CategoryModel;
import '../../../providers/index.dart' show ProductsProvider;
import '../../../theme/index.dart';
import '../../../widgets/index.dart';
import '../../../widgets/index.dart' show HttpServiceExceptionWidget;
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
      appBar: BotigaAppBar(
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
                        child: ProductSearchScreen(_getSeller()));
                  },
                );
              },
            ),
          )
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? Loader()
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
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return SellerBrandContainer(seller);
                          } else if (index == 1) {
                            return Divider(
                              thickness: 4.0,
                              color: AppTheme.dividerColor,
                            );
                          } else if (index == 2) {
                            return _categoryList(context, seller);
                          } else {
                            return Column(
                              children: [
                                Divider(
                                  thickness: 5.0,
                                  color: AppTheme.dividerColor,
                                ),
                                FssaiTile(
                                    'House of Rasda',
                                    'Rohini Colony, Radha Nagar, A.S Ram Nagar, Bengaluru, Karnataka 560002',
                                    '11212138765689'),
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

  Future<void> _getProducts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      await Provider.of<ProductsProvider>(context, listen: false)
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
    return Consumer<ProductsProvider>(
      builder: (context, provider, child) {
        final categoryList = provider
            .products(seller.id)
            .where((category) => category.products.length > 0)
            .toList();

        return Column(
          children: [
            ...categoryList.asMap().entries.map((entry) {
              int idx = entry.key;
              CategoryModel category = entry.value;
              bool isLast = idx == categoryList.length - 1;
              return CategoryList(
                  category: category, seller: seller, isLast: isLast);
            })
          ],
        );
      },
    );
  }
}
