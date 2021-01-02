import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

import '../theme/index.dart';
import '../widgets/index.dart';
import 'toast.dart';

class InviteTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      height: 180,
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: Color(0xff121714).withOpacity(0.12),
            blurRadius: 40.0, // soften the shadow
            spreadRadius: 0.0, //extend the shadow
            offset: Offset(
              0.0, // Move to right 10  horizontally
              0.0, // Move to bottom 10 Vertically
            ),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 12.0, bottom: 24, top: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Share with neighbours',
                    style: AppTheme.textStyle.w700
                        .size(17.0)
                        .lineHeight(1.3)
                        .color100,
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Help your neighbours to explore products they might love :)',
                    style: AppTheme.textStyle.w500
                        .size(13.0)
                        .lineHeight(1.5)
                        .color50,
                  ),
                  SizedBox(height: 16.0),
                  FlatButton(
                    onPressed: () {
                      BotigaBottomModal(
                        child: share(context),
                        color: Color(0xffF3F3F3),
                      ).show(context);
                    },
                    child: Text(
                      'Share Now',
                      style: AppTheme.textStyle.w600
                          .size(15)
                          .lineHeight(1.5)
                          .colored(AppTheme.backgroundColor),
                    ),
                    color: AppTheme.color100,
                    height: 42.0,
                    minWidth: 136.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Image.asset(
              'assets/images/invite.png',
              fit: BoxFit.fill,
            ),
          )
        ],
      ),
    );
  }

  Widget share(BuildContext context) {
    const borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(16.0),
      topRight: const Radius.circular(16.0),
    );

    const text =
        'Hello friends,\nI have been ordering amazing products from our apartment online mall - Botiga.\nDownload it to buy wonderful products - http://onelink.to/husbnk';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: borderRadius,
          ),
          child: Center(
            child: Text(
              'SHARE WITH YOUR FRIENDS',
              style: AppTheme.textStyle.w700
                  .size(12)
                  .lineHeight(1.4)
                  .colored(AppTheme.backgroundColor),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/coupan.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 24.0,
            ),
            child: Text(
              text,
              style: AppTheme.textStyle.w500.color100.size(15).lineHeight(1.3),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
                onPressed: () {
                  FlutterClipboard.copy(text).then((_) {
                    Toast(
                      message: 'Copied to Clipboard',
                      icon: Icon(
                        Icons.content_copy_outlined,
                        size: 24,
                        color: AppTheme.backgroundColor,
                      ),
                    ).show(context);
                  }).catchError((_, __) => null);
                },
                color: AppTheme.color100,
                child: Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Text(
                    'Copy message',
                    style: AppTheme.textStyle.w500
                        .size(15.0)
                        .lineHeight(1.3)
                        .colored(AppTheme.backgroundColor),
                  ),
                ),
              ),
              FlatButton.icon(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
                icon: Padding(
                  padding: const EdgeInsets.only(left: 13, top: 13, bottom: 13),
                  child: Image.asset('assets/images/whatsapp.png'),
                ),
                onPressed: () {
                  Share.share(text)
                      .then((_) => Navigator.pop(context))
                      .catchError((_, __) => null); //catch error do nothing
                },
                color: AppTheme.color100,
                label: Padding(
                  padding: const EdgeInsets.only(
                    right: 13,
                    top: 13,
                    bottom: 13,
                  ),
                  child: Text(
                    'Share',
                    style: AppTheme.textStyle.w500
                        .size(15.0)
                        .lineHeight(1.3)
                        .colored(AppTheme.backgroundColor),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
