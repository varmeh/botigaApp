import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Pulses',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 20.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  title: Text(
                    'items',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
