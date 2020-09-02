import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expandable/expandable.dart';

import '../../models/index.dart' show StoreModel;
import 'widgets/index.dart' show StoreBrandCard, CategoryCard;
import '../../providers/index.dart' show ProductsProvider, CartProvider;
import '../../util/index.dart' show HttpServiceExceptionWidget;
import '../cart/cartBottomModal.dart';

class ProductListScreen extends StatefulWidget {
  static String route = 'productsScreen';
  final StoreModel store;

  ProductListScreen([this.store]);

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<CartProvider>(context, listen: false)
          .selectedProductListStore = this._store;
    });
    super.initState();
  }

  StoreModel get _store => widget.store == null
      ? ModalRoute.of(context).settings.arguments
      : widget.store;

  @override
  void dispose() {
    // Provider.of<CartProvider>(context, listen: false).selectedProductListStore =
    //     null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final StoreModel store = this._store;
    return Container(
      child: Scaffold(
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
                      _futureBuilder(context, store.id),
                    ],
                  ),
                  CartBottomModal()
                ],
              )),
        ),
      ),
    );
  }

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
}
