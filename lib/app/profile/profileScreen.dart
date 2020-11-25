import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';

import '../../models/addressModel.dart';
import '../../util/index.dart' show Http;
import '../../widgets/index.dart'
    show ContactWidget, Toast, PassiveButton, ActiveButton;
import '../../providers/index.dart' show UserProvider, SellersProvider;
import '../../theme/index.dart';
import '../location/searchApartmentScreen.dart';
import '../auth/loginScreen.dart';
import 'profileUpdateScreen.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final sizedBox24 = SizedBox(height: 24.0);
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
              _address(provider),
              divider,
              _support(provider),
              divider,
              _logout(provider),
              SizedBox(height: 100.0)
            ],
          ),
        );
      },
    );
  }

  Widget _logout(UserProvider provider) {
    return GestureDetector(
      onTap: () async {
        try {
          await provider.logout();

          Navigator.pushNamedAndRemoveUntil(
            context,
            LoginScreen.route,
            (route) => false,
          );
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
                sizedBox8,
                _infoTile('assets/images/email.png',
                    provider.email ?? 'Add your email'),
                sizedBox8,
                _infoTile(
                    'assets/images/whatsappOutline.png', provider.whatsapp),
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
                  'Login/Sign up to  manage your orders',
                  style: AppTheme.textStyle.w500.color50
                      .size(15.0)
                      .lineHeight(1.3),
                ),
                sizedBox24,
                ActiveButton(title: 'Login', height: 44.0, onPressed: () {}),
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

  Widget _address(UserProvider provider) {
    AddressModel address = provider.address;
    return !provider.isLoggedIn
        ? Container()
        : Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                divider,
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
                      style: AppTheme.textStyle.w700.color100
                          .size(15.0)
                          .lineHeight(1.3),
                    )
                  ],
                ),
                address != null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${address.house}, ${address.apartment}',
                              style: AppTheme.textStyle.w500.color100
                                  .size(15.0)
                                  .lineHeight(1.3),
                            ),
                            sizedBox8,
                            Text(
                              '${address.area}, ${address.city}, ${address.state} - ${address.pincode}',
                              style: AppTheme.textStyle.w500.color50
                                  .size(13.0)
                                  .lineHeight(1.5),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                sizedBox24,
                OpenContainer(
                  closedElevation: 0.0,
                  transitionDuration: Duration(milliseconds: 500),
                  closedBuilder: (context, openContainer) => PassiveButton(
                    title: address != null ? 'Change Address' : 'Add Address',
                    onPressed: openContainer,
                  ),
                  openBuilder: (_, __) =>
                      SearchApartmentScreen(onSelection: (_) {
                    Provider.of<SellersProvider>(context, listen: false)
                        .empty();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  }),
                )
              ],
            ),
          );
  }

  Widget _support(UserProvider provider) {
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
          ContactWidget(
            phone: '9910057232',
            whatsapp: '9910057232',
            whatsappMessage:
                'Hello Team Botiga\nI am ${provider.firstName}, residing in ${provider.address?.apartment}, ${provider.address?.area}, ${provider.address?.city}',
          )
        ],
      ),
    );
  }
}
