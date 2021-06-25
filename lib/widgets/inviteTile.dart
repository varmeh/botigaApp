import 'package:flutter/material.dart';

import '../theme/index.dart';
import '../widgets/index.dart' show ShareModal;

class InviteTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            flex: 2,
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
                    'Help your neighbours explore products they might love :)',
                    style: AppTheme.textStyle.w500
                        .size(13.0)
                        .lineHeight(1.5)
                        .color50,
                  ),
                  SizedBox(height: 16.0),
                  TextButton(
                    onPressed: () {
                      ShareModal(
                        title: 'SHARE WITH YOUR NEIGHBOURS',
                        message:
                            'Hey there!\nI am using Botiga to order wonderful products from our apartment\'s hand-picked merchants.\nDownload it here to experience the new way of shopping at home.\nhttp://onelink.to/husbnk',
                      ).show(context);
                    },
                    child: Text(
                      'Share Now',
                      style: AppTheme.textStyle.w600
                          .size(15)
                          .lineHeight(1.5)
                          .colored(AppTheme.backgroundColor),
                    ),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      backgroundColor: AppTheme.color100,
                      minimumSize: Size(136.0, 42.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Container(
                child: Image.asset(
                  'assets/images/invite.png',
                  fit: BoxFit.fill,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
