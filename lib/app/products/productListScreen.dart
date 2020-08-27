import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

import '../../models/index.dart' show StoreModel;
import 'widgets/index.dart' show StoreBrandCard, CategoryCard;

class ProductListScreen extends StatelessWidget {
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
                ExpandableTheme(
                  data: ExpandableThemeData(
                    useInkWell: true,
                  ),
                  child: Expanded(
                    child: ListView.builder(
                      itemCount: 4,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return CategoryCard();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
