import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expandable/expandable.dart';

import '../../models/index.dart' show StoreModel;
import 'widgets/index.dart' show StoreBrandCard, CategoryCard;
import '../../providers/index.dart' show ProductsProvider;
import '../../util/index.dart' show HttpServiceExceptionWidget;

class ProductListScreen extends StatelessWidget {
  static String route = 'productsScreen';

  Widget _futureBuilder(BuildContext context, String storeId) {
    return FutureBuilder(
      future: Provider.of<ProductsProvider>(context, listen: false)
          .getProducts(storeId),
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
                    itemCount: provider.products(storeId).length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return CategoryCard(provider.products(storeId)[index]);
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

  @override
  Widget build(BuildContext context) {
    final StoreModel store = ModalRoute.of(context).settings.arguments;
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text(store.name),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Column(
              children: [
                StoreBrandCard(store),
                SizedBox(height: 4.0),
                _futureBuilder(context, store.id),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
