import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/*
 * Displays cached network image 
 * In case, imageUrl is null or image does not exist at url
 * it shows placeholder image
*/

class CircleNetworkAvatar extends StatelessWidget {
  final String imageUrl;
  final double radius;
  final String imagePlaceholder;

  CircleNetworkAvatar({
    @required this.imageUrl,
    this.imagePlaceholder = 'assets/images/avatar.png',
    this.radius = 25.0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(this.radius),
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        width: this.radius * 2,
        height: this.radius * 2,
        placeholder: (_, __) => Image.asset(this.imagePlaceholder),
        imageUrl: this.imageUrl != null ? this.imageUrl : '',
      ),
    );
  }
}
