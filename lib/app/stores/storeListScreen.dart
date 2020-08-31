import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/index.dart' show StoresProvider;

import 'widgets/storeCard.dart';

import '../products/productListScreen.dart';

class StoreListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<StoresProvider>(
      builder: (context, storeProvider, child) {
        final _storeList = storeProvider.storeList;
        return ListView.builder(
          itemCount: _storeList.length,
          itemBuilder: (context, index) {
            return StoreCard(
              title: _storeList[index].name,
              subTitle: _storeList[index].segments,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  ProductListScreen.route,
                  arguments: _storeList[index],
                );
              },
            );
          },
        );
      },
    );
  }
}
