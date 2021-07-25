import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/*
 * Displays cached network image 
 * In case, imageUrl is null or image does not exist at url
 * it shows placeholder image
*/

import './customCacheManager.dart';

class NetworkCachedImage extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final String imagePlaceholder;
  final bool isColored;

  NetworkCachedImage({
    @required this.imageUrl,
    @required this.width,
    @required this.height,
    this.imagePlaceholder = 'assets/images/homePlaceholder.png',
    this.isColored = false,
  });

  @override
  Widget build(BuildContext context) {
    return imageUrl == null ? _placeholderImage() : _networkImage();
  }

  Widget _networkImage() {
    return CachedNetworkImage(
      colorBlendMode: BlendMode.saturation,
      fadeInDuration: Duration(milliseconds: 300),
      imageBuilder: (context, imageProvider) {
        return Container(
          width: this.width,
          height: this.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              colorFilter: isColored
                  ? ColorFilter.mode(
                      Colors.transparent,
                      BlendMode.multiply,
                    )
                  : ColorFilter.mode(
                      Colors.grey,
                      BlendMode.saturation,
                    ),
              image: imageProvider,
            ),
          ),
        );
      },
      fit: BoxFit.cover,
      width: width,
      height: height,
      placeholder: (_, __) => _placeholderImage(),
      imageUrl: this.imageUrl,
      cacheManager: customCacheManager,
    );
  }

  Widget _placeholderImage() {
    return Image.asset(this.imagePlaceholder,
        width: this.width, height: this.height);
  }
}
