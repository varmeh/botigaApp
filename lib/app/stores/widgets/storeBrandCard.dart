import 'package:flutter/material.dart';
import '../models/index.dart' show StoreModel;

class StoreBrandCard extends StatelessWidget {
  final StoreModel store;

  StoreBrandCard(this.store);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).accentColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              store.moto,
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 8.0),
            Text(
              store.combinedCategory,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(height: 8.0),
            Text(
              store.combinedTag,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
      ),
    );
  }
}
