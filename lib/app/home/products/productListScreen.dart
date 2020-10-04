import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets/sellerBrandContainer.dart';
import 'widgets/categoryList.dart';

import '../../../models/index.dart' show SellerModel;
import '../../../providers/index.dart' show ProductsProvider;
import '../../../util/index.dart' show HttpServiceExceptionWidget;
// import '../../cart/cartBottomModal.dart';
import '../../../theme/index.dart';

class ProductListScreen extends StatelessWidget {
  static String route = 'productsScreen';
  final SellerModel seller;

  ProductListScreen([this.seller]);

  SellerModel getSeller(BuildContext context) =>
      seller == null ? ModalRoute.of(context).settings.arguments : seller;

  @override
  Widget build(BuildContext context) {
    final SellerModel seller = getSeller(context);
    return Container(
      color: AppTheme.backgroundColor, // setting status bar color to white
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: AppTheme.textColor100,
            ),
          ),
          backgroundColor: AppTheme.backgroundColor,
          elevation: 0.0,
        ),
        body: SafeArea(
          child: Container(
            color: AppTheme.backgroundColor,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                ListView(
                  children: [
                    SellerBrandContainer(seller),
                    Divider(
                      thickness: 4.0,
                    ),
                    _categoryList(context, seller),
                  ],
                ),
                // CartBottomModal()
              ],
            ),
          ),
        ),
      ),
    );
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
    return FutureBuilder(
      future: Provider.of<ProductsProvider>(context, listen: false)
          .getProducts(seller.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            ),
          );
        } else if (snapshot.hasError) {
          return HttpServiceExceptionWidget(snapshot.error);
        } else {
          return Consumer<ProductsProvider>(
            builder: (context, provider, child) {
              final categoryList = provider.products(seller.id);
              return Column(
                children: [
                  ...categoryList
                      .map((category) => CategoryList(category, seller))
                ],
              );
            },
          );
        }
      },
    );
  }
}
