import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../theme/index.dart';

class LottieScreen extends StatelessWidget {
  final String json;
  final String message;
  final String description;
  final String buttonTitle;
  final Function onTap;
  final double width;
  final double height;

  LottieScreen({
    @required this.json,
    @required this.message,
    @required this.description,
    @required this.buttonTitle,
    @required this.onTap,
    this.width = 160.0,
    this.height = 160.0,
  });

  @override
  Widget build(BuildContext context) {
    const sizedBox = SizedBox(height: 24);
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                json,
                width: width,
                height: height,
                fit: BoxFit.fill,
              ),
              sizedBox,
              Text(
                message,
                style:
                    AppTheme.textStyle.w700.color100.size(16).lineHeight(1.4),
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
              TextButton(
                onPressed: onTap,
                child: Text(
                  buttonTitle,
                  style:
                      AppTheme.textStyle.w500.color100.size(15).lineHeight(1.5),
                ),
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  backgroundColor: AppTheme.color05,
                  minimumSize: Size(188.0, 44.0),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
