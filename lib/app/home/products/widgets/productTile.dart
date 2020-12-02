import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../models/index.dart' show SellerModel, ProductModel;
import '../../../../theme/index.dart';
import '../../../../util/index.dart' show StringExtensions;
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
    _hasImage = widget.product.imageUrl.isUrl;
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
                      .size(15),
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
                widget.product.description != null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Text(
                          widget.product.description,
                          style: AppTheme.textStyle.w500.color50
                              .lineHeight(1.3)
                              .letterSpace(0.2)
                              .size(12),
                        ),
                      )
                    : Container()
              ],
            ),
          ),
          SizedBox(width: 20.0),
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
                            colorFilter: widget.product.available
                                ? ColorFilter.mode(
                                    Colors.transparent,
                                    BlendMode.multiply,
                                  )
                                : ColorFilter.mode(
                                    Colors.grey,
                                    BlendMode.saturation,
                                  ),
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
