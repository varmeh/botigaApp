import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../theme/index.dart';

class TapBannerModel {
  final String url;
  final Function onTap;

  TapBannerModel({@required this.url, this.onTap});
}

class BannerCarosuel extends StatefulWidget {
  final List<TapBannerModel> bannerList;

  BannerCarosuel(this.bannerList);

  @override
  _BannerCarosuelState createState() => _BannerCarosuelState();
}

class _BannerCarosuelState extends State<BannerCarosuel> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CarouselSlider.builder(
            itemCount: widget.bannerList.length,
            itemBuilder: (context, index, realIndex) {
              return GestureDetector(
                onTap: () {
                  if (widget.bannerList[index].onTap != null) {
                    widget.bannerList[index].onTap();
                  }
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(
                          widget.bannerList[index].url),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  ),
                ),
              );
            },
            options: CarouselOptions(
                height: 160,
                viewportFraction: 0.85,
                initialPage: 0,
                reverse: false,
                autoPlay: widget.bannerList.length > 1,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
                onPageChanged: (index, reason) =>
                    setState(() => _current = index)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...widget.bannerList.asMap().entries.map((entry) {
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == entry.key
                        ? AppTheme.color100
                        : AppTheme.color25,
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
