import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:clipboard/clipboard.dart';

import '../theme/index.dart';
import 'botigaBottomModal.dart';
import 'toast.dart';

class ShareModal {
  final String title;
  final String message;

  ShareModal({
    @required this.title,
    @required this.message,
  });

  void show(BuildContext context) {
    BotigaBottomModal(
      child: _modal(context),
      color: Color(0xffF3F3F3),
    ).show(context);
  }

  Widget _modal(BuildContext context) {
    const borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(16.0),
      topRight: const Radius.circular(16.0),
    );

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
              title,
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
              message,
              style: AppTheme.textStyle.w500.color100.size(15).lineHeight(1.3),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  backgroundColor: AppTheme.color100,
                ),
                onPressed: () {
                  FlutterClipboard.copy(message).then((_) {
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
              TextButton.icon(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  backgroundColor: AppTheme.color100,
                ),
                icon: Padding(
                  padding: const EdgeInsets.only(left: 13, top: 13, bottom: 13),
                  child: Image.asset('assets/images/whatsapp.png'),
                ),
                onPressed: () {
                  Share.share(message)
                      .then((_) => Navigator.pop(context))
                      .catchError((_, __) => null); //catch error do nothing
                },
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
