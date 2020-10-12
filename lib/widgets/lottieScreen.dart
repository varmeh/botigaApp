import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../theme/index.dart';

class LottieScreen extends StatelessWidget {
  final String json;
  final String message;
  final String description;
  // final String retryUrl;
  final String buttonTitle;
  final Function onTap;

  LottieScreen({
    @required this.json,
    @required this.message,
    @required this.description,
    @required this.buttonTitle,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const sizedBox = SizedBox(height: 24);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            json,
            width: 200,
            height: 200,
            fit: BoxFit.fill,
          ),
          sizedBox,
          Text(
            message,
            style: AppTheme.textStyle.w700.color100.size(16).lineHeight(1.4),
          ),
          SizedBox(height: 8.0),
          Text(
            description,
            style: AppTheme.textStyle.w500.color50
                .size(12)
                .lineHeight(1.4)
                .letterSpace(0.2),
          ),
          sizedBox,
          FlatButton(
            onPressed: onTap,
            child: Text(
              buttonTitle,
              style: AppTheme.textStyle.w500.color100.size(15).lineHeight(1.5),
            ),
            color: AppTheme.color05,
            height: 44.0,
            minWidth: 188.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          )
        ],
      ),
    );
  }
}
