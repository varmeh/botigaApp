import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/index.dart' show StoresProvider;

import 'widgets/sellerTile.dart';

import '../products/productListScreen.dart';
import '../../util/index.dart' show HttpServiceExceptionWidget;

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<StoresProvider>(context, listen: false).getStores(),
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
          return Consumer<StoresProvider>(
            builder: (context, provider, child) {
              return ListView.builder(
                itemCount: provider.storeList.length,
                itemBuilder: (context, index) {
                  return SellerTile(
                    title: provider.storeList[index].name,
                    subTitle: provider.storeList[index].segments,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        ProductListScreen.route,
                        arguments: provider.storeList[index],
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
