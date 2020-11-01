import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../theme/index.dart';
import '../../../../models/index.dart' show SellerModel, ProductModel;
import 'productSelectionButton.dart';

class ProductTile extends StatefulWidget {
  const ProductTile({
    Key key,
    @required this.seller,
    @required this.product,
  }) : super(key: key);

  final SellerModel seller;
  final ProductModel product;

  @override
  _ProductTileState createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  bool _hasImage;

  @override
  void initState() {
    super.initState();
    _hasImage =
        widget.product.imageUrl != null && widget.product.imageUrl.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.name,
                  style: AppTheme.textStyle.w500.color100
                      .lineHeight(1.35)
                      .size(15)
                      .letterSpace(1),
                ),
                Text(
                  widget.product.size,
                  style:
                      AppTheme.textStyle.w500.color50.lineHeight(1.6).size(13),
                ),
                SizedBox(height: 3),
                Text(
                  '₹${widget.product.price}',
                  style: AppTheme.textStyle.w500.color100
                      .lineHeight(1.6)
                      .size(13)
                      .letterSpace(0.5),
                ),
                SizedBox(height: 5),
                widget.product.description != null
                    ? Text(
                        widget.product.description,
                        style: AppTheme.textStyle.w500.color50
                            .lineHeight(1.3)
                            .letterSpace(0.2)
                            .size(12),
                      )
                    : Container()
              ],
            ),
          ),
          SizedBox(
            width: 120,
            height: 110,
            child: Stack(
              children: [
                _hasImage
                    ? Container(
                        width: 120.0,
                        height: 90.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            onError: (_, __) =>
                                setState(() => _hasImage = false),
                            fit: BoxFit.fill,
                            image: CachedNetworkImageProvider(
                                widget.product.imageUrl),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        ),
                      )
                    : Container(),
                Positioned(
                  bottom: _hasImage ? 0 : 40,
                  left: 20,
                  child: ProductSelectionButton(
                    seller: widget.seller,
                    product: widget.product,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
