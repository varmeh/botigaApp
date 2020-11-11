import 'package:flutter/material.dart';

enum ImageStatus { pending, success, failure }

class StatusImageWidget extends StatelessWidget {
  final String baseImage;
  final ImageStatus status;

  StatusImageWidget({
    @required this.baseImage,
    @required this.status,
  });

  @override
  Widget build(BuildContext context) {
    String statusImage;
    switch (status) {
      case ImageStatus.success:
        statusImage = 'assets/images/success.png';
        break;

      case ImageStatus.failure:
        statusImage = 'assets/images/failure.png';
        break;

      case ImageStatus.pending:
        statusImage = 'assets/images/pending.png';
    }

    return Stack(
      overflow: Overflow.visible,
      children: [
        Image.asset(
          baseImage,
          width: 24.0,
          height: 24.0,
        ),
        Positioned(
          right: -10.0,
          top: -5.0,
          child: Image.asset(
            statusImage,
            width: 20.0,
            height: 20.0,
          ),
        ),
      ],
    );
  }
}
