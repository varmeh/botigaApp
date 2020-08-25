import 'package:flutter/material.dart';

import 'package:botiga/screens/stores/widgets/storeCardWidget.dart';

class StoresScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return StoreCardWidget(
          title: '24 Mantra',
          subTitle: 'Grocery',
          onTap: () {},
        );
      },
    );
  }
}
