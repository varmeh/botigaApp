import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

import '../../../util/index.dart' show Constants;
import '../../../models/index.dart' show CategoryModel;
import 'categoryProductList.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel category;

  CategoryCard(this.category);

  @override
  Widget build(BuildContext context) {
    final _textTheme = Theme.of(context).textTheme;
    return ExpandableNotifier(
      child: Card(
        child: Container(
          padding: Constants.kEdgeInsetsCard,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    category.category,
                    style: _textTheme.headline6,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text(
                      category.products.length.toString(),
                      style: _textTheme.bodyText2,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              CategoryProductList(category.products),
            ],
          ),
        ),
      ),
    );
  }
}
