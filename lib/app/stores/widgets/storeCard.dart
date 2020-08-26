import 'package:flutter/material.dart';

class StoreCard extends StatelessWidget {
  final String title;
  final String subTitle;
  final Function onTap;

  StoreCard({@required this.title, @required this.subTitle, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.label),
        title: Text(this.title),
        subtitle: Text(this.subTitle),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
