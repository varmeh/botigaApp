import 'package:botiga/models/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/index.dart' show SellersProvider;

import '../products/productListScreen.dart';
import '../../util/index.dart' show HttpServiceExceptionWidget;

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<SellersProvider>(context, listen: false).getSellers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ),
          );
        } else if (snapshot.hasError) {
          return HttpServiceExceptionWidget(snapshot.error);
        } else {
          return Consumer<SellersProvider>(
            builder: (context, provider, child) {
              return ListView.builder(
                itemCount: provider.sellerList.length,
                itemBuilder: (context, index) {
                  return _sellersTile(context, provider.sellerList[index]);
                },
              );
            },
          );
        }
      },
    );
  }

  Widget _sellersTile(BuildContext context, SellerModel seller) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.label),
        title: Text(seller.brandName),
        subtitle: Text(seller.businessCategory),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.pushNamed(
            context,
            ProductListScreen.route,
            arguments: seller,
          );
        },
      ),
    );
  }
}
