import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/index.dart' show SellerModel;
import '../../../providers/index.dart' show ProductsProvider;
import '../../../widgets/index.dart';
import '../../../widgets/index.dart' show HttpServiceExceptionWidget;
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
                            FlatButton(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
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
      await Provider.of<ProductsProvider>(context, listen: false)
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
    return Consumer<ProductsProvider>(
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
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [...products],
          ),
        );
      },
    );
  }
}
