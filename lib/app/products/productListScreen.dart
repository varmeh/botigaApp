import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expandable/expandable.dart';

import '../../models/index.dart' show SellerModel;
import 'widgets/index.dart' show StoreBrandCard, CategoryCard;
import '../../providers/index.dart' show ProductsProvider;
import '../../util/index.dart' show HttpServiceExceptionWidget;
import '../cart/cartBottomModal.dart';

class ProductListScreen extends StatelessWidget {
  static String route = 'productsScreen';
  final SellerModel store;

  ProductListScreen([this.store]);

  SellerModel getStore(BuildContext context) =>
      store == null ? ModalRoute.of(context).settings.arguments : store;

  @override
  Widget build(BuildContext context) {
    final SellerModel store = getStore(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(store.name),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Column(
                children: [
                  StoreBrandCard(store),
                  SizedBox(height: 4.0),
                  _futureBuilder(context, store),
                ],
              ),
              CartBottomModal()
            ],
          ),
        ),
      ),
    );
  }

  Widget _futureBuilder(BuildContext context, SellerModel store) {
    return FutureBuilder(
      future: Provider.of<ProductsProvider>(context, listen: false)
          .getProducts(store.id),
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
                    itemCount: provider.products(store.id).length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return CategoryCard(
                        store: store,
                        category: provider.products(store.id)[index],
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
