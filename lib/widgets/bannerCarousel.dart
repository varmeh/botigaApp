import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../theme/index.dart';
import './customCacheManager.dart';

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
    bool hasMoreThan1Banner = widget.bannerList.length > 1;

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CarouselSlider(
            items: widget.bannerList.map((banner) {
              return Builder(
                builder: (BuildContext context) {
                  return InkWell(
                    onTap: () {
                      if (banner.onTap != null) {
                        banner.onTap();
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                            banner.url,
                            cacheManager: customCacheManager,
                          ),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
            options: CarouselOptions(
                height: 160,
                viewportFraction: hasMoreThan1Banner ? 0.85 : 0.90,
                initialPage: 0,
                enableInfiniteScroll: hasMoreThan1Banner,
                reverse: false,
                autoPlay: hasMoreThan1Banner,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
                onPageChanged: (index, reason) =>
                    setState(() => _current = index)),
          ),
          hasMoreThan1Banner
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...widget.bannerList.asMap().entries.map((entry) {
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
        ],
      ),
    );
  }
}
