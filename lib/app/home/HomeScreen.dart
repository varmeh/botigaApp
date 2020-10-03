import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/index.dart' show SellersProvider;

import 'widgets/sellerTile.dart';

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
                  return SellerTile(
                    title: provider.sellerList[index].brandName,
                    subTitle: provider.sellerList[index].businessCategory,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        ProductListScreen.route,
                        arguments: provider.sellerList[index],
                      );
                    },
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}
