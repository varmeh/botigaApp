import 'package:flutter/material.dart';

import 'productTile.dart';

class CategoryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Pulses',
              style: Theme.of(context).textTheme.headline6,
            ),
            Column(
              children: [
                ProductTile(),
                ProductTile(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
