import 'package:botiga/models/index.dart';
import 'package:flutter/material.dart';
import '../../../../theme/index.dart';

class CategoryList extends StatelessWidget {
  final CategoryModel category;

  CategoryList(this.category);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(
      dividerColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
    );

    final numberOfProducts = category.products.length;

    return Column(
      children: [
        Theme(
          data: theme,
          child: ListTileTheme(
            contentPadding: EdgeInsets.all(0),
            child: ExpansionTile(
              title: RichText(
                text: TextSpan(
                  text: numberOfProducts > 9
                      ? numberOfProducts.toString()
                      : '0${numberOfProducts.toString()}',
                  style: AppTheme.textStyle.w600.color50.size(12),
                  children: <TextSpan>[
                    TextSpan(
                      text: ' ',
                      style: AppTheme.textStyle.letterSpace(20.0),
                    ),
                    TextSpan(
                      text: category.name,
                      style: AppTheme.textStyle.w600.color100
                          .size(14)
                          .letterSpace(1.0),
                    ),
                  ],
                ),
              ),
              children: [],
            ),
          ),
        ),
        SizedBox(height: 5),
        Divider(thickness: 1.0)
      ],
    );
  }
}
