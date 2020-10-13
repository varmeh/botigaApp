import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:clipboard/clipboard.dart';

import '../theme/index.dart';
import 'toast.dart';

class InviteTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.0, 24.0, 0, 24.0),
      color: Color(0xfffcf4ed),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Don\'t see your favorite merchant?',
                      style: AppTheme.textStyle.w600
                          .size(15.0)
                          .lineHeight(1.3)
                          .colored(
                            Color(0xff47270A),
                          ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Invite merchants to botiga by sharing the following link with them.',
                      style: AppTheme.textStyle.w600
                          .size(13.0)
                          .lineHeight(1.5)
                          .colored(
                            Color(0xff743F11),
                          ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Image.asset('assets/images/invite.png'),
              ),
            ],
          ),
          SizedBox(height: 24.0),
          FlatButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (builder) {
                  return share(context);
                },
              );
            },
            child: Text(
              'Invite merchant',
              style: AppTheme.textStyle.w500
                  .size(15)
                  .lineHeight(1.5)
                  .colored(AppTheme.backgroundColor),
            ),
            color: AppTheme.color100,
            height: 44.0,
            minWidth: 136.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
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
        'Hi, I am placing orders to all my merchants using Botiga. Why don’t you try it out. it just takes 3 mins to register and start selling. Download Botiga app now. https://botiga.app/xcGha';

    return Container(
      width: double.infinity,
      height: 350,
      padding: EdgeInsets.only(left: 22, right: 22, top: 32),
      decoration: BoxDecoration(
        color: AppTheme.dividerColor,
        borderRadius: borderRadius,
      ),
      child: Column(
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
                "SHARE WITH YOUR MERCHANTS",
                style: AppTheme.textStyle.w700
                    .size(12)
                    .lineHeight(1.4)
                    .colored(AppTheme.backgroundColor),
              ),
            ),
          ),
          Container(
            height: 150,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/coupan.png"),
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
                style:
                    AppTheme.textStyle.w500.color100.size(15).lineHeight(1.3),
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
                        iconData: Icons.content_copy_outlined,
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
                    padding:
                        const EdgeInsets.only(left: 13, top: 13, bottom: 13),
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
      ),
    );
  }
}
