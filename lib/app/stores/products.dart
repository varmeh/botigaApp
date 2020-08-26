import 'package:flutter/material.dart';

import 'models/index.dart' show StoreModel;
import 'widgets/index.dart' show StoreBrandCard, CategoryCard;

class ProductsScreen extends StatelessWidget {
  static String route = 'productsScreen';

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
                Expanded(
                  child: ListView.builder(
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return CategoryCard();
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
