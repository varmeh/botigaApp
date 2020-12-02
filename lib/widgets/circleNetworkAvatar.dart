import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/index.dart';

/*
 * Displays cached network image 
 * In case, imageUrl is null or image does not exist at url
 * it shows placeholder image
*/

class CircleNetworkAvatar extends StatelessWidget {
  final String imageUrl;
  final double radius;
  final String imagePlaceholder;
  final bool isColored;

  CircleNetworkAvatar({
    @required this.imageUrl,
    this.imagePlaceholder = 'assets/images/avatar.png',
    this.radius = 24.0,
    this.isColored = false,
  });

  @override
  Widget build(BuildContext context) {
    return imageUrl == null ? _placeholderImage() : _networkImage();
  }

  Widget _networkImage() {
    return CachedNetworkImage(
      colorBlendMode: BlendMode.saturation,
      imageBuilder: (context, imageProvider) {
        return Container(
          width: 120.0,
          height: 90.0,
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
            borderRadius: BorderRadius.circular(this.radius),
          ),
        );
      },
      fit: BoxFit.cover,
      width: this.radius * 2,
      height: this.radius * 2,
      placeholder: (_, __) => _placeholderImage(),
      imageUrl: this.imageUrl,
    );
  }

  Widget _placeholderImage() {
    return CircleAvatar(
      backgroundColor: AppTheme.color05,
      backgroundImage: AssetImage(this.imagePlaceholder),
      radius: this.radius,
    );
  }
}
