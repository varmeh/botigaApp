import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

import '../../../util/index.dart' show Constants;
import 'categoryProductList.dart';

class CategoryCard extends StatelessWidget {
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
                    'Pulses',
                    style: _textTheme.headline6,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text(
                      '22',
                      style: _textTheme.bodyText2,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              CategoryProductList(),
            ],
          ),
        ),
      ),
    );
  }
}
