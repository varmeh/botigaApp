import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/index.dart' show StoresProvider;

import 'widgets/storeCard.dart';

import '../products/productListScreen.dart';

class StoreListScreen extends StatelessWidget {
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
          return Center(
            child: Text('${snapshot.error}'),
          );
        } else {
          return Consumer<StoresProvider>(
            builder: (context, storeProvider, child) {
              return ListView.builder(
                itemCount: storeProvider.storeList.length,
                itemBuilder: (context, index) {
                  return StoreCard(
                    title: storeProvider.storeList[index].name,
                    subTitle: storeProvider.storeList[index].segments,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        ProductListScreen.route,
                        arguments: storeProvider.storeList[index],
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
