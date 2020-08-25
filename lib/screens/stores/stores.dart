import 'package:flutter/material.dart';

import 'package:botiga/models/index.dart' show StoreModel;

import 'package:botiga/screens/stores/products.dart';
import 'package:botiga/screens/stores/widgets/index.dart' show StoreCard;

final store = StoreModel(
  name: '24 Mantra',
  moto: 'You, Farmers, Nature, Deserve the Best Deserve the Best ',
  categories: ['Grocery', 'Healthy Foods'],
  tags: ['Foods', 'Organic', 'Certified', 'USDA Organic', 'India Organic'],
);

class StoresScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return StoreCard(
          title: store.name,
          subTitle: store.combinedCategory,
          onTap: () {
            Navigator.pushNamed(
              context,
              ProductsScreen.route,
              arguments: store,
            );
          },
        );
      },
    );
  }
}
