import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';

import '../../theme/index.dart';
import '../auth/index.dart' show SignupWelcomeScreen;

class OnboardingScreen extends StatelessWidget {
  static const route = 'onboarding';

  final List<Slide> _slides = [
    Slide(
      title: 'Buy amazing products in your community',
      description:
          'See an extensive catalog of the merchants serving in your community',
      pathImage: 'assets/images/communities.png',
    )
  ];

  Widget _customTab(Slide slide) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
              child: Image.asset(
            slide.pathImage,
            width: 331.0,
            height: 246.0,
            fit: BoxFit.contain,
          )),
          SizedBox(
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Container(
              width: double.infinity,
              child: Text(
                slide.title,
                style: AppTheme.textStyle.w700.size(22).color100,
                textAlign: TextAlign.left,
              ),
              margin: EdgeInsets.only(top: 20.0),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Container(
                width: double.infinity,
                child: Text(
                  slide.description,
                  style: AppTheme.textStyle.w500.size(15).color50,
                  textAlign: TextAlign.left,
                  maxLines: 3,
                ),
                margin: EdgeInsets.only(top: 20.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: IntroSlider(
          slides: this._slides,
          colorDot: AppTheme.color25,
          colorActiveDot: AppTheme.primaryColor,
          onDonePress: () {
            Navigator.of(context).pushNamed(SignupWelcomeScreen.route);
          },
          listCustomTabs: _slides.map((slide) => _customTab(slide)).toList(),
          colorSkipBtn: AppTheme.backgroundColor,
          styleNameSkipBtn: AppTheme.textStyle.w500.size(15).color50,
          nameSkipBtn: 'Skip',
          nameNextBtn: 'Next',
          nameDoneBtn: 'Done',
          colorDoneBtn: AppTheme.backgroundColor,
          styleNameDoneBtn:
              AppTheme.textStyle.w500.size(15).colored(AppTheme.primaryColor),
          highlightColorDoneBtn: AppTheme.primaryColor,
        ),
      ),
    );
  }
}
