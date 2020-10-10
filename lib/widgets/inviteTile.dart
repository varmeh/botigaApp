import 'package:flutter/material.dart';

import '../theme/index.dart';

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
                      'Don\'t see your favorite vendor?',
                      style: AppTheme.textStyle.w600
                          .size(15.0)
                          .lineHeight(1.3)
                          .colored(
                            Color(0xff47270A),
                          ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Invite vendors to botiga by sharing the following link with them.',
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
            onPressed: () {},
            child: Text(
              'Invite vendor',
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
}
