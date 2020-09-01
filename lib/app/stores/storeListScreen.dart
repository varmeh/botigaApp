import 'package:botiga/util/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/index.dart' show StoreModel;
import '../../providers/index.dart' show StoresProvider;

import 'widgets/storeCard.dart';

import '../products/productListScreen.dart';

class StoreListScreen extends StatefulWidget {
  @override
  _StoreListScreenState createState() => _StoreListScreenState();
}

class _StoreListScreenState extends State<StoreListScreen> {
  final httpService = HttpService();
  Future<List<StoreModel>> _futureStoreList;

  @override
  void initState() {
    super.initState();
    _futureStoreList = httpService.getStoreList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureStoreList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          ));
        } else if (snapshot.hasError) {
          return Center(
            child: Text('${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          return Consumer<StoresProvider>(
            builder: (context, storeProvider, child) {
              storeProvider.storeList = snapshot.data;
              return ListView.builder(
                itemCount: storeProvider.storeList.length,
                itemBuilder: (context, index) {
                  return StoreCard(
                    title: storeProvider.storeList[index].name,
                    subTitle: storeProvider.storeList[index].segments,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        ProductListScreen.route,
                        arguments: storeProvider.storeList[index],
                      );
                    },
                  );
                },
              );
            },
          );
        } else {
          return Text('Press the button 👇');
        }
      },
    );
  }
}
