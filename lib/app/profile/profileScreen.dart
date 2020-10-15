import 'package:flutter/material.dart';

import '../../theme/index.dart';
import '../../widgets/contactPartnerWidget.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final sizedBox24 = SizedBox(height: 24.0);
  final sizedBox8 = SizedBox(height: 8.0);

  @override
  Widget build(BuildContext context) {
    final divider = Divider(
      thickness: 8.0,
      color: AppTheme.dividerColor,
    );

    return SafeArea(
      child: ListView(
        children: [
          _profile(),
          divider,
          _address(),
          divider,
          _support(),
          divider,
          _logout(),
          SizedBox(height: 100.0)
        ],
      ),
    );
  }

  Widget _logout() {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Logout',
              style:
                  AppTheme.textStyle.w500.color100.size(15.0).lineHeight(1.5),
            ),
            Icon(
              Icons.logout,
              color: AppTheme.color100,
            ),
          ],
        ),
      ),
    );
  }

  Widget _profile() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profile',
            style: AppTheme.textStyle.w700.size(22.0).lineHeight(1.3),
          ),
          sizedBox24,
          _infoTile('assets/images/smile.png', 'Ritu Sharma'),
          sizedBox8,
          _infoTile('assets/images/email.png', 'email@email.com'),
          sizedBox8,
          _infoTile('assets/images/whatsappOutline.png', '9910099100'),
          sizedBox24,
          _spanButton('Edit Profile', () {})
        ],
      ),
    );
  }

  Widget _infoTile(String image, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(
          image,
          color: AppTheme.color100,
        ),
        SizedBox(width: 10.0),
        Text(
          text,
          style: AppTheme.textStyle.w500.color100.size(15.0).lineHeight(1.3),
        )
      ],
    );
  }

  Widget _address() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/homeOutline.png',
                color: AppTheme.color100,
              ),
              SizedBox(width: 12.0),
              Text(
                'Address',
                style:
                    AppTheme.textStyle.w700.color100.size(15.0).lineHeight(1.3),
              )
            ],
          ),
          sizedBox24,
          Text(
            'V503, T5, Adarsh Palm Retreat',
            style: AppTheme.textStyle.w500.color100.size(15.0).lineHeight(1.3),
          ),
          sizedBox8,
          Text(
            'Bellandur, Bengaluru, Karantaka - 560103',
            style: AppTheme.textStyle.w500.color50.size(13.0).lineHeight(1.5),
          ),
          sizedBox24,
          _spanButton('Change Address', () {})
        ],
      ),
    );
  }

  Widget _support() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/chatSmile.png',
                color: AppTheme.color100,
              ),
              SizedBox(width: 12.0),
              Text(
                'Need Help?',
                style:
                    AppTheme.textStyle.w700.color100.size(15.0).lineHeight(1.3),
              )
            ],
          ),
          sizedBox24,
          Text(
            'Any queries or concerns. We are always available to help you out.',
            style: AppTheme.textStyle.w500.color50.size(13.0).lineHeight(1.5),
          ),
          sizedBox24,
          ContactPartnerWidget(phone: '9910057232', whatsapp: '9910057232')
        ],
      ),
    );
  }

  Widget _spanButton(String title, Function onTap) {
    return FlatButton(
      onPressed: onTap,
      child: Center(
        child: Text(
          title,
          style: AppTheme.textStyle.w500.color100.size(15.0).lineHeight(1.5),
        ),
      ),
      color: AppTheme.color05,
      height: 44.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }
}
