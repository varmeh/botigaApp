import 'package:flutter/material.dart';

import '../../models/index.dart' show StoreModel;
import 'widgets/storeCard.dart';

import '../products/productListScreen.dart';

final storeList = new List<StoreModel>.generate(
  6,
  (index) => StoreModel(
    id: 'store_id$index',
    name: '24 Mantra ${index + 1}',
    moto: 'You, Farmers, Nature, Deserve the Best',
    segmentList: ['Grocery', 'Foods'],
    phone: '+919900099000',
    whatsapp: '+919900099000',
  ),
);

class StoreListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: storeList.length,
      itemBuilder: (context, index) {
        return StoreCard(
          title: storeList[index].name,
          subTitle: storeList[index].segments,
          onTap: () {
            Navigator.pushNamed(
              context,
              ProductListScreen.route,
              arguments: storeList[index],
            );
          },
        );
      },
    );
  }
}
