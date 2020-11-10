import 'package:async/async.dart';
import 'package:botiga/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets/sellerBrandContainer.dart';
import 'widgets/categoryList.dart';

import '../../../models/index.dart' show SellerModel;
import '../../../providers/index.dart' show ProductsProvider;
import '../../../widgets/index.dart' show HttpServiceExceptionWidget;
import '../../cart/cartBottomModal.dart';
import '../../../theme/index.dart';

class ProductListScreen extends StatefulWidget {
  static String route = 'productsScreen';

  final SellerModel seller;

  ProductListScreen([this.seller]);

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _memoizer = AsyncMemoizer();

  @override
  Widget build(BuildContext context) {
    final SellerModel seller = widget.seller != null
        ? widget.seller
        : ModalRoute.of(context).settings.arguments;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: BotigaAppBar(''),
      body: SafeArea(
        child: FutureBuilder(
          future: _memoizer.runOnce(
            () => Future.delayed(
              Duration(milliseconds: 100),
              () => Provider.of<ProductsProvider>(context, listen: false)
                  .getProducts(seller.id),
            ),
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Loader();
            } else if (snapshot.hasError) {
              return HttpServiceExceptionWidget(
                exception: snapshot.error,
                onTap: () {
                  // Rebuild widget
                  setState(() {});
                },
              );
            } else {
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  ListView.builder(
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return SellerBrandContainer(seller);
                      } else if (index == 1) {
                        return Divider(
                          thickness: 4.0,
                        );
                      } else if (index == 2) {
                        return _categoryList(context, seller);
                      } else {
                        return SizedBox(height: 60.0);
                      }
                    },
                  ),
                  CartBottomModal()
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _categoryList(BuildContext context, SellerModel seller) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Categories',
            style: AppTheme.textStyle.w700.color100.size(17),
          ),
          SizedBox(height: 20),
          _productList(context, seller),
        ],
      ),
    );
  }

  Widget _productList(BuildContext context, SellerModel seller) {
    return Consumer<ProductsProvider>(
      builder: (context, provider, child) {
        final categoryList = provider.products(seller.id);
        return Column(
          children: [
            ...categoryList.map(
              (category) => category.products.length > 0
                  ? CategoryList(category, seller)
                  : Container(),
            )
          ],
        );
      },
    );
  }
}
