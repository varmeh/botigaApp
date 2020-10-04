import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expandable/expandable.dart';

import 'widgets/index.dart' show SellerBrandContainer, CategoryCard;

import '../../../models/index.dart' show SellerModel;
import '../../../providers/index.dart' show ProductsProvider;
import '../../../util/index.dart' show HttpServiceExceptionWidget;
import '../../cart/cartBottomModal.dart';
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
    return Scaffold(
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
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Column(
                children: [
                  SellerBrandContainer(seller),
                  Divider(
                    thickness: 4.0,
                  ),
                  _futureBuilder(context, seller),
                ],
              ),
              CartBottomModal()
            ],
          ),
        ),
      ),
    );
  }

  Widget _futureBuilder(BuildContext context, SellerModel seller) {
    return FutureBuilder(
      future: Provider.of<ProductsProvider>(context, listen: false)
          .getProducts(seller.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Expanded(
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return HttpServiceExceptionWidget(snapshot.error);
        } else {
          return ExpandableTheme(
            data: ExpandableThemeData(
              useInkWell: true,
            ),
            child: Expanded(
              child: Consumer<ProductsProvider>(
                builder: (context, provider, child) {
                  return ListView.builder(
                    itemCount: provider.products(seller.id).length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return CategoryCard(
                        seller: seller,
                        category: provider.products(seller.id)[index],
                      );
                    },
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }
}
