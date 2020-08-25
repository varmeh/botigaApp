import 'package:flutter/material.dart';

import 'package:botiga/models/index.dart' show StoreModel;
import 'package:botiga/screens/stores/widgets/index.dart' show StoreBrandCard;

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
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text('Pulses'),
                            ],
                          ),
                        ),
                      );
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
