import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../../../models/index.dart' show SellerModel, ProductModel;
import '../../../../theme/index.dart';
import '../../../../widgets/index.dart' show ShimmerWidget;
import '../../../../util/index.dart' show StringExtensions;
import 'productSelectionButton.dart';

class ProductTile extends StatefulWidget {
  const ProductTile({
    Key key,
    @required this.seller,
    @required this.product,
    this.lastTile = false,
  }) : super(key: key);

  final SellerModel seller;
  final ProductModel product;
  final bool lastTile;

  @override
  _ProductTileState createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  bool _hasImage;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _hasImage = widget.product.imageUrl.isUrl;
  }

  @override
  Widget build(BuildContext context) {
    final _hasMrp = widget.product.mrp != null &&
        (widget.product.mrp - widget.product.price > 0);
    final _hasTag = widget.product.tag.isNotNullAndEmpty;
    final _hasZoomImages = widget.product.imageUrlLarge.isNotNullAndEmpty;
    final _ribbonColor = Color(0xfff49302);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (_hasZoomImages) {
          _showZoomBottomModal();
        }
      },
      child: Container(
        padding: widget.lastTile
            ? EdgeInsets.only(top: 24, bottom: 18)
            : EdgeInsets.only(top: 24, bottom: 24),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color:
                  widget.lastTile ? Colors.transparent : AppTheme.dividerColor,
              width: 1.0,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment:
              _hasImage ? CrossAxisAlignment.center : CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _hasTag
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              Container(
                                  color: _ribbonColor, width: 3, height: 20),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(4.0),
                                    bottomRight: Radius.circular(4.0),
                                  ),
                                  color: _ribbonColor.withOpacity(0.1),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6.0),
                                height: 20,
                                child: Center(
                                  child: Text(
                                    widget.product.tag.toUpperCase(),
                                    style: AppTheme.textStyle.w600
                                        .size(11.0)
                                        .lineHeight(1.2)
                                        .letterSpace(0.5)
                                        .colored(_ribbonColor),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  Text(
                    widget.product.name,
                    style: AppTheme.textStyle.w600.color100
                        .lineHeight(1.35)
                        .size(15),
                  ),
                  SizedBox(height: 3),
                  Text(
                    widget.product.size,
                    style: AppTheme.textStyle.w500.color50
                        .lineHeight(1.6)
                        .size(13),
                  ),
                  SizedBox(height: 3),
                  Row(
                    children: [
                      _hasMrp
                          ? Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                '₹${widget.product.mrp}',
                                style: AppTheme.textStyle.w500.color50
                                    .lineHeight(1.6)
                                    .size(13)
                                    .letterSpace(0.5)
                                    .lineThrough,
                              ),
                            )
                          : Container(),
                      Text(
                        '₹${widget.product.price}',
                        style: AppTheme.textStyle.w500.color100
                            .lineHeight(1.6)
                            .size(13)
                            .letterSpace(0.5),
                      ),
                    ],
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
            _hasImage
                ? SizedBox(
                    width: 120,
                    height: 140,
                    child: Stack(
                      children: [
                        Container(
                          width: 120.0,
                          height: 120.0,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.dividerColor),
                            image: DecorationImage(
                              onError: (_, __) =>
                                  setState(() => _hasImage = false),
                              fit: BoxFit.cover,
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0)),
                          ),
                        ),
                        Positioned(
                          bottom: _hasImage ? 0 : 40,
                          left: 20,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6.0)),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0.0, 4.0),
                                  blurRadius: 3.0,
                                  color: AppTheme.color25,
                                ),
                              ],
                            ),
                            child: ProductSelectionButton(
                              seller: widget.seller,
                              product: widget.product,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: ProductSelectionButton(
                      seller: widget.seller,
                      product: widget.product,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void _showZoomBottomModal() {
    final _product = widget.product;
    List<String> _imageList = [
      _product.imageUrlLarge,
      ..._product.secondaryImageUrls
    ];

    // Precaching images
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _imageList.forEach((imageUrl) {
        precacheImage(CachedNetworkImageProvider(imageUrl), context);
      });
    });

    _current = 0;
    bool _hasMoreThan1Image = _imageList.length > 1;

    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        isDismissible: true,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, updateState) {
              return Container(
                width: double.infinity,
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16.0),
                    topRight: const Radius.circular(16.0),
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CarouselSlider.builder(
                        itemCount: _imageList.length,
                        itemBuilder: (context, index, realIndex) {
                          return ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                            child: CachedNetworkImage(
                              imageUrl: _imageList[index],
                              fit: BoxFit.fill,
                              width: double.infinity,
                              placeholder: (_, __) => ShimmerWidget(
                                child: Container(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          aspectRatio: 1,
                          viewportFraction: 1.0,
                          initialPage: 0,
                          reverse: false,
                          enlargeCenterPage: true,
                          enableInfiniteScroll: _hasMoreThan1Image,
                          scrollDirection: Axis.horizontal,
                          onPageChanged: (index, reason) =>
                              updateState(() => _current = index),
                        ),
                      ),
                      _hasMoreThan1Image
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ..._imageList.asMap().entries.map((entry) {
                                  return Container(
                                    width: 8.0,
                                    height: 8.0,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 12.0, horizontal: 4.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _current == entry.key
                                          ? AppTheme.color100
                                          : AppTheme.color25,
                                    ),
                                  );
                                }),
                              ],
                            )
                          : Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Container(),
                            ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _product.name,
                                  style: AppTheme.textStyle.w500.color100
                                      .size(15)
                                      .lineHeight(1.3),
                                ),
                                Text(
                                  _product.size,
                                  style: AppTheme.textStyle.w500.color50
                                      .size(13)
                                      .lineHeight(1.5),
                                ),
                                Text(
                                  '₹${_product.price}',
                                  style: AppTheme.textStyle.w500.color100
                                      .size(13)
                                      .lineHeight(1.5),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 20),
                          ProductSelectionButton(
                            seller: widget.seller,
                            product: widget.product,
                          ),
                        ],
                      ),
                      widget.product.description != null
                          ? Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                widget.product.description,
                                style: AppTheme.textStyle.w500.color50
                                    .size(12)
                                    .lineHeight(1.3)
                                    .letterSpace(0.2),
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
              );
            },
          );
        });
  }
}
