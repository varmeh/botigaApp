import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/index.dart' show SellerModel;
import '../../../providers/index.dart' show SellerProvider;
import '../../../theme/index.dart';
import '../../../widgets/index.dart'
    show HttpServiceExceptionWidget, Loader, SearchBar;
import './widgets/productTile.dart';

class ProductSearchScreen extends StatefulWidget {
  static String route = 'productsScreen';

  final SellerModel seller;

  ProductSearchScreen([this.seller]);
  @override
  _ProductSearchScreenState createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  bool _isLoading = false;
  Exception _error;
  String _query = '';

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

    return SafeArea(
      child: _isLoading
          ? Loader()
          : _error != null
              ? HttpServiceExceptionWidget(
                  exception: _error,
                  screenName: 'ProductSearch',
                  onTap: () {
                    _getProducts();
                  },
                )
              : SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(height: 20.0),
                        Row(
                          children: [
                            SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: SearchBar(
                                autoFocus: true,
                                showLeadingSearch: true,
                                placeholder: 'Search products',
                                onClear: () {
                                  setState(() => _query = '');
                                },
                                onChange: (value) {
                                  setState(() => _query = value);
                                },
                                onSubmit: (_) {},
                              ),
                            ),
                            TextButton(
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "Cancel",
                              ),
                            ),
                          ],
                        ),
                        _filteredProductList(context, seller),
                        SizedBox(height: 60.0)
                      ],
                    ),
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
      await Provider.of<SellerProvider>(context, listen: false)
          .getProducts(_getSeller().id);
    } catch (error) {
      _error = error;
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _filteredProductList(BuildContext context, SellerModel seller) {
    if (_query.isEmpty) {
      return SizedBox.shrink();
    }
    return Consumer<SellerProvider>(
      builder: (context, provider, child) {
        final categoryList = provider.products(seller.id);
        List<ProductTile> products = [];
        categoryList.forEach(
          (category) {
            if (category.products.length > 0) {
              category.products.forEach(
                (product) {
                  if (product.name
                      .toLowerCase()
                      .contains(_query.toLowerCase())) {
                    products.add(
                      ProductTile(
                        seller: seller,
                        product: product,
                      ),
                    );
                  }
                },
              );
            }
          },
        );
        return products.length > 0
            ? Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [...products],
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(top: 48.0),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/searchFailure.png',
                      width: 200,
                      height: 200,
                    ),
                    SizedBox(height: 14),
                    Text(
                      'Nothing here',
                      style: AppTheme.textStyle.w700.color100
                          .size(17)
                          .lineHeight(1.3),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Try searching other words',
                      style: AppTheme.textStyle.w500.color50
                          .size(12)
                          .lineHeight(1.3),
                    ),
                  ],
                ),
              );
      },
    );
  }
}
