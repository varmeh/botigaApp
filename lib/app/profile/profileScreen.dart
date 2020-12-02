import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/index.dart' show UserProvider, CartProvider;
import '../../theme/index.dart';
import '../../util/index.dart' show Http;
import '../../widgets/index.dart'
    show
        WhatsappIconButton,
        CallIconButton,
        Toast,
        PassiveButton,
        ActiveButton,
        PolicyWebiewScreen;
import '../auth/index.dart' show LoginScreen;
import '../location/index.dart' show ManageAddressesScreen;
import 'profileUpdateScreen.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final sizedBox24 = SizedBox(height: 24.0);
  final sizedBox16 = SizedBox(height: 16.0);
  final sizedBox8 = SizedBox(height: 8.0);

  final divider = Divider(
    thickness: 8.0,
    color: AppTheme.dividerColor,
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, child) {
        return SafeArea(
          child: ListView(
            children: [
              _profile(provider),
              _addresses(provider),
              divider,
              _support(provider),
              divider,
              provider.isLoggedIn ? _logout(provider) : Container(),
              SizedBox(height: 100.0)
            ],
          ),
        );
      },
    );
  }

  Widget _logout(UserProvider provider) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        try {
          await provider.logout();

          Provider.of<CartProvider>(context, listen: false).clearCart();
          setState(() {});
        } catch (error) {
          Toast(message: Http.message(error)).show(context);
        }
      },
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
              color: AppTheme.color50,
            ),
          ],
        ),
      ),
    );
  }

  Widget _profile(UserProvider provider) {
    return provider.isLoggedIn
        ? Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profile',
                  style: AppTheme.textStyle.w700.color100
                      .size(22.0)
                      .lineHeight(1.3),
                ),
                sizedBox24,
                _infoTile('assets/images/smile.png',
                    '${provider.firstName} ${provider.lastName}'),
                sizedBox16,
                _infoTile('assets/images/callOutline.png', provider.phone),
                sizedBox16,
                _infoTile('assets/images/email.png',
                    provider.email ?? 'Add your email'),
                sizedBox16,
                _infoTile('assets/images/whatsappOutline.png',
                    provider.whatsapp ?? 'Add your whatsapp number'),
                sizedBox24,
                OpenContainer(
                  closedElevation: 0.0,
                  transitionDuration: Duration(milliseconds: 500),
                  closedBuilder: (context, openContainer) => PassiveButton(
                    title: 'Edit Profile',
                    onPressed: openContainer,
                  ),
                  openBuilder: (_, __) => ProfileUpdateScreen(),
                )
              ],
            ),
          )
        : Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profile',
                  style: AppTheme.textStyle.w700.color100
                      .size(22.0)
                      .lineHeight(1.3),
                ),
                sizedBox8,
                Text(
                  'Login / Signup to  manage your orders',
                  style: AppTheme.textStyle.w500.color50
                      .size(15.0)
                      .lineHeight(1.3),
                ),
                sizedBox24,
                ActiveButton(
                  title: 'Login',
                  height: 44.0,
                  onPressed: () =>
                      Navigator.pushNamed(context, LoginScreen.route),
                ),
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
        Expanded(
          child: Text(
            text,
            style: AppTheme.textStyle.w500.color100.size(15.0).lineHeight(1.3),
          ),
        )
      ],
    );
  }

  Widget _addresses(UserProvider provider) {
    return !provider.isLoggedIn
        ? Container()
        : GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.pushNamed(
              context,
              ManageAddressesScreen.route,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                divider,
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            'Saved Addresses',
                            style: AppTheme.textStyle.w700.color100
                                .size(15.0)
                                .lineHeight(1.3),
                          )
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: AppTheme.color50,
                      )
                    ],
                  ),
                )
              ],
            ),
          );
  }

  Widget _support(UserProvider provider) {
    final divider = Divider(thickness: 1.0, color: AppTheme.dividerColor);
    return Container(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 24.0),
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
          sizedBox8,
          Text(
            'Any queries or concerns. We are always available to help you out.',
            style: AppTheme.textStyle.w500.color50.size(13.0).lineHeight(1.5),
          ),
          sizedBox16,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Monday - Friday',
                    style: AppTheme.textStyle.w500.color100
                        .size(15)
                        .lineHeight(1.3),
                  ),
                  Text(
                    '10 AM to 6 PM',
                    style: AppTheme.textStyle.w500.color50
                        .size(15)
                        .lineHeight(1.3),
                  )
                ],
              ),
              Row(
                children: [
                  WhatsappIconButton(number: '9910057232'),
                  SizedBox(width: 16.0),
                  CallIconButton(number: '9910057232'),
                ],
              ),
            ],
          ),
          SizedBox(height: 32),
          divider,
          _policy(
            'Cancellation Policy',
            'https://s3.ap-south-1.amazonaws.com/products.image.prod/cancellationPolicy.html',
          ),
          divider,
          _policy(
            'Privacy Policy',
            'https://s3.ap-south-1.amazonaws.com/products.image.prod/privacyPolicy.html',
          ),
          divider,
          _policy(
            'Terms & Conditions',
            'https://s3.ap-south-1.amazonaws.com/products.image.prod/termsAndConditions.html',
          ),
          divider,
          _policy(
            'Frequently Asked Questions',
            'https://s3.ap-south-1.amazonaws.com/products.image.prod/faqCustomers.html',
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _policy(String name, String url) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => PolicyWebiewScreen(url)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style:
                  AppTheme.textStyle.w500.color100.size(15.0).lineHeight(1.3),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppTheme.color50,
            )
          ],
        ),
      ),
    );
  }
}
