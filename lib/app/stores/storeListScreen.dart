import 'package:flutter/material.dart';

import 'models/index.dart' show StoreModel;
import 'widgets/index.dart' show StoreCard;

import 'productListScreen.dart';

final store = StoreModel(
  name: '24 Mantra',
  moto: 'You, Farmers, Nature, Deserve the Best',
  category: 'Grocery',
  tagList: ['Foods', 'Organic', 'Certified', 'USDA Organic', 'India Organic'],
);

class StoreListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return StoreCard(
          title: store.name,
          subTitle: store.category,
          onTap: () {
            Navigator.pushNamed(
              context,
              ProductListScreen.route,
              arguments: store,
            );
          },
        );
      },
    );
  }
}
